#Genome Assembly
#Etta Schaye
#Due Sep. 20th, 2024

#Set working directory
setwd("qbb2024-answers/week1/")

#Import libraries
library(tidyverse)

#Import simulated data
genome_coverage <- read_csv("genome_coverage.csv", col_names = FALSE)

#Plot simulated data
ggplot(genome_coverage, 
       aes(X1)) +
  geom_histogram(bins = 14, alpha = 0.7) + #one bin for integers 0 to 13
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  theme_minimal()
sequencing_depth <- 0:13 
poisson_overlay <- dpois(x = sequencing_depth, lambda = 3)
poisson_overlay <- tibble(Column1 = sequencing_depth, Column2 = poisson_overlay)
poisson_overlay <- rename(poisson_overlay, depth = Column1, probability = Column2)


# Create the plot
ggplot() +
    geom_histogram(data = genome_coverage, aes(x = X1), bins = 14, alpha = 0.7) + #one bin for integers 0 to 13
       xlab("Simulated sequencing depth") +
       ylab("Number of nucleotides") +
       theme_minimal() +
  geom_col(data = poisson_overlay, aes(x = sequencing_depth, y = probability),fill = "blue", alpha = 0.7) +
  labs(x = "Sequencing Depth", y = "Probability", title = "Title") + scale_y_continuous(sec.axis = sec_axis(~./max(table(genome_coverage$X1)), name = "Probability"))
  theme_minimal() 
  
#I cannot get them to overlay successfully

#Count how many times each coverage level occurred 
genome_coverage
coverage_tally <- genome_coverage %>% count(X1)
coverage_tally

#50687 positions were not sequenced 
#Poisson estimate for 0X: 0.04978707
#With 1 million positions, 0X coverage should occur 49787.07 times

