library(tidyverse)
setwd("qbb2024-answers/day4-lunch-exercise/")
expression <- read_tsv("dicts_expr.tsv")

glimpse(expression)

#Add new identifier with tissue and gene
#Log-transform expression data
expression <- expression %>%
  mutate(Tissue_Data = paste0(Tissue, "", GeneID))  %>%
  mutate(Log2_Expr = log2(Expr + 1))

#Violin plot of expression data
ggplot(data = expression,
       mapping = aes(y = Tissue_Data, x = Log2_Expr)) +
  geom_violin() +
  labs(x = "Log 2 Gene Expression", y = "Tissue + Gene") +
  theme_classic()

