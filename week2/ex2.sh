#!/bin/bash

#make sure to set directory to /week2

echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt #add header
for maf in 0.1 0.2 0.3 0.4 0.5 #step through each MAF value
do 
    maf_file=chr1_snps_${maf}.bed #get maf file
    bedtools coverage -a genome_chr1.bed -b ${maf_file} > ${maf}_cov_chr1.txt #check coverage of whole genome 
    snp_sum=$(awk '{s+=$4}END{print s}' ${maf}_cov_chr1.txt) #sum SNPs
    total_sum=$(awk '{s+=$6}END{print s}' ${maf}_cov_chr1.txt) #sum total
    background=$(bc -l -e "${snp_sum} / ${total_sum}") #get background
    for feature in cCREs_merged exons_merged introns other #step through each feature
    do
        ffile=feature_files/${feature}_chr1.bed #get feature file
        bedtools coverage -a ${ffile} -b ${maf_file} > ${maf}_cov_${feature}.txt #check coverage of feature by this MAF level 
        snp_sum_f=$(awk '{s+=$4}END{print s}' ${maf}_cov_${feature}.txt) #sum SNPs for feature
        total_sum_f=$(awk '{s+=$6}END{print s}' ${maf}_cov_${feature}.txt) #sum total for feature
        ratio=$(bc -l -e "${snp_sum_f} / ${total_sum_f}") #get ratio of snps to total for feature
        enrichment=$(bc -l -e "${ratio} / ${background}") #get enrichment
        echo -e "${maf}\t${feature}\t${enrichment}" >> snp_counts.txt  #append snp_counts file
    done
done
