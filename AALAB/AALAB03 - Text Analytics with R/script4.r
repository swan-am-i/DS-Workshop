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

# text pre-processing 2: remove numbers and stop words 

myCorpus <- tm_map(myCorpus, removeNumbers) 
myStopWords <- c(stopwords("english")) 
myCorpus <- tm_map(myCorpus, removeWords, myStopWords) 

# text pre-processing 3: stem words 

myCorpusCopy <- myCorpus 
myCorpus <- tm_map(myCorpus, stemDocument) 

# convert stems to real words 
stemCompletion2 <- function(x, dictionary) 
{ 
	x <- unlist(strsplit(as.character(x), " ")) 
	x <- x[x != ""] 
	x <- stemCompletion(x, dictionary = dictionary) 
	x <- paste(x, sep="", collapse=" ") 
	PlainTextDocument(stripWhitespace(x)) 
} 

myCorpus2 <- lapply(myCorpus, stemCompletion2, dictionary=myCorpusCopy) 
myCorpus <- Corpus(VectorSource(myCorpus2)) 

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
