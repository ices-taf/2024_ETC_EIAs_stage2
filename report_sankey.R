# Library
library(icesTAF)
library(networkD3)
library(dplyr)
library(ggalluvial)
library(RColorBrewer)
library(htmlwidgets)
library(webshot)

# Load df saved after 00_preprocess.R script
unique(data$Sector)
unique(data$Pressure)

# Reorganize df to source>target
data$id <- as.character(row.names(data))

# Filter low values for sankey
data <- data |> filter(ImpactRisk > 0.01)

links <-
  data |>
  transmute(source = Sector, target = Pressure, value = ImpactRisk, linkgroup = Pressure) |>
  rbind(
    data |> transmute(source = Pressure, target = Ecological.Characteristic, value = ImpactRisk, linkgroup = Pressure)
  ) |>
  group_by(source, target, linkgroup) |>
  summarise(value = sum(value) * 10) |>
  arrange(value)

summary(links$value)

# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- links |>
  group_by(source) |>
  summarise(value = sum(value))
names(nodes) <- c("name", "value")
nodes1 <- links |>
  group_by(target) |>
  summarise(value = sum(value))
names(nodes1) <- c("name", "value")
nodes <- rbind(nodes, nodes1)
nodes <- nodes |>
  group_by(name) |>
  summarise(value = sum(value)) |>
  arrange(-value)
nodes$group <- "nodes"
nodes <- nodes |> select(-value)


# With networkD3, connection must be provided using id, not using real name like in the data dataframe.. So we need to reformat it.
links$IDsource <- match(links$source, nodes$name) - 1
links$IDtarget <- match(links$target, nodes$name) - 1
nodes <- data.frame(nodes)
nodes$name <- as.character(nodes$name)
links <- data.frame(links)
links <- links |> arrange(value, IDsource, IDtarget)



# prepare color scale: I give one specific color for each node.
n <- length(unique(links$linkgroup))
pal <- brewer.pal(n, "Set2")[1:n]
pal2 <- unlist(mapply(brewer.pal, n - nrow(pal), "Dark2"))
pal <- rbind(pal, pal2)


pal <- gplots::col2hex(c("red", "blue", "green", "purple"))
pal <- paste(shQuote(pal), collapse = ", ")
dom <- unique(links$linkgroup)
dom <- paste(shQuote(dom), collapse = ", ")

my_color <-
  paste0("d3.scaleOrdinal().domain([", dom, ",'nodes']).range([", pal, ",'grey'])")


# Make the Network. I call my colour scale with the colourScale argument
p <- sankeyNetwork(
  Links = links, Nodes = nodes, Source = "IDsource", Target = "IDtarget",
  Value = "value", NodeID = "name",
  fontSize = 20,
  colourScale = my_color,
  LinkGroup = "linkgroup", NodeGroup = "group", iterations = 0
)
p

# save the widget
saveWidget(p, file = "sankey.html", selfcontained = TRUE)

# save the widget
webshot("sankey.html", "sankey.png", vwidth = 900, vheight = 1000)
