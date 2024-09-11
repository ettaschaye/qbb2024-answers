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
       mapping = aes(x = Tissue_Data, y = Log2_Expr)) +
  geom_violin() +
  labs(y = "Log 2 Gene Expression", x = "Tissue + Gene") +
  coord_flip()+
  theme_classic()

#Given the tissue specificity and high expression level of these genes, are you surprised by the results?
  #No, I'm not surprised. It makes sense that expression would be high in the tissues
#What tissue-specific differences do you see in expression variability?
  #Stomach, small intestine, and pituitary glands have a wide range of expression
  #While pancreas tends to be narrowly highly expressed
#Speculate on why certain tissues show low variability while others show much higher expression variability.
  #The pancreas in general has high gene expression with low variability
  #My guess is this is because the pancreas is fairly consistently expressing genes to produce enzymes