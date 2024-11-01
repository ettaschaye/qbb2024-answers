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
#It seems like WASH7P is slightly upregulated in males, but the result is not significant (p value: 2.792437e-01)
#Females were used as the reference group and the estimate for males is higher than the reference group
#2.1.2
m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
#This gene also appears upregulated in males but this result is more significant

#Step 2.2 
#2.2.1
dds <- DESeq(dds)

#Step 2.3
#2.3.1
res <- results(dds, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")
#2.3.2
res %>% filter(padj < 0.1)

#262 genes have an FDR below 10%, but none have an FDR of exactly 0.1

#2.3.3
chrom <- read_delim("gene_locations.txt")
genes_mapped <- res %>% left_join(chrom, by = "GENE_NAME") %>% arrange(padj)
#Unsurprisingly, my top hits are Y-chromosome genes upregulated in males
#There are also X-chromosome genes downregulated in males 
#2.3.4
genes_mapped %>% filter(GENE_NAME == "WASH7P")
genes_mapped %>% filter(GENE_NAME == "MAP7D2")
#Here it looks like MAP7D2 is actually downregulated in males and it is a very signficiant result
#and WASH7P is weakly upregulated in males and it is not significant (which is consistent with the lm)

#Step 2.4
#2.4.1 
res2 <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes")  %>%
  as_tibble(rownames = "GENE_NAME")
#2.4.2
res2 %>% filter(padj < 0.1)
#16,069 genes are differentially expressed
#Given that these are blood cells, we would not expect there to be a huge number
#of sex-specific differences in gene expression
#However, people on ventilators are more likely to be very sick and/or old, so maybe
#that accounts for differences in gene expression

#Exercise 3
#Step 3.1
ggplot(data = res, aes(x = log2FoldChange, y = padj )) +
  geom_point(aes(color = ifelse(padj < 0.1 & log2FoldChange > 1, "yes", "no"))) +
  scale_color_manual(values = c("yes" = "red", "no" = "black")) +
  labs(title = "Differential gene expression by sex", color = "Significantly upregulated?")
ggsave(filename = "volcano_plot.png")

#Advanced exercises 




#Exercise 2