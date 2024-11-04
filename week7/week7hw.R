##Week7 Assignment

library(tidyverse)
library(broom)
library(DESeq2)
library(viridis)

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
plotPCA(vsd, intgroup = "SEX") +
  labs(title = "PCA Grouped by Sex") + 
  scale_color_viridis_d()
plotPCA(vsd, intgroup = "AGE") +
  labs(title = "PCA Grouped by Age") + 
  scale_color_viridis_c(labels = c("20-29","30-39","40-49","50-59","60-69","70-79"))
plotPCA(vsd, intgroup = "DTHHRDY") +
  labs(title = "PCA Grouped by Death Classification") + 
  scale_color_viridis_d(labels = c("Fast death of natural causes","Ventilator case"))

#1.3.3
#48% and 7%, respectively 
#Principle component 1 appears to be associated with death classification (DTHRDY) as there is noticeable separation between groups along this axis.


#2.1.1
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata, vsd_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
#WASH7P does not show significant sex-differential expression (linear regression model p.valeu = 2.79e-1)

#2.1.2
m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
#Yes, expression increases with sex = male, p = 2.57e-2. 

#2.2.1
dds <- DESeq(dds)

#2.3.1
res <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")

#2.3.2
res_nona <- res %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.1) %>%
  arrange(padj)
nrow(res_nona)
#262 genes

#2.3.3
gene_loc <- read_delim("~/qbb2024-answers/week7/gene_locations.txt")
res <- left_join(res, gene_loc, by = "GENE_NAME")
res <- arrange(res, padj)
#The top upregulated genes are in males in this case, as they are all located on the Y chromosome. Females cannot have upregulation on the Y chromosome. Also, the model specifies "males vs females", setting female as the reference condition. 

#2.3.4
filter(res, GENE_NAME == "WASH7P" | GENE_NAME == "SLC25A47")
#Yes, the results are the same (WASH7P expression does not vary significantly by sex, SLC25A47 does. However, the p values do not exactly match the p.values from the regression models.)

#2.4.1
res2 <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_NAME")
res2_nona <- res2 %>%
  filter(!is.na(padj)) %>%
  filter(padj < 0.1) %>%
  arrange(padj)
nrow(res2_nona)
#16069 genes are differentially expression according to death classification at padj < 0.1. 

#2.4.2
#Yes, this result makes sense, especially given that these sequencing samples were taken post-mortem. It would make sense that genes related to specific death conditions would be significantly upregulated/downregulated in the moments before and after death. This difference as it relates to disease/health would likely be much greater than the subtle expression differences seen between sexes. 
#We also saw in the PCA plots that death classification explained 48% of the expression variation whereas sex only explained 7%. 

#3.1

res <- res %>%
  filter(!is.na(padj))

ggplot(data = res, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = (abs(log2FoldChange) > 1 & padj < 0.1))) +
  geom_text(data = res %>% filter(abs(log2FoldChange) > 1 & -log10(padj) > 10),
            aes(x = log2FoldChange, y = -log10(padj) + 8, label = GENE_NAME), size = 3,) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("darkgray", "coral")) +
  labs(title = "Differential Expression in Males vs. Females", y = expression(-log[10]("p-adjusted")), x = expression(log[2]("fold change")))




