###############
# Code to compute summary metrics (sd, mean, median etc.,)
# repurposed from https://github.com/itismeghasyam/recover-sleep-measures/blob/main/scripts/functions/calcMetrics.R
###############

### Required functions
calcMetrics <- function(data, 
                        vars, 
                        metrics,
                        primaryDateCol = "Date") {
  
  accepted_metrics <- 
    c("mean", "median", "variance",
      "percentile5", "percentile95", "count",
      "percent", "circularSD", "SD")
  
  invalid_metrics <- metrics[!metrics %in% accepted_metrics]
  
  if (length(invalid_metrics) > 0) {
    stop("Invalid 'metrics' argument(s): ", paste(invalid_metrics, collapse = ", "), 
         ". Accepted values are: ", paste(accepted_metrics, collapse = ", "))
  }
  
  summary_functions <-
    list(
      mean = ~mean(.x, na.rm = TRUE),
      median = ~median(.x, na.rm = TRUE),
      variance = ~var(.x, na.rm = TRUE),
      percentile5 = ~quantile(.x, 0.05, na.rm = TRUE),
      percentile95 = ~quantile(.x, 0.95, na.rm = TRUE),
      count = ~sum(!is.na(.x)),
      percent = ~sum(.x, na.rm = TRUE)/sum(!is.na(.x)),
      circularSD = ~psych::circadian.sd(.x, hours = TRUE, na.rm = TRUE)$sd,
      SD = ~stats::sd(.x, na.rm = TRUE)
    )
  
  selected_functions <- summary_functions[metrics]
  
  result <-
    data %>%
    summarise(
      across(.cols = all_of(c(vars)),
             .fns = selected_functions,
             .names = "{.col}_{.fn}"),
      .groups = "drop"
    )
  
  return(result)
  
}


### get sample data (fitbitdailydata for 100 participants from 2025-04-17 archive)
source('analysis/load_example_data.R')

### Get metric summaries
### Get vars for metrics, and change var type (to num / int)
df_vars <- df_fileList %>% 
  dplyr::mutate(Calories = as.numeric(Calories),
                Distance = as.numeric(Distance),
                MinutesVeryActive = as.numeric(MinutesVeryActive)) %>% 
  dplyr::select(ParticipantIdentifier,
                Date, 
                Calories,
                Distance,
                MinutesVeryActive) 

## We end up with a summary dataframe that 
## has columns like var_metric (for eg., Distance_SD, or Calories_mean)
df_summary <- df_vars %>% 
  dplyr::group_by(ParticipantIdentifier) %>% 
  dplyr::group_modify(~ calcMetrics(.x, 
                                    vars = c('Calories','Distance','MinutesVeryActive'),
                                    metrics = c('mean', 'median', 'SD'))) %>% 
  dplyr::ungroup()



