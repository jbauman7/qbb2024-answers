#!/usr/bin/env python3 

import sys


#Step 3.2

filepath = sys.argv[1]
#open file
file = open(filepath, mode = 'r')

#print("allelefreq" + "\t" + "freq")
print("DP")
#Print the header for the output file
for line in file:
    #Step through the file
    if line.startswith('#'):
        continue
    #Skip the header lines
    fields = line.rstrip("\n").split("\t")
    #split each line by tabs and remove new line character
    info = fields[7].split(";")
    #Split the info column by semicolon 
    allelefreq = info[3] 
    #Grab the allele requency (3rd item in the info list)
    allelefreq = allelefreq.replace('=', '\t')
    #Format the output as tab-separated so it can be read into R
    #print(allelefreq)
    for i in [9, 10, 11, 12, 13, 14, 15, 16, 17, 18]:
        format = fields[i]
        #loop through fields 9 through 18 (sample specific FORMAT fields)
        format = format.split(":")
        #splot these fields by colon
        print(format[2])
        #print the second item in the format list
#Save the output of this script as a text file that can be read into R 



