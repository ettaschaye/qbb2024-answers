## Exercise 1
### Steps 1.1 through 1.3 
I downloaded 3 files from the UCSC Genome Table Browser ("https://genome.ucsc.edu/cgi-bin/hgTables")
1. genes.bed: contains the known genes on Chr1
2. exons.bed: contains the known coding exons on Chr1
3. cCREs.bed: contains the regulatory elements on Chr1

### Step 1.4 
There are many isoforms of genes, so some regions in the genome are represented multiple times in the gene and exon .bed files. We want to create a file without overlapping ranges. 

First we sort the file by chromosome and coordinate. By default, bedtools sort sorts a .bed file first by chromosome and then by start position (in ascending order) ("https://bedtools.readthedocs.io/en/latest/content/tools/sort.html)  

bedtools sort
```
sortBed -i genes.bed > genes_sorted.bed
sortBed -i exons.bed > exons_sorted.bed
sortBed -i cCREs.bed > cCREs_sorted.bed
```

When we merge, we are collapsing repeating features within an individual file, not merging the files
bedtools merge
```
bedtools merge -i genes_sorted.bed > genes_sorted_merged.bed

```

One of the files from chr1_snps.tar.gz is the full chromosome 