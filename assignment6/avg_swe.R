### Summarize SWE for year range for a single model
### call with ave_swe.R $model# $scenario $start_year $end_year
### i.e., Rscript ave_swe.R 1 rcp45 2050 2059

library(terra)
library(glue)
library(tidyverse)

terraOptions(verbose = TRUE)

##nc_dir <- file.path("~/data/nps_gridded_wb/gye/forecasts/")
nc_dir <- file.path("/media/smithers/shuysman/data/nps_gridded_wb/gye/forecasts/")

models <- c("BNU-ESM",
            "CanESM2",
            "CCSM4",
            "CNRM-CM5",
            "CSIRO-Mk3-6-0",
            "GFDL-ESM2G",
            "HadGEM2-CC365",
            "inmcm4",
            "IPSL-CM5A-LR",
            "MIROC5",
            "MIROC-ESM-CHEM",
            "MRI-CGCM3",
            "NorESM1-M")

args <- commandArgs(trailingOnly = TRUE)

model <- models[args[1]]
scenario <- args[2]
start_year <- args[3]
end_year <- args[4]

### For testing
model <- "BNU-ESM"
scenario <- "rcp45"
start_year <- 2050
end_year <- 2059


### Find SWE files matching year range
years_pattern <- paste(start_year:end_year, collapse = "|")
swe_nc_files <- list.files(nc_dir, pattern = glue("accumswe_{model}_{scenario}_.*"), full.names = TRUE)
swe_nc_files <- swe_nc_files[str_detect(swe_nc_files, pattern = years_pattern)]

swe_rast <- terra::rast(swe_nc_files)

annual_swe <- swe_rast %>%
    subset(yday(time(.)) == 365) %>%
    clamp(lower = 0, values = FALSE)

time(annual_swe) <- year(time(annual_swe))

### Convert from units = accumswe * 10
annual_swe <- annual_swe / 10

swe_avg <- terra::app(annual_swe, fun = "mean")

writeCDF(swe_avg, filename = file.path("~/out/", glue("accumswe_{model}_{scenario}_{start_year}-{end_year}_mean.nc")), overwrite = TRUE)
