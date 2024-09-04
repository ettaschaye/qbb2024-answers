# Day 2 Lunch Assignment
Etta Schaye
September 4th, 2024

## Exercise 1 
This will show me only the column gene_biotype: ```cut -f 7 hg38-gene-metadata-feature.tsv``` 

```cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c```

There are 19618 protein_coding genes. <br>

I would like to know more about the type IG_pseudogene because there is only one instance of it and I want to know why if it exists at all, it only exists once in the data set.

Look at the number of go_ids for each ensembl_gene_id, sorted numerically: ``` cut -f 1 hg38-gene-metadata-go.tsv | uniq -c | sort -n ```
Display all rows with the ensembl_gene_id ENSG00000168036 and save them: ```grep "ENSG00000168036" hg38-gene-metadata-go.tsv > ENSG00000168036_go_ids.txt```
This gene must be something very basic and essential because it is associated with a variety of GO terms

### Exercise 2
Find the number of IG genes on each chromosome:
```grep -w "IG_._gene" genes.gtf | cut -f 1 | uniq -c | sort -n```
Find the number of IG pseudogenes on each chromosome:
```grep -w "IG_._pseudogene" genes.gtf | cut -f 1 | uniq -c | sort -n```
There are no IG genes on chromosomes 1, 8, 9, 10 but there are pseudogenes. There is one IG gene on chromosome 21 but it does not have a pseudogene.

The word pseudogene appears in multiple columns 
Use this pattern instead, because it narrows what is included to just the gene_type column since all the rows in that column: ```grep "gene_type .*pseudogene.*" genes.gtf``` 

If we just want the chromosome (column 1), start (column 4), stop (column 5), and gene_name (column 14), we need to pull out those columns using cut
```sed "s/ /\t/g" genes.gtf > gene-tabs.gtf```
```cut -f 1,4,5,14 gene-tabs.gtf > gene-tabs.bed```