# Datascience Capastone Project- COre file
# This file load the raw corpus, clean the corpus and finally Tokenize based on Ngrams 
# Author: Sachin Kumar Singhal

suppressWarnings(library(NLP))
suppressWarnings(library(tm))
suppressWarnings(library(RWeka))

# Read Data
blogs <- readLines("../Data Files/en_US.blogs.txt", warn = FALSE, encoding = "UTF-8")
news <- readLines("../Data Files/en_US.news.txt", warn = FALSE, encoding = "UTF-8")
twitter <- readLines("../Data Files/en_US.twitter.txt", warn = FALSE, encoding = "UTF-8")

 set.seed(1000) 
 sample_size <- 0.02 # Subsample to 2%
 
 sampletext <- function(textbody, portion) {
   taking <- sample(1:length(textbody), length(textbody)*portion)
   Sampletext <- textbody[taking]
   Sampletext
 }
 Sampleblogs<-sampletext(blogs,sample_size)
 Samplenews<-sampletext(news,sample_size)
 Sampletwitter<-sampletext(twitter,sample_size)

 writeLines(c(Sampleblogs, Samplenews, Sampletwitter), "./SampleData/SampleAll.txt")

 #Create corpus from sample data set and clean
 
 corpus <- VCorpus(DirSource("./SampleData", encoding = "UTF-8"))
 corpus <- tm_map(corpus, removePunctuation) # Remove punctuation
 corpus <- tm_map(corpus, stripWhitespace) # Remove unneccesary white spaces
 corpus <- tm_map(corpus, content_transformer(tolower)) # Convert to lowercase
 corpus <- tm_map(corpus, removeNumbers) # Remove numbers
 corpus <- tm_map(corpus, PlainTextDocument) # Plain text

# this function create term document matrix  
fn_tdm_ngram<- function(tcorpus,n){
nGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = n, max = n))
tdm_ngrams <- TermDocumentMatrix(tcorpus, control = list(tokenizer = nGramTokenizer))
tdm_ngrams
}

tdm_Bigrams<-fn_tdm_ngram(corpus,2)
tdm_Trigrams<-fn_tdm_ngram(corpus,3)
tdm_Quadgrams<-fn_tdm_ngram(corpus,4)

#this function create sorted data frame from tdm
fn_ngram_df <- function (x) {
  ngram_df <- as.data.frame(as.matrix(x))
  colnames(ngram_df) <- "Count"
  ngram_df <- ngram_df[order(-ngram_df$Count), , drop = FALSE]
  ngram_df
}

df_Bigrams<-fn_ngram_df(tdm_Bigrams)
df_Trigrams<-fn_ngram_df(tdm_Trigrams)
df_Quadgrams<-fn_ngram_df(tdm_Quadgrams)

#split bigrams in individual word and store in data frame
bigram <- data.frame(rows=rownames(df_Bigrams),count=df_Bigrams$Count)
bigram$rows <- as.character(bigram$rows)
bigram_split <- strsplit(as.character(bigram$rows),split=" ")
bigram <- transform(bigram,first = sapply(bigram_split,"[[",1),second = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = bigram$first,bigram = bigram$second,freq = bigram$count,stringsAsFactors=FALSE)
write.csv(bigram[bigram$freq > 1,],"./ProcessedData/bigram.csv",row.names=F)
bigram <- read.csv("./ProcessedData/bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"./ProcessedData/2gram.RData")

#split trigrams in individual word and store in data frame
trigram <- data.frame(rows=rownames(df_Trigrams),count=df_Trigrams$Count)
trigram$rows <- as.character(trigram$rows)
trigram_split <- strsplit(as.character(trigram$rows),split=" ")
trigram <- transform(trigram,first = sapply(trigram_split,"[[",1),second = sapply(trigram_split,"[[",2),third = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = trigram$first,bigram = trigram$second, trigram = trigram$third, freq = trigram$count,stringsAsFactors=FALSE)
write.csv(trigram[trigram$freq > 1,],"./ProcessedData/trigram.csv",row.names=F)
trigram <- read.csv("./ProcessedData/trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"./ProcessedData/3gram.RData")

#split quadgrams in individual word and store in data frame
quadgram <- data.frame(rows=rownames(df_Quadgrams),count=df_Quadgrams$Count)
quadgram$rows <- as.character(quadgram$rows)
quadgram_split <- strsplit(as.character(quadgram$rows),split=" ")
quadgram <- transform(quadgram,first = sapply(quadgram_split,"[[",1),second = sapply(quadgram_split,"[[",2),third = sapply(quadgram_split,"[[",3), fourth = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = quadgram$first,bigram = quadgram$second, trigram = quadgram$third, quadgram = quadgram$fourth, freq = quadgram$count,stringsAsFactors=FALSE)
write.csv(quadgram[quadgram$freq > 1,],"./ProcessedData/quadgram.csv",row.names=F)
quadgram <- read.csv("./ProcessedData/quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"./ProcessedData/4gram.RData")



