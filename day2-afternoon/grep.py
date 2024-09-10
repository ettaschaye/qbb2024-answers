#!/usr/bin/env python3
import sys

pattern = sys.argv[1]

my_file = open(sys.argv[2]) #assigns the file in position 2 of command line argument to the variable my_file

for line in my_file: #for every line in my_file
    line = line.rstrip("\n") #remove the new line character from every line
    if pattern in line:
     print(line)


my_file.close()

#The grep utility searches any given input files, selecting lines that match one or more patterns.
#By default, a pattern matches an input line if the regular expression (RE) in the pattern matches the input line without its trailing newline.
#An empty expression matches every line.  Each input line that matches at least one of the patterns is written to the standard output.

"""
 ./grep.py pattern test_file.txt
"""