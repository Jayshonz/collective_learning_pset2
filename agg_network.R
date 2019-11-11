# Load appropriate libraries
library(igraph)
library(readxl)
library(readr)
library(janitor)
library(viridis)
library(ggraph)
library(GGally)
library(scales)
library(network)
library(visNetwork)
library(networkD3)
library(tidyverse)

# Resources
# https://igraph.org/python/doc/tutorial/tutorial.html
# https://www.r-graph-gallery.com/247-network-chart-layouts.html


# Read in the network data
agg_data <- read_xlsx("aggregated_net_data.xlsx") %>% clean_names()

add_data <- read_csv("additional.csv") %>% clean_names()
tot <- full_join(agg_data, add_data, by=c("industry_id1"="id_industry_group"))

# Create graph object
agg_g <- graph_from_data_frame(d=tot, directed=TRUE)

## Create node/link dfs
vis.links <- data.frame(
  to = tot$to,
  from = tot$from,
  value = tot$value
)

link_list <- c("to", "from", "value")
vis.nodes <- tot %>% select(-1,-2,-3, -4, -5)
agg_g <- graph_from_data_frame(d=tot, directed=TRUE)

vis.nodes$title  <- NA # Text on click
#vis.nodes$label  <- NA # Node label
#vis.nodes$size   <- vis.nodes$average_income # Node size
#vis.nodes$borderWidth <- 2 # Node border width
vis.nodes$color.background <- c("gray50", "tomato", "gold", "blue") [vis.nodes$state]
#vis.nodes$color.highlight.background <- "orange"
##vis.nodes$color.highlight.border <- "darkred"

visNetwork(agg_g, vis.nodes)

# Create full DF for network

visNetwork(nodes_CTP, links_CTP, height = "700px", width = "100%") %>%
  visOptions(selectedBy = "label", 
             highlightNearest = TRUE, 
             nodesIdSelection = TRUE) %>%
  visPhysics(stabilization = FALSE)