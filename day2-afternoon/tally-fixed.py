#!/usr/bin/env python3

# Compare to grep -v "#" | cut -f 1 | uniq -c
# ... spot and fix the three bugs in this code

import sys

my_file = open( sys.argv[1] )

chr = ""
count = 0

for my_line in my_file:
    if "#" in my_line:
        continue
    fields = my_line.split("\t")
    if chr == "":
        chr = fields[0] #removes the 0 from the beginning of the output
    if fields[0] != chr:
        print( count, chr )
        chr = fields[0]
        count = 1 #should be count = 1, not count = 0
        continue
    count = count + 1
    
print( count, chr ) #needs to be added to print the value for the last chromosome 
my_file.close()
