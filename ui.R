source(file = "global.R")

##########UI.R  following the Rshiny Cheatsheet approach


navbarPage("Email Analysis",

                tabPanel("All Email",
                        sidebarLayout(
                                # Sidebar with a slider and selection inputs
                                sidebarPanel(
                                        sliderInput("freq",
                                                    "Minimum Frequency:",
                                                    min = 1,  max = 500, value = 5),
                                        sliderInput("max",
                                                    "Maximum Number of Words:",
                                                    min = 1,  max = 100,  value = 50),
                                        plotOutput("wholeword")
                                ),
                                mainPanel(
                                        plotOutput("all_bigrams_subj"),
                                        plotOutput("all_bigrams_email")
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
                                                      value = "Ross"
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
                ),
           tabPanel("Debug Page",
                    fluidRow(
                            textOutput("test")
                    )
           )


)




