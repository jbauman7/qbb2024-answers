#Day4 Lunch Assignment Question 8

library(dplyr)
library(tidyverse)
library(broom)

relevant_expression <- read_tsv("~/qbb2024-answers/d4_lunch/relevant_expression_values.tsv")
View(relevant_expression)

#Creating a violin plot broken down by GeneIDs
ggplot(
  data = relevant_expression,
  mapping = aes(x = GeneID, y = Expression_Values)) + 
  geom_violin() + 
  coord_flip()

#Created combination of tissue and geneIDs
relevant_expression <- relevant_expression %>%
  mutate(Tissue_Gene=paste0(Tissue, " ", GeneID)) %>%
  mutate(exp_transformed = log2(Expression_Values + 1)) #log transform the data 

ggplot(
  data = relevant_expression,
  mapping = aes(x = Tissue_Gene, y = exp_transformed) 
) + 
  geom_violin() + 
  coord_flip() + 
  ylab("Log-Transformed Expression") + 
  xlab ("Tissue-Gene")

#It looks like some tissues have more variability in their highly expressed genes than others. 
#For example, testis and pancreas seem to have low variability in these genes, as the highly expressed genes included here have small distrubtions around high expression levels.
#Stomach and pituitary tissues have wider distributions, suggesting more variability in these highly expressed genes. 
# I would guess that the highly expressed genes in tissues such as testis and pancreas are important for tissue function, and thus must maintain high levels of expression. For tissues with more variability in these genes, such as stomach and pituitary, I would guess these genes are more involved in environmental response and signaling, where variation in expression is reasonable, and potentially necessary for function. 





