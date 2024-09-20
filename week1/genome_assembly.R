#Genome Assembly
#Etta Schaye
#Due Sep. 20th, 2024

#Set working directory
setwd("qbb2024-answers/week1/")

#Import libraries
library(tidyverse)

#Import simulated data
simulated_coverage_3X <- read_csv("genome_coverage.csv", col_names = FALSE)
simulated_coverage_3X <- simulated_coverage_3X %>% rename("position_coverage" = "X1")
              
#Plot simulated data
ggplot(simulated_coverage_3X, 
       aes(position_coverage)) +
  geom_histogram(bins = 14, alpha = 0.7) + #one bin for integers 0 to 13
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  theme_minimal()

#Make a vector containing all coverage options (integers 0 to 13)
sequencing_depth_3X <- 0:13 

#Calculate Poisson distribution 
poisson_overlay_3X <- dpois(x = sequencing_depth_3X, lambda = 3)

#Calculate normal distribution
normal_distribution_3X <- dnorm(x = sequencing_depth_3X, mean = 3, sd = 1.73 )

#Make a tibble containing the range of coverage and the likelihood of an individual position having that coverage
poisson_overlay_3X <- tibble(Column1 = sequencing_depth_3X, Column2 = poisson_overlay_3X)
poisson_overlay_3X <- rename(poisson_overlay_3X, depth = Column1, probability_poisson = Column2)
poisson_overlay_3X <- mutate(poisson_overlay_3X, depth_label = paste0(depth,"X"))

normal_distribution_3X <- tibble(Column1 = sequencing_depth_3X, Column2 = normal_distribution_3X)
normal_distribution_3X <- rename(normal_distribution_3X, depth = Column1, probability_normal = Column2)
normal_distribution_3X <- mutate(normal_distribution_3X, depth_label = paste0(depth,"X"))


#Count the number of positions with each coverage level 
coverage_distribution_3X <- simulated_coverage_3X %>% count(position_coverage)

#Make one tibble
full_data_3X <- poisson_overlay_3X %>% left_join(coverage_distribution_3X, by = join_by(depth == position_coverage
                                                    ))
full_data_3X <- full_data_3X %>% left_join(normal_distribution_3X)
full_data_3X <- full_data_3X %>% mutate(poisson_predicted_n = probability_poisson * 1000000)
full_data_3X <- full_data_3X %>% mutate(normal_predicted_n = probability_normal * 1000000)

#Plot full data

ggplot(full_data_3X) + #one bin for integers 0 to 13
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  scale_x_discrete(limits = full_data_3X$depth, labels = full_data_3X$depth_label) +
  theme_minimal() +
  geom_col(aes(x = depth, y = n), fill = "red", alpha = 0.5) +
  geom_col(aes(x = depth, y = poisson_predicted_n), fill = "blue", alpha = 0.5) +
  geom_col(aes(x = depth, y = normal_predicted_n), fill = "yellow", alpha = 0.5)
ggsave("ex1_*_cov.png")

#Count how many times each coverage level occurred 
print(full_data_3X)
#50687 positions were not sequenced 
#Poisson estimate for 0X: 0.04978707
#With 1 million positions, 0X coverage should occur 49787.07 times

