df <- read.csv("hmda_lar.csv", stringAsFactors = FALSE)
#reading in the database as df for consistency and typing speed, with strings not read as factors in case of text or dates

summary(df)
table(df$edit_status)
#basic functions to explore the dataset, where we can check for invalid values like negatives or incorrect text, lowercases, uppercases, etc. etc.

round(sort(colSums(is.na(df)), decreasing = TRUE)/nrow(df), 2)
#the first issue we can tackle are the missing values, the above line of code returns their frequency for each variable in decreasing order

names(tail(sort(sapply(df, function(x) mean(is.na(x)))), sum(sapply(df, function(x) mean(is.na(x))) > 0.8)))
df <- subset(df, select = -c(edit_status, denial_reason_1, denial_reason_2, rate_spread, applicant_race_2))
#is it probably a good idea, depending on the nature of the analysis, to remove the variables that contains only NAs or above a certain percentage of NAs

df <- na.omit(df)
df <- subset(df, !is.na(edit_status))
#we can decide to remove all the observations that have NAs in any variable or in specific ones  

library(mice)
imputed <- complete(mice(NAsdf))
df$applicant_income_000s <- imputed$applicant_income_000s
#instead of removing observations, we can impute them with the mice package, with NAsdf a dataframe with only the variables with missing values of choice

df[is.na(df)] <- 0
df <- df[rowSums(is.na(df)) == 0, ]
#or we can impute them manually with a fixed value of choice

sum(duplicated(df))
df <- unique(df)
#a check for repeated observations and theirs subsequent potential removal

plot(df$applicant_income_000s)
plot(df$loan_amount_000s)
#investigating possible outliers in continuous variables, if they are owed to human error

DateConvert <- as.Date(strptime(df$Date, "%m/%d/%y %H:%M"))
#the present dataframe did not have a significant date variable, but, in that case, we need to make sure that the format is coherent in every observation and preferably of class Date

df$Date <- DateConvert
df$Month <- months(DateConvert)
df$Weekday <- weekdays(DateConvert)
#this way it is easier to extraxt informations of choice from a date variable

df$Date <- strptime(df$Date, format = "%m/%d/%y %H:%M")
df$Weekday <- weekdays(df$Date)
df$Hour <- df$Date$hour
#a turnaround without using the as.Date function

#depending on the machine learning algorithm of choice, we need to further polish our data
#we can employ scaling by normalization, when we don't want larger values to dominate on smaller ones
#transformation with the goal of reducing the variability
#feature selection or dimensionality reduction to have a smaller but still significant dataframe