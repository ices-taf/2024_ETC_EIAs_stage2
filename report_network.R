
# could hard code this as a shape file...

# and use the shiny code to click things and highlight things....

library(networkD3)

# Load data
data(MisLinks)
data(MisNodes)
# Create graph
forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4, zoom = TRUE
)

# Create graph with legend and varying node radius
forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Nodesize = "size",
  radiusCalculation = "Math.sqrt(d.nodesize)+6",
  Group = "group", opacity = 0.8, legend = TRUE
)

# Create graph directed arrows
forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4, arrows = TRUE
)

## Not run:
#### JSON Data Example
# Load data JSON formated data into two R data frames
# Create URL. paste0 used purely to keep within line width.
URL <- paste0(
  "https://cdn.rawgit.com/christophergandrud/networkD3/",
  "master/JSONdata/miserables.json"
)

MisJson <- jsonlite::fromJSON(URL)

# Create graph
forceNetwork(
  Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4
)

# Create graph with zooming
forceNetwork(
  Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4, zoom = TRUE
)


# Create a bounded graph
forceNetwork(
  Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4, bounded = TRUE
)

# Create graph with node text faintly visible when no hovering
forceNetwork(
  Links = MisJson$links, Nodes = MisJson$nodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.4, bounded = TRUE,
  opacityNoHover = TRUE
)

## Specify colours for specific edges
# Find links to Valjean (11)
which(MisNodes == "Valjean", arr = TRUE)[1] - 1
ValjeanInds <- which(MisLinks == 11, arr = TRUE)[, 1]

# Create a colour vector
ValjeanCols <- ifelse(1:nrow(MisLinks) %in% ValjeanInds, "#bf3eff", "#666")

forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 0.8, linkColour = ValjeanCols
)


## Create graph with alert pop-up when a node is clicked.  You're
# unlikely to want to do exactly this, but you might use
# Shiny.onInputChange() to allocate d.XXX to an element of input
# for use in a Shiny app.

MyClickScript <- 'alert("You clicked " + d.name + " which is in row " +
       (d.index + 1) +  " of your original R data frame");'

forceNetwork(
  Links = MisLinks, Nodes = MisNodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name",
  Group = "group", opacity = 1, zoom = FALSE,
  bounded = TRUE, clickAction = MyClickScript
)


###



library(networkD3)
library(htmlwidgets)

nodes <- data.frame(name = c("a", "b", "c", "d"))
links <- data.frame(
  source = c(0, 0, 1, 1),
  target = c(2, 3, 2, 3),
  value = c(1, 3, 2, 4)
)

sn <- sankeyNetwork(
  Links = links, Nodes = nodes, Source = "source",
  Target = "target", Value = "value", NodeID = "name"
)

js <-
  '
    function(el) {
      d3.select(el)
        .selectAll(".node")
        .append("image")
        .attr("xlink:href", d => "https://pngimg.com/uploads/letter_" + d.name + "/letter_" + d.name + "_PNG4.png")
    }
  '

htmlwidgets::onRender(sn, js)
