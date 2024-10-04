#!/usr/bin/env bash 

# # Exercise 1.1 ##
awk '{ print length($0) }' A01_09.fastq
# The first row of each read is 76 characters long. The reads are 76 nucleotides


## Exercise 1.2 ##
wc -l A01_09.fastq
bc -l -e  "(2678192) / 4"
# I counted the number of lines in the fastq and divided by 4 (gives number of reads), which is 669548

## Exercise 1.3 ##
bc -l -e "(669548 * 76) / 12157000"
# I multiplied the number of reads times the read length, then divided by the length of the SacCer genome. The answer is about 4x coverage (4.18570765813934358805)

## Exercise 1.4 ##
for file in $(ls ./A01_*.fastq)
do
    du -m ${file}
done
# The largest sample is A01_62 (149 Mb) and the smallest sample is A01_27 (110 Mb)

## Exercise 1.5 ##
fastqc A01_09.fastq

#The median quality is score is around 35 for each base across the read. 
#The formula for quality score in fastq is score = -10*log10(probability of error), which means that a score of 35 means that the median probability of error is 0.0003162

#There is not a lot of variation over the course of the reads. Some variation in outliers is seen over the course of each read, where the outliers vary more at the beginning and end of the read. 


