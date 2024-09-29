#!/usr/bin/env bash

### Question 1.1 ###
sed -n '2p' A01_09.fastq | wc -c
#This prints the second line in the file, which contains the base calls for that read. Then it counts the characters in that line
#By default, it includes the new line character, so I accounted for that by subtracting 1 (77-1=76)
#Maybe I will come back to this and confirm that every single read is the same length, but I spot checked for a few random reads

### Question 1.2 ###
wc -l A01_09.fastq
#This counts the total number of lines in the file, which is 2678192. 
#Dividing this number by 4 gives me the number of reads: 669548

### Question 1.3 ###
#Since according to this paper the yeast genome is 1.2 Mb and we have 76 bp reads 
#(genome_size * coverage)/read_length = number_of_reads
#(1,200,000 bp * coverage)/76 bp = 669548
#1,200,000 bp * coverage = 50885648
#~42.4X coverage 

### Question 1.4 ###
du -h A01_*.fastq | sort
#This gives me the size of all the files in my folder with the naming format A01_(anything).fastq and sorts them by ascending size
#Since sort appears to work by looking at the first character in each line for any differences, then the second, and so on
#This might not work if the numbers had a different number of digits, but I can see that they do and it works
#The smallest file is 110M: A01_27.fastq
#The largest file is 149M: A01_62.fastq

### Question 1.5 ###
#The median base quality is 35
#A Phred score of 30 means there is a 1 in 1000 chance a call for any given base is wrong 
#A Phred score of 40 means there is a 1 in 10000 chance a call for any given base is wrong
#So I think 1/(10^(Phred_score/10)) is the probability a call for a given base is wrong
#A Phred score of 35 means 1 in every ~3162 bases is wrong
#It doesn't look like there is a huge amount of variation in the quality since the median quality score is between 35 and 36 across the full read

### Question 2.1 ###
wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
gunzip sacCer3.fa.gz
bwa index sacCer3.fa #index 
# These are the file types it should produce when it is indexed
# .amb: text, records appearance of N (or other non-ATGC) in the reference fasta
# .ann: text, to record ref sequences, name, length, etc.
# .bwt: binary, the Burrows-Wheeler transformed sequence
# .pac: binary, packaged sequence (four base pairs encode one byte)
# .sa: binary, suffix array index

#There are 16 chromosomes in the yeast genome

#Let's write a for loop
