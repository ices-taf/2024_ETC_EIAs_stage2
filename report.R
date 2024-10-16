## Prepare plots and tables for report

## Before:
## After:

library(icesTAF)
library(glue)

mkdir("report")

# Load df -----------
all_data <- readRDS("data/all_data.rds")

sankeys <- list()

# tab <- "Fisheries-NEA"
for (tab in names(all_data)) {
  mkdir(glue("report/{tab}"))
  data <- all_data[[tab]]

  setwd(glue("report/{tab}"))
  sourceTAF("../../report_sankey.R")
  setwd("../..")

  sankeys[[tab]] <- p
}

save(sankeys, file = "report/sankeys.rds")

# combine into a single html report
rmarkdown::render("report.Rmd", output_file = "report.html", output_dir = "report")
