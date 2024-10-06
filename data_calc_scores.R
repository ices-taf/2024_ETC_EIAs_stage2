library(icesTAF)
mkdir("data")

source("utilities_pressures.R")

# read in data

files <- c(
  "boot/data/google_sheets/Fisheries-NEA.csv",
  "boot/data/google_sheets/Fisheries-Med.csv",
  "boot/data/google_sheets/Aquaculture-NEA.csv",
  "boot/data/google_sheets/Aquaculture-Med.csv"
)

all_data <- lapply(files, calc_scores)

# do we include a confidence measure.... ?

saveRDS(all_data, file = "data/all_data.rds")
