# Jussi Järvinen 9.12.2019
# Creating Meet and Repeat analysis dataset for Analysis of longitudinal data excercises from BPRS and RATS datasets
# from GitHub repository of MABS. 

setwd("C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project")

library(dplyr)
library(tidyr)

# 1. Load the data sets (BPRS and RATS)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = T)


# Also, take a look at the data sets: check their variable names, view the data contents and structures,
# and create some brief summaries of the variables, so that you understand the point of the wide form data.

names(BPRS)
glimpse(BPRS)
summary(BPRS)

# BPRS has 40 observations and 11 variables: treatment vs. no treatment group, subject id, and weekly measure of
# breaf psychiatric rating scale (BPRS) from week 0 (baseline) to week 8.

names(RATS)
glimpse(RATS)
summary(RATS)

# RATS has 16 observations and 13 variables: rat id, treatment group (diet), and (approximately) weekly bodyweight (grams)


# 2. Convert the categorical variables of both data sets to factors. (1 point)

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


# 3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS.

# BPRS to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, start = 5, stop = 6)))

# RATS to long form
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, start = 3, stop = 5))) 
glimpse(RATSL)


# 4. Now, take a serious look at the new data sets and compare them with their wide form versions:

# Check the variable names
names(BPRS)
names(BPRSL)

names(RATS)
names(RATSL)

# view the data contents and structures, and create some brief summaries of the variables
glimpse(BPRS)
glimpse(BPRSL)

glimpse(RATS)
glimpse(RATSL)

summary(BPRSL)
summary(RATSL)

# Make sure that you understand the point of the long form data and the crucial difference between the wide and the long forms
# before proceeding the to Analysis exercise.

# The  wide form data is called "wide", because if you look at the data matrix, it is literally wide sideways. Each subject is
# one row and the values of repeated measure variables is spread out and each timepoint for that variable has its own column.
# The long form data is long vertically. The measures of each subject is distributed to several rows, as one row corresponds to
# one measurement point of one subject.

# Saving data to csv
write.csv(BPRSL, file = "data/BPRSL.csv")
write.csv(RATSL, file = "data/RATSL.csv")

