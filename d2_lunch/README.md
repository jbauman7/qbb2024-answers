
# Question 1
`cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c`
There are 19618 protein coding genes. 
I would be interested in learning more about transcribed processed pseudogenes, as I would like to know why they are transcribed if theyre "pseudogenes" 

# Question 2
`cut -f 1 hg38-gene-metadata-go.tsv | sort | uniq -c | sort -n`
ENSG00000168036 has the most go_ids (273). 

`grep "ENSG00000168036" hg38-gene-metadata-go.tsv | less -S | sort -k3`   
I am seeing lots of terms related to protein-protein and protein DNA binding. I would guess this gene functions in signaling pathways and gene expression. 

# GENCODE section
# Question 1
`cmdb@QuantBio-15 d2_morning % grep "IG_" genes.gtf | grep -v "pseudogene" | sort -k1 | cut -f 1 |uniq -c | sort -n -r`
This outputs: 
 91 chr14
  52 chr2
  48 chr22
  16 chr15
   6 chr16
   1 chr21
Showing us the number of IG genes (not pseudogenes) on each chromosomes. 
To find the distribution of IG_pseudogenes, I did this: 
`cmdb@QuantBio-15 d2_morning % grep "IG_" genes.gtf | grep "pseudogene" | sort -k1 | cut -f 1 | uniq -c | sort -n -r`
This outputs: 
  84 chr14
  48 chr22
  45 chr2
   8 chr16
   6 chr15
   5 chr9
   1 chr8
   1 chr18
   1 chr10
   1 chr1
Showing the distributions of IG Pseudogenes over the chromosomes. It seems to mostly reflect the distrubtion of IGs without pseudogenes. 

# Question 2








