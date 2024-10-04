library(ggplot2)
library(tidyverse)

#allele frequency plot
AFdat <- read_tsv("~/qbb2024-answers/week3/AF.txt")
ggplot(data = AFdat, mapping = aes(x = freq)) +
  geom_histogram(bins = 11) + 
  xlab("Alternate Allele Frequency") + 
  ylab("Count") + 
  labs(title = "Distribution of Allele Frequencies Across SNP Variants")

#Question 3.1
#Yes, this looks as expected (a normal distribution centered around allele frequency of 0.5)
#This is because most SNPs dont have any selective pressure as they are not within coding regions of the genome, and thus stay at an AF around 0.5. Some SNPs are selected for and might sweep to frequency = 1 (right tail of the distribution), or selected against (left tail of the distribution)
#The SNP alleles that are selected for (right end of distribution) might be near an advantageous allele in a coding/regulatory region, and thus sweep to high frequency (opposite for left end). 

#read depth plot
DPdat <- read_tsv("~/qbb2024-answers/week3/DP.txt")
ggplot(data = DPdat, mapping = aes(x = DP)) +
  geom_histogram(bins = 21) + 
  xlim(0,20) + 
  xlab("Read depth for SNPs") + 
  ylab("Count") + 
  labs(title = "Distribution of Read Depth across SNPs in all samples")

#Question 3.2
#Yes, this distribution looks as expected
#A poisson distribution centered around a read depth of 4. This makes sense, as we calculated the overall average read depth to be aroudn 4 earlier in the exercise. The poisson distribution also make sense as read depth must consist of integers and cannot be less than 0. 

  