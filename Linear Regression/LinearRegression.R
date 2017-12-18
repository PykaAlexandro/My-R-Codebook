df <- mtcars
#reassigning mtcars dataframe to improve typing speed and consistency

colnames(df)[1] <- "Y"
#reassigning the miles per gallon variable to Y, making explicit that that is our dependent variable of interest

varsMatrix <- matrix(" Y = mpg", ncol = 1)
dimnames(varsMatrix) <-list(rep("", dim(varsMatrix)[1]), rep("", dim(varsMatrix)[2]))
varsMatrix
#a matrix to keep tabs of the variables reassignings

cor(df$Y, df)
#multicollinearity matrix, to determine which independent variable is more apt to start building our model

pairs(df)
#a graphical tool to investigate the correlations between indipendent and dependent variables

varsMatrix1 <- rbind(varsMatrix, "x1 = wt")
colnames(df)[order(cor(df$Y, df))[1]] <- "x1"
df1 <- df[, c(1, order(cor(df$Y, df))[1], 2:(order(cor(df$Y, df))[1]-1), (order(cor(df$Y, df))[1]+1):length(df))]
#reassigning the first indipendent variable to use in the linear model to x1, for typing speed, consistency and avoiding typos

model1 <- lm(Y ~ x1, data = df1)
summary(model1)
#building the model and visualizing the parameters for the goodness of fit

SSTbaseline <- sum((df1$Y - mean(df1$Y))^2)
#Total sum of Squares for the baseline model, seen as the average of the dependent variable (i.e. the indipendent variables have no effect) (chance baseline method)

SSEmodel1 <- sum(model1$residuals^2)
#Sum of Squared Errors of the first model 

R2model1 <- 1 - SSEmodel1/SSTbaseline
#to calculate manually the R^2 parameter, how much variance can the model explain

hist(model1$residuals)
ks.test(model1$residuals, rnorm(length(model1$residuals), mean = 0, sd = sd(model1$residuals)))
#to check if the distribution of the error terms is normal

par(mfrow=c(2,2))
plot(model1)
#checking for eteroscedasticity

cor(df1[c(1:2)], df1[-c(1:2)])
#looking for the second indipendent variable to use in the model, one that is not strongly correlated (>|70|) with the first one

varsMatrix2 <- rbind(varsMatrix1, "x2 = hp")
colnames(df1)[order(cor(df1$Y, df1))[4]] <- "x2"
df2 <- df1[, c(1:2, order(cor(df1$Y, df1))[4], 3:(order(cor(df1$Y, df1))[4]-1), (order(cor(df1$Y, df1))[4]+1):length(df1))]
#reassigning the second indipendent variable to use in the linear model to x2, for typing speed, consistency and avoiding typos

model2 <- lm(Y ~ x1 + x2, data = df2)
summary(model2)
#building the second model and checking the significance of the variables used
R2model1 > summary(model2)$adj.r.squared
#comparing the previous model R^2 with the current model's adjusted R^2 (because the degrees of freedom must account for two indipendet variables)

par(mfrow=c(2,2))
plot(model2)
hist(model2$residuals)
ks.test(model2$residuals, rnorm(length(model2$residuals), mean = 0, sd = sd(model2$residuals)))
#residual analysis and normality check

cor(df2[c(1:3)], df2[-c(1:3)])

varsMatrix3 <- rbind(varsMatrix2, "x3 = am")
colnames(df2)[order(cor(df2$Y, df2))[8]] <- "x3"
df3 <- df2[, c(1:3, order(cor(df2$Y, df2))[8], 4:(order(cor(df2$Y, df2))[8]-1), (order(cor(df2$Y, df2))[8]+1):length(df2))]
model3 <- lm(Y ~ x1 + x2 + x3, data = df3)
summary(model2)$adj.r.squared > summary(model3)$adj.r.squared
summary(model3)$coefficients
linRegModel <- model2
#the adjusted R^2 for model3 is higher than model2's but x3 is not statistically significant, model2 is going to be the model of choice then

newcar <- data.frame(x1 = 5.568, x2 = 150)
predict(linRegModel, newcar)
#we then predict the fuel consumption for a car of choice using our predictive model


