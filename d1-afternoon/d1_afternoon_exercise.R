#Question 1
library(tidyverse)
df <- read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#Question 2
glimpse(df)

#Question 3
df_RNA <- df %>% filter(SMGEBTCHT == "TruSeq.v1")

#Question 4
ggplot(data = df_RNA, 
       mapping = aes(
         x = SMTSD
       ))+ 
  geom_bar() + 
  coord_flip()

#Question 5
ggplot(data = df_RNA, 
       mapping = aes(
         x = SMRIN
       )) + 
  geom_histogram(binwidth = .1)
# I think a histogram with binwidth = .1 is best for this data. This way, you can see that most of the values are in the 6-8 range, with a significant amount of perfect 10s as well. 
# The distribution is bimodal, with a larger peak around 6-8, and a smaller peak at exactly 10. 

#Question 6
ggplot(data = df_RNA, 
       mapping = aes(
         x = SMTSD,
         y = SMRIN
       )) + 
  geom_boxplot() +
  coord_flip()
# I think a boxplot is the best for this type of relationship. Violin plot did not look good at this scale, and histograms aren't practical with this many tissue types. 
# There seems to be signficant variation in RNA degredation across tissue types. 
# fibroblasts, leukemia cell lines, and EBV transformed fibroblasts seem to be outliers as these samples have distribution centered around 10 (least degradation). Maybe these cells are easier to extract high-quality RNA from? 

#Question 7
ggplot(data = df_RNA, 
       mapping = aes(
         x = SMTSD,
         y = SMGNSDTC
       )
    ) + geom_boxplot() +
  coord_flip()
#I still think boxplots are best for this kind of mult-distribution data. Violin plots don't make outliers and quartiles as obvious. 
#it seems testis are an outlier with very high gene expression, and whole blood is an outlier with low gene expression. The paper references suggests that testis have high gene expression in order to maintain high DNA sequence integrity via "transcriptional scanning." I would hypothesize that whole blood gene espression is relatively low because blood cells replicate in bone tissue, not while in circulation. 

#Question 8
ggplot(data = df_RNA, 
       mapping = aes(
         x = SMTSISCH,
         y = SMRIN
       )) + geom_point( size = 0.5, alpha = 0.5) + 
  geom_smooth(method = "lm")+
  facet_wrap(. ~ SMTSD)
#In general, it seems like RNA quality goes down with increasing ischemic time (with a few notable exceptions like cultured fibroblasts, where the quality is high across the board). It seems to depend on tissue, as trends are not obvious when the data is not sorted by tissue type. Trends are not as pronounced in brain tissues. 

#Question 9
ggplot(data = df_RNA, 
       mapping = aes(
         x = SMTSISCH,
         y = SMRIN
       )) + geom_point(mapping = aes(color = SMATSSCR),
                       size = 0.5, 
                       alpha = 0.5) + 
  geom_smooth(method = "lm")+
  facet_wrap(. ~ SMTSD)
# It seems the variation does depend on tissue type. It seems like, for some tissues, the autolysis score increases with ischemic time, and seems to be inversely proportional to RNA quality.For other tissues, the relationship is not as obvious, and for some there is no autolysis data at all (for example, cultured fibroblasts). 

#Question 10
ggplot(data = df_RNA %>% filter(SMBSMMRT < .025), 
       mapping = aes(
         x = SMBSMMRT, 
         y = SMRIN)) + 
  geom_point() + 
  geom_smooth(method = "lm")
#When you compare RIN to the Base Mismatch Rate (SMBSMMRT) and remove outliers, it seems like there is a slight negative correlation (which makes sense to me. The more mismatches, the lower quality the RNA sample). 

ggplot(data = df_RNA %>% filter(SMBSMMRT < .025), 
       mapping = aes(
         x = SMBSMMRT, 
         y = SMRIN)) + 
  geom_point() + 
  geom_smooth(method = "lm") + 
  facet_wrap(. ~ SMTSD)
#However, this correlaton is much less clear when you subset by tissue type. 
  
 



