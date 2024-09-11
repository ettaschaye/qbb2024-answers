#!/usr/bin/env python3

import sys

import numpy

#get file name 
#use gene_tissue.tsv as the file here
#allows the first argument provided in the command line (after the program itself in position 0) 
#to be passed on as filename
filename = sys.argv[1] 
#open file in read only mode, assign the file object to the variable fs 
fs = open(filename, mode='r') 
#create dict to hold samples for gene-tissue pairs
#create empty dictionary named relevant_samples
relevant_samples = {}
#step through file
for line in fs:
    #split line into fields
    #by removing trailing new line characters and splitting on tab
    fields = line.rstrip("\n").split("\t")
    #create key from gene and tissue
    #the gene id is in field 0 and the tissue is in field 2
    key = (fields[0], fields [2])
    # initialize dict from key with list to hold samples
    relevant_samples[key] = []
fs.close()
#print(relevant_samples)
#output for relevant_samples is the dictionary
#each key is the format ('gene_id', 'tissue'), and each value is empty []


#get metadata file name 
#GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt is the metadata file 
filename = sys.argv[2] 
#open file
fs = open(filename, mode='r')
#skip line
fs.readline()
#create dict to hold samples for gene-tissue pairs
tissue_samples = {}
#step through file
for line in fs:
    #split line into fields
    fields = line.rstrip("\n").split("\t")
    #create key from gene and tissue
    key = fields[6]
    value = fields[0]
    # initialize dict from key with list to hold samples
    tissue_samples.setdefault(key, [])
    tissue_samples[key].append(value)
fs.close()

#get third file name 
filename = sys.argv[3] 
#open file
fs = open(filename, mode='r')
#skip line
fs.readline()
fs.readline()
header = fs.readline().rstrip("\n").split("\t")
header = header[2:]

#print(header)


#We want to create a dictionary of each tissue
#and which columns in the gene expression file correspond to it

tissue_columns = {} #creates empty dictionary tissue_columns
for tissue, samples in tissue_samples.items():
    tissue_columns.setdefault(tissue, []) #it says to get rid of the s in setdefault
    for sample in samples:
        if sample in header: #used to say if sample in samples
            position = header.index(sample) #if i eliminate the error in 68, it says there is a new issue here
            tissue_columns[tissue].append(position)

#print(tissue_columns)
#this prints the position of the relevant samples
#how can we go from a list of relevant samples to number of samples per tissue
#Now you have pairs of genes and tissues and you can select relevant genes
#Next step is get the length of the list of the sample columns 
for key, value in tissue_columns.items():
    print(key, value) #on every line we should have the key followed by the list)
    print(key, len(value)) #print out the tissue type and length of the value

#Find tissue with max number of samples
max_value = 0 #assign the value 0 to the variable max_value
max_tissue = "" #assign an empty string to the variable max_tissue

#Return the key-value pairs for the dictionary tissue_columns
#Then, if the length of the list of samples is greater than or equal to max_value (starting value is 0)...
#set max_value to the length of the sample list and set max_tissue to the name of the tissue key associated with the longest list of samples
#after that loop, print the final value of max_tissue and max_value
for tissue, samples in tissue_columns.items():   
    if len(samples) >= max_value:  
        max_value = len(samples)
        max_tissue = tissue
print(max_tissue, max_value)


#Find tissue with min number of samples
min_value = 0 #assign the value 0 to the variable min_value
min_tissue = "" #assign an empty string to the variable min_tissue

#Return the key-value pairs for the dictionary tissue_columns
#Then, if the length of the list of samples is less than or equal to min_value (starting value is 0)...
#set min_value to the length of the sample list and set min_tissue to the name of the tissue key associated with the longest list of samples
#after that loop, print the final value of min_tissue and min_value

for tissue, samples in tissue_columns.items():
    if len(samples) <= min_value:
        min_value = len(samples)
        min_tissue = tissue
print(min_tissue, min_value)

#Muscle - Skeletal cells have the most samples: 803
#Cells - Leukemia cell line (CML) have the fewest samples: 0

"""
python ./day4-lunch-exercise.py gene_tissue.tsv GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct
"""
