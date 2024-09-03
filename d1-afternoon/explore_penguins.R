library(tidyverse)
library(palmerpenguins)
library(ggthemes)

#double(float) - integers that contain decimal points 
#tidy format: observations in rows, variables in columns 

penguins[,2]
penguins[,"island"]
penguins[,1:2]
penguins[,c("species", "island")]
penguins[2,c("species", "island")]
select(penguins, "island")

ggplot(
  data = penguins, 
  mapping = aes(
    x = flipper_length_mm, 
    y = body_mass_g,
    )
) +
  geom_point(mapping = aes(
    color = species,
    shape = species
    )
  ) + 
  scale_color_colorblind() + 
  #scale_color_manual(values = c("red", "green", "blue"))
  geom_smooth(method = "lm") +
  xlab("Flipper length (mm") + 
  ylab("Body mass (g)") + 
  ggtitle("Relationship between body mass \nand flipper length")

ggsave(filename = "~/qbb2024-answers/d1-afternoon/penguin-plot.pdf")

####
#seeing how bill length varies by sex

ggplot(data = penguins %>% filter(!is.na(sex)), mapping = 
         aes(x = bill_length_mm, 
             fill = sex)
       ) + 
         geom_histogram(
          #binwidth = 0.5 
          position = "identity", 
          alpha = 0.5
         ) +
  scale_fill_colorblind() + 
  facet_grid(sex ~ species)

#it seems bill length is related to sex, but you must look *within* species

#does body mass change over the years? 
ggplot(data = penguins, 
       mapping = aes(
         x = factor(year),
         y = body_mass_g, 
         fill = species
       )) + geom_boxplot() + 
  facet_grid(. ~ sex)
# not really


  





