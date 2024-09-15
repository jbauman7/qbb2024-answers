#!/usr/bin/env python3 

import sys 
import numpy 


#1: 30,0000 reads 
num_reads = 1000000 * 3 / 100
num_reads = 30000
#Change for higher coverages
num_reads = 300000

#1.2
genome_length = numpy.zeros(1000000, int) #Make 1d array of zeros

startpos = ""
endpos = ""

for i in range(num_reads): #for 30,000 reads (or more for higher coverage)
    startpos = numpy.random.randint(0, len(genome_length) - 100 + 1) #Get a random start point 
    endpos = startpos + 100 #Get a random endpoint
    genome_length[startpos:endpos] += 1 #add a count for every position with the read of 100 
    startpos = ""
    endpos = ""

#print(genome_length)
numpy.savetxt('coverages30x.txt', genome_length, delimiter = ',', fmt = '%d', header = "Coverage")


# Question 2.1
reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']

print("digraph {")
for read in reads: #Step through the reads
    read_split = list(read) #Split the read into characters
    for i in range(len(read_split) - 3): #for each kmer1, 
        kmer1 = read_split[i: i+3] #get kmer1
        kmer2 = read_split[i+1: i+1+3] #get kmer2
        kmer1 = ''.join(kmer1) #join the kmer lists into strings 
        kmer2 = ''.join(kmer2) 
        print(kmer1 + " -> " + kmer2) #print the edges in a way that can be read by graphviz
print("}")
#Save this output as edges.txt

#Question 2.4
#command line code (after activating graphviz)
#dot -Tpng ./edges.txt -o ex2_digraph.png




   
