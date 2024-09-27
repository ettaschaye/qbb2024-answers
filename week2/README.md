## Exercise 1
### Steps 1.1 through 1.3 
I downloaded 3 files from the UCSC Genome Table Browser ("https://genome.ucsc.edu/cgi-bin/hgTables")
1. genes.bed: contains the known genes on Chr1
2. chr1_exons2.bed: contains the known coding exons on Chr1
3. cCREs.bed: contains the regulatory elements on Chr1

### Step 1.4 
There are many isoforms of genes, so some regions in the genome are represented multiple times in the gene and exon .bed files. We want to create a file without overlapping ranges. 

First we sort the file by chromosome and coordinate. By default, bedtools sort sorts a .bed file first by chromosome and then by start position (in ascending order) ("https://bedtools.readthedocs.io/en/latest/content/tools/sort.html)  

bedtools sort
```
sortBed -i genes.bed > genes_sorted.bed
sortBed -i chr1_exons2.bed > exons_sorted.bed
sortBed -i cCREs.bed > cCREs_sorted.bed

```

When we merge, we are collapsing repeating features within an individual file, not merging the files
bedtools merge
```
bedtools merge -i genes_sorted.bed > genes_chr1.bed
bedtools merge -i exons_sorted.bed > exons_chr1.bed
bedtools merge -i cCREs_sorted.bed > cCREs_chr1.bed
```
One of the files from chr1_snps.tar.gz is the full chromosome 

### Step 1.5 
I will remove exons from the merged gene file using the merged exon file
bedtools subtract 
``` bedtools subtract -a genes_chr1.bed -b exons_chr1.bed > introns_chr1.bed
```
### Step 1.6
I will take the full genome_chr1.bed file and subtract exon, intron, and cCRE files 
```
bedtools subtract -a genome_chr1.bed -b exons_chr1.bed introns_chr1.bed cCREs_chr1.bed > other_chr1.bed
```

## Exercise 2
I will be finding how many SNPs overlap each, finding the mean SNP/bp for each feature and then calculating the enrichment of each feature SNP density for each minor allele frequency

### Step 2.1 
I need to write a bash script that loops through every minor allele frequency file and each feature bed file and use bedtools coverage to figure out how mant SNPs fall within each set of features

I think chr1_snps_0.1.bed and equivalent files are the SNPs partitioned by minor allele frequency (0.1, 0.2, 0.3, 0.4, 0.5). I'm curious if 0.1 would be 0.0 through 0.0. I assume yes because these are all pretty common variants otherwise)

The features we are using are exons, introns, cCREs (regulatory elements), and other.

