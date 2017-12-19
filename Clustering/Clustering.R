df <- read.csv("hmda_lar_clean_clust.csv")
df <- df[,-1]
#reassigning dataframe to improve typing speed and consistency plus removing the sequential id variable

library(caTools)
set.seed(1)
split <- sample.split(df$loan_granted, SplitRatio = 0.6)
dftrain <- subset(df, split == TRUE)
dftest <- subset(df, split == FALSE)
#we equally split our dataframe by the dependent variable, setting the seed for reproducibility

clustDftrain <- dftrain
clustDftrain$loan_granted <- NULL
clustDftest <- dftest
clustDftest$loan_granted <- NULL
#we remove the dependent variable, otherwise it will erroneously improve the result of the clustered models

library(caret)
preproc <- preProcess(clustDftrain)
clustDftrainNorm <- predict(preproc, clustDftrain)
clustDftestNorm <- predict(preproc, clustDftest)
#we normalize our two dataframes, or the variables that are on a larger scale (000s) will dominate the clustering

distances <- dist(clustDftrainNorm, method = "euclidean")
hierclustersDftrain <- hclust(distances, method = "ward.D")	
#we run our hierarchical clustering algorithm, using euclidean distances 

plot(hierclustersDftrain)
#we investigate our dendogram to choose the more apt number of clusters (6)

rect.hclust(hierclustersDftrain, k = 6, border = "red")
#we can visualize them this way

hierclustersGroups <- cutree(hierclustersDftrain, k = 6)
table(hierclustersGroups)
#we build 6 clusters and we take a look at their partition

sort(tapply(dftrain$applicant_income_000s, hierclustersGroups, mean), decreasing = TRUE)
sort(tapply(dftrain$loan_amount_000s, hierclustersGroups, mean), decreasing = TRUE)
sort(tapply(dftrain$number_of_1_to_4_family_units , hierclustersGroups, mean), decreasing = TRUE)
sort(tapply(dftrain$number_of_owner_occupied_units, hierclustersGroups, mean), decreasing = TRUE)
sort(tapply(dftrain$minority_population, hierclustersGroups, mean), decreasing = TRUE)
sort(tapply(dftrain$population, hierclustersGroups, mean), decreasing = TRUE)
#we try to determine if any cluster has a particular distinctive features (for example we can see that cluster number 6 is for high income and high loan value)

dftrain$Clusters <- hierclustersGroups
cluster1 <- subset(dftrain, hierclustersGroups == 1)
#a way to assign each data point of our train set to a cluster

set.seed(1)
kmclustersGroups <- kmeans(clustDftrainNorm, centers = 6)
#we run a k-means algorithm with the number of centroids equal to the one decided for in hierarchical clustering, setting the seed for reproducibility

table(kmclustersGroups$cluster)
#we can see that the composition of the clusters is different

sort(tapply(dftrain$applicant_income_000s, kmclustersGroups$cluster, mean), decreasing = TRUE)
sort(tapply(dftrain$loan_amount_000s, kmclustersGroups$cluster, mean), decreasing = TRUE)
sort(tapply(dftrain$number_of_1_to_4_family_units , kmclustersGroups$cluster, mean), decreasing = TRUE)
sort(tapply(dftrain$number_of_owner_occupied_units, kmclustersGroups$cluster, mean), decreasing = TRUE)
sort(tapply(dftrain$minority_population, kmclustersGroups$cluster, mean), decreasing = TRUE)
sort(tapply(dftrain$population, kmclustersGroups$cluster, mean), decreasing = TRUE)
#here we can see that, for example, is the cluster number 5 the one defined by high income and high loan value in the k-means clustering

table(hierclustersGroups, kmclustersGroups$cluster)
#to compare the compositions of the two clustered dataframes

library(flexclust)
km.kcca <- as.kcca(kmclustersGroups, clustDftrainNorm)
clusterTrain <- predict(km.kcca)
clusterTest <- predict(km.kcca, newdata=clustDftestNorm)
#we assign each data point to a cluster in both the train and test set

kmcluster1Train <- subset(dftrain, clusterTrain == 1)
kmcluster2Train <- subset(dftrain, clusterTrain == 2)
kmcluster3Train <- subset(dftrain, clusterTrain == 3)
kmcluster4Train <- subset(dftrain, clusterTrain == 4)
kmcluster5Train <- subset(dftrain, clusterTrain == 5)
kmcluster6Train <- subset(dftrain, clusterTrain == 6)
kmcluster1Test <- subset(dftest, clusterTest == 1)
kmcluster2Test <- subset(dftest, clusterTest == 2)
kmcluster3Test <- subset(dftest, clusterTest == 3)
kmcluster4Test <- subset(dftest, clusterTest == 4)
kmcluster5Test <- subset(dftest, clusterTest == 5)
kmcluster6Test <- subset(dftest, clusterTest == 6)
#we can now divide our train and test set by clusters, and then run classification algorithms on each of them