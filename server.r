
?source("global.R")

#########Server.R as per the cheat sheet approach.


function(input, output, session) 
        {
        
        # Make the wordcloud drawing predictable during a session
        wordcloud_rep <- repeatable(wordcloud)
        
        output$wholeplot <- renderPlot({
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


