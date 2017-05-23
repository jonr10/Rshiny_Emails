
?source("global.R")

#########Server.R as per the cheat sheet approach.


function(input, output, session)
        {

        ######## BITS TO PUT IN TO TEST THE THING
        test_text <- c("PLACEHOLDER TEXT WILL GO HERE", "this might break though")
        output$text1 <- renderText(test_text)
        output$text2 <- renderText(test_text)
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
        indiv_corpus<-reactive({
        ind_emails<-individual_emails(raw_data, input$Who_emailed)
        #Make the tidy data using unnest and removing stop words
        ind_text<-tidy_stop_email(ind_emails)
        return(ind_text)
        })


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



        ####Default is Ross
        ind_emails_def<-individual_emails(raw_data)
        ind_text_def<-tidy_stop_email(ind_emails_def)
        #For basic word cloud
        indiv_corpus_def<-ind_text_def$word





        output$singleplot <- renderPlot({
                wordcloud(indiv_corpus_def, max.words = input$max, scale = c(4,0.5), rot.per = 0.35,
                          min.freq = input$freq, random.order = FALSE)
                })






        ####### OUTPUT FOR MULTI-PERSON
        output$multiplot <- renderPlot({
                wordcloud(shiny_corpus, max.words = input$max, scale = c(4,0.5), rot.per = 0.35,
                          min.freq = input$freq, random.order = r_order$logi[r_order$text==input$random_select])
                })

        }


