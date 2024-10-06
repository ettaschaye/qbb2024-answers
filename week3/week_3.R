#Etta Schaye
setwd("qbb2024-answers/week3")
library(tidyverse)
AF_dist <- read.table("AF.txt") %>% rename("allele_frequency" = "V1")
DP_dist <- read.table("DP.txt") %>% rename("read_depth" = "V1") %>%
  filter(read_depth <= 20)


ggplot(AF_dist, aes(x = allele_frequency)) +
  geom_histogram(bins = 11, color = "white") +
  labs(title = "Allele frequency distribution", x = "Allele frequency", y = "Number of variants") +
  scale_x_continuous(breaks = seq(0, 1, by = 0.1)) +
   theme(panel.background = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "light gray"),
        panel.grid.minor.y = element_line(color = "light gray"))
ggsave("AF_dist.png")

ggplot(DP_dist, aes(x = read_depth)) +
  geom_histogram(bins = 20, color = "white") +
  labs(title = "Read depth distribution", x = "Read depth", y = "Number of samples") +
  scale_x_continuous(breaks = seq(1, 20, by = 1)) +
  theme(panel.background = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(color = "light gray"),
        panel.grid.minor.y = element_line(color = "light gray")) 
ggsave("DP_dist.png")


biallelic <- read_tsv("biallelic.vcf", comment = "#", col_names = FALSE) 

biallelic <- biallelic %>%
  rename("CHROM" = "X1", "POS" = "X2", "A01_62"	= "X10", "A01_09" = "X19") %>%
  select(CHROM, POS, A01_62, A01_09) %>%
  mutate("A01_62_genotype" = substr(A01_62, 1, 1)) %>%
  mutate("A01_09_genotype" = substr(A01_09, 1, 1))

chrIV <- biallelic %>% filter(CHROM == "chrIV")


# Create a combined plot with y-axis labels and custom legend title
wine_vs_lab <- ggplot() +  
  geom_jitter(data = chrIV, aes(x = POS, y = 0.2, color = A01_62_genotype), size = 2, width = 0.2, height = 0.1) +
  geom_jitter(data = chrIV, aes(x = POS, y = 0.45, color = A01_09_genotype), size = 2, width = 0.2, height = 0.1) +
  labs(title = "Genotype by Position on Chromosome IV", x = "Position") +
  scale_color_manual(values = c("black", "blue", "red"), 
                     labels = c("Missing", "REF", "ALT"),
                     name = "Genotype") + 
  scale_y_continuous(breaks = c(0.2, 0.45), labels = c("Strain A01_62", "Strain A01_09")) +
  theme(axis.ticks.y = element_blank(),
        axis.title.y = element_blank())
ggsave("wine_vs_lab.png", scale = 1.5)
