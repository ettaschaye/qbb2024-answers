library(tidyverse)
library(palmerpenguins)
library(ggthemes)
glimpse(penguins)
penguins

#we are using the data visualization in R for Data Science 
#indexing different parts of a data frame
penguins[,"island"] #select all rows, but just the island column 
penguins[,c("species", "island")] #you need to use the c() notation when providing multiple values 
#in a tibble, columns have names, but rows don't 
penguins[2,] #if you just wanted to see the second observation (row), you can note it that way
penguins[2,2] #if you just wanted to see the second row and second column, you can note it this way

?ggplot
?aes

ggplot(data = penguins) + 
       geom_point(mapping = aes(x = flipper_length_mm,
                     y = body_mass_g,
                     color = species,
                     shape = species)) +
       geom_smooth(mapping = aes(x = flipper_length_mm,
                                 y = body_mass_g),
                   method = 'lm') +
       scale_color_colorblind() +
       xlab('Flipper length (mm)') +
       ylab('Body mass (g)') +
       ggtitle('Relationship between body mass\nand flipper length')
  ggsave(filename = "penguin-plot.pdf")
?ggsave
  

ggplot(data = penguins,
       mapping = aes(x = bill_length_mm, fill = sex)) +
       scale_fill_colorblind() +
    geom_histogram(position = "identity", alpha = 0.5) +
    facet_grid(sex ~ species)

ggplot(data = penguins,
       mapping = aes(x = bill_length_mm, fill = species)) +
  scale_fill_colorblind() +
  geom_histogram(position = "identity", alpha = 0.5) +
  facet_grid(sex ~ . )


ggplot(data = penguins, mapping = aes(x = factor(year), y = body_mass_g, fill = sex))+
  geom_boxplot()+
  facet_grid(island ~ species)
?geom_boxplot
