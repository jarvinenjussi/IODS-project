#### Week 4 data wrangling excercise ###
# Jussi Järvinen 17.11.2019
# Creating dataset "human" from UN Human Development Reports' datas about Human development Index (HDI) and
# Gender inequality Index (GII) (http://hdr.undp.org/en/content/human-development-index-hdi)

library(dplyr)

setwd("C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project/")

# 2 Read the Human development and Gender inequality datas into R

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

colnames(hd) <- c("hdi.rank", "country", "hdi", "life.exp", "edu.exp", "edu.mean",
                  "gni", "gni.mrank")
colnames(gii) <- c("gii.rank", "country", "gii", "mat.mor", "ado.birth", "parlF",
                   "edu2F", "edu2M", "labF", "labM")



# 5 Mutate the Gender inequality data and create two new variables.

gii <- gii %>% mutate(edu2FM = edu2F/edu2M,
                      labFM = labF/labM)

# edu2ratio = the ratio of female and male populations with secondary education
# lab_ratio = the ratio of labour force participation of females and males in each country



# 6 Join together the two datasets using the variable Country as the identifier.

human <- inner_join(hd,gii, by = "country")
glimpse(human)

# The dataset "human" has 195 observations and 19 variables.

write.csv(human, file = "data/human.csv")


#### Week 5 data wrangling excercise ####

# Jussi Järvinen 29.11.2019
# Continuing creating the "human" dataset

# 1 Mutate the data: transform the Gross National Income (GNI) variable to numeric.

library(stringr)

human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric()


# 2 Exclude unneeded variables: keep only the columns matching the following variable names (described in the meta file above):
# "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"

keep <- c("country", "edu2FM", "labFM", "edu.exp", "life.exp", "gni", "mat.mor", "ado.birth", "parlF")
human <- select(human, one_of(keep)) # 9 variables


# 3 Remove all rows with missing values

human_ <- filter(human, complete.cases(human) == T) # 162 observations


# 4 Remove the observations which relate to regions instead of countries.

tail(human_, 10)
last <- nrow(human_) - 7
human_ <- human_[1:last, ] # 155 observations

# 5 Define the row names of the data by the country names and remove the country name column from
# the data.

rownames(human_) <- human_$country
human_ <- select(human_, -country) # 8 variables

# The data should now have 155 observations and 8 variables.

glimpse(human_) # the data has 155 observations and 8 variabels

# Save the human data in your data folder including the row names. You can overwrite your old 'human' data.

write.csv(human_, file = "data/human.csv")

