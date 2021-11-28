#Johanna Liuhanen 
#28.11.2021
#R-script for Exercise 4 Data Wrangling
#Data used in the exercise is from the United Nations Development Programme,
#Human Development Reports
###################################################################

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Dimensions of the data sets
dim(hd) # 195 rows and 8 columns
dim(gii) #195 rows and 10 columns

#Structure of the data sets
str(hd) #195 observations on 8 variables, of which 4 numerical, 2 integers and 2 character variables
str(gii) #195 observations on 10 variables, of which 7 numerical, 2 integers and 1 character variable

#Summaries of the variables
summary(hd)
summary(gii)

#Checking column names and changing them shorter
colnames(hd)
colnames(gii)

#New variable names for hd
colnames(hd)[1] <- "hdirank"
colnames(hd)[2] <- "country"
colnames(hd)[3] <- "hdi"
colnames(hd)[4] <- "lifexp"
colnames(hd)[5] <- "expedu"
colnames(hd)[6] <- "meanedu"
colnames(hd)[7] <- "gni"
colnames(hd)[8] <- "gni_hdi"

#New variable names for gii
colnames(gii)[1] <- "giirank"
colnames(gii)[2] <- "country"
colnames(gii)[3] <- "gii"
colnames(gii)[4] <- "matmor"
colnames(gii)[5] <- "adobirth"
colnames(gii)[6] <- "parlia"
colnames(gii)[7] <- "edu2F"
colnames(gii)[8] <- "edu2M"
colnames(gii)[9] <- "labF"
colnames(gii)[10] <- "labM"

#Activating library dplyr (needed in the next steps)
library(dplyr)

#Defining new variables: the ratio of Female and Male populations with secondary education
gii <- mutate(gii, eduratio = (edu2F / edu2M))

#And the ratio of labour force participation of females and males
gii <- mutate(gii, labratio = (labF / labM))

#Joining the two datasets (country as identifier)
human <- inner_join(hd, gii, by = "country")

#Checking the structure of joined data
str(human) # 195 observations on 19 variables
