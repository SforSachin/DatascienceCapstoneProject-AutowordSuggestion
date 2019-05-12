#
# Data Science Capastone Project
# Author: Sachin Kumar Singhal
#

suppressWarnings(library(shiny))
suppressWarnings(library(tm))

#Read ngram data stored seperately
quadgram <- readRDS("./ProcessedData/4gram.RData")
trigram <- readRDS("./ProcessedData/3gram.RData")
bigram <- readRDS("./ProcessedData/2gram.RData")

# Main logical function to get the suggested word from ngrams
# Check the input word count and then based on input
# if input is 3 or more words then get last 3 word and check in quadgram 
# if input is 2 words then check in Trigram 
# if input is 1 words then check in bigram 
NextSuggestedWord <- function(inputString){ 
  inputString<-removeNumbers(removePunctuation(tolower(inputString)))

  lst <- strsplit(inputString, " ")[[1]]

  if (length(lst)>= 3) {
    lst <- tail(lst,3)
    if (identical(character(0),head(quadgram[quadgram$unigram == lst[1] & quadgram$bigram == lst[2] & quadgram$trigram == lst[3], 4],1))){
      NextSuggestedWord(paste(lst[2],lst[3],sep=" "))
     }
    else {
      head(quadgram[quadgram$unigram == lst[1] & quadgram$bigram == lst[2] & quadgram$trigram == lst[3], 4],n=1)}
    }
  else if (length(lst) == 2){
    lst <- tail(lst,2)
    if (identical(character(0),head(trigram[trigram$unigram == lst[1] & trigram$bigram == lst[2], 3],1))) {
    NextSuggestedWord(lst[2])
    }
    else {
      head(trigram[trigram$unigram == lst[1] & trigram$bigram == lst[2], 3], n=1)}
    }
  else if (length(lst) == 1){
    lst <- tail(lst,1)
    if (identical(character(0),head(bigram[bigram$unigram == lst[1], 2],1))) {
      head("the",1)
    }
    else {
      head(bigram[bigram$unigram == lst[1],2],n=1)
    }
}
}
# Define server logic required to call defined fuction 
shinyServer(function(input, output) {
  
  output$suggestedWord <- renderPrint({
    outcome <- NextSuggestedWord(input$txtWord)
    outcome
  });
  
  output$inputWords <- renderText({input$txtWord});
  })

