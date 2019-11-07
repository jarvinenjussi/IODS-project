# Jussi Järvinen 6.11.2019 IODS learning2014 data

library(dplyr)

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)
str(lrn14)
dim(lrn14)

# 60 variables,  183 observations. All variables integer, except gender which is a 2-level factor.

#### Creating use data 'learning2014'####

# Combining variables by avaring items related each construct
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

learning2014 <- select(lrn14, one_of(keep_columns))

# Renaming columns
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"

# Excluding observations where the exam points variable is zero
learning2014 <- filter(learning2014, points != 0)

# Setting working directory
setwd("C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project")

# Saving dataset
write.csv(learning2014, file = "C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project/data/learning2014.csv")

# Re-reading the dataset
learning2014b <- read.csv("C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project/data/learning2014.csv", row.names = 1)

str(learning2014b)
head(learning2014b)
head(learning2014)

# The original dataset learning2014 and new dataset 'learning2014b' are identical
