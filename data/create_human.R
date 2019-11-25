# Jussi Järvinen 17.11.2019
# Creating dataset "human" from UN Human Development Reports' datas about Human development Index (HDI) and
# Gender inequality Index (GII) (http://hdr.undp.org/en/content/human-development-index-hdi)

library(dplyr)

setwd("C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project/")


# 2 Read the “Human development” and “Gender inequality” datas into R

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")



# 3 Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables.

glimpse(hd)
summary(hd)

glimpse(gii)
summary(gii)

# The datasets describe the Human Development Indices (HDI) and Gender Equality Indices (GII) of 195 countries.
# Both contain 195 observations and 8 variables (all numeric except "country").



# 4 Look at the meta files and rename the variables with (shorter) descriptive names

colnames(hd) <- c("hdi_rank", "country", "hdi", "lifeexp", "exp_ed", "mean_ed",
                  "gbi", "gni_rank")
colnames(gii) <- c("gii_rank", "country", "gii", "mat_mort", "ad_birth_rate", "parliament",
                   "edu2f", "edu2m", "lab_f", "lab_m")



# 5 Mutate the “Gender inequality” data and create two new variables.

gii <- gii %>% mutate(edu2ratio = edu2f/edu2m,
                      lab_ratio = lab_f/lab_m)

# edu2ratio = the ratio of female and male populations with secondary education
# lab_ratio = the ratio of labour force participation of females and males in each country



# 6 Join together the two datasets using the variable Country as the identifier.

human <- inner_join(hd,gii, by = "country")
glimpse(human)

# The dataset "human" has 195 observations and 19 variables.

write.csv(human, file = "data/human.csv")
