

library("zellkonverter")
library("scuttle")
library("scater")
library("ggplot2")


gut <- readH5AD("~/qbb2024-answers/week8/v2_fca_biohub_gut_10x_raw.h5ad")
assayNames(gut) <- "counts"
gut <- logNormCounts(gut) #adds new assay (data) 

#Question 1
#13,407 genes are quantified (as this is how many rows are in the data set)
#11,788 cells are quantified (the number of columns in the dataset)
#Pca, tsne, and umap

colData(gut)
colnames(colData(gut))

#Question 2
#39 columns
#celdat_decontx__comtanimation (are there contaminating cells? What does this mean? ), age (how much does age differ between cells?), and dissection_lab (could this contribute to batch effect?) are interesting. 
plotReducedDim(gut, "X_umap", colour_by = "broad_annotation")

#Question 3
genecounts <- rowSums(assay(gut))
summary(genecounts)
#The mean genecount is 3185, and the median is 254. This suggests that the majority of the genes have summed expression values around the median, but some extremely highly expressed outliers raise the mean significantly.
tail(sort(genecounts))
#The 3 highest expressed genes are lncRNA:Hsromega, pre-rRNA:CR45845, and lncRNA:roX1. All of these are functional RNA molecules (long noncoding RNAs and rRNAs)

#Question 4a
cellcounts <- colSums(assay(gut))
hist(cellcounts)
summary(cellcounts)
#mean counts per cell is 3622
#The cells with much higher total counts are cells with high basal levels of gene expression. 

#Question 4b
celldetected <- colSums(assay(gut)>0) #returns TRUE in the data frame when the expression value is > 0
hist(celldetected)
summary(celldetected)
#On average, 1059 genes are detected per cell. 
1059/13407 * 100
#This represents about 8% of the total genes in the data set 

#Question 5
mito <- grep(rownames(gut), pattern = "^mt:", value = TRUE)
df <- perCellQCMetrics(gut, subsets = list(Mito = mito))
df <- as.data.frame(df)
summary(df)
#mean sum and detected match 
colData(gut) <- cbind( colData(gut), df )
plotColData(gut, y = "subsets_Mito_percent", x = "broad_annotation") + 
  theme( axis.text.x=element_text( angle=90 ) ) + 
  labs(title = "Percent Mitochondrial Reads Across Cell Types", y = "Percent Mitochondrial Reads", x = "Cell type")
#Looks like enteroendocrine cells, gland cells, gut cells, muscle cells, and somatic precursor cells seems to have the highest percentage of mitochondrial reads, and thus have the highest presence/activity of mitochondria within them. This makes sense, as these cells are involved with lots of secretion and protein production (glands, gut, and enteroendocrine), cell division (precursors), or muscle contraction (muscle system). All of these activities require lots of energy and ATP.

#Question 6a



