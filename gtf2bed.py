#!/usr/bin/env python3
import sys
my_file = open(sys.argv[1])

for line in my_file:
    line_split = line.strip("\n").split()
    print((line_split[0] + "\t" + line_split[3] + "\t" + line_split[4] + "\t" + line_split[13].replace('"','')).replace(';',''))

my_file.close()

#(base) cmdb@QuantBio-17 day2-afternoon % ../gtf2bed.py ../day2-morning/genes.gtf