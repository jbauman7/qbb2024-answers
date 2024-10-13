#Week5 Homework


#1.1 
Likely because we are looking at RNA expression data (and thus cDNA), whereas fastqc is meant for DNA genomic sequence data. The reads would match RNAs (mRNAs, rRNAs, etc) which would have different early sequence and GC content from that which would be expected of the entire genome. 

#1.2
The most overrepresented sequence in the expression data is from serine protease (Ser1, Ser2 and Ser3). This makes sense because serine proteases are digestive enzymes, and would thus have high representation within the drosophila gut. 

#2
- It depends on the quality checking method. In general stats, you would keep 25 samples. In fastqc, you would not keep any samples.  
- Yes, there are blocks of 3x3 corresponding to each replicate of 3 (each sample is closest in euclidian distance to its two replicates), suggesting high consistency between replicates. 

#3.3 
Some of the replicates are not clustered together, suggesting there is some mislabelling of samples going on (LFC-FE rep 3 and FE rep 1 labels got switched).

#3.6
The categories of enrichment include several metabolic processes such as glutamine biosynthesis, ethanol metabolism, NADH metabolism, midgut development, and carbohydrate metabolism. However, there are also some processes that I would not have expected to be upregulated in the midgut, such as eggshell formation and eye morphogenesis. I would have to assume that these processes contain genes that are upregulated everywhere in the fly, and thus still appear highly expressed in the midgut. 