#!/bin/sh
# Create the results file with a header
echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt

# Loop through each possible MAF value
for frequency in 0.1 0.2 0.3 0.4 0.5 

# Use the MAF value to get the file name for the SNP MAF file
do
    maf_file = chr_1_snps_${frequency}.bed

#   Find the SNP coverage of the whole chromosome

done
You will need to sum two values, the number of SNPs and the total size of the feature. Double check what the output columns of bed coverage are. In order to sum the values in a colum, remember that you can use the awk command covered in lecture, subbing in the correct column number for $1 (i.e. column 3 would be $3) and putting in your file name for <filename>.

SUM=$(awk '{s+=$1}END{print s}' <filename>)
#   Sum SNPs from coverage
#   Sum total bases from coverage
#   Calculate the background
#   Loop through each feature name
#     Use the feature value to get the file name for the feature file
#     Find the SNP coverage of the current feature
#     Sum SNPs from coverage
#     Sum total bases from coverage
#     Calculate enrichment
#     Save result to results file