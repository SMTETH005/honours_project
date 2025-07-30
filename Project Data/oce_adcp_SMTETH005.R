# Usage of the oce package for processing ADCP data 
# Ethan Smith SMTETH005 
# 30/07/2025

# Installation: ----
#   In the R console (R-4.5.1) 
# install.packages("oce", repos = c("https://dankelley.r-universe.dev", "https://cloud.r-project.org"))
# also install ocedata with: 
#   remotes::install_github("dankelley/ocedata", ref="main")

library("oce")
library("ocedata")

# Usage: ----

from_time <- "2015-05-20 08:00:00" # yyyy mm dd
to_time <- "2015-08-09 00:00:00"
from <- as.POSIXct(from_time, format = "%Y-%m-%d %H:%M:%S")
to <- as.POSIXct(to_time, format = "%Y-%m-%d %H:%M:%S")

read.adp.rdi(
  "C:/Users/ethan/OneDrive/UCT/Honours 2025/Honours Project/Project Data/extracted_project_data/extracted_gordons_bay_data/GB_20150520/Raw/CSIR_RDI_Sentinel_FB_20150520_V3000.000",
  #from,
  #to,
  by,
  tz = getOption("oceTz"),
  longitude = NA,
  latitude = NA,
  type = c("workhorse"),
  which,
  encoding = NA,
  monitor = txtProgressBar(),
  despike = TRUE,
  #processingLog,
  testing = FALSE,
  debug = getOption("oceDebug")
)

GB1 <- read.adp.rdi("C:/Users/ethan/OneDrive/UCT/Honours 2025/Honours Project/Project Data/extracted_project_data/extracted_gordons_bay_data/GB_20150520/Raw/CSIR_RDI_Sentinel_FB_20150520_V3000.000", despike = T)

plot(GB1)

vel <- GB1[['v']]        # 3D velocity array: time x depth x component
time <- GB1[['time']]    # time vector
depth <- GB1[['distance']]  # bin distances from transducer
