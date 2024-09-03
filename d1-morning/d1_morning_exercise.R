# Question 3
library(tidyverse)
df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
df <- df %>%
  mutate(
    SUBJECT = str_extract(
      SAMPID,
      "[^-]+-[^-]+"
    ), 
    .before =1
  )
#Question 4
#which subjects have the most/least samples
df %>%
  group_by(SUBJECT) %>%
  summarize( samples = n()) %>%
  arrange(-samples)
# most samples: K-562 and GTEX-NPJ8 
df %>%
  group_by(SUBJECT) %>%
  summarize( samples = n()) %>%
  arrange(samples)
#least samples: GTEX-1JMI6 and GTEX-1PAR6

#Question 5
df_smtsd <- df %>%
  group_by(SMTSD) %>%
  summarize (samples = n()) 

#which tissue types have the most samples? 
df_smtsd %>% 
  arrange(-samples)
#the most samples: Whole blood, Muscle - Skeletal. These are probably the easiest to sample, and thus have more representation. 
df_smtsd %>%
  arrange(samples)
#the least samples: Kidney - Medulla, Cervix - Extocervix. These tissues are likely more difficult to sample. 

#Question 6
#create new object of just subject = NPJ8
df_NPJ8 <- df %>%
  filter(SUBJECT == "GTEX-NPJ8")

df_NPJ8_tissue <- df_NPJ8 %>%
  group_by( SMTSD) %>%
  summarize( samples = n() ) %>%
  arrange(-samples)
View(df_NPJ8 %>%
       filter(SMTSD == "Whole Blood"))

# Whole Blood has the most samples (9)
# It seems that this tissue (Whole blood) has many samples, and several different types of sequencing. There must be many ways to sequence whole blood tissue, and several were used in this project. 

#Question 7
df_nona <- df %>%
  filter(!is.na(SMATSSCR))

#group by subject, summarize by mean of each subject smattscr
df_grp <- df_nona %>%
  group_by(SUBJECT) %>%
  summarize( mean_smatsscr = mean(SMATSSCR))

df_grp %>%
  filter(mean_smatsscr == 0)
#I notice the output is 15 observations long
#Thus, total number of subjects is 15


#reporting data 





