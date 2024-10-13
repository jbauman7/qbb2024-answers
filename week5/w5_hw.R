#w5_hw.R

library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(hexbin) 
library(ggfortify)

#Step 3.1
#Load tab-separated data file
data = readr::read_tsv('salmon.merged.gene_counts.tsv')
#Change gene names into row names
data = column_to_rownames(data, var="gene_name")
#Get rid of gene id column
data = data %>% select(-gene_id)
#Change data to integers
data = data %>% mutate_if(is.numeric, as.integer)
#Remove low coverage samples
data = data[rowSums(data) > 100,]
# Pull out narrow region samples
dat.narrow = data %>% select(10:ncol(data))

#Step 3.2
# Create metadata tibble with tissues and replicate numbers based on sample names
narrow_metadata = tibble(tissue=as.factor(c(
  "A1", "A1", "A1", "A2-3", "A2-3", "A2-3", "Cu", "Cu", "Cu", "LFC-Fe", "LFC-Fe", "Fe", "LFC-Fe", "Fe", "Fe", "P1", "P1", "P1", "P2-4", "P2-4", "P2-4" 
  )),
                        rep=as.factor(c(1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 1, 3, 2, 3, 1, 2, 3, 1, 2, 3)))

# Create a DESeq data object
narrowdata = DESeqDataSetFromMatrix(countData=as.matrix(dat.narrow), colData=narrow_metadata, design=~tissue)

#Plot mean and sd of data before vst transformation. 
meanSdPlot(assay(normTransform(narrowdata)))
# You can see that variance depends on the mean (not good)

# Batch-correct data to remove excess variance with variance stabilizing transformation
narrowVstdata = vst(narrowdata)

# Plot variance by average to verify the removal of batch-effects
meanSdPlot(assay(narrowVstdata)) #Looks a little better. Less of a hump (controlling for batch effect) 

# Perform PCA and plot to check batch-correction
narrowPcaData = plotPCA(narrowVstdata,intgroup=c("rep","tissue"), returnData=TRUE)
ggplot(narrowPcaData, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)
#I went back and swapped the metadata for LFC-FE 3 and Fe 1 to fix the PCA plot. 

#convert to matrix
narrowVstdata = as.matrix(assay(narrowVstdata))

# Find replicate means, filtering just for replicate 1
# then repeat process for replicate 2
# Essentially averaging each replicate (averaging within replicate)
combined = narrowVstdata[,seq(1, 21, 3)]
combined = combined + narrowVstdata[,seq(2, 21, 3)]
combined = combined + narrowVstdata[,seq(3, 21, 3)]
combined = combined / 3

#Find sd of rows (standard dev of each gene)
sds = rowSds(combined)

#Filter for genes with std dev greater than 1
filt = sds > 1
narrowVstdata = narrowVstdata[filt,]

#Set seed for reproducibility
set.seed(42)

# Cluster genes using k-means clustering
k=kmeans(narrowVstdata, centers=12)$cluster

# Find ordering of samples to put them into their clusters
ordering = order(k)

# Reorder genes (to match clusters)
k = k[ordering]

# Plot heatmap of expressions and clusters
heatmap(narrowVstdata[ordering,],
        Rowv=NA,
        Colv=NA,
        RowSideColors = RColorBrewer::brewer.pal(12,"Paired")[k])

#get the gene names for cluster 1
genes = rownames(narrowVstdata[k == 1,])

#output the gene names into a format acceptable to Panther
write.table(genes, "cluster_genes.txt", sep="\n", quote=FALSE, row.names=FALSE, col.names=FALSE)

