## Preprocess data, write TAF data tables

## Before:
## After:

library(icesTAF)

mkdir("data")

sourceTAF("data_calc_scores.R")

# Load df -----------
all_data <- readRDS("data/all_data.rds")

for (tab in names(all_data)) {
  mkdir(glue("data/{tab}"))
  data <- all_data[[tab]]

  setwd(glue("data/{tab}"))
  sourceTAF("../../data_exploratory.R")
  setwd("../..")
}
