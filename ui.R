source(file = "global.R")

##########UI.R  following the Rshiny Cheatsheet approach


navbarPage("Email Analysis",

                tabPanel("All Email",
                        sidebarLayout(
                                # Sidebar with a slider and selection inputs
                                sidebarPanel(
                                        
                                        plotOutput("countto")
                                ),
                                mainPanel(
                                        fluidRow(column(width=4, sliderInput("freq", "Minimum Frequency:",
                                                                   min = 1,  max = 500, value = 5),
                                                       sliderInput("max",
                                                                   "Maximum Number of Words:",
                                                                   min = 1,  max = 100,  value = 50)               
                                                        ),
                                                column(width=6, offset = 1, plotOutput("wholeword"))
                                                ),
                                        fluidRow(plotOutput("all_bigrams_subj")
                                                )
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
                                                      value = "Wyatt"
                                                ),
                                            plotOutput("singleplot2"),
                                            plotOutput("singleplot3")
                                    ),
                                    mainPanel(
                                            plotOutput("indiv_Bigram"),
                                            plotOutput("indiv_Bigram_email")
                                    )
                            )
                   )
           ,

           tabPanel("Emails to many people",
                    sidebarLayout(
                            # Sidebar with a slider and selection inputs
                            sidebarPanel(
                                    textInput(inputId = "Person1",
                                              label = "Individual #1",
                                              width = '100%',
                                              value = "Wyatt"
                                    ),
                                    textInput(inputId = "Person2",
                                              label = "Individual #2",
                                              width = '100%',
                                              value = "Marriott"
                                    ),
                                    textOutput("text1"),
                                    textOutput("text2"),
                                    textOutput("text3")

                            ),
                            mainPanel(
                                    plotOutput("multiplot"),
                                    plotOutput("multiplot_email")
                            )
                    )
                ),
           tabPanel("Debug Page",
                    fluidRow(
                            textOutput("test")
                    )
           )


)




