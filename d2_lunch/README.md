
# Question 1
`cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c`
There are 19618 protein coding genes. 
I would be interested in learning more about transcribed processed pseudogenes, as I would like to know why they are transcribed if theyre "pseudogenes" 

# Question 2
`cut -f 1 hg38-gene-metadata-go.tsv | sort | uniq -c | sort -n`
ENSG00000168036 has the most go_ids (273). 

`grep "ENSG00000168036" hg38-gene-metadata-go.tsv | less -S | sort -k3`   
I am seeing lots of terms related to protein-protein and protein DNA binding. I would guess this gene functions in signaling pathways and gene expression. 









