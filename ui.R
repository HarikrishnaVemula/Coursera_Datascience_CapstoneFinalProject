#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that shows the input text

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Next Word Prediction"),
  
  sidebarPanel(
    textInput("inputString", "Please enter a word",value = ""),
    submitButton('Submit'),
    br(),
    br(),
    br(),
    br()
  ),
  
  mainPanel(
    h4("Your Next Word should be : "),
    verbatimTextOutput("prediction")
   
  )
))