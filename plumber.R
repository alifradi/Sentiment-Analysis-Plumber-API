library(reticulate)
library(tidyquant)
library(tidyverse)
library(reticulate)
library(dplyr)
library(rjson)
source_python("pyPredict.py")
library(RestRserve)
library("caret")
library(dplyr)
library(jsonlite)

#* @param df data to feed
#* @post /LR


function(req, res) {
  # parse the JSON string from the post body
  data <- jsonlite::fromJSON(req$postBody)
  df = data.frame(
    page_num       = data$page_num,
    paragraph_num  = data$paragraph_num,
    paragraph_text = data$paragraph_text
  )
  
  output <- df %>% 
    pull(paragraph_text) %>%
    pipeline_regression()
  return(
    
    jsonlite::toJSON(
      list(
        result = output
      )
    )
  )
}


#* @param df data to feed
#* @post /GLM


function(req, res) {
  # parse the JSON string from the post body
  data <- jsonlite::fromJSON(req$postBody)
  df = data.frame(
    page_num       = data$page_num,
    paragraph_num  = data$paragraph_num,
    paragraph_text = data$paragraph_text
  )
  
  output <- df %>% 
    pull(paragraph_text) %>%
    pipeline_classification()
  return(
    
    jsonlite::toJSON(
      list(
        result = output
      )
    )
  )
}