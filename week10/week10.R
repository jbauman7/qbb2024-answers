library(dplyr)
library(ggplot2)
library(tidyverse)

nuclei_signal <- read_tsv("~/qbb2024-answers/week10/nuclei_signal.txt")

ggplot(data = nuclei_signal, mapping = aes(x = Gene, y = nascentRNA)) + 
  geom_violin(fill = "#87ae73") +
  labs(title = "Nascent RNA signal (transcription)", 
       y = "Nascent RNA fluorescence signal",
       x = "siRNA knock-down")

ggplot(data = nuclei_signal, mapping = aes(x = Gene, y = PCNA)) + 
  geom_violin(fill = "#87ae73") +
  labs(title = "PCNA signal (replication)", 
       y = "PCNA fluorescence signal",
       x = "siRNA knock-down")

ggplot(data = nuclei_signal, mapping = aes(x = Gene, y = log2ratio)) + 
  geom_violin(fill = "#87ae73") +
  labs(title = "Ratio of transcription:replication", 
       y = "Log2(nascentRNA/PCNA)",
       x = "siRNA knock-down")
