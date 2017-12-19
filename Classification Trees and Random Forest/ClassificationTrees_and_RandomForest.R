df <- read.csv("hmda_lar_clean.csv")
df <- df[,-1]
df$loan_granted <- as.factor(df$loan_granted)
#reassigning dataframe to improve typing speed and consistency, removing first sequential id variable and factorizing our dependent variable of interest

table(df$loan_granted)/(nrow(df))
baselineAccuracy <- as.matrix(table(df$loan_granted)/(nrow(df)))[2]
#defining our baseline model accuracy as the ratio of most frequent observations / total number of observations (frequency baseline method)

library(caTools)
set.seed(1)
split <- sample.split(df$loan_granted, SplitRatio = 0.6)
dftrain <- subset(df, split == TRUE)
dftest <- subset(df, split == FALSE)
#we equally split our dataframe by the dependent variable, setting the seed for reproducibility

library(rpart)
model1 <- rpart(loan_granted ~ ., data = dftrain, method = "class", minbucket = 2000) 
#we build a CART model with a number of observations in the terminal leaf equal to 2000 

library(rpart.plot)
prp(model1)
#we plot the decision tree

model1TestPredict <- predict(model1, newdata = dftest, type = "class")
#we run predictions on our test set

table(dftest$loan_granted, model1TestPredict)
model1TestAccuracy <- (table(dftest$loan_granted, model1TestPredict)[1] + table(dftest$loan_granted, model1TestPredict)[4])/nrow(dftest)
model1TestAccuracy > baselineAccuracy
#we create a confusion matrix to calculate the accuracy and compare it with the baseline's

library(ROCR)
model1TestPredictROC <- predict(model1, newdata = dftest)
model1TestPredictROCPred <- prediction(model1TestPredictROC[,2], dftest$loan_granted)
auc1test <- as.numeric(performance(model1TestPredictROCPred, "auc")@y.values)
#to calculate the auc number

library(caret)
library(e1071)
numFolds <- trainControl(method = "cv", number = 10)
cpGrid <- expand.grid(.cp=seq(0.01, 0.5, 0.01))
tr <- train(loan_granted ~ ., data = dftrain, method = "rpart", trControl = numFolds, tuneGrid = cpGrid)
#we use cross-validation to find the optimal value of the cp parameter, a way to improve our classification tree model

model2 <- rpart(loan_granted ~ ., data = dftrain, method = "class", cp = tr$bestTune$cp)
model2TestPredict <- predict(model2, newdata = dftest, type = "class")
table(dftest$loan_granted, model2TestPredict)
model2TestAccuracy <- (table(dftest$loan_granted, model2TestPredict)[1] + table(dftest$loan_granted, model2TestPredict)[4])/nrow(dftest)
model2TestAccuracy > model1TestAccuracy
#we pursue a cross-validated model and we test it against our first model

model2TestPredictROC <- predict(model2, newdata = dftest)
model2TestPredictROCPred <- prediction(model2TestPredictROC[,2], dftest$loan_granted)
auc2test <- as.numeric(performance(model2TestPredictROCPred, "auc")@y.values)
auc2test > auc1test
#to calculate the auc number of the second model and compare it with the first's

par(mfrow = c(1, 2))
prp(model1, extra = 101)
prp(model2, extra = 101)
#we plot our two decisions trees

library(randomForest)
model3 <- randomForest(loan_granted ~ ., data = dftrain)
#we train a random forest model with default parameters

model3TestPredict <- predict(model3, newdata = dftest, type = "class")
#we run predictions on our test set

table(dftest$loan_granted, model3TestPredict)
model3TestAccuracy <- (table(dftest$loan_granted, model3TestPredict)[1] + table(dftest$loan_granted, model3TestPredict)[4])/nrow(dftest)
model3TestAccuracy > model2TestAccuracy
#we assess the improvement in accuracy over the previous models

model3TestPredictROC <- predict(model3, newdata = dftest, type = "prob")
model3TestPredictROCPred <- prediction(model3TestPredictROC[,2], dftest$loan_granted)
auc3test <- as.numeric(performance(model3TestPredictROCPred, "auc")@y.values)
auc3test > auc2test
#to calculate the auc number of the third model and compare it with the second one's

scoresMatrixValues <- c(model1TestAccuracy, auc1test, model2TestAccuracy, auc2test, model3TestAccuracy, auc3test)
scoresMatrix <- matrix(scoresMatrixValues, nrow = 2)
rownames(scoresMatrix) <- c("Test Accuracy", "Test auc")
colnames(scoresMatrix) <- c("Tree", "CV Tree", "Random Forest")
round(scoresMatrix, 2)
#a convenient matrix to compare scores between the three different models

vu = varUsed(model3, count=TRUE)
vusorted = sort(vu, decreasing = FALSE, index.return = TRUE)
dotchart(vusorted$x, names(model3$forest$xlevels[vusorted$ix]))
#an useful graphic to determine which variable is present more times in the various trees

varImpPlot(model3)
#show which variable is more significant in reducing the heterogeneity in the leaves