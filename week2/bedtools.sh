#!/bin/sh

# ## Exercise 2
# I will be finding how many SNPs overlap each, finding the mean SNP/bp for each feature and then calculating the enrichment of each feature SNP density for each minor allele frequency

# ### Step 2.1 
# I need to write a bash script that loops through every minor allele frequency file and each feature bed file and use bedtools coverage to figure out how mant SNPs fall within each set of features

# I think chr1_snps_0.1.bed and equivalent files are the SNPs partitioned by minor allele frequency (0.1, 0.2, 0.3, 0.4, 0.5). I'm curious if 0.1 would be 0.0 through 0.0. I assume yes because these are all pretty common variants othersswise)

# The features we are using are exons, introns, cCREs (regulatory elements), and others.

# The feature files are:
# exons_chr1.bed (exon feature file)
# introns_chr1.bed (intron feature file)
# cCREs_chr1.bed (regulatory elements feature file)
# others_chr1.bed (others feature file)

# The MAF files are: chr1_snps_0.1.bed, chr1_snps_0.2.bed, chr1_snps_0.3.bed, chr1_snps_0.4.bed, chr1_snps_0.5.bed
# The structure of these is they have |chromosome number| SNP postion | SNP postion + 1| identifier 

# Maybe the goal here is to figure out how much coverage each kind of element received?

# We will calculate bedtools coverage of the feature bedtool with the respective MAF
# Start with outer loop, loop through MAF files
# We need to calculate a normalization value based on the genome, which is just total SNPs in the entire genome file 

# The struture of the genome_chr1.bed file is 
# chr1 | n | n + 20000| 

# So the output of this...
echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt
for file in chr1_snps_*.bed
 do
    tmp_file_name="$(basename "$file" .bed)_snp_coverage.txt"
    bedtools coverage -a "genome_chr1.bed" -b $file > ${tmp_file_name}
    # Process text file line by line, add the value in the specified column to the variable s, print the variable s and pass it to SUM
    SNPs=$(awk '{s+=$4}END{print s}' "$tmp_file_name") #Change column depending on which you want 
    # echo ${SNPs} "SNPs in" ${tmp_file_name}
    LENG=$(awk '{l+=$6}END{print l}' "$tmp_file_name")
    # echo ${LENG} "is the size of" ${tmp_file_name}
    background=$(echo "${SNPs}/${LENG}" | bc -l) #Divide number of SNPs by the length of the chromosome to calculate the background
    # echo ${background} "is the background for" ${tmp_file_name}
 
    for feature_file in *s_chr1.bed
    do 
        tmp_file_name_2="$(basename "$feature_file" .bed)$(basename "$file" .bed).txt"
        bedtools coverage -a $feature_file -b $file > ${tmp_file_name_2}
        SNPs_2=$(awk '{s+=$4}END{print s}' "$tmp_file_name_2")
        LENG_2=$(awk '{l+=$6}END{print l}' "$tmp_file_name_2")
        enrichment=$(echo "${SNPs_2}/${LENG_2}/${background}" | bc -l)
        echo -e "${file}\t${feature_file}\t${enrichment}"
         >> snp_counts_raw.txt
    done

done

# should be...
# chr1 | start pos. from A | end pos. from file A | n SNPs in B from range in A | 20,000 | fraction of bp in range that have 1 or more SNPs

# From the assignment "You don’t actually need the set of SNPs that overlap each feature set,
# but instead are interested in the total count of SNPs"
# So I guess I just want to sum all the values in |n SNPs in B from range in A| and sum the | 20,000 | feature size column 
# Then I divide SNP sum by the feature size sum, to give me (total SNPs on chr1)/(size of chr1 in bp) which is the background!

