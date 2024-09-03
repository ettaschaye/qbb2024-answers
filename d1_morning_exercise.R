#Etta Schaye
#September 3rd, 2024
#Quant Bio Bootcamp Day 1, Morning

#Exercise 2
library("tidyverse") #load tidyverse

#Exercise 3
df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt") #load text file and assign it to the variable df
df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 )
head(df) 

#Exercise 4
df %>%
  group_by(SUBJECT) %>%  #group by subject
  summarise(num_of_samples = n()) %>% #produce a new data frame that only includes grouping variables
                                      #and create the variable num_of_samples corresponding to the size of the current group
                                      #which in this case is instances of each SUBJECT
  arrange(desc(num_of_samples))       #arrange num_of_samples descending

#K-562 and GTEX-NPJ8 have the most samples, with 217 and 72 samples respectively

df %>%
  group_by(SUBJECT) %>%
  summarise(num_of_samples = n()) %>%
  arrange((num_of_samples)) 
#GTEX-1JMI6 and GTEX-1PAR6 have the fewest samples, and both have 1 sample

#Exercise 5
df %>%
  group_by(SMTSD) %>%
  summarise(num_of_samples = n()) %>%
  arrange(desc(num_of_samples))
#Whole Blood and Muscle-Skeletal have the most samples, with 3288 and 1132 respectively

df %>%
    group_by(SMTSD) %>%
    summarise(num_of_samples = n()) %>%
    arrange((num_of_samples))
#Kidney-Medulla has the fewest number of samples, 4. 
#Cervix-Ectocervix and Fallopian tube are tied for second fewest, with 9 samples each. 

#Exercise 6
df_npj8 <- subset(df, SUBJECT == "GTEX-NPJ8")

df_npj8_dplyr <- df %>% 
  filter(SUBJECT == "GTEX-NPJ8")

df_npj8 %>%
  group_by(SMTSD) %>%
  summarise(num_of_samples = n()) %>%
  arrange(desc(num_of_samples))
#Whole Blood has the most number of samples 

View(df_npj8)

df_npj8_Whole_Blood <- df_npj8 %>%
    filter(SMTSD == "Whole Blood")
#Different technology was used to analyse different samples

#Exercise 7
df_autolysis <- df %>% #filter out NA values 
      filter( !is.na(SMATSSCR) )

df_autolysis <- df_autolysis %>% #create a new tibble using these operations
  mutate() %>% #make a new column
  group_by(SUBJECT) %>% #group by SUBJECT
  summarise(mean_SMATSSCR = mean(SMATSSCR)) #calculate the mean SMATSSCR by subject

df_autolysis %>% #filter to only those subjects with a SMATSSCR mean of 0
    filter(mean_SMATSSCR == 0)

ggplot(df_autolysis, 
       aes(x = mean_SMATSSCR))+
  geom_histogram()

#It looks to me like the autolysis scores are a normal distribution centered at 1
#I would probably display it as a histogram 


