## Introduction 

Auto Word Suggestion is part of the final project submission of Data Science Capastone course.The overal goal of the capstone is to develop a prediction algorithem for the most likely next word in a sequence of words. 

## Package Background

Auto-completion is a common feature on web interfaces or mobile devices while a user trying to search a word. As a user types, an auto-completion function presents that user with possible completions to the current word being typed or probable words that could follow the current word or phrase after it is typed. The package "Auto Word Suggestion" provides this feature.

In order to build a package that can provide word-suggestion, a predictive model is needed.  Such models use known content to predict unknown content.  For this demonstration, that content came from the HC Corpora collection, which is "a collection of corpora for various languages freely available to download" (Christensen, n.d.). 

## Data Structure & Cleaning: The "tm" Package
  
  - A subset of the original data was sampled from the three sources (blogs,twitter and news) which is then merged into one.
  - Next, data cleaning is done by conversion to lowercase, strip white space, and removing punctuation and numbers.
  - The corresponding n-grams are then created (Quadgram,Trigram and Bigram).Next, the term-count data frames are extracted from the N-Grams and sorted according to the frequency in descending order.
  - finally, the n-gram objects are saved (.RData files).

## Data Processing: n-Grams and Back-Off Model
  
"an n-gram is a contiguous sequence of n items from a given sequence of text or speech."  This package takes a key word or phrase, matches that key to the most frequent n-1 term found in a TDM of n-word terms, and returns the nth word of that item.

Of course, not all possible words or phrases exist in the corpus from which the TDM was derived. For this reason, a simplified back-off model is used, which backs off to smaller n-grams when a key is not found in the larger n-gram.  The maximum n-gram handled is a quadgram.  The word returned is the match found in the largest n-gram where the key is found.  When the key is not found in the unigram, the word "the" is returned.