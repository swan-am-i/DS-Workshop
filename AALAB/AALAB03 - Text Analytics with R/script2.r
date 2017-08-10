library(dplyr) 
library(tm) 
library(SnowballC) 

# set input data to object 

Tweets<-as.data.frame(maml.mapInputPort(1)) 
# text pre-processing 1 
myCorpus <- Corpus(VectorSource(Tweets$text)) 
myCorpus <- tm_map(myCorpus, stripWhitespace) 
myCorpus <- tm_map(myCorpus, content_transformer(tolower)) 
myCorpus <- tm_map(myCorpus, removePunctuation) 

# create matrix of terms with frequency of terms 
tdm <- TermDocumentMatrix(myCorpus, control = list(wordLengths=c(1, Inf))) 
m <- as.matrix(rowSums(as.matrix(tdm)),rownames.force=NA) 
rownames(m) <- NULL 
m <- data.frame(Terms=rownames(tdm), Frequency=m, stringsAsFactors = FALSE)
m <- arrange(m,desc(Frequency)) 

# output data 

maml.mapOutputPort("m") 

# visualize term frequency with wordcloud 
library(wordcloud) 
wordcloud(m[,1], m[,2], random.order = FALSE, random.color = FALSE, scale = c(10, .5), colors = c(colors(),"orange"))