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
ggplot(full_data_3X) +
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  scale_x_discrete(limits = full_data_3X$depth, labels = full_data_3X$depth_label) +
  theme_bw() +
  geom_col(aes(x = depth, y = n), fill = "black", alpha = 0.5) +
  geom_line(aes(x = depth, y = poisson_predicted_n, color = "Poisson Predicted"), alpha = 0.5) +
  geom_line(aes(x = depth, y = normal_predicted_n, color = "Normal Predicted"), alpha = 0.5) +
  labs(title = "Simulated genome coverage 3X") +
  scale_color_manual(values = c("Poisson Predicted" = "blue", "Normal Predicted" = "red")) 
ggsave("ex1_3x_cov.png", scale = 2)
ggsave("ex1_*_cov.png")

#Count how many times each coverage level occurred 
print(full_data_3X)


### ### ### ### ### ### ### ### 
### Repeat with 10X coverage ### 
### ### ### ### ### ### ### ### 
#Import simulated data
  simulated_coverage_10X <- read_csv("genome_coverage_10X.csv", col_names = FALSE)
simulated_coverage_10X <- simulated_coverage_10X %>% rename("position_coverage" = "X1")

#Plot simulated data
ggplot(simulated_coverage_10X, 
       aes(position_coverage)) +
  geom_histogram(bins = 28, alpha = 0.7) + #one bin for integers 0 to 27
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  theme_minimal()

#Make a vector containing all coverage options (integers 0 to 13)
sequencing_depth_10X <- 0:27 

#Calculate Poisson distribution 
poisson_overlay_10X <- dpois(x = sequencing_depth_10X, lambda = 10)

#Calculate normal distribution
normal_distribution_10X <- dnorm(x = sequencing_depth_10X, mean = 10, sd = 3.16 )

#Make a tibble containing the range of coverage and the likelihood of an individual position having that coverage
poisson_overlay_10X <- tibble(Column1 = sequencing_depth_10X, Column2 = poisson_overlay_10X)
poisson_overlay_10X <- rename(poisson_overlay_10X, depth = Column1, probability_poisson = Column2)
poisson_overlay_10X <- mutate(poisson_overlay_10X, depth_label = paste0(depth,"X"))

normal_distribution_10X <- tibble(Column1 = sequencing_depth_10X, Column2 = normal_distribution_10X)
normal_distribution_10X <- rename(normal_distribution_10X, depth = Column1, probability_normal = Column2)
normal_distribution_10X <- mutate(normal_distribution_10X, depth_label = paste0(depth,"X"))


#Count the number of positions with each coverage level 
coverage_distribution_10X <- simulated_coverage_10X %>% count(position_coverage)

#Make one tibble
full_data_10X <- poisson_overlay_10X %>% left_join(coverage_distribution_10X, by = join_by(depth == position_coverage
))
full_data_10X <- full_data_10X %>% left_join(normal_distribution_10X)
full_data_10X <- full_data_10X %>% mutate(poisson_predicted_n = probability_poisson * 1000000)
full_data_10X <- full_data_10X %>% mutate(normal_predicted_n = probability_normal * 1000000)

#Plot full data
ggplot(full_data_10X) +
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  scale_x_discrete(limits = full_data_10X$depth, labels = full_data_10X$depth_label) +
  theme_bw() +
  geom_col(aes(x = depth, y = n), fill = "black", alpha = 0.5) +
  geom_line(aes(x = depth, y = poisson_predicted_n, color = "Poisson Predicted"), alpha = 0.5) +
  geom_line(aes(x = depth, y = normal_predicted_n, color = "Normal Predicted"), alpha = 0.5) +
  labs(title = "Simulated genome coverage 10X") +
  scale_color_manual(values = c("Poisson Predicted" = "blue", "Normal Predicted" = "red")) 
  ggsave("ex1_10x_cov.png", scale = 2)

#Count how many times each coverage level occurred 
print(full_data_10X)


### ### ### ### ### ### ### ### 
### Repeat with 30X coverage ### 
### ### ### ### ### ### ### ### 
#Import simulated data
simulated_coverage_30X <- read_csv("genome_coverage_30X.csv", col_names = FALSE)
simulated_coverage_30X <- simulated_coverage_30X %>% rename("position_coverage" = "X1")

#Plot simulated data
ggplot(simulated_coverage_30X, 
       aes(position_coverage)) +
  geom_histogram(bins = 58, alpha = 0.7) + #one bin for integers 0 to 57
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  theme_minimal()

#Make a vector containing all coverage options (integers 0 to 57)
sequencing_depth_30X <- 0:57 

#Calculate Poisson distribution 
poisson_overlay_30X <- dpois(x = sequencing_depth_30X, lambda = 30)

#Calculate normal distribution
normal_distribution_30X <- dnorm(x = sequencing_depth_30X, mean = 30, sd = 5.47 )

#Make a tibble containing the range of coverage and the likelihood of an individual position having that coverage
poisson_overlay_30X <- tibble(Column1 = sequencing_depth_30X, Column2 = poisson_overlay_30X)
poisson_overlay_30X <- rename(poisson_overlay_30X, depth = Column1, probability_poisson = Column2)
poisson_overlay_30X <- mutate(poisson_overlay_30X, depth_label = paste0(depth,"X"))

normal_distribution_30X <- tibble(Column1 = sequencing_depth_30X, Column2 = normal_distribution_30X)
normal_distribution_30X <- rename(normal_distribution_30X, depth = Column1, probability_normal = Column2)
normal_distribution_30X <- mutate(normal_distribution_30X, depth_label = paste0(depth,"X"))


#Count the number of positions with each coverage level 
coverage_distribution_30X <- simulated_coverage_30X %>% count(position_coverage)

#Make one tibble
full_data_30X <- poisson_overlay_30X %>% left_join(coverage_distribution_30X, by = join_by(depth == position_coverage
))
full_data_30X <- full_data_30X %>% left_join(normal_distribution_30X)
full_data_30X <- full_data_30X %>% mutate(poisson_predicted_n = probability_poisson * 1000000)
full_data_30X <- full_data_30X %>% mutate(normal_predicted_n = probability_normal * 1000000)

#Plot full data
ggplot(full_data_30X) +
  xlab("Simulated sequencing depth") +
  ylab("Number of nucleotides") +
  scale_x_discrete(limits = full_data_30X$depth, labels = full_data_30X$depth_label) +
  theme_bw() +
  geom_col(aes(x = depth, y = n), fill = "black", alpha = 0.5) +
  geom_line(aes(x = depth, y = poisson_predicted_n, color = "Poisson Predicted"), alpha = 0.5) +
  geom_line(aes(x = depth, y = normal_predicted_n, color = "Normal Predicted"), alpha = 0.5) +
  labs(title = "Simulated genome coverage 30X") +
  scale_color_manual(values = c("Poisson Predicted" = "blue", "Normal Predicted" = "red")) 
ggsave("ex1_30X_cov.png", scale = 2)



#Count how many times each coverage level occurred 
print(full_data_30X)


