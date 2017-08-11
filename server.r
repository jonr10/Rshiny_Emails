
?source("global.R")

#########Server.R as per the cheat sheet approach.


function(input, output, session)
        {

        ######## BITS TO PUT IN TO TEST THE THING
        test_text <- c("PLACEHOLDER TEXT WILL GO HERE", "this might break though")
        output$test1 <- renderText(test_text[1])
        output$test2 <- renderText(test_text[2])
        output$indiv_emailed <- renderText(input$Who_emailed)
        output$test <- renderPrint(head(indiv_corpus()$word))

        ####### NOT SURE WHAT THIS DOES
        # Make the wordcloud drawing predictable during a session
        wordcloud_rep <- repeatable(wordcloud)

        ####### OUTPUT FOR THE WHOLE CORPUS
        output$all_bigrams_subj <- renderPlot({ggplot(commonBigrams, aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                        xlab("Terms") + ylab("Count") + coord_flip()})

        output$all_bigrams_email <- renderPlot({ggplot(commonBigrams_email, aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                        xlab("Terms") + ylab("Count") + coord_flip()})

        output$wholeword <- renderPlot({
                wordcloud(subject_corpus, max.words = input$max, scale = c(4,0.5), rot.per = 0.35,
                          min.freq = input$freq, random.order = FALSE)
                })

        ####### OUTPUT FOR ONE PERSON
        ##MAke reactive versions of the functions in server.
        indiv_corpus<-reactive({
        ind_emails<-individual_emails(useful_data, input$Who_emailed)
        ind_text<-tidy_stop(ind_emails, which_text="email")
        return(ind_text)
        })

        indiv_Bigrams<-reactive({
                ind_emails<-individual_emails(useful_data, input$Who_emailed)
                com_Big<-mostcommon(ind_emails, n=2)
                return(com_Big)
        })

        indiv_Bigrams_email<-reactive({
                ind_emails<-individual_emails(useful_data, input$Who_emailed)
                com_Big<-mostcommon(ind_emails, n=2, which_text = "Email")
                return(com_Big)
        })

        output$indiv_Bigram <- renderPlot({ggplot(indiv_Bigrams(), aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                        xlab("Terms") + ylab("Count") + coord_flip()})

        output$indiv_Bigram_email <- renderPlot({ggplot(indiv_Bigrams_email(), aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                        xlab("Terms") + ylab("Count") + coord_flip()})

        output$singleplot2 <- renderPlot({
                wordcloud(indiv_corpus()$word, max.words = input$max, scale = c(4,0.5), rot.per = 0.35,
                          min.freq = input$freq, random.order = FALSE)
        })

        #For Sentiment cloud
        to_plot  <- ind_text_def %>%
                inner_join(bing) %>%
                count(word, sentiment, sort = TRUE) %>%
                acast(word ~ sentiment, value.var = "n", fill = 0)

        output$singleplot3 <- renderPlot({
                comparison.cloud(to_plot, colors = c("#F8766D", "#00BFC4"),
                                 max.words = 100)
        })


        ####### OUTPUT FOR MULTI-PERSON

        multi_bigrams<-reactive({
                sent_to<-c(input$Person1, input$Person2)
                for (i in 1:length(sent_to)){
                        if (i==1){
                                input_data<-individual_emails(useful_data, who=sent_to[i])
                                #commonWords <- input_data %>% mostcommon() %>% cbind(sent_to[i])
                                commonBigrams <- input_data %>% mostcommon(n=2) %>% cbind(sent_to[i])
                        }
                        else {
                                input_data<-individual_emails(useful_data, who=sent_to[i])
                                #commonWords <- input_data %>% mostcommon() %>% cbind(sent_to[i]) %>% rbind(commonWords)
                                commonBigrams <- input_data %>% mostcommon(n=2) %>% cbind(sent_to[i]) %>% rbind(commonBigrams)
                        }
                }
                return(commonBigrams)
        })

        multi_bigrams_email<-reactive({
                #choosing tex=1 for words; tex = 2 for bigrams
                tex<-1
                sent_to<-c(input$Person1, input$Person2)
                for (i in 1:length(sent_to)){
                        if (i==1){
                                input_data<-individual_emails(useful_data, who=sent_to[i])
                                commonText <- input_data %>% mostcommon(n=1, which_text = "Email") %>% cbind(sent_to[i])
                        }
                        else {
                                input_data<-individual_emails(useful_data, who=sent_to[i])
                                commonText <- input_data %>% mostcommon(n=1, which_text = "Email") %>% cbind(sent_to[i]) %>% rbind(commonText)
                        }
                }
                return(commonText)
        })


         output$multiplot <- renderPlot({ggplot(multi_bigrams(), aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                         xlab("Terms") + ylab("Count") + coord_flip() +  facet_wrap(~who, ncol = 3, scales = "free_x")
         })

         output$multiplot_email <- renderPlot({ggplot(multi_bigrams_email(), aes(x = word, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                         xlab("Terms") + ylab("Count") + coord_flip() +  facet_wrap(~who, ncol = 3, scales = "free_x")
         })



        ## TODO: REMOVE ONE PAGE TESTED output$text1 <- renderText(input$Person1)
        ## TODO: REMOVE ONE PAGE TESTED output$text2 <- renderText(input$Person2)

         multi_corpus_test<-reactive({
                 ### make a char vector of the people you want to search on
                 sent_to<-c(input$Person1, input$Person2)
                 ### pass into the pre-backed functions
                 #ind_emails<-individual_emails(raw_data, input$Who_emailed)
                 #ind_text<-tidy_stop(ind_emails, which_text="email")
                 multi_text<-sent_to
                 return(multi_text)
         })


        output$text3 <- renderText(multi_corpus_test())



        ######Code graveyard


        ####Default is Ross
        ind_emails_def<-individual_emails(useful_data)
        ind_text_def<-tidy_stop(ind_emails_def, which_text=email)
        #For basic word cloud
        indiv_corpus_def<-ind_text_def$word

        output$singleplot <- renderPlot({
                wordcloud(indiv_corpus_def, max.words = input$max, scale = c(4,0.5), rot.per = 0.35,
                          min.freq = input$freq, random.order = FALSE)
        })



}













