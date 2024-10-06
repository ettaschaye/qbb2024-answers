#!/usr/bin/env python3

import re

#Look for the allele frequencies
AF_pattern = r'AF=([^;]*)' 
#r': denotes a raw character
#AF=: looks for for the literal expression "AF="
#(): establishes a capturing group that treats part of the pattern as a single unit
#[^;]: a wild-card that matches anything except a semi-colon 
#*: zero or more times
#Basically, this looks for places in the file where there is AF=, followed by anything and terminating when it finds a semicolon

#Make an empty list to store allele frequencies
af_values = []  

#Opens the vcf and loops through it
with open('biallelic.vcf') as infile:
    for line in infile:
        if line.startswith('#'):  #Skip header lines which begin with pound sign
            continue
        fields = line.rstrip('\n').split('\t')  #Strip new line characters and split on tabs
        
        #Looks for matches to the pattern
        for field in fields:
            match = re.search(AF_pattern, field)
            if match:
                af_value = float(match.group(1))  #
                af_values.append(af_value)
                break  #Exit loop after the first match
 #Write allele frequencies to a file called AF.txt
with open('AF.txt', 'w') as outfile:
    for af in af_values:
        outfile.write(f"{af}\n")  #Put each allele frequency on its own line




### Question 3.1 ###

#This looks somewhat expected to me. Since these are recombinant lines where one parent strain is lab adapted and the other is a wine strain,
#I would expect many loci to vary based on which parent it was inherited from
#However, I am surpised there aren't more variants with an allele frequency of 1.0, since there must be many conserved regions of the genome
#where there is no variation
#Would those just not be identified as variants, like if the wine strain matches the reference strain at a locus, then it is not a variant?
#This kind of looks like a Poisson distribution. Technically a Poisson distribution only uses integers but given that we have 11 bins and 11 values (0, 0.1...1.0)
#spaced equally apart, maybe it functions as "Poisson-like"? Or it is just a normal distribution and I am overthinking it 

#Make an empty list to store read depth
dp_values = []  

#Opens the vcf and loops through it
with open('biallelic.vcf') as infile:
    header = next(infile)
    sample_names = header.rstrip('\n').split('\t')[9:]  # Get sample names from the header

    for line in infile:
        if line.startswith('#'):  #Skip header lines which begin with pound sign
            continue
        fields = line.rstrip('\n').split('\t')  #Strip new line characters and split on tabs
        
        #Only look at sample specific fields
        sample_fields = fields[9:]
        
        for sample_data in sample_fields:
            #Split each tab separated section on colons to look at specific values
            values = sample_data.split(':')
            if len(values) >= 3:  #Make sure the third value (which should be read depth) exists
                dp_sample = int(values[2])  
                dp_values.append(dp_sample)

with open('DP.txt', 'w') as dp_file:
    for dp in dp_values:
        dp_file.write(f"{dp}\n")  #Write each read depth on a new line