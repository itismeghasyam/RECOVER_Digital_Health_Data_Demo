###############
# Code to Access a dataset (group of participants)
###############

### Required libraries
library('arrow')
library('tidyverse')

### Required Parameters
ARCHIVE_VERSION <- '2025-04-17'
cohort <- 'adults'
dataset_type <- 'dataset_fitbitdevices'

## Subset of participants we want to access the data of
## Getting current subset using a file on seven bridges, replace the list with your own
participant_list <- read.csv('/sbgenomics/project-files/adults_drs_manifest_2025-04-17.csv') %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(ParticipantID = strsplit(name,'/')[[1]][5]) %>% 
  dplyr::mutate(datasetType = strsplit(name,'/')[[1]][4]) %>% 
  dplyr::ungroup() %>% 
  unique() %>% 
  dplyr::filter(datasetType == dataset_type) %>% 
  dplyr::slice_sample(n=30) %>% 
  dplyr::pull(ParticipantID) 


### Here are two different ways of accessing cohort data:

## 1. Use arrow::open_dataset() objects
## Iterate over all participants to create list of arrow::open_dataset() objects
dataset_sources <- lapply(participant_list, function(participant_id){
  temp_dataset_path <- paste0('/sbgenomics/project-files/RECOVER_DigitalHealth_RawData/',
                         ARCHIVE_VERSION,'/',
                         cohort,'/',
                         dataset_type,'/',
                         participant_id)
  temp_df_arrow <- arrow::open_dataset(temp_dataset_path)
  return(temp_df_arrow)
}) 

## Lets read the dataset into memory
df <- arrow::open_dataset(dataset_sources) %>% 
  dplyr::collect()

## 2. List all individual files
## Iterate over all participants to create list of individual parquet files
dataset_sources_fileList <- lapply(participant_list, function(participant_id){
  temp_dataset_path <- paste0('/sbgenomics/project-files/RECOVER_DigitalHealth_RawData/',
                              ARCHIVE_VERSION,'/',
                              cohort,'/',
                              dataset_type,'/',
                              participant_id)
  temp_file_list <- list.files(temp_dataset_path, full.names = T)
  return(temp_file_list)
}) %>% unlist()

## Lets read the dataset into memory
df_fileList <- arrow::open_dataset(dataset_sources_fileList) %>% 
  dplyr::collect()

