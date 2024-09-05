#!/usr/bin/env python3
import sys 

import numpy

#open file 
fs = open(sys.argv[1], mode = 'r') #fs is for filestream 

#skip 2 lines
fs.readline() #skip first line
fs.readline() #skip second line
line = fs.readline() 
fields = line.strip("\n").split("\t") #strip new line character and split on tab, creating a list of tissue types 

tissues = fields[2:] 

#create way to hold gene names
gene_names = []

#create way to hold gene IDs
gene_IDs = []

#create way to hold expression values
expression = []

#for each line
for line in fs:
    #split line
    fields = line.strip("\n").split("\t")
    #save field 0 into gene IDs
    gene_IDs.append(fields[0])
    #save field 1 into gene names
    gene_names.append(fields[1])
    #save fields 2+ into expression values
    expression.append(fields[2:])

#print(tissues)
fs.close()

#convert into numpy arrays
gene_IDs = numpy.array(gene_IDs)
gene_names = numpy.array(gene_names)
expression = numpy.array(expression, dtype=float) #numpy will convert strings to numbers
tissues = numpy.array(tissues)

# print(gene_IDs)
# print(gene_names)
# print(expression)
# print(tissues)

#Question 2: Expression data is the only kind that is numerical, the rest are strings

#Now let’s see how numpy arrays make working with data more streamlined by calculating the same mean expression values for the first 10 genes but using the build-in numpy function mean and printing them.

expression_10 = expression[:10,:]
mean_expression_10 = numpy.mean(expression_10, axis=1)
# print(mean_expression_10)

#Question 5 
mean_expression_all = numpy.mean(expression)
median_expression_all = numpy.median(expression)

# print(mean_expression_all)
# print(median_expression_all)

#Since the mean is a much larger value than the median value, there must be some very large expression values that skew the mean

#Question 6 
expression_pseudo = expression + 1
#print(expression)
#print(expression_pseudo)
expression_log_transformed = numpy.log2(expression_pseudo)
# print(expression_log_transformed)
expression_log_transformed_mean = numpy.mean(expression_log_transformed)
expression_log_transformed_median = numpy.median(expression_log_transformed)
# print(expression_log_transformed_mean)
# print(expression_log_transformed_median)

#The log-transformed median and mean are closer together, though still not very close together

#Question 7
expression_log_transformed_copy = numpy.copy(expression_log_transformed)
#print(expression_log_transformed_copy)
expression_log_transformed_sorted = numpy.sort(expression_log_transformed_copy, axis=1)
#print(expression_log_transformed_sorted) 
expression_gap = expression_log_transformed_sorted[:,-1] - expression_log_transformed_sorted[:,-2] #difference between highest and second highest value
#print(expression_gap)
more_than_10 = numpy.where(expression_gap > 10) #find position of elements with a value greater than 10
print(numpy.shape(more_than_10)) #print the shape as a shortcut to identifying the number of elements

