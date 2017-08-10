library(dplyr) 
library(ggplot2) 

#set input data to object 

Tweets<-as.data.frame(maml.mapInputPort(1)) 

#summarize Tweets 
summaryOfTweets <- group_by(Tweets, user) %>% summarise(numberOfTweets = n()) %>% arrange(desc(numberOfTweets)) 
top5<-as.data.frame(head(summaryOfTweets, n = 5)) 
#visualize summary with bar chart 
ggplot(top5, aes(x = reorder(user, numberOfTweets), y = numberOfTweets, width = 0.5)) + 
	geom_bar(stat = "identity", fill = "grey70", colour = "black") + 
    coord_flip() + 
    ggtitle("Top users Tweeting with the keyword Azure") + 
    xlab("Username") + ylab("Number of Tweets") 

#output data 
maml.mapOutputPort("top5")