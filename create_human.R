#Johanna Liuhanen 
#28.11.2021 & 29.11.2021
#R-script for Exercise 4 Data Wrangling
#R-script for Exercise 5 Data wrangling
#Data used in the exercise is from the United Nations Development Programme,
#Human Development Reports
###################################################################
#Exercise 4 Data Wrangling

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

#Save the data
write.table(human,"~/Rstudio_Git/IODS-project/data/human")

##########################################################################
#Exercise 5 Data Wrangling

#Loading the data
human <- read.table("human", header=TRUE)

#Exploring the dimensions ane structure of the data
dim(human)
str(human)

#The human data used in the exercise is from the United Nations Development 
#Programme, Human Development Reports. It contains 195 observations on 19 
#variables, of which 13 are numerical, 4 are integers, and 2 are character
#variables. The variables include country, rank of Human Development Index (HDI)
#(hdirank), Human Development Index (hdi), life expectancy at birth (lifexp),
#expected years of education (expedu),mean years of education (meanedu), Gross
#National Income (GNI) per capita (gni), Gross National #Income per capita rank 
#minus HDI rank (gni_hdi), rank of Gender Inequality Index (GII) (giirank),
#Gender Inequality Index (GII)(gii), maternal mortality ratio (matmor), 
#adolescent birth rate (adobirth), percent representation in parliament (parlia),
#population with secondary education for males (edu2M) and females (edu2F), 
#labour force participation for males (labM) and females (labF).

#The variable gni is a character variable although it contains numbers. 
#Transforming gni to numeric

library(stringr)

human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric

#Selecting columns to keep in the data
keep <- c("country", "eduratio", "labratio", "lifexp", "expedu", "gni", 
          "matmor", "adobirth", "parlia")

# selecting the 'keep' columns
human <- select(human, one_of(keep))

#Removing missing values from the data
# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

# filter out all rows with NA values
human_ <- filter(human, complete.cases(human))

#Checking how many observations are left
str(human_) # 162 observations on 9 variables

#Checking countries and removing observations that are not countries
#the last 10 observations
tail(human_, 10)

# last indice we want to keep
last <- nrow(human_) - 7

# choose everything until the last 7 observations
human_ <- human_[1:last, ]

# add countries as rownames
rownames(human_) <- human_$country

# remove the Country variable
human_ <- select(human_, -country)

#Checking the structure of the data
str(human_) # 155 observations on 8 variables
head(human_) # countries are rownames

#Save the data
write.csv(human_,"human.csv")

#Checking the data
human <- read.csv("data/human.csv", header=TRUE, sep= " ")
str(human)
head(human)
