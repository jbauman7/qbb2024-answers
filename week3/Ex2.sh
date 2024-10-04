#!/usr/bin/env bash 

# Exercise 2.1 ##
wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
gunzip sacCer3.fa.gz

bwa index sacCer3.fa
less sacCer3.fa.ann
#This index file shows that there are 17 total chromosomes in the index

#Code for exercises 2.1-2.4 shown below##
for SAMPLE in $(ls ./A01_*.fastq)
#go through the sample files
do
    SAMPNAME=$(basename ${SAMPLE} .fastq)
    #pull out the sample name
    bwa mem -t 4 -R "@RG\tID:${SAMPNAME}\tSM:${SAMPNAME}" sacCer3.fa ${SAMPLE} > ${SAMPNAME}.sam
    #run bwa mem on each sample (addin the sample name to the header)
    samtools sort -@ 4 -O bam -o ${SAMPNAME}.bam ${SAMPNAME}.sam
    #sort the sam file into a bam file
    samtools index ${SAMPNAME}.bam
    #index the bam file
done

#Question 2.2
less -S A01_09.sam
grep -v '^@' A01_09.sam | cut -b 1-9 > nreads_A01_09.txt
wc -l nreads_A01_09.txt
#This counts the lines in the sam file (after removing the header and columns 1-9, to make wc run faster). This shows that there are 669548 alignments in the file. 

#Question 2.3
grep "chrIII" A01_09.sam | cut -b 4-9 > chrIII_A01_09.txt
wc -l chrIII_A01_09.txt
#First I grepped out all lines that contain "chrIII", made a new file, then counted the lines in that file. This shows that there are 18196 reads that map to chromosome III. 

#Question 2.4
#Yes, although it is very variable. Some regions have 8x coverage, some have 0 coverage. The average looks to be about 4. 

#Question 2.5
#I see 3 SNPs in this range. I am less confident in the rightmost SNP as it is only covered by two reads (still statistically unlikely to be an artifact of sequencing, but more coverage would be reassuring)

#Question 2.6
#This SNP is located at position 825,834 on chromosome IV.
#I zoomed out slightly, showing that this SNP is not within a gene. 