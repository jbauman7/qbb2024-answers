library(tidyverse)
library(dplyr)
library(broom)

coverages <- read_tsv("~/qbb2024-answers/week1/coverages30x.txt")

#Question 1.3
#I re-used this code for questions 1.5 and 1.6

coverages <- coverages %>%
  group_by(`# Coverage`) %>%
  summarize(Frequency = n()) #Summarize the coverages by count 
coverages_pmf <- mutate(coverages, "pmf" = dpois(`# Coverage`, lambda = 30,)) #Add poisson probabilities for each coverage
coverages_pmf_pdf <- mutate(coverages_pmf, "pdf" = dnorm(`# Coverage`, mean = 30, sd = 5.47)) #Add normal probabilities for each coverage
View(coverages_pmf_pdf)

coverages_pmf_pdf <- coverages_pmf_pdf %>% #Multiply both probabilities by 1000000 so that they fit on the plot 
  mutate("pmf_trans" = pmf * 1000000) %>%
  mutate("pdf_trans" = pdf * 1000000)

colors = c("poisson_distribution" = "red", "normal_distribution" = "blue")

ggplot(data = coverages_pmf_pdf, mapping = aes (x = `# Coverage`)) + 
  geom_bar(mapping = aes(y = Frequency), stat = "identity", alpha = 0.5) + #Plot the coverages
  geom_line(mapping = aes(y = pmf_trans,  color = "poisson_distribution")) + #plot the poisson distribution
  geom_line(mapping = aes(y = pdf_trans, color = "normal_distribution")) + #plot the normal distribution
  labs(x = "Coverage", 
       y = "Frequency in Genome", 
       color = "Legend") + 
  scale_color_manual(values = colors)



