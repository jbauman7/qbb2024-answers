#!/usr/bin/env python3

import sys 

my_file = open(sys.argv[1])
for my_line in my_file:
    if "##" in my_line: 
        continue
    line_split = my_line.split("\t") #split the lines by tabs
    line8 = line_split[8]
    line8_split = line8.split(";") #split line 8 (gene names) by semicolon
    print(
        line_split[0] + #print the chromosome
        "\t" + 
        line_split[3] + #print the start position
        "\t" + 
        line_split[4] + #print the stop position
        "\t" +
        line8_split[2].rstrip("\"").lstrip("gene_name \"") #print the gene name (without "" or "gene_name")
        )        


my_file.close()



