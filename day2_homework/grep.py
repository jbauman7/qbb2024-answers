#!/usr/bin/env python3

import sys 

gword = sys.argv[1] # setting an argument for the word that you are searching for with grep 
my_file = open(sys.argv[2])

for my_line in my_file:
    if gword in my_line:
        print(my_line)
 
#if the word is present in the line, print the line. 
my_file.close()