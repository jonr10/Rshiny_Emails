
?source("global.R")

#########Server.R as per the cheat sheet approach.


function(input, output, session) 
        {
        
        test_text <- c("PLACEHOLDER TEXT WILL GO HERE", "this might break though")
                output$text1 <- renderText(test_text)
                output$text2 <- renderText(test_text)
                output$indiv_emailed <- renderText(input$Who_emailed)
                
        
        # Make the wordcloud drawing predictable during a session
        wordcloud_rep <- repeatable(wordcloud)
        
        output$all_bigrams <- renderPlot({ggplot(commonBigrams, aes(x = phrase, y = n, fill = who)) + geom_bar(stat = "identity", show.legend = FALSE) +
                        xlab("Terms") + ylab("Count") + coord_flip()})
        
        output$wholeword <- renderPlot({
                wordcloud(shiny_corpus, max.words = input$max, scale = c(4,0.5), rot.per = 0.35, 
                          min.freq = input$freq, random.order = r_order$logi[r_order$text==input$random_select])
                })
        
        output$singleplot <- renderPlot({
                wordcloud(shiny_corpus, max.words = input$max, scale = c(4,0.5), rot.per = 0.35, 
                          min.freq = input$freq, random.order = r_order$logi[r_order$text==input$random_select])
                })

        output$multiplot <- renderPlot({
                wordcloud(shiny_corpus, max.words = input$max, scale = c(4,0.5), rot.per = 0.35, 
                          min.freq = input$freq, random.order = r_order$logi[r_order$text==input$random_select])
                })
        
        }


