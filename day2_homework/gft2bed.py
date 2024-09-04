#!/usr/bin/env python3

import sys 

my_file = open(sys.argv[1])
for my_line in my_file:
    if "##" in my_line: 
        continue
    line_split = my_line.split("\t")
    line8 = line_split[8]
    line8_split = line8.split(";")
    print(
        line_split[0] + 
        "\t" + 
        line_split[3] + 
        "\t" + 
        line_split[4] +
        "\t" +
        line8_split[2].rstrip("\"").lstrip("gene_name \"")
        )        


my_file.close()



