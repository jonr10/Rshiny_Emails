

######### Global.R following the RShiny cheatsheet approach

setwd("/Users/jonathanroberts/Documents/R/RShiny_Emails")


##Install libraries (possibly too many!)

libraries <- c("tidytext", "magrittr", "dplyr", "tidyr",
               "lazyeval", "purrr","ggplot2", "wordcloud", "reshape2", "shiny")

#lapply(libraries, install.packages)  #UNCOMMENT TO INSTALL PACKAGES
lapply(libraries, library, character.only = TRUE)

##Read in email data and special stopwords, e.g. things that appear in my signature.

#this is the csv that outlook spits out through it's export function.
raw_data <- read.csv("../SensitiveData/2017_sent_emails_FebtoMay24.CSV",  colClasses = "character",stringsAsFactors = F)
email_stopwords <- read.csv("../SensitiveData/email_stopwords.CSV", colClasses = "character")
bing <- get_sentiments("bing")

#rename the columns of the text and recipients so that it is easy to call later
colnames(raw_data)[2]<-"email"
colnames(raw_data)[6]<-"who"


############USEFUL FUNCTIONS

####Make a couple of functions to unnest and tidy up the data

tidy_stop_email <- function(text_df) {
        #manipulate the data so that each word has its own row
        tidy_Qdf<- text_df %>% unnest_tokens(word,"email",to_lower=TRUE)
        #remove stopwords
        clean_Qdf <- tidy_Qdf %>% anti_join(stop_words)
        clean_Qdf <- clean_Qdf %>% anti_join(email_stopwords)
}

tidy_stop<- function(text_df, which_text="email") {
        word<-"word"
        tidy_Qdf<- text_df %>% unnest_tokens_(word,"Subject",to_lower=TRUE)
        clean_Qdf <- tidy_Qdf %>% anti_join(stop_words)
        clean_Qdf <- clean_Qdf %>% anti_join(email_stopwords)
}

#####Bigrams Functions
## TODO: i want to be able to call to $email or $Subject in the defintion of the function, but can't do this in the obvious way.

mostcommon <- function(text_df,n=1,x=20, which_text = "Subject") {
        #manipulate the data so that each word has its own row
        #remove stopwords
        #count the occurrences of each word, sort by the number of occurrences, and take the top x

        if(n==1){
                #wierd thing to solve an issue with tidytext reading in strings for variables
                word<-"word"
                # NOTE THE UNDERSCORE - solves the tidytext issue
                tidy_Qdf<- text_df %>% unnest_tokens_(word,which_text,to_lower=TRUE)
                clean_Qdf <- tidy_Qdf %>% anti_join(stop_words)
                clean_Qdf <- clean_Qdf %>% anti_join(email_stopwords)
                top_x <- (clean_Qdf %>% count(word,sort=TRUE))[1:x,]
        }
        else if(n==2){
                bigram<-"bigram"
                tidy_Qdf<- text_df %>% unnest_tokens_(bigram,which_text,to_lower=TRUE,token="ngrams",n=2)
                bigrams_separated <- tidy_Qdf %>% separate(bigram, c("word1", "word2"), sep = " ")
                bigrams_filtered <- bigrams_separated %>%
                        filter(!word1 %in% stop_words$word) %>%
                        filter(!word2 %in% stop_words$word) %>%
                        filter(!word1 %in% email_stopwords$word) %>%
                        filter(!word2 %in% email_stopwords$word)


                top_x <- as.data.frame((bigrams_filtered %>% count(word1, word2, sort = TRUE))[1:x,])

                #rejoin the words back into bigrams
                top_x$phrase <- sapply(1:x,
                                       function(x)
                                               paste(top_x[x,]$word1,top_x[x,]$word2))
                #only keep the bigrams
                top_x <- top_x[,!(names(top_x) %in% c("word1","word2"))]
        }
        who<-rep(text_df$who[1],x)
        return(cbind(top_x,who))
}



######Strip out data for one person

#i've design this function to only accept one name and c
#I call it repeatedly if i want to give it lots of people to analyse at once.
#I guess this bit could accept a character vector.

individual_emails<-function(source_data, who = "Ross"){

        #vector to take the instances where the match is true
        who<-paste0("\\b",tolower(who),"\\b")
        v<-grepl(who, tolower(source_data$who))
        #filter on matches
        person_data<-(source_data[v,])
        return(person_data)
}



#######Call Functions and get some data ready for the UI/Server calls
##Mostly calls to the whole corpus

email_text<-tidy_stop(raw_data, which_text = "email")
subject_text<-tidy_stop(raw_data, which_text = "Subject")
subject_corpus<-subject_text$word
email_corpus<-email_text$word
commonBigrams <- raw_data %>% mostcommon(n=2)
commonBigrams_email <- raw_data %>% mostcommon(n=2, which_text = "email")


#######TESTBED for code before i drop it in server.ui
ggplot(commonBigrams, aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
        xlab("Terms") + ylab("Count") + coord_flip()

#subject_text %>%
#        count(word) %>%
#        with(wordcloud(word, n, max.words = 60))


### Sentiment cloud
####Default is Ross
ind_emails_def<-individual_emails(raw_data)
ind_text_def<-tidy_stop_email(ind_emails_def)
to_plot  <- ind_text_def %>%
        inner_join(bing) %>%
        count(word, sentiment, sort = TRUE) %>%
        acast(word ~ sentiment, value.var = "n", fill = 0)

        comparison.cloud(to_plot, colors = c("#F8766D", "#00BFC4"),
                         max.words = 100)




##Useful bits for the interface
r_order <- data.frame(text = c("On","Off"), logi = c(TRUE,FALSE), stringsAsFactors = FALSE)



