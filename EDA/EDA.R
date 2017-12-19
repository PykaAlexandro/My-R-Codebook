df <- read.csv("2013MOOCdata.csv")
#reassigning dataframe to improve typing speed and consistency

library(ggplot2)
#loading the ggplot2 graphical package

names(df)
summary(df)
str(df)
head(df)
#beginning to explore the dataframe with basic functions, another function we could use is pairs(), but with this dataframe is not very useful

subset(df, is.na(registered))
df <- subset(df, !is.na(registered))
#we remove the only row with an NA in the registered, viewed, explored and certified variables

table(df$certified)
ggplot(df, aes(factor(certified))) + geom_bar(aes(fill = factor(certified)))
#the first thing we want to know is how many users successfully passed the courses (registered with a value of 1 in the "certified" variable)

table(df$course_id)
ggplot(df, aes(x = reorder(course_id, course_id, function(x) - length(x)))) + geom_bar(fill = "blue")
#then a breakdown of partecipants per course

table(df$certified, df$course_id)
sort(round(tapply(df$certified, df$course_id, mean, na.rm = TRUE), 4), decreasing = TRUE)
ggplot(df, aes(factor(certified))) + geom_bar(aes(fill = factor(certified))) + facet_wrap(~reorder(course_id, course_id, function(x) - length(x)), nrow = 1)
#to investigate which course has a higher success ratio

table(df[df$explored ==1, ]$certified, df[df$explored == 1, ]$course_id)[, c(2, 4, 3, 5, 1)]
sort(round(tapply(df[df$explored ==1, ]$certified, df[df$explored == 1, ]$course_id, mean, na.rm = TRUE), 4), decreasing = TRUE)
ggplot(df[df$explored == 1, ], aes(factor(certified))) + geom_bar(aes(fill = factor(certified)))
ggplot(df[df$explored == 1, ], aes(factor(certified))) + geom_bar(aes(fill = factor(certified))) + facet_wrap(~reorder(course_id, course_id, function(x) - length(x)), nrow = 1)
#we apply the same concepts as before but just to users who have followed and not just browsed the course (registered with a value of 1 in the "explored" variable)

head(sort(table(df$final_cc_cname_DI), decreasing = TRUE), 20)
round(head(sort(table(df$final_cc_cname_DI), decreasing = TRUE)/nrow(df), 20), 2)
ggplot(df, aes(x=reorder(final_cc_cname_DI, final_cc_cname_DI, function(x)-length(x)))) + geom_bar(fill = "blue") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
#to investigate the country of origin of the users

table(df[df$explored == 1, ]$certified, df[df$explored == 1, ]$final_cc_cname_DI)
ggplot(df[df$explored == 1, ], aes(x=reorder(final_cc_cname_DI, final_cc_cname_DI, function(x)-length(x)))) + geom_bar(aes(fill = factor(certified))) + theme(axis.text.x = element_text(angle = 45, hjust = 1))
#limiting the dataframe just to active users (explorer = 1) and displaying the ratio of success

round(table(df$LoE_DI, df$certified)/nrow(df), 3)
table(df[df$explored == 1, ]$certified, df[df$explored == 1, ]$LoE_DI)
round(table(df[df$explored == 1, ]$certified, df[df$explored == 1, ]$LoE_DI)/nrow(df[df$explored == 1, ]), 3)
ggplot(df[df$explored == 1, ], aes(x=reorder(LoE_DI, LoE_DI, function(x)-length(x)))) + geom_bar(aes(fill = factor(certified))) 
#another variable we can explore is the level of education and its influence on the rate of success for active users

ggplot(df[df$explored == 1, ], aes(YoB)) + geom_histogram(aes(fill = factor(certified)))
#the year of birth is certainly another interesting variable to investigate

cor(df[df$explored == 1, ]$grade, df[df$explored == 1, ]$ndays_act, use = "pairwise.complete.obs")
ggplot(df[df$explored == 1, ], aes(x = grade, y = ndays_act)) + geom_point() + facet_wrap(~course_id, nrow = 1)
#looking at the number of days the active users stayed online, we can see that there is a slight correlation with the final grades for certain courses

ggplot(df[df$explored == 1, ], aes(course_id, grade)) + geom_boxplot()
#here we can see the distribuition of grades in the five different courses for active users

ggplot(aes(x = YoB), data = df[df$explored == 1, ]) + geom_histogram(aes(fill = gender), binwidth = 5, position="identity", alpha=0.5)
#an useful graphic about the demographic (age and sex) of active users

ggplot(df[df$explored == 1, ]) + geom_boxplot(aes(gender, grade))
#the distribuition of grades by gender

ggplot(aes(x = 2013 - YoB, y = grade), data = df[df$explored == 1, ]) + geom_point(aes(color = gender, shape = factor(certified))) + geom_line(data = df[df$explored == 1 & df$gender == "m", ], stat = 'summary', fun.y = mean, color = "blue", size = 1)  + geom_line(data = df[df$explored == 1 & df$gender == "f", ], stat = 'summary', fun.y = mean, color = "green", size = 1)
#here we can see interesting patterns in the averages of grades by age for active users, separating also by gender

ggplot(aes(x = 2013 - YoB, y = nevents), data = df[df$explored == 1, ]) + geom_point(color = "white") + geom_line(data = df[df$explored == 1 & df$gender == "m", ], stat = 'summary', fun.y = mean, color = "blue", size = 1)  + geom_line(data = df[df$explored == 1 & df$gender == "f", ], stat = 'summary', fun.y = mean, color = "pink", size = 1)
#trying to correlate the age with the number of accesses for active users, separating also by gender

ggplot(df, aes(x = reorder(final_cc_cname_DI, final_cc_cname_DI, function(x)-length(x)))) + geom_bar(aes(fill = LoE_DI), position = "fill") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
#the composition of users by education, by country

ggplot(df, aes(x = gender)) + geom_bar(aes(fill = LoE_DI), position = "fill") 
#comparing the level of education by genre

#the possibilities are endless, we can for example investigate the common traits amongst users with better grades or for users that almost passed the courses but ultimately failed
#the goal should be to determine specific segments of users to whom apply treatments of choice to improve their learning performances or to design courses that have a higher success ratio
