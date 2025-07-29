###############
# Code to write results to Seven Bridges
###############
# You need to save all your files under '/sbgenomics/output-files/<PATH>'
# and then stop/shutdown your Data Studio instance
# Once the instance shuts down successfully, you will see the output files
# under Files section at <PATH>

## Some sample data
sample_data <- data.frame(test_out = rnorm(12),
                          sample_col = rnorm(12))


## Create folder in output-files to store data
out_folder <- '/sbgenomics/output-files/demo_out' 
dir.create(out_folder)

## Write out to output location
out_path <- paste0(out_folder,'/','demo_out.csv')
write.csv(sample_data, out_path)

## Now after the data has been written to output-files, STOP this instance 
## After successful shutdown you will see the outputs under FILES
## NOTE: Large files (size/number) can take a lot of time to save after shutdown