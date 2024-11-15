#Etta Schaye
#Quant Bio Lab Week 8
#Single Cell RNA-seq Analysis with Bioconductor

#This assignment is an example of how you might analyze data sourced from a public database,
#in which case you start at the point of analysis where the authors left off.

#This data comes from the Fly Cell Atlas
#They characterized 15 tissue types alongside whole head and whole body.
#They identified and annotated 250+ single cell clusters 

#Load required packages
# BiocManager::install("zellkonverter") 
library("zellkonverter")
#loads single cell data from H5ad file format and creates a SingleCellExperiment object

library("scuttle")
library("scran")
library("scater")
#provide core single cell functionality 

library("ggplot2")

setwd("~/qbb2024-answers/week8/")

gut <- readH5AD("v2_fca_biohub_gut_10x_raw.h5ad")
assayNames(gut) <- "counts"
gut <- logNormCounts(gut)
#Exercise 1 
gut
#13407 genes are quantified 
#11788 cells are quantified 
#pca, tsne, umap are present 

ncol(colData(gut))
#There are 39 columns 
colnames(colData(gut))
#I'm interested in the scrublet columns because I have no idea what that means
gut_counts <- logNormCounts(gut)
plotReducedDim(gut, "X_umap", colour_by = "broad_annotation")

#Exercise 2
genecounts <- rowSums(assay(gut))
summary(genecounts)
#The mean is 3185
#The median is 254
#It seems like some genes with very high counts are skewing the mean

sort(genecounts, decreasing =  TRUE)
?sort
#The genes with the highest expression are...
#lncRNA:Hsromega 601414, pre-rRNA:CR45845 470729, lncRNA:roX1 291965
#At least two of these are non-coding RNAs

cellcounts <- colSums(assay(gut))
hist(cellcounts)
summary(cellcounts)

#The mean number of counts per cell is 3622
#I'm not sure why some cells have really high counts, I will come back to that question

celldetected <- colSums(assay(gut)>0) 
hist(celldetected)
summary(celldetected)

#The mean number of genes per cell is 1059

1059/13407

#This is 0.07898859 of the total genes in the dataset

gut_names <- rownames(gut)
mito <- grep(pattern = "^mt:", gut_names, value = TRUE)
df <- perCellQCMetrics(gut, subsets=list(Mito=mito))
df <- as.data.frame(df)
summary(df)
