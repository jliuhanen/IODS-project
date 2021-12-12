#Johanna Liuhanen 
#7.12.2021
#R-script for Exercise 6 Data Wrangling
###################################################################

#Two data sets will be used in this exercise, bprs and rats. Bprs is a dataset
#of clinical trial of 40 males, who were randomly assigned to two treatment
#groups and assessed with brief psychiatric rating scale (BPRS) weekly during
#a 8 week period. Rats is a nutrition study conducted in three groups of rats.
#The three groups were on different diets and each animal's body weight was
#recorded approximately weekly during a 9 week period.

#Loading the data into R
bprs <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = " ", header = T)

rats <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt")

#Checking data dimensions, structure variable names and summaries
dim(bprs) # 40 rows and 11 columns
str(bprs) #40 observations on 11 variables
names(bprs)
summary(bprs)

dim(rats) # 16 rows and 13 columns
str(rats) #16 observations on 13 variables
names(rats)
summary(rats)

#Both of the data sets are in wide form, which means that each row represents
#a subject (man or animal), and columns represents measures at different time
#points.

#Activating libraries needed
library(dplyr)
library(tidyr)

#First we need to convert categorical variables to factors
# bprs: Convert categorical variables to factors (treatment & subject)
bprs$treatment <- factor(bprs$treatment)
bprs$subject <- factor(bprs$subject)

str(bprs)

# rats: Convert categorical variables to factors (ID & Group)
rats$ID <- factor(rats$ID)
rats$Group <- factor(rats$Group)

str(rats)

#Next we want to convert data sets to long form
#Converting data sets to long form

# Convert bprs to long form
bprsL <-  bprs %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
bprsL <-  bprsL %>% mutate(week = as.integer(substr(weeks,5,5)))

# Checking the bprsL data
glimpse(bprsL)
str(bprsL)
names(bprsL)
head(bprsL)
summary(bprsL)

#The data is now in long form; it has 5 variables and 360 observations.
#The bprs measure is now in one single column (bprs) (in wide data there were
#as many columns as there were measurement points), and the "week" column
#tells from which week the bprs measure is. The "treatment" variable tells
#in which of the two groups the subject belongs to. Every subject is repeated
#in many rows in the data (compared to only one row in the wide data). 

# Convert rats to long form
ratsL <-  rats %>% gather(key = WD, value = Weight, -ID, -Group)

# Extract the WD number
ratsL <-  ratsL %>% mutate(Time = as.integer(substr(WD,3,5)))

# Take a glimpse at the ratsL data
glimpse(ratsL)
str(ratsL)
names(ratsL)
head(ratsL)
tail(ratsL)
summary(ratsL)

#The rats data is also now in long form, so that there is only 5 variables
#and 176 observations. The repeated measurements of weight are now in one
#single column, and the subjects are repeated in many rows of the data.

#Saving the data sets
write.table(bprsL,"~/data/bprsL.txt")

write.table(ratsL,"~/data/ratsL.txt")

#Checking that the data is ok
test1 <- read.table("data/bprsL.txt")
str(test1)
test2 <- read.table("data/ratsL.txt")
str(test2)
