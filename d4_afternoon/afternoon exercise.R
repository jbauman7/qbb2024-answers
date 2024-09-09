library(tidyverse)
library(dplyr)
library(broom)

#Exercise 1

#Load in the data 
dnm <- read.csv(file = "~/qbb2024-answers/d4_afternoon/aau1043_dnm.csv")
ages <- read.csv(file = "~/qbb2024-answers/d4_afternoon/aau1043_parental_age.csv")

dnm_summary <- dnm %>%
  group_by(Proband_id) %>%
  summarize(n_paternal_dnm = sum(Phase_combined == "father", na.rm = TRUE),
            n_maternal_dnm = sum(Phase_combined == "mother", na.rm = TRUE))

dnm_by_parental_age <- left_join(dnm_summary, ages, by = "Proband_id")

#data.frame(dnm_summary, ages) #This duplicates the proband ids

#Exercise 2.1
dad_dnm <- ggplot(data = dnm_by_parental_age, mapping = aes(
  x = Father_age, 
  y = n_paternal_dnm
)) + 
  geom_point() + 
  xlab("Paternal Age") + 
  ylab("Paternal de novo Mutations")

mom_dnm <- ggplot(data = dnm_by_parental_age, mapping = aes(
  x = Mother_age, 
  y = n_maternal_dnm
)) + 
  geom_point() +
  xlab("Maternal Age") + 
  ylab("Maternal de novo Mutations")

#Exercises 2.2 
mom_ml <- lm(data = dnm_by_parental_age, formula = n_maternal_dnm ~ 1 + Mother_age)
summary(mom_ml)
#The maternal dnms increase with maternal age with a slope of 0.37757. This doesnt seem like a strong correlation, but it is a significant one. The R^2 is around 0.2, but the p value is 2e-16. 
#This means that there is not a large increase in maternal dnms with maternal age, but it is very unlikely that the variation can be explained by random chance. 

#Exercise 2.3
dad_ml <- lm(data = dnm_by_parental_age, formula = n_paternal_dnm ~ 1 + Father_age)
summary(dad_ml)
#The paternal dnms increase with paternal age with a slope of 1.35384. This is a much higher increase with paternal age than for the maternal case. The R squared is much higher (0.61), and the relationship is significant. 
#This suggests to me that the paternal dnms increase more strongly than maternal dnms with parental age. The paternal dmns have a more tight relationship with less variation from the model (they are more effectively explained by paternal age, the R squared is higher). 
#Both relationships, maternal and paternal, are hgihly significant (low p values)

#Exercise 2.4
guy <- tibble(Father_age = 50.5)
predict(dad_ml, newdata = guy)
#This gives the number of paternal dnms as 78.69436

#Exercise 2.5
ggplot(data = dnm_by_parental_age) +
 geom_histogram(aes(x = n_paternal_dnm),binwidth = 1, alpha = 0.7, fill = "blue") + 
 geom_histogram(aes(x = n_maternal_dnm), binwidth = 1, alpha = 0.7, fill = "pink") +
  xlab("Number of de novo mutations")

#Exercise 2.6
#A two-sided t-test would be effective for determining if there is significant difference between the number of paternally inherited dnms and maternally inherited dnms. This is because a two sided t-test will allow us to test two populations against each other, to determine if their means and distributions are significantly different. 
t.test(
  dnm_by_parental_age$n_paternal_dnm,
  dnm_by_parental_age$n_maternal_dnm, 
  alternative = "two.sided")
#This returns a sample mean of paternal dnms of ~52, and ~13 for maternal dnms. The populations are significantly different with a p value of 2.2e-16. This suggests that there are significantly more paternally inherited dmns per proband than maternally inherited dnms, and this variation is very unlikely due to chance. 




