### CSCI 594 Assignment 4
### Calculate average 2010-2020 historical annual precip for the Greater Yellowstone Ecosystem
### Run in parallel and sequentially, compare run times

time <- Sys.time()

library(terra)
library(tidyverse)

terraOptions(verbose = TRUE)

cores <- 64

##wb_data_dir <- file.path("/media/smithers/shuysman/data/nps_gridded_wb/gye/historical/")
wb_data_dir <- file.path("~/data/nps_gridded_wb/gye/historical/")

rain_file_pattern <- "rain_.*_subset.nc"

rain_files <- list.files(wb_data_dir, pattern = rain_file_pattern, full.names = TRUE)

rain <- rast(rain_files) %>%
    subset(year(time(.)) >= 2010) %>% subset(year(time(.)) <= 2020) %>% ### filter to years of interest
    clamp(lower = 0) ### Clamp off weird negative pixels over bodies of water, etc.

### Calculate mean accumulate SWE across history 

### Mean rain for each year
annual_mean_rain <- terra::tapp(rain,
                         fun = \(i) mean(i), ### Use base R mean() to allow parallelization
                         index = "years",
                         cores = cores)

### Mean rain for all years
mean_rain <- terra::app(annual_mean_rain,
                        fun = \(i) mean(i),  ### Use base R mean() to allow parallelization
                        cores = cores)

png(filename = "~/out/rain-parallel.png")
plot(mean_rain)
dev.off()

(run_time <- Sys.time() - time) ### output run time
