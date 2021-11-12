# Johanna Liuhanen, 9th November 2021, Exercise 2

data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                   header=T, sep="\t", stringsAsFactors=TRUE)
dim(data)

#The data has 183 rows and 60 columns. 

str(data)

#The data is stored as a data frame. 59 of the 60 variables in the data
#set have integers as values, and 1 variable ("gender") is a factor 
#with 2 levels ("M"/"F").

install.packages("dplyr")
library(dplyr)

#Variables needed for the new dataset:
#gender Age Attitude Points deep stra surf 

#Selecting questions for deep, stra and surf
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14",
                    "D22", "D30","D06",  "D15", "D23", "D31")

surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13",
                       "SU21","SU29","SU08","SU16","SU24","SU32")

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12",
                         "ST20","ST28")

#Creating new variables, deep, surf and stra by selecting the columns 
#containing the relevant questions and taking a mean of them
deep_columns <- select(data, one_of(deep_questions))
data$deep <- rowMeans(deep_columns)

surface_columns <- select(data, one_of(surface_questions))
data$surf <- rowMeans(surface_columns)

strategic_columns <- select(data, one_of(strategic_questions))
data$stra <- rowMeans(strategic_columns)

#Checking that the new columns deep, surf and stra are in the data
head(data)

#Selecting the columns needed for the new dataset "learning2014"
keep_columns <- c("gender","Age","Attitude", "Points", "deep", "stra", "surf")

learning2014 <- select(data, one_of(keep_columns))

#Checking the new dataset contains all the clommuns
str(learning2014)

#Checking column names and changing a few of them
colnames(learning2014)

colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[4] <- "points"

#Selecting only observations, that do not have value 0 on "points"
learning2014 <- filter(learning2014, points > 0)

#Checking how many observations are left
str(learning2014)

#166 observations of 7 variables.

#Save the data
write.table(learning2014,"~/Rstudio_Git/IODS-project/data/Learning2014")

#Open the saved data
data_test <- read.table("~/Rstudio_Git/IODS-project/data/Learning2014",
                        header=T, sep=" ")

#Checking that the data is ok
head(data_test)
str(data_test)
