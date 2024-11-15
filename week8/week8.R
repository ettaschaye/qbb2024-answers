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
