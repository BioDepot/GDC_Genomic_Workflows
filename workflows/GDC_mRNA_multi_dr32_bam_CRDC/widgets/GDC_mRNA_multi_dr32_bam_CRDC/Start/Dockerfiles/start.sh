#!/bin/bash

printenv
set -o pipefail

makeArrayString() {
	echo $1 | sed 's/[][]//g; s/\,/ /g'
}

outputArrayVar() {
	local array=$1[@]
	printf '%s\n' "${!array}" | jq -R . | jq -s . > "/tmp/output/$1"
}

unquotedFile() {
	echo $* | sed 's/\"//g'
}

mkdir -p $work_dir || exit 1
mkdir -p $genome_dir || exit 1

# Make each sample have their own directory for bam to fastq output conversion (needs to be separated to work)
gtexFastqDirs=($(makeArrayString $gtex_fastq_dirs))
for gtexFastqdir in "${gtexFastqDirs[@]}"; do
    mkdir -p gtexFastqdir || exit 1
done

mkdir -p $gtex_fastq_dirs || exit 1

# Prepend output files with date and time
[ -n "$prepend_date" ] && current_date=$(date +"%Y%m%d_%H%M%S_")

files=($(makeArrayString $bam_file))
bamSeen=false
for file in "${files[@]}"; do
	echo "working on $file"
	unquoted=$(unquotedFile $file)
	if [ -n "$custom_extension" ]; then
		extension=$custom_extension
	elif ! extension=$(echo ${unquoted} | grep -Eo '\.bam$|\.fastq\.gz$|\.fastq$|\.fq\.gz$|\.fq$'); then
		echo "ERROR: File type not supported by this Start widget, Supported file types are .bam, fastq.gz, .fastq, .fq.gz, and .fq"
		echo "You may bypass the Start widget check by entering a custom file extension"
		exit 1
	fi
	echo "extension is $extension"
	case $extension in
		.fastq.gz|.fastq|.fq.gz|.fq)
			fq=$(echo $extension | cut -c 2-)
			;;
		*)
			fq='fq'
			;;
	esac
	filename=$(basename -- "$unquoted")
	# use rsync instead of cp to avoid an error if file is already in workdir and to only clobber if file is different
	cmd="rsync -aq $file $work_dir/$filename"
	echo $cmd
	eval $cmd
	fileBase="$work_dir/$current_date${filename%.*}"
	if [[ $extension == '.bam' ]]; then
		# filenames for biobambam
		bamSeen=true
		fastq1_files+=(${fileBase}_1.$fq)
		fastq2_files+=(${fileBase}_2.$fq)
		fastqo1_files+=(${fileBase}_o1.$fq)
		fastqo2_files+=(${fileBase}_o2.$fq)
		fastqs_files+=(${fileBase}_s.$fq)
        fastq_star_files+=(${fileBase}_1.$fq)
		fastq_star_files+=(${fileBase}_2.$fq)
		archive_files+=($work_dir/${filename%.*}.bam)
		if [ -n "${paired_end}" ]; then
			# filenames for bwa
			fastq_files+=(${fileBase}_1.$fq)
			fastq_files+=(${fileBase}_2.$fq)
		else
			fastq_files+=(${fileBase}_s.$fq)
		fi
	else
		# filenames for bwa
		fastq_files+=($work_dir/${filename%.*}.$fq)
	fi
	biobambam_files+=($work_dir/${filename%.*}.bam)
done

# output delete files to cleanup
if [ -n "$prepend_date" ]; then
	delete_files=($work_dir/${current_date}'*')
else
	# this isn't a comprehensive list but the best we can do without the date/time stamp
	delete_files=(${fastq1_files[@]} ${fastq2_files[@]} ${fastqo1_files[@]} ${fastqo2_files[@]} ${fastqs_files[@]})
fi

# output prefix to cleanup
if [ -n "$prepend_date" ]; then
	echo ${current_date}gdc_dna_seq > /tmp/output/archive_prefix
else
	echo $(date +"%Y%m%d_%H%M%S_")gdc_dna_seq > /tmp/output/archive_prefix
fi

# output genome dictionary file
echo $genome_file | sed 's/fa$/dict/' > /tmp/output/genome_dict_file

outputArrayVar biobambam_files

if $bamSeen; then
	outputArrayVar fastq1_files
	outputArrayVar fastq2_files
	outputArrayVar fastqo1_files
	outputArrayVar fastqo2_files
	outputArrayVar fastqs_files
    outputArrayVar fastq_star_files
fi
