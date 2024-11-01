#Etta Schaye
#Quant Bio Lab Week 7

#This data comes from GTEx, which has whole-genome and RNA-seq data from 800+ post-mortem individuals
#across 50+ tissues, though not all individuals donated all tissues
#There are 17,000+ total RNA-seq samples 

#You will want to determine whether expression of each gene is correlated with the relevant predictor variable
#but you also want to "model out" the effects of less relevant covariates 

#If you want you can come back to this and look into how different predictor variables are being
#treated under the hood aka how you put less emphasis on particular variables

#Setup
setwd("~/qbb2024-answers/week7")
library("tidyverse")
library("DESeq2")

#Exercise 1 
#Step 1.1

#1.1.1
#Read in the count data and metadata
counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
metadata_df <- read.delim("gtex_metadata_downsample.txt", sep = ',')

#1.1.2
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")

#1.1.3
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")

#1.1.4

#Step 1.2

#1.2.1
table(colnames(counts_df) == rownames(metadata_df)) 

#1.2.2
dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~SEX + DTHHRDY + AGE)
#Step 1.3
#1.3.1
vsd <- vst(dds)

#1.3.2
plotPCA(vsd, intgroup = "SEX") + labs(title = "PCA", color = "Donor sex")
ggsave(filename = "PCA_SEX.png")
plotPCA(vsd, intgroup = "DTHHRDY") + labs(title = "PCA", color = "Cause of death") 
ggsave(filename = "DTHHRDY.png")
plotPCA(vsd, intgroup = "AGE") + labs(title = "PCA", color = "Donor age")
ggsave(filename = "AGE.png")

#Come back to these and change the legend to reflect the age range in each age category
#1.3.3
#PC1 accounts for 48% of the variance, while PC2 accounts for 7% of the variance 
#PC1 seems to be associated with cause of death, but the other subject-level variables
#don't separate particularly well on either axis 

#Exercise 2
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()

vsd_df <- bind_cols(metadata_df, vsd_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
#Step 2.1
#2.1.1
#It seems like WASH7P is slightly upregulated in males, but the result is not significant (2.792437e-01)
#Females were used as the reference group and the estimate for males is higher than the reference group
#2.1.2


#Step 2.2 
#2.2.1

#Step 2.3
#2.3.1
#2.3.2
#2.3.3
#2.3.4

#Step 2.4
#2.4.1 
#2.4.2


#Exercise 3
#Step 3.1

#3.1.1

#Advanced exercises 




#Exercise 2