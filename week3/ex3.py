for line in open(biallelic.vcf):
    if line.startswith('#'):
        continue
    fields = line.rstrip('\n').split('\t')

#I want to extract the allele frequency of each variant and output it to a file called AF.txt