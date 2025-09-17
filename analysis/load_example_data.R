###############
# Example data: fitbitdailydata for 100 participants from 2025-04-17 archive
###############

### Required libraries
library('arrow')
library('tidyverse')

### Required Parameters
ARCHIVE_VERSION <- '2025-04-17'
cohort <- 'adults'
dataset_type <- 'dataset_fitbitdailydata'

## Subset of participants we want to access the data of
## Getting current subset using folders(each participants has their own folder) in considered dataset
participants_path <-  paste0('/sbgenomics/project-files/RECOVER_DigitalHealth_RawData/',
                             ARCHIVE_VERSION,'/',
                             cohort,'/',
                             dataset_type,'/')
df_enrolled <- arrow::open_dataset(participants_path) 
participant_list <- df_enrolled$files %>%
  as.data.frame() %>%
  `colnames<-`('filePath') %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(ParticipantIdentifier = stringr::str_split(filePath, '/')[[1]][11]) %>% 
  dplyr::ungroup() %>% 
  dplyr::select(ParticipantIdentifier) %>% 
  unique() %>% 
  dplyr::slice_sample(n=100) %>% 
  unlist()


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

### Load arrow object
df_fileList_arrow <- arrow::open_dataset(dataset_sources_fileList) 

##
df_fileList <- df_fileList_arrow %>% dplyr::collect()

##
print('df_fileList: sample data loaded into env')
