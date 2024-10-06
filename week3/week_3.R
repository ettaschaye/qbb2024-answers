#Etta Schaye
setwd("qbb2024-answers/week3")
library(tidyverse)
AF_dist <- read.table("AF.txt") %>% rename("allele_frequency" = "V1")
DP_dist <- read.table("DP.txt") %>% rename("read_depth" = "V1") %>%
  filter(read_depth <= 20)


ggplot(AF_dist, aes(x = allele_frequency)) +
  geom_histogram(bins = 11 ) +
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


