df <- read.csv("hmda_lar_clean.csv")
df <- df[,-1]
#reassigning dataframe to improve typing speed and consistency and removing first sequential id variable 

table(df$loan_granted)/(nrow(df))
baselineAccuracy <- as.matrix(table(df$loan_granted)/(nrow(df)))[2]
#defining our baseline model accuracy as the ratio of most frequent observations / total number of observations (frequency baseline method)

library(caTools)
set.seed(1)
split <- sample.split(df$loan_granted, SplitRatio = 0.6)
dftrain <- subset(df, split == TRUE)
dftest <- subset(df, split == FALSE)
#we equally split our dataframe by the dependent variable, setting the seed for reproducibility

model1 <- glm(loan_granted ~ ., family = "binomial", data = dftrain)
#building the first model with backward selection

summary(model1)
AIC1 <- AIC(model1)
#investigating the goodness of fit of the model
which indipendente variables are not statistically significant (applicant_race_name, applicant_sex_name, census_tract_number, co_applicant_ethnicity_name, co_applicant_race_name_1, purchaser_type_name, number_of_owner_occupied_units, population, tract_to_msamd_income)

model1Predict <- predict(model1, type = "response")
#creating previsions for the train set

table(dftrain$loan_granted, model1Predict > 0.5)
model1Accuracy <- (table(dftrain$loan_granted, model1Predict > 0.5)[1] + table(dftrain$loan_granted, model1Predict > 0.5)[4])/nrow(dftrain)
model1Accuracy > baselineAccuracy
#using a confusion matrix with a threshold of 0.5, we calculate the accuracy of our model and we compare it with the baseline's

model1TestPredict <- predict(model1, type = "response", newdata = dftest)
#creating predictions for the test set

table(dftest$loan_granted, model1TestPredict > 0.5)
model1TestAccuracy <- (table(dftest$loan_granted, model1TestPredict > 0.5)[1] + table(dftest$loan_granted, model1TestPredict > 0.5)[4])/nrow(dftest)
model1TestAccuracy > baselineAccuracy
#calculating the accuracy of our model for the test set and comparing it with the baseline's

library(ROCR)
ROCR1Pred <- prediction(model1Predict, dftrain$loan_granted)
ROCR1Perf <- performance(ROCR1Pred, "tpr", "fpr")
auc1 = as.numeric(performance(ROCR1Pred, "auc")@y.values)
#calculating AUC number for train set

ROCR1TestPred <- prediction(model1TestPredict, dftest$loan_granted)
ROCR1TestPerf <- performance(ROCR1TestPred, "tpr", "fpr")
auc1test = as.numeric(performance(ROCR1TestPred, "auc")@y.values)
auc1test > auc1
#calculating AUC number for test set and comparing it with the train set's

par(mfrow = c(1,2))
plot(ROCR1Perf, colorize = TRUE, print.cutoffs.at = seq(0, 1, 0.1), text.adj = c(-0.2, 1.7))
plot(ROCR1TestPerf, colorize = TRUE, print.cutoffs.at = seq(0, 1, 0.1), text.adj = c(-0.2, 1.7))
#comparing ROCR graphs for the train and test set

model2 <- glm(loan_granted ~ agency_name + applicant_ethnicity_name + co_applicant_sex_name + loan_purpose_name + loan_type_name + owner_occupancy_name + loan_amount_000s + number_of_1_to_4_family_units + minority_population, family = "binomial", data = dftrain)
#building a model with only the statistically significant indipendent variables

summary(model2)
AIC2 <- AIC(model2)
AIC2 > AIC1
#investigating the goodness of fit of the second model and comparing to the first one

model2Predict <- predict(model1, type = "response")
table(dftrain$loan_granted, model2Predict > 0.5)
model2Accuracy <- (table(dftrain$loan_granted, model2Predict > 0.5)[1] + table(dftrain$loan_granted, model2Predict > 0.5)[4]) / nrow(dftrain)
model2TestPredict <- predict(model2, type = "response", newdata = dftest)
table(dftest$loan_granted, model2TestPredict > 0.5)
model2TestAccuracy <- (table(dftest$loan_granted, model2TestPredict > 0.5)[1] + table(dftest$loan_granted, model2TestPredict > 0.5)[4]) / nrow(dftest)
model2TestAccuracy > baselineAccuracy
model2TestAccuracy > model1TestAccuracy
#evaluating the accuracy of the second model

ROCR2TestPred <- prediction(model2TestPredict, dftest$loan_granted)
ROCR2TestPerf <- performance(ROCR2Pred, "tpr", "fpr")
auc2test <- as.numeric(performance(ROCR2TestPred, "auc")@y.values)
auc2test > auc1test
#comparing test scores between the two models

scoresMatrixValues <- c(model1Accuracy, model1TestAccuracy, AIC1, auc1test, model2Accuracy, model2TestAccuracy, AIC2, auc2test)
scoresMatrix <- matrix(scoresMatrixValues, nrow = 4)
rownames(scoresMatrix) <- c("Accuracy", "Test Accuracy", "AIC", "Test auc")
colnames(scoresMatrix) <- c("model 1", "model 2")
round(scoresMatrix, 2)
#convenient matrix to compare scores between the two different models