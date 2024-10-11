# Week 5 Assignment 
# Quant Bio 2024 
# Etta Schaye

## Background
This gene expression data comes from a paper by Marianes and Spralding: https://pubmed.ncbi.nlm.nih.gov/23991285/. They looked at RNA-seq samples from *Drosophila* midguts cut into nine sections. Each sample has three replicates.  

In some studies, you want to highlight some predictor variables by "modeling out" other, less relevant varaibles. 

## Our goals for this exercise
1. Use Fastqc to examine the quality of the fastq data 
2. Use the quality report from the RNA processing pipeline to assess the quality of the mapped samples 
3. Do some exploratory analysis and clustering to explore the data

## Data
1. sample_1.fq.gz and sample_2.fq.gz correspond to the forward and reverse reads for the A1 sample, replicate 1
2. multiqc is a folder containing an HTML file and supporting data detailing quality metrics about the processed data
3. salmon.merged.gene.gene_counts.tsv is a table of transcript counts for each gene (rows) and sample (columns)

## Exercises 

##  Step 1.1 ##
It looks like for both files, the per-base sequence content is variable at the start of the read. The GC content is very high in the middle of the read. It also flagged a few overrepresented sequences. It seems like the high GC content is a result of overrepresented sequences, which might be highly expressed genes. Maybe it could be contamination, which would also make sense because gut cells should have lots of bacterial sequences in them?
##  Step 1.2 ##
CTTGACCAAGATGAAACTGTTCGTATTCCTGGCCTTGGCCGTGGCCGCAA : The *Drosophila* serine protease gene is most overrepresented in both files, which makes sense because it would be involved in digestion 

##  Step 2 ##
- I don't see any samples with more than 45% unique reads, so I would not keep any. 
- I can see the triplicates! This heat map is made of little 3 x 3 grids that represent the similarity between all replicates of two samples. I think the samples are consistent between replicates because they tend to have high similarity to each other.

##  Step 3.3 ##

##  Step 3.6 ##