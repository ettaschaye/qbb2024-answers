#Etta Schaye
#September 3rd, 2024

#Q1
setwd("/Users/cmdb/qbb2024-answers/d1-afternoon/") #set working directory
library(tidyverse) #load tidyverse
library(viridis) 
df <- read_delim("/Users/cmdb/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt") #read GTEx file

#Q2
glimpse(df) #view all columns of the data frame

#Q3
RNA_seq_only <- df %>% 
  filter(SMGEBTCHT == "TruSeq.v1") #filter the data frame to only RNAseq data, save it as a new data frame

#Q4
ggplot(data = RNA_seq_only, 
       mapping = aes(x = SMTSD)) + #produce a ggplot from data frame df where the x-axis is SMTSD
                                   #by default the y-axis will be the number of samples 
  geom_bar() + #represent the data using a bar plot
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + #rotate the x-axis text
  xlab("Tissue type") + #label the x-axis 
  ylab("Number of samples") + #label the y-axis
  labs(title = "Number of samples by tissue type")

#Q5
#SMRIN is the tissue integrity number, ranging from least (10) to most (1) degraded 
ggplot(data = RNA_seq_only, 
       mapping = aes(x = SMRIN)) + 
  geom_histogram() +
  xlab("Tissue integrity number") +
  ylab("Number of samples")
#I would say the distribution is unimodal even though there is a smaller peak at the high end of the distribution

#Q6
ggplot(data = RNA_seq_only, 
       mapping = aes(x = SMTSD, y = SMRIN)) + 
       geom_boxplot() +
       theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +  #rotate the x-axis text
       xlab("Tissue type") +
       ylab("Tissue integrity number") +
      labs(title = "Tissue integrity number by tissue type")

#Cultured fibroblasts, EBV-transformed lymphocytes, and Leukemia cell lines all have high medians
#Additionally, cultured fibroblasts and EBV-transformed lymphocytes have many outliers
#These are all cell types that are cultured in a lab rather than whole tissues so they might have   
#Kidney medulla cells are in general of low quality but I don't have a good hypothesis for why :) 

#Q7
#Genes detected is SMGNSDTC
ggplot(data = RNA_seq_only, 
       mapping = aes(x = SMTSD, y = SMGNSDTC)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +  #rotate the x-axis text
  xlab("Tissue type") +
  ylab("Genes detected") +
  labs(title = "Genes detected by tissue type")
#There are a very high number of genes detected in samples taken from the testis
#Maybe this is because there is more undifferentiated tissue in testis
#Since there is continuous spermatogenesis taking place there 
#Wow cool, I hadn't looked at the paper yet
#There is high transcription activity coupled with efficient DNA damage repair

#Q8
#SMTSISCH is total ischemic time
#SMRIN is tissue integrity number
ggplot(data = RNA_seq_only, 
       mapping = aes(x = SMTSISCH, y = SMRIN)) + 
  geom_point(size = 0.5, alpha = 0.5) +
  facet_wrap(vars(SMTSD)) +
  geom_smooth(method = "lm") +
  xlab("Ischemic time (minutes)") +
  ylab("RNA integrity number") 
#In general, the quality of the sample declines the longer it sits before being stabilized
#The exceptions to this trend are cultured cells, skin tissue, brain tissue, and whole blood samples

#Q9
ggplot(data = RNA_seq_only, 
       mapping = aes(x = SMTSISCH, y = SMRIN)) + 
  geom_point(size = 0.5, alpha = 0.5, aes(color = SMATSSCR)) +
  facet_wrap(vars(SMTSD)) +
  geom_smooth(method = "lm") +
  xlab("Ischemic time (minutes)") +
  ylab("RNA integrity number") +
  labs(color = "Autolysis score") 
  

