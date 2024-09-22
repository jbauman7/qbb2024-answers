#!/bin/bash



#1.4
bedtools sort -i genes.txt > genes_chr1.bed
bedtools merge -i genes_chr1.bed > genes_chr1_merged.bed

bedtools sort -i exons.txt > exons_sorted.bed
bedtools merge -i exons_sorted.bed > exons_merged_chr1.bed

bedtools sort -i cCREs.txt > cCREs_sorted.bed 
bedtools merge -i cCREs_sorted.bed > cCREs_merged_chr1.bed

#1.5 
bedtools subtract -a genes_chr1_merged.bed -b exons_merged_chr1.bed > introns_chr1.bed

#1.6
cat exons_merged_chr1.bed introns_chr1.bed cCREs_merged_chr1.bed > exincC.bed
bedtools subtract -a genome_chr1 -b exincC.bed > other_chr1.bed