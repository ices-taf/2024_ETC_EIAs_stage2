## Prepare plots and tables for report

## Before:
## After:

library(icesTAF)

mkdir("report")

# Load df -----------
all_data <- readRDS("data/all_data.rds")

for (tab in names(all_data)) {
  mkdir(glue("report/{tab}"))
  data <- all_data[[tab]]

  setwd(glue("report/{tab}"))
  sourceTAF("../../report_sankey.R")
  setwd("../..")
}

# combine into a single html report
