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


# There are 17 chromosomes in the yeast genome
grep "chr" sacCer3.fa # Check matches for the pattern "chr" and confirm by eye that it looks correct
grep "chr" sacCer3.fa | wc -l # Count the number of matches for the pattern


#Let's write a for loop

# #Defines the loop as applying to all files beginning with A01_ and ending with .fastq
# for file in A01_*.fastq
#  do
#  #Strip the prefix (path to the directory) and suffix (file extension) and save the base name as a variable called sample_name
#     sample_name=$(basename "$file" .fastq)
#     bwa mem -t 8 -R "@RG\tID:${sample_name}\tSM:${sample_name}\tPL:illumina" sacCer3.fa "$file" > "${file%.fastq}.sam" 
# done

### Question 2.2 ###
samtools view -c A01_09.sam
#There are 669548 read alignments 

### Question 2.3 ###
samtools view -b -o A01_09.bam A01_09.sam
samtools sort -o sorted_A01_09.bam A01_09.bam
samtools index sorted_A01_09.bam
samtools idxstats sorted_A01_09.bam
#17815 reads from chrIII

### Question 2.4 ###
#OK I can update my for loop

for file in A01_*.fastq
 do
    sample_name=$(basename "$file" .fastq)
    bwa mem -t 8 -R "@RG\tID:${sample_name}\tSM:${sample_name}\tPL:illumina" sacCer3.fa "$file" > "${file%.fastq}.sam" 
    samtools sort -O bam -o ${sample_name}_sorted.bam "${file%.fastq}.sam" 
    samtools index "${sample_name}_sorted.bam" 
done

#The depth of coverage does not look like I expected it to. I don't see any part of the genome that exceeds ~15X coverage 

### Question 2.5 ###

#I feel confident about the SNPs at 113,132, 113,207 and 113,326
#However, the SNPs at 113,137, 113,178, 113,252, 113,261, 113,285, 113,303, 113,305, 113,306, and 113,313 only appear in a single read each
#That makes me less confident that they are real rather than just an error in sequencing 

### Question 2.6 ###
#The SNP is at chrI:825,834 and does not appear to be in a gene