#!/usr/bin/env python3

#open file 
#skip 2 lines 
#split column header by tabs and skip first two entries 
# create way to hold gene names 
# create way to hold expression values 
# for each line, 
    # split line
    # save field 1 into gene names 
    #save 2+ into expression values 


import sys 

import numpy

#open file 
#split column header by tabs and skip first two entries
fs = open(sys.argv[1], mode = "r")
fs.readline() #skipping the first line
fs.readline() #skipping the second line

line = fs.readline()
fields = line.strip("\n").split("\t")
tissues = fields[2:]

# create way to hold gene names 
gene_names = []
gene_IDs = []
# create way to hold expression values 
expression = []

for line in fs:
    fields = line.strip("\n").split("\t") #stripping the new line character so that we dont mess with the nice integers int he data, and splitting
    gene_IDs.append(fields[0])
     # save field 1 into gene names 
    gene_names.append(fields[1])
    #save 2+ into expression values 
    expression.append(fields[2:])
fs.close()

tissues = numpy.array(tissues) #these are strings, we leave them as strings
gene_IDs = numpy.array(gene_IDs) #these are strings, we leave them as strings
gene_names = numpy.array(gene_names)  #these are strings, we leave them as strings
expression = numpy.array(expression, dtype = float)

#Question 4
#print(numpy.mean(expression, axis = 1)[0:10]) #printed the means of the rows, then set that to print just the first 10. 

#Question 5
#print(numpy.mean(expression))
#print(numpy.median(expression))
#This suggests that most of the genes have a very low expression level, with a few expremely high expressing outliers that shift the mean dramatically. 

#Question 6
exp_1 = expression + 1
#print(exp_1)
exp_log = numpy.log2(exp_1)
# print(numpy.mean(exp_log))
# print(numpy.median(exp_log))
#This log transformation reduces the mean a lot, but the median does not change very much. This makes the median and mean a lot closer to eachother. 

#Question 7
exp_sort = numpy.sort(exp_log, axis =1)
exp_high = exp_sort[:,(-1,-2)]
#print(exp_high)
exp_diff = exp_high[:,-2] - exp_high[:,-1]
#print(exp_diff)

#Question 8
exp_10fold = numpy.where(exp_diff > 10)
print(numpy.size(exp_10fold))
#the number of genes with 1000fold difference in expression between the most expressed and second most expressed tissue is 33




