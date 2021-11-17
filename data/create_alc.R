#Johanna Liuhanen 
#16.11.2021
#R-script for Exercise 3 Data Wrangling
#Data used in the exercise is from UCI Machine Learning Repository
#https://archive.ics.uci.edu/ml/datasets/Student+Performance
###################################################################

#Reading the two datasets, student-mat.csv and student-por.csv, in to R

math <- read.csv("student-mat.csv", sep = ";", stringsAsFactors=TRUE)
por <- read.csv("student-por.csv", sep = ";", stringsAsFactors=TRUE)

#Exploring the structure and dimensions of the data sets:

dim(math)
str(math)
dim(por)
str(por)

#math has 395 rows and 33 columns, por has 649 rows and 33 columns

#math includes 395 observations on 33 variables, of which about half are
#factors and the other half are variables that have integers as values.

#por includes 649 observations on 33 variables, which seems to be the same
#variables as in the math data set.

#Joining the two datasets:
#Define own id for both data sets
library(dplyr)
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

#Define which columns vary in data sets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

#The rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

#Combine the two data sets to one long data
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

#Explore dimension and structure of the joined data
dim(pormath)
str(pormath)

#The joined data set has 370 rows and 51 columns
#370 observations on 51 variables

#The next step is to combine duplicated columns:
# create a new data frame with only the joined columns
alc <- select(pormath, one_of(join_cols))

# for every column name not used for joining...
for(column_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(pormath, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}
glimpse(alc)

#Create a new variable, alc_use, by taking an average of weekday and
#weekend alcohol consumption

alc_use_questions <- c("Walc", "Dalc")
alc_use_columns <- select(alc, one_of(alc_use_questions))
alc$alc_use <- rowMeans(alc_use_columns)

#Define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#Checking that the data is in order
glimpse(alc)

#There is 370 rows and 36 columns, the data looks ok

#Save the data
write.table(alc,"~/Rstudio_Git/IODS-project/data/alc")

