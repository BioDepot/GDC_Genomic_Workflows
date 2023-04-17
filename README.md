# GDC Genomic Workflows
This repository contains data files, outputs, Jupyter notebooks, and Biodepot-workflow-builder (Bwb) workflows mentioned in the CRDC paper.

## Bwb workflows

### GDC_mRNA_dr15plus
GDC Data Release v15 mRNA-Seq workflow, as seen in Figure 2a.

A demonstration video for this workflow is seen here:
https://www.youtube.com/watch?v=YzFa9Een7Tc

### GDC_mRNA_multi_dr32_fpkm
GDC Data Release v32 mRNA-Seq workflow, as seen in Figure 2b.

**NOTE**: STAR Fusion widget has been disabled as the default, as genome library directory files are not longer available to download. To execute the widget, build the widget's Docker image with the widget's Dockerfile (located in the widget's folder in the workflow's directory), provide the widget with your genome library directory, and manually execute it. STAR Fusion version 1.6 to 1.9 preferred. For more information about STAR Fusion, refer to the project's GitHub page [here](https://github.com/STAR-Fusion/STAR-Fusion).

### GDC_mRNA_multi_dr32chr22
GDC Data Release v32 mRNA-Seq workflow isolated to chromosome 22 genome files, as seen in Figure 2c.

**NOTE**: Gene Fusion widgets (Arriba and STAR Fusion) are disabled as the default.

### GDC_mRNA_multi_dr32_bam_CRDC
mRNA-Seq analysis workflow with Jupyter notebook analysis at the end, as seen in Figure 3. Notebook in this workflow is the [GDC vs GTEx compare](###GDC-vs-GTEx-compare) notebook.

### GDC_dna_seq
GDC DNA-Seq analysis workflow, as seen in Figure 4.

A demonstration video for this workflow is seen here:
https://youtu.be/M7MCI83Q7_A

### GATK_workflows
GATK workflow containing the Cromwell widget, as seen in Figure 5.

### toil_wgs_sanger
WGS Variant Calling workflow using the Toil CWL widget, as seen in Figure 6.

A demonstration video for this workflow is seen here:
https://youtu.be/XRdhJRvVecM

## GDC's TCGA vs GTEx samples analyses notebooks
**TCGA GDC samples are TCGA-AB-2821, TCGA-AB-2828, and TCGA-AB-2839. GTEx samples are N7MS, NFK9, and O5YT.**

### GDC vs GTEx compare
Normal "whole blood" non-cancerous tissue data from GTEx versus AML cancer bone marrow tissue data from TCGA GDC.

Two versions of gene expression counts for each sample are used in this notebook, one labelled "PUBLISHED" and the other labelled "REPROCESSED". Published counts are taken from the [GDC Data Portal](https://portal.gdc.cancer.gov/) and [GTEx Portal](https://gtexportal.org/home/). Reprocessed counts are outputs from the RNA-Seq workflow when using each sample's fastq files into [STAR](https://github.com/alexdobin/STAR) to generate gene expression counts. Analysis of the counts, including differential expression analysis using [DESeq2](https://bioconductor.org/packages/release/bioc/html/DESeq2.html), is shown.

This folder contains the counts of these 6 samples (published and reprocessed), and outputs from the [GDC_mRNA_multi_dr32_bam_CRDC](###-GDC_mRNA_multi_dr32_bam_CRDC) workflow, and the Jupyter notebook running analyses on the workflow outputs. Figure 7 volcano plot is shown in the notebook.

### GDC v15 vs v32 published counts compare
Comparison of the counts for the three GDC samples, GDC published counts from Data Release version 15 vs published counts from version 32. GDC Data Releases between v15 and v32 have a pipeline to generate counts using  [HTSeq](https://github.com/htseq/htseq), and v32 onwards uses a [STAR](https://github.com/alexdobin/STAR) to generate counts. Details of the differences in workflows are detailed in the [GDC mRNA ANalysis Pipeline documentations](https://docs.gdc.cancer.gov/Data/Bioinformatics_Pipelines/Expression_mRNA_Pipeline/).

Each sample has its own notebook and output files. Comparing both versions, relative change analysis and matching counts for each gene are included.

Old v15 HTSeq counts are not available on GDC anymore, but access to these files can be done using their file IDs listed in the [gdc-docs Github](https://github.com/NCI-GDC/gdc-docs/tree/develop/docs/Data/Release_Notes/GCv36_Manifests) (v22 counts are equivalent to v15 counts).

### GTEX published vs reprocessed counts compare
Comparison of the counts fro the three GTEx samples, gene read counts published on the GTEx Portal ([GTEx Analysis V8 (dbGaP Accession phs000424.v8.p2)](https://gtexportal.org/home/datasets)) vs reprocessed counts from running the [GDC_mRNA_multi_dr32_bam_CRDC](###GDC_mRNA_multi_dr32_bam_CRDC) workflow. 

Relative change and differential expression analyses are included.

## Troubleshooting
- If a certain widget in one of the workflow fails, check the widget's console to see the error menssage. If it is the download widget failing, see if one of the links is no longer available, or rerun the widget if the files are partially downloaded but abruptly stopped before completing.
