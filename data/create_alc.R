# Jussi Järvinen 17.11.2019
# Creating a merged data file from UCI Machine Learning Repository, Student Performance Data (https://archive.ics.uci.edu/ml/datasets/Student+Performance)

# Setting up
setwd("C:/LocalData/jussijar/Analyysit/2019 IODS/IODS-project")
library(dplyr)


#### 3. Reading the datasets  ####
math <- read.table("data/student-mat.csv", sep = ";", header = T)
por <- read.table("data/student-por.csv", sep = ";", header = T)

# Exploring the structure and dimensions of both datasets
str(math)
dim(math)
str(por)
dim(por)


#### 4. Joining datasets ####

# creating vector of common columns used as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# joining the datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# Exploring the structure and dimensions of the new dataset
str(math_por)
dim(math_por)


#### 5. Combining duplicated answers #### 

# Creating dataset with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}


#### 6. Creating alcohol usage variables ####

# Creating 'alc_use' = average of Dalc (weekday alcohol consumption) and Walc (weekend alcohol consumption)
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Creating 'high_use' = TRUE if 'alc_use' > 2
alc <- mutate(alc, high_use = alc_use > 2)


#### 7. Glimpsing and saving the data ####

glimpse(alc)

# The data 'alc' has 382 observations and 35 variables

# Saving data to 'data' folder
write.csv(alc, file = "data/alc.csv")

