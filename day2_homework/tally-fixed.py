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
        chr = fields[0] #need to add this, as the original function was leaving line 1 of the data uncounted, because the if statement is true when the initial chr value is just an empty string
    if fields[0] != chr:
        print( count, chr )
        chr = fields[0]
        count = 1 #Count now needs to be set to 1, so that it accounts for the count of line 1 that we added above
        continue
    count = count + 1
print(count, chr) #Prints the final entry ChrM, which was initially excluded by the if statement, because the loop only prints count,chr if it encounters a new chr value

my_file.close()
