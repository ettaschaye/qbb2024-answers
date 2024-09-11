#Etta Schaye
#September 6th, 2024
library(tidyverse)
library(broom)

setwd("/Users/cmdb/qbb2024-answers/day4-afternoon/")

#read in the data
dnm <- read_csv("aau1043_dnm.csv") 
ages <- read_csv("aau1043_parental_age.csv") #mother and father age at birth

#we are looking at de novo mutations that were not present in the parents of this individual
  #we essentially group by the individual (Proband_id)
dnm_summary <- dnm %>% 
  group_by(Proband_id) %>% 
  summarise(n_paternal_dna = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dna = sum(Phase_combined == "mother", na.rm = TRUE))

#Join the data frames, keep all observations from dnm_summary that have a matching key in ages
dnm_by_age <- left_join(dnm_summary, ages, by = "Proband_id")

# Step 2.1
# First, you’re interested in exploring if there’s a relationship between the number of DNMs and parental age. Use ggplot2 to plot the following. All plots should be clearly labelled and easily interpretable.
# 
# 1. the count of maternal de novo mutations vs. maternal age
ggplot(data = dnm_by_age,
       mapping = aes(y = n_maternal_dna,
                     x = Mother_age)) +
  geom_col() +
  xlab("Maternal age at birth") +
  ylab("Number of maternal de novo mutations") 


# 2. the count of paternal de novo mutations vs. paternal age

ggplot(data = dnm_by_age,
       mapping = aes(y = n_paternal_dna,
                     x = Father_age)) +
  geom_col() +
  xlab("Paternal age at birth") +
  ylab("Number of paternal de novo mutations")

# Step 2.2
# Now that you’ve visualized these relationships, you’re curious whether they’re statistically significant.
# Fit a linear regression model to the data using the lm() function.

lm(data = dnm_by_age,
   formula = n_maternal_dna ~1 + Mother_age) %>%
  summary()

# What is the “size” of this relationship? In your own words, what does this mean?
# Does this match what you observed in your plots in step 2.1?

# - For every year older a woman is when giving birth...
  # her child is predicted to inherit 0.37757 additional de novo mutations
  # Honestly, this does not appear to match what I plotted in step 2.1

# Is this relationship significant? How do you know? In your own words, what does this mean?
# - This relationship is significant. The P value for Mother_age is < 2e-16 ***

# Step 2.3
# As before, fit a linear regression model, but this time to test for an association between paternal age and paternally inherited de novo mutations.
lm_paternal <- lm(data = dnm_by_age,
   formula = n_paternal_dna ~1 + Father_age) %>%
  summary()
# What is the “size” of this relationship? In your own words, what does this mean? Does this match what you observed in your plots in step 2.1?
# - For every year older a man is when his baby is born...
# his child is predicted to inherit 1.35384 additional de novo mutations

# Is this relationship significant? How do you know? In your own words, what does this mean?
# - This relationship is significant. The P value for Father_age is < 2e-16 ***

# Step 2.4
# Using your results from step 2.3, predict the number of paternal DNMs
  #for a proband with a father who was 50.5 years old at the proband’s time of birth.
#Record your answer and your work (i.e. how you got to that answer).
#10.32632 + (Father_age)(1.35384) = 78.69524
10.32632 + (50.5*1.35384)

# Step 2.5
# Next, you’re curious whether the number of paternally inherited DNMs match
# the number of maternally inherited DNMs. 
# Plot the distribution of maternal DNMs per proband (as a histogram).
#In the same panel (i.e. the same set of axes) plot the distribution of paternal DNMs per proband. 
#Make sure to make the histograms semi-transparent so you can see both distributions.

#OK we want two histograms on the same axes where each bar is the number of maternal or paternal DNMs

ggplot(data = dnm_by_age) +
geom_histogram(mapping = aes(n_paternal_dna), alpha = 0.5, fill = "lightblue") + 
  geom_histogram(mapping = aes(n_maternal_dna), alpha = 0.5, fill = "pink") +
  xlab("Number of de novo mutations") +
  ylab("Number of individuals")

#Step 2.6
#Now that you’ve visualized this relationship
#you want to test whether there is a significant difference
#between the number of maternally vs. paternally inherited DNMs per proband.
#What would be an appropriate statistical model to test this relationship? Fit this model to the data.
 #I'm going to use a t-test because I am evaluating how a categorical variable (origin parent for DNM)
 #predicts the mean value of another variable (the number of DNM)

t.test(x = dnm_summary$n_paternal_dna, y = dnm_summary$n_maternal_dna, paired = TRUE)

#After performing your test, answer the following questions:
#What statistical test did you choose? Why?
 #See above

#Was your test result statistically significant? 
 #Yes, the p-value is less than 2.2e-16

#Interpret your result as it relates to the number of paternally and maternally inherited DNMs.
 #There are a statistically significant number of paternally and maternally DNMs
 #On average, there are 39.23485 more paternally contributed DNMs than maternally contributed DNMs


dnm_by_age


?aes()
?geom_histogram


