#day2-lunch answers
##Etta Schaye
##September 4th, 2024

##Exercise 1 
cut -f 7 hg38-gene-metadata-feature.tsv ###this will show me only the column gene_biotype
cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c 

###There are 19618 protein_coding genes
###I would like to know more about the type IG_pseudogene because there is only one instance of it and I want to know why if it exists at all, it only exists once in the data set

cut -f 1 hg38-gene-metadata-go.tsv | uniq -c | sort -n ###look at the number of go_ids for each ensembl_gene_id, sorted numerically
grep "ENSG00000168036" hg38-gene-metadata-go.tsv > ENSG00000168036_go_ids.txt ###display all rows with the ensembl_gene_id ENSG00000168036 and save them  
###This gene must be something very basic and essential because it is associated with a variety of GO terms

###Exercise 2
grep -w "IG_._gene" genes.gtf | cut -f 1 | uniq -c | sort -n #find the number of IG genes on each chromosome 
grep -w "IG_._pseudogene" genes.gtf | cut -f 1 | uniq -c | sort -n #find the number of IG pseudogenes on each chromosome 
###There are no IG genes on chromosomes 1, 8, 9, 10 but there are pseudogenes. There is one IG gene on chromosome 21 but it does not have a pseudogene