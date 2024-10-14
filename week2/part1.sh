#!/bin/sh
# ## Exercise 1
# ### Steps 1.1 through 1.3 
# I downloaded 3 files from the UCSC Genome Table Browser ("https://genome.ucsc.edu/cgi-bin/hgTables")
# 1. gene.bed: contains the known gene on Chr1
# 2. chr1_exons2.bed: contains the known coding exons on Chr1
# 3. cCREs.bed: contains the regulatory elements on Chr1

# ### Step 1.4 
# There are many isoforms of gene, so some regions in the genome are represented multiple times in the gene and exon .bed files. We want to create a file without overlapping ranges. 

# First we sort the file by chromosome and coordinate. By default, bedtools sort sorts a .bed file first by chromosome and then by start position (in ascending order) ("https://bedtools.readthedocs.io/en/latest/content/tools/sort.html)  

# You can either say bedtools sort or use sortBed, they are equivalent
sortBed -i gene.bed > gene_sorted.bed
sortBed -i chr1_exons2.bed > exons_sorted.bed
sortBed -i cCREs.bed > cCREs_sorted.bed

# When we merge, we are collapsing repeating features within an individual file, not merging the files
# bedtools merge

bedtools merge -i gene_sorted.bed > gene_chr1.bed
bedtools merge -i exons_sorted.bed > exons_chr1.bed
bedtools merge -i cCREs_sorted.bed > cCREs_chr1.bed

# One of the files from chr1_snps.tar.gz is the full chromosome 

# ### Step 1.5 
# I will remove exons from the merged gene file using the merged exon file
# bedtools subtract 
bedtools subtract -a gene_chr1.bed -b exons_chr1.bed > introns_chr1.bed
# ### Step 1.6
# I will take the full genome_chr1.bed file and subtract exon, intron, and cCRE files 
bedtools subtract -a genome_chr1.bed -b exons_chr1.bed introns_chr1.bed cCREs_chr1.bed > others_chr1.bed