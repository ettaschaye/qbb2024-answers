#Etta Schaye
setwd("qbb2024-answers/week2")
library(tidyverse)
snp_counts <- read.table("snp_counts_raw.txt", header = TRUE)
snp_counts <- snp_counts %>% 
  mutate(MAF = str_replace(snp_counts$MAF, "chr1_snps_", "")) %>% 
  mutate(MAF = str_replace(snp_counts$MAF, ".bed", "")) %>%
  mutate(Feature = str_replace(snp_counts$Feature, "_chr1.bed", "")) %>%
  mutate(Feature = str_replace(snp_counts$Feature, "others", "other")) 
write.table(snp_counts, file = "snp_counts.txt", sep = "\t", row.names = FALSE, quote = TRUE)
snp_counts <- snp_counts %>% mutate(Enrichment = log2(Enrichment))


ggplot(snp_counts, aes(x = MAF, y = Enrichment, color = Feature, group = Feature)) +
  geom_line() +
  ggtitle("Enrichment of Genomic Features Partitioned\n by Minor Allele Frequency") +
  labs(x = "Minor Allele Frequency", y = "Enrichment (Log2 Transformed)")
ggsave("snp_enrichments.pdf", plot = last_plot(), device = "pdf")



  
