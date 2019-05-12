#
# Data Science Capastone Project
# Author: Sachin Kumar Singhal
#


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = "bootstrap.css",
      titlePanel("Auto Word Suggestion"),
      tabsetPanel(
      tabPanel(
      "Application",
      br(),
      br(),
      sidebarPanel(
      "Please enter a word, Phrase or Sequence of characters",
          textInput("txtWord",h3("Text Input:"),"",width= '400px'),
          width = 4
      ),
      mainPanel(
        strong("Text input for Suggestion:"),
        textOutput("inputWords"),
        br(),
        strong("Suggested Output:"),
        textOutput("suggestedWord")
      )
    ),
    tabPanel(
      "Help",
      br(),
      includeHTML("help.html")
    ),
    tabPanel(
      "About",
      br(),
      includeHTML("About.html")
    )
    
  )  
))
