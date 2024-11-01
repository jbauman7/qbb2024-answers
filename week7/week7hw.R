##Week7 Assignment

library(tidyverse)
library(broom)
library(DESeq2)

#1.1.1
data <- read_delim("~/qbb2024-answers/week7/gtex_whole_blood_counts_downsample.txt")
metadata <- read_delim("~/qbb2024-answers/week7/gtex_metadata_downsample.txt")

#1.1.2
data <- column_to_rownames(data, var = "GENE_NAME")

#1.1.3
metadata <- column_to_rownames(metadata, var = "SUBJECT_ID")

#1.2.1
table(colnames(data) == rownames(metadata)) 
#count up trues and falses. Only trues are returned, thus the rownames and colnames are identical. 

#1.2.2
dds <- DESeqDataSetFromMatrix(countData = data,
                              colData = metadata,
                              design = ~ SEX + DTHHRDY + AGE) # specify predictor variables

#1.3.1
vsd <- vst(dds)

#1.3.2
plotPCA(vsd, intgroup = "SEX")
plotPCA(vsd, intgroup = "AGE")
plotPCA(vsd, intgroup = "DTHHRDY")

#1.3.3
#48% and 7%, respectively 
#Principle component 1 appears to be associated with death classification (DTHRDY) as there is noticeable separation between groups along this axis.


#2.1.1
