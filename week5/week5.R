#Etta Schaye
#October 11th, 2024
setwd("~/qbb2024-answers/week5")

#Load libraries
library(DESeq2)
library(vsn)
library(matrixStats)
library(readr) 
library(dplyr)
library(tibble)
library(hexbin) 
library(ggfortify)


data = readr::read_tsv('salmon.merged.gene_counts.tsv') #read in data
data = tibble::column_to_rownames(data, var = "gene_name" ) #make gene_name row name
data = data %>% dplyr::select(-gene_id) #remove the gene_id column
#DESeq2 expects count data so it only tolerates integers 
data = data %>% mutate_if(is.numeric, as.integer) #convert floats to integers
data = data[rowSums(data) > 100,] #keep rows with 100+ reads
narrow = data %>% select(starts_with(c("A1_", "Cu_", "LFC-Fe_", "Fe_", "P1_", "P2-4_"))) #select narrow regions

