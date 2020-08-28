library(pdftools)
library(tesseract)
library(reticulate)
library(magick)
library(tidyquant)
library(plotly)
library(tidyverse)
library(reticulate)
library(dplyr)
library(rjson)
source_python("pyPredict.py")
library(RestRserve)
library("caret")
library(dplyr)
library(jsonlite)

# function(req, res) {
#   # parse the JSON string from the post body
#   #data <- jsonlite::fromJSON(req$postBody)
#   output=  tibble(
#     #page Text
#     page_text = as.character(req$postBody)
#   ) %>%
#     rowid_to_column(var = "page_num") %>%
#     #Paragraph Text
#     mutate(paragraph_text = str_split(page_text, pattern = "\\.\r")) %>%
#     select(-page_text) %>%
#     unnest(paragraph_text) %>%
#     rowid_to_column(var = "paragraph_num") %>%
#     select(page_num, paragraph_num, paragraph_text) %>%
#     pull(paragraph_text)
#   
#   return(
#     
#     jsonlite::toJSON(
#       list(
#         result = output
#       )
#     )
#   )
# }

#* @param df data to feed
#* @post /LR


#* @param a Text
#* @post /todef
function(a) {
  df=  as.character(a) %>%
    tibble(
      #page Text
      page_text = a
    ) %>%
    rowid_to_column(var = "page_num") %>%
    #Paragraph Text
    mutate(paragraph_text = str_split(page_text, pattern = "\\.\r")) %>%
    select(-page_text) %>%
    unnest(paragraph_text) %>%
    rowid_to_column(var = "paragraph_num") %>%
    select(page_num, paragraph_num, paragraph_text) %>% 
    pull(paragraph_text) 
  
  df <- jsonlite::toJSON(data.frame(df, auto_unbox=TRUE))
  
  return(df)
}

#* @param df data to feed
#* @post /score



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