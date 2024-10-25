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

#Step 3.1
data = readr::read_tsv('salmon.merged.gene_counts.tsv') #read in data
data = tibble::column_to_rownames(data, var = "gene_name" ) #make gene_name row name
data = data %>% dplyr::select(-gene_id) #remove the gene_id column

#DESeq2 expects count data so it only tolerates integers 
data = data %>% mutate_if(is.numeric, as.integer) #convert floats to integers
data = data[rowSums(data) > 100,] #keep rows with 100+ reads
narrow = data %>% select(starts_with(c("A1_", "Cu_", "LFC-Fe_", "Fe_", "P1_", "P2-4_"))) #select narrow regions

#Step 3.2
# Create metadata tibble with tissues and replicate numbers based on sample names
narrow_metadata = tibble(tissue=as.factor(c("A1", "A1", "A1", "Cu", "Cu",
"Cu", "LFC-Fe", "LFC-Fe", "LFC-Fe", "Fe", "Fe", "Fe", "P1",
"P1", "P1", "P2-4", "P2-4", "P2-4" )),
                        rep=as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3)))

# Create a DESeq data object
narrowdata = DESeqDataSetFromMatrix(countData=as.matrix(narrow), colData=narrow_metadata, design=~tissue)

# Plot variance by average
meanSdPlot(assay(narrowdata))

# Log transform data
narrowLogdata = normTransform(narrowdata) # log(1 + data)

# Plot log-transformed data variance by average
meanSdPlot(assay(narrowLogdata))

#create PCA data
narrowPcaData = plotPCA(narrowLogdata,intgroup=c("rep","tissue"), returnData=TRUE)

# Plot PCA data
ggplot(narrowPcaData, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)

# Batch-correct data to remove excess variance with variance stabilizing transformation
narrowVstdata = vst(narrowdata)

# Plot variance by average to verify the removal of batch-effects
meanSdPlot(assay(narrowVstdata))

# Perform PCA and plot to check batch-correction
narrowPcaData = plotPCA(narrowVstdata,intgroup=c("rep","tissue"), returnData=TRUE)
ggplot(narrowPcaData, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)
ggsave(filename = "PCA_plot.png")

#calculate standard deviations 
sds = apply(assay(narrowVstdata), 1, sd)

# Convert into a matrix
narrowVstdata = as.matrix(assay(narrowVstdata))

# Find replicate means
combined = data[,seq(1, 21, 3)]
combined = combined + data[,seq(2, 21, 3)]
combined = combined + data[,seq(3, 21, 3)]
combined = combined / 3
sds = rowSds(as.matrix(combined))

# Use replicate means to filter low variance genes out
filt = rowSds(as.matrix(combined)) > 1
narrowVstdata = narrowVstdata[filt,]

# Plot expression values with hierarchical clustering
heatmap(narrowVstdata, Colv=NA)

# Perform new hierarchical clustering with different clustering method
distance = dist(narrowVstdata)
Z = hclust(distance, method='ave')

# Plot expression values with new hierarchical clustering
heatmap(narrowVstdata, Colv=NA, Rowv=as.dendrogram(Z))

# Set seed so this clustering is reproducible
set.seed(42)

# Cluster genes using k-means clustering
k=kmeans(narrowVstdata, centers=12)$cluster

# Find ordering of samples to put them into their clusters
ordering = order(k)

# Reorder genes
k = k[ordering]

# Plot heatmap of expressions and clusters
heatmap(narrowVstdata[ordering,],Rowv=NA,Colv=NA,RowSideColors = RColorBrewer::brewer.pal(12,"Paired")[k])

# Save heatmap
png("heatmap.jpg")
heatmap(narrowVstdata[ordering,],Rowv=NA,Colv=NA,RowSideColors = RColorBrewer::brewer.pal(12,"Paired")[k])
dev.off()

# Pull out gene names from a specific cluster
genes = rownames(narrowVstdata[k == 2,])

# Same gene names to a text file
write.table(genes, "cluster_genes.txt", sep="\n", quote=FALSE, row.names=FALSE, col.names=FALSE)

# Only look at cluster 1
genes_cluster_1 = rownames(narrowVstdata[k == 1, ])
cat(genes_cluster_1, sep = "\n")

# Only look at cluster 2
genes_cluster_2 = rownames(narrowVstdata[k == 2, ])
cat(genes_cluster_2, sep = "\n")

# Only look at cluster 3
genes_cluster_3 = rownames(narrowVstdata[k == 2, ])
cat(genes_cluster_3, sep = "\n")

# Only look at cluster 12
genes_cluster_12 = rownames(narrowVstdata[k == 2, ])
cat(genes_cluster_12, sep = "\n")
