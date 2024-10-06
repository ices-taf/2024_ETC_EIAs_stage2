
library(googlesheets4)
library(glue)
library(icesTAF)

# Read google sheets data into R
base <- "https://docs.google.com/spreadsheets/d/{sheet}/edit"
sheet <- "1IgNNPUnJH7q9qcMN1Ssm-Lq0esZa4-fRdIzgJ3C8MfY"

ranges <-
  outer(
    c("Fisheries", "Aquaculture"),
    c("NEA", "Med"),
    FUN = function(X, Y) glue("{X} - {Y}")
  )

data <-
  sapply(
    ranges,
    function(range) {
      x <- read_sheet(glue(base), range = range)
      write.taf(x, file = paste0(gsub(" ", "", range), ".csv"), quote = TRUE)
      x
    },
    simplify = FALSE)
