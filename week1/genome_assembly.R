#Genome Assembly
#Etta Schaye
#Due Sep. 20th, 2024

#Set working directory
setwd("qbb2024-answers/week1/")

#Import libraries
library(tidyverse)

#Import simulated data
simulated_coverage <- read_csv("genome_coverage.csv", col_names = FALSE)
simulated_coverage <- simulated_coverage %>% rename("position_coverage" = "X1")
              
#Plot simulated data
ggplot(simulated_coverage, 
       aes(position_coverage)) +
  geom_histogram(bins = 14, alpha = 0.7) + #one bin for integers 0 to 13
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  theme_minimal()

#Make a vector containing all coverage options (integers 0 to 13)
sequencing_depth <- 0:13 

#Calculate Poisson distribution 
poisson_overlay <- dpois(x = sequencing_depth, lambda = 3)

#Make a tibble containing the range of coverage and the likelihood of an individual position having that coverage
poisson_overlay <- tibble(Column1 = sequencing_depth, Column2 = poisson_overlay)
poisson_overlay <- rename(poisson_overlay, depth = Column1, probability = Column2)
poisson_overlay <- mutate(poisson_overlay, depth_label = paste0(depth,"X"))


#Count the number of positions with each coverage level 
coverage_distribution <- simulated_coverage %>% count(position_coverage)

#Can I join these and make one tibble?
full_data <- poisson_overlay %>% left_join(coverage_distribution, by = join_by(depth == position_coverage
                                                    ))
full_data <- full_data %>% mutate(poisson_predicted_n = probability * 1000000)

ggplot(full_data) + #one bin for integers 0 to 13
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  scale_x_discrete(limits = full_data$depth, labels = full_data$depth_label) +
  theme_minimal() +
  geom_col(aes(x = depth, y = n), fill = "red", alpha = 0.5) +
  geom_col(aes(x = depth, y = poisson_predicted_n), fill = "blue", alpha = 0.5)


#Count how many times each coverage level occurred 
print(full_data)
#50687 positions were not sequenced 
#Poisson estimate for 0X: 0.04978707
#With 1 million positions, 0X coverage should occur 49787.07 times

