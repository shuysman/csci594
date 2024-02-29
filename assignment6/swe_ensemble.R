library(terra)
library(glue)
library(tidyverse)

out_dir <- file.path("~/out")
nc_files <- list.files(out_dir, pattern = ".*nc", full.names = TRUE)

rasts <- terra::rast(nc_files)

ensemble <- terra::app(rasts, fun = "mean")

writeCDF(ensemble, filename = file.path(out_dir, "accumswe_ensemble.nc"))

png(file = file.path(out_dir, "accumswe_ensemble.png"))
plot(ensemble, main = "Average accumswe ensemble")
dev.off()
