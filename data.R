## Preprocess data, write TAF data tables

## Before:
## After:

library(icesTAF)

mkdir("data")

sourceTAF("data_calc_scores.R")
sourceTAF("data_exploratory.R")
