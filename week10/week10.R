#Etta Schaye
#Quant Bio Lab 2024
library(ggplot2)
library(tidyverse)

setwd("~/qbb2024-answers/week10/")
means <- read.delim("data.tsv")
RNA_mean <- means %>% dplyr::select(Gene, RNA_mean)
PCNA_mean <- means %>% dplyr::select(Gene, PCNA_mean)
log2_ratio <- means %>% dplyr::select(Gene, log2_ratio)

#Nascent RNA
RNA_mean_plot <- ggplot(RNA_mean, aes(x = Gene, y = RNA_mean)) + 
  geom_violin()
RNA_mean_plot <- RNA_mean_plot + geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Mean nuclear intensity (nascent RNA) by gene knocked down",
           x = "Gene knocked down",
          y = "Nascent RNA intensity")
#PCNA
PCNA_mean_plot <- ggplot(PCNA_mean, aes(x = Gene, y = PCNA_mean)) + 
  geom_violin()
PCNA_mean_plot <- PCNA_mean_plot + geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "Mean nuclear intensity (PCNA) by gene knocked down",
       x = "Gene knocked down",
       y = "PCNA intensity")

#log2_ratio
log2_ratio_mean_plot <- ggplot(log2_ratio, aes(x = Gene, y = log2_ratio)) + 
  geom_violin()
log2_ratio_mean_plot <- log2_ratio_mean_plot + geom_jitter(shape=16, position=position_jitter(0.2)) +
  labs(title = "log2 ratio of nascent RNA to PCNA by gene knocked down",
       x = "Gene knocked down",
       y = "log2 ratio")

ggsave("RNA_mean_plot.png", RNA_mean_plot)
ggsave("PCNA_mean_plot.png", PCNA_mean_plot)
ggsave("log2_ratio_mean_plot.png", log2_ratio_mean_plot)



#APEX1 has the lowest nascent RNA to PCNA ratio, meaning there is less transcription.
#This gene is involved in DNA repair and regulates the activity of transcription factors. 
#SRSF1 has the highest ratio. It can both activate and repress splicing.
#Maybe it is the loss of repression that is keeping transcription high when this gene is knocked down. 
#That is how I would make sense of the results I'm seeing. 


