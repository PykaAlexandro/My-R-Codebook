df<- read.csv("tafornlp.csv", stringsAsFactors = FALSE)
#reading in the database as df for consistency and typing speed

library(tm)
library(SnowballC)
corpus <- VCorpus(VectorSource(df$Review))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, c("seattle", "best western pioneer square hotel", "best western", "hotel", "pioneer", stopwords("english")))
corpus <- tm_map(corpus, stemDocument)
#we create a processed corpus with a bag of words technique

corpus[[1]]$content
#we investigate the first element of the corpus

frequencies <- DocumentTermMatrix(corpus)
#we create a matrix of frequencies for every word of the corpus

frequencies
inspect(frequencies[61:67, 1000:1005])
#we inspect the matrix

findFreqTerms(frequencies, lowfreq=20)
#to find the most common terms

sparse <- removeSparseTerms(frequencies, 0.9)
#we can remove the less frequent terms to reduce the sparsity of the matrix

reviewSparse <- as.data.frame(as.matrix(sparse))
colnames(reviewSparse) <- make.names(colnames(reviewSparse))
#we transform the matrix in a dataframe apt for further analysis, for example we could employ a logistic regression to determine which words yield a negative rating

library(wordcloud)
wordcloud(colnames(reviewSparse), colSums(reviewSparse), scale=c(3, 0.3), random.order = FALSE, colors = c("Yellow2", "Blue")) 
#if we are interested in a more visual analysis