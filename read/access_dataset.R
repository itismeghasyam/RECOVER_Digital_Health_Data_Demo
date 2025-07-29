###############
# Code to Access a dataset (per participant)
###############

### Required libraries
library('arrow')
library('tidyverse')

### Required Parameters
ARCHIVE_VERSION <- '2025-04-17'
cohort <- 'adults'
dataset_type <- 'dataset_enrolledparticipants'
participant_id <- '<PID>' # Choose a valid participantID

dataset_path <- paste0('/sbgenomics/project-files/RECOVER_DigitalHealth_RawData/',
                     ARCHIVE_VERSION,'/',
                     cohort,'/',
                     dataset_type,'/',
                     participant_id)

### Load Dataset
## Look for the required dataset under the Files section of your project
## Lets read the dataset into memory
df <- arrow::open_dataset(dataset_path) %>% 
  dplyr::collect()
