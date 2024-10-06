# Quantitative biology lab week 3
## Variant calling
The goal of this assignment is to align (or map) reads to a reference genome and identify sites that are different from the reference 

The data source for this assignment is Ilumina short read-sequencing data. They crossed the lab strain of Saccharomyces cerevisiae with a wine strain to map associations between genotypes and phenotypes. The diploid offspring were sporulated, producing a colony of haploid segregants. We will expect them to be a mosaic of the parent  

fastq files consist of four lines per entry with this structure
1. The sequence identifier
2. The sequence with the base calls (A, T, C, G, and N)
3. The separator (+)
4. The base call quality scores 
