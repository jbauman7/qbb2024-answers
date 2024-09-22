library(tidyverse)
library(dplyr)
library(ggplot2)

dat <- read_tsv("~/qbb2024-answers/week2/snp_counts.txt")
View(dat)

ggplot(data = dat,
       mapping = aes(
         x = MAF, 
         y = log2(Enrichment), 
         color = Feature
       )
     ) + 
  geom_line() + 
  xlab("Minor Allele Frequency") + 
  ylab("SNP Enrichment (log2)") + 
  scale_color_discrete(labels = c("cCREs", "Exons", "Introns", "Other"))