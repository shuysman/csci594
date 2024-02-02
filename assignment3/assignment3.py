## CSCI 594 Assignment 3: Work with Environments 
## Use a conda environment created on Tempest ('assignment3')
## Load 2021 historical Actual Evapotranspiration (AET) netcdf, calculate annual sum of AET, create and save map

import matplotlib.pyplot as plt
import xarray as xr
from pathlib import Path

data_path = Path.home() / "data/nps_gridded_wb/gye/historical/AET_2021_subset.nc"
aet_xr  = xr.open_dataset(data_path)  

# Subset to only days 1-365 to drop bad -32767 value day at EOY, divide by 10 because units are AET * 10 and label units as "AET"
aet_xr = aet_xr["AET"][0:365] / 10
aet_xr.attrs["units"] = "AET"

print(aet_xr)

sum_aet = aet_xr.sum(dim = "time")

plt.figure(figsize=(10,10))

sum_aet.plot.pcolormesh()

plt.title("2021 Annual Actual Evapotranspiration, Greater Yellowstone Ecosystem")

##plt.show()

plt.savefig(Path.home() / "out" / "assignment3.png")
