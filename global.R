

######### Global.R following the RShiny cheatsheet approach

setwd("/Users/jonathanroberts/Documents/R/RShiny_Emails")


##Install libraries (possibly too many!)

libraries <- c("tidytext", "magrittr", "dplyr", "tidyr", 
               "lazyeval", "purrr","ggplot2", "wordcloud", "reshape2", "shiny")

#lapply(libraries, install.packages)  #UNCOMMENT TO INSTALL PACKAGES
lapply(libraries, library, character.only = TRUE)

##Read in email data and special stopwords, e.g. things that appear in my signature.

#this is the csv that outlook spits out through it's export function. 
raw_data <- read.csv("../SensitiveData/2017_sent_emails.CSV",  colClasses = "character",stringsAsFactors = F)
email_stopwords <- read.csv("../SensitiveData/email_stopwords.CSV", colClasses = "character")


#rename the columns of the text and recipients so that it is easy to call later 
colnames(raw_data)[2]<-"email"
colnames(raw_data)[6]<-"who"


##Make a couple of functions to unnest and tidy up the data
#TODO:  for some reason this function doesn't allow you to pass "email" or "Subject" 
#       as an argument and work in the way that you would expect. 

tidy_stop_email <- function(text_df) {
        #manipulate the data so that each word has its own row
        tidy_Qdf<- text_df %>% unnest_tokens(word,"email",to_lower=TRUE)
        #remove stopwords
        clean_Qdf <- tidy_Qdf %>% anti_join(stop_words)  
        clean_Qdf <- clean_Qdf %>% anti_join(email_stopwords)
}

tidy_stop_subject <- function(text_df) {
        tidy_Qdf<- text_df %>% unnest_tokens(word,"Subject",to_lower=TRUE)
        clean_Qdf <- tidy_Qdf %>% anti_join(stop_words)  
        clean_Qdf <- clean_Qdf %>% anti_join(email_stopwords)
}

email_text<-tidy_stop_email(raw_data)
subject_text<-tidy_stop_subject(raw_data)

shiny_corpus<-subject_text$word

#subject_text %>%
#        count(word) %>%
#        with(wordcloud(word, n, max.words = 60))



##Useful bits for the interface
r_order <- data.frame(text = c("On","Off"), logi = c(TRUE,FALSE), stringsAsFactors = FALSE)



