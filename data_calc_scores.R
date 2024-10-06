library(icesTAF)
library(glue)
mkdir("data")

source("utilities_pressures.R")

# read in data

files <- c(
  "Fisheries-NEA",
  "Fisheries-Med",
  "Aquaculture-NEA",
  "Aquaculture-Med"
)

all_data <- sapply(files, function(x) calc_scores(glue("boot/data/google_sheets/{x}.csv")), simplify = FALSE)

# do we include a confidence measure.... ?

saveRDS(all_data, file = "data/all_data.rds")
