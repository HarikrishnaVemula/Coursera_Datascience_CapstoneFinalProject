#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(stringr)
suppressWarnings(library(shiny))

biWords <- readRDS("bi_words.rds")
triWords  <- readRDS("tri_words.rds")
quadWords <- readRDS("quad_words.rds")

bigram <- function(input_words){
  num <- length(input_words)
  filter(biWords,
         word1==input_words[num]) %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 2)) %>%
    as.character() -> out
  ifelse(out =="character(0)", "?", return(out))
}

trigram <- function(input_words){
  num <- length(input_words)
  filter(triWords,
         word1==input_words[num-1],
         word2==input_words[num])  %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 3)) %>%
    as.character() -> out
  ifelse(out=="character(0)", bigram(input_words), return(out))
}

quadgram <- function(input_words){
  num <- length(input_words)
  filter(quadWords,
         word1==input_words[num-2],
         word2==input_words[num-1],
         word3==input_words[num])  %>%
    top_n(1, n) %>%
    filter(row_number() == 1L) %>%
    select(num_range("word", 4)) %>%
    as.character() -> out
  ifelse(out=="character(0)", trigram(input_words), return(out))
}

ngrams <- function(input_text){
  # Create a dataframe
  input_text <- data_frame(text = input_text)
  # Clean the Inpput
  replace_reg <- "[^[:alpha:][:space:]]*"
  input_text <- input_text %>%
    mutate(text = str_replace_all(text, replace_reg, ""))
  # Find word count, separate words, lower case
  input_count <- str_count(input_text, boundary("word"))
  input_words <- unlist(str_split(input_text, boundary("word")))
  input_words <- tolower(input_words)
  # Call the matching functions
  nextWord <- ifelse(input_count == 0, "Please enter a word to be guess what the next word should be.",
                     ifelse (input_count == 1, bigram(input_words),
                             ifelse (input_count == 2, trigram(input_words),
                                     ifelse (input_count == 3, quadgram(input_words)
                                             ))))
  if(nextWord == "?"){
    nextWord = "Unbale to predict the next word based on your input due to data related queries. Please try with aother word." 
  }
  return(nextWord)
}

shinyServer(function(input, output) {
  
  output$prediction <- renderPrint({
    next_word <- ngrams(input$inputString)
    next_word
  })
  
  output$text1 <- renderText({
    input$inputString
  });
  
})
