source(file = "global.R")

##########UI.R  following the Rshiny Cheatsheet approach


navbarPage("Email Analysis",
               tabPanel("All Email",
                        sidebarLayout(
                                # Sidebar with a slider and selection inputs
                                sidebarPanel(
                                        selectInput("random_select", "Random order?:",
                                                    choices = r_order$text),
                                        sliderInput("colour_num",
                                                    "Number of colours:",
                                                    min = 3,  max = 8, value = 8),
                                        sliderInput("freq",
                                                    "Minimum Frequency:",
                                                    min = 1,  max = 500, value = 5),
                                        sliderInput("max",
                                                    "Maximum Number of Words:",
                                                    min = 1,  max = 100,  value = 50)
                                ),
                                mainPanel( 
                                        plotOutput("wholeword"),
                                        plotOutput("all_bigrams")
                                )
                        )
               )
               ,
                   tabPanel("Emails to one person",
                            sidebarLayout(
                                    # Sidebar with a slider and selection inputs
                                    sidebarPanel(
                                            textInput(inputId = "Who_emailed", 
                                                      label = "Individual",
                                                      width = '100%',
                                                      value = "Ross Wyatt"
                                                )
                                            
                                    ),
                                    mainPanel( 
                                            textOutput("text1"),
                                            textOutput("text2"),
                                            textOutput("indiv_emailed"),
                                            plotOutput("singleplot"),
                                            plotOutput("singleplot2")
                                    )
                            )
                   )
           ,
           
           tabPanel("Emails to many people",
                    sidebarLayout(
                            # Sidebar with a slider and selection inputs
                            sidebarPanel(
                                    textInput(inputId = "Who did you email #1", 
                                              label = "Individual #1",
                                              width = '100%',
                                              value = "Ross Wyatt"
                                    ),
                                    textInput(inputId = "Who did you email #2", 
                                              label = "Individual #2",
                                              width = '100%',
                                              value = "Mike Marriott"
                                    )
                                    
                            ),
                            mainPanel( 
                                    plotOutput("multiplot")
                            )
                    )
                )
       

)




