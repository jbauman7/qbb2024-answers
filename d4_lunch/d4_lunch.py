#!/usr/bin/env python3 

import sys 
import numpy 

#Question 1-4

# get gene_tissue file name 
filename = sys.argv[1]
#open file
fs = open(filename, mode = 'r')
#create dict to hold samples for gene-tissue pairs
relevant_samples = {}
# step through file
for line in fs:
    # Split line into fields
    fields = line.rstrip("\n").split("\t")
    # Create key from gene and tissue
    key = fields[0]
    # Initialize dict from key with list to hold samples
    relevant_samples[key] = fields[2]
fs.close()
#print(relevant_samples)
#print(list(relevant_samples.keys()))

#get metadata file name
filename = sys.argv[2]
#open file
fs = open(filename, mode = 'r')
#create dict to hold samples for tissue names
tissue_samples = {}
# step through file 
for line in fs: 
    #split line into fields
    fields = line.rstrip("\n").split("\t")
    # Create key and value
    key = fields[6]
    value = fields[0]
    # Initialize dict from key with list to hold samples 
    tissue_samples.setdefault(key, [])
    tissue_samples[key].append(value)
#print(tissue_samples)

#Question 5

filename = sys.argv[3]
#open file
fs = open(filename, mode = 'r')
fs.readline()
fs.readline()
header = fs.readline().rstrip("\n").split("\t")
header = header[2:]

tissue_columns = {}
for tissue, samples in tissue_samples.items():
    tissue_columns.setdefault(tissue, [])
    for sample in samples:
        if sample in header: 
            position = header.index(sample)
            tissue_columns[tissue].append(position)
#print(tissue_columns)
#Finding the tissues that have largest and smallest number of samples
counts = {}
for key, values in tissue_columns.items(): 
    counts[key] = len(values) #counting the number of values for each key in tissue_columns
#Now, sort the new dictionary by value to organize by counts    
sorted_counts = dict(sorted(counts.items(), key = lambda item: item[1]))

#for tissue, count in sorted_counts.items():
#    print(tissue, count) 
#This shows us that skeletal muscle has the most number of samples (803), and Leukemia cell lines have the least (0) (Kidney - Medulla is next lowest with 4)

# Question 6

#make empty lists for storing expression values and gene names 
expression_values = []
gene_names = []

for line in fs: #back to the expression data file 
    expression_field = line.rstrip("\n").split("\t")
    #store the names of the genes in gene_names list
    gene_names.append(expression_field[0])
    #take the expression values (every column after the first two) and store in expression_field list
    expression_values.append(expression_field[2:])

#convert expression values into a Numpy array
expression_array = numpy.array(expression_values, dtype = float)

#make a list for relevant genes 
relevant_genes = []
#start an index for counting gene names
index = 0
#make the dictionary for pulling out relevant expression values 
relevant_exp = {}

for gene in gene_names: 
    if gene in relevant_samples: #check if the gene is a relevant one
        relevant_tissue = relevant_samples[gene] #get the tissue for that gene
        relevant_column = tissue_columns[relevant_tissue] #get the expression values for that tissue
        key = (gene, relevant_tissue) #make a tuple of the gene and tissue
        relevant_exp.setdefault(key, []) #set an empty list for this key 
        value = expression_array[index][relevant_column] #get the relevant columns from the expression the array based on the current count for the relevant gene 
        relevant_exp[key].append(value) #set the value for this gene/tissue key as an array of relevant expression values 
    index += 1 #add one count to index if the gene is not in relevant_samples
    relevant_tissue = "" #reset relevant_tissue to an empty string for the next round
    relevant_column = "" #reset relevant_coumn for the same reason
    key = "" #reset key
    value = "" #reset value
#print(relevant_exp)


#Question 7
file_header = ("GeneID" + "\t" + "Tissue" + "\t" + "Expression_Values") #Make a header for the tsv file
print(file_header)
for key, value in relevant_exp.items():
    for i in range(len(value)): #step through each value in the dictionary (expression arrays)
        for j in range(len(value[i])): #step through each expression value in the arrays themselves
            print(key[0],key[1],value[i][j], sep = "\t") #print gene, tissue, and individual expression value





fs.close()
