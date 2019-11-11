# Load appropriate libraries
library(igraph)
library(readxl)
library(readr)
library(janitor)
library(viridis)
library(ggraph)
library(visNetwork)
library(networkD3)
library(tidyverse)

# Resources
# https://www.r-bloggers.com/network-visualization-part-6-d3-and-r-networkd3/
#

ny_18 <- read_xlsx("NY_networked_18.xlsx") %>% clean_names() %>% select(1:9) %>% na.omit() 
agg_data <- read_xlsx("aggregated_net_data.xlsx") %>% clean_names()

node_size <- agg_data %>% count(to)
agg_data<-agg_data %>% full_join(size, by="to")
# Create a data frame that will be used to set up the initial network links. 
edges <- data.frame(
  to=agg_data$from,
  from=agg_data$to,
  value = agg_data$value,
  id = agg_data$id,
  color = agg_data$color
  #importance=(sample(1:4, 12, replace=T))
)

# Create a data frame that will be used to enrich the network nodes using characteristics. 
nodes <- data.frame(
  to_industry = agg_data$industry2,
  from_industry = agg_data$industry1,
  value = agg_data$value,
  id = agg_data$id,
  color = agg_data$color
)

# Data structure that combines both for a simple network


simple_network2 <- data.frame(
  to=ny_18$from,
  from=ny_18$to,
  id = ny_18$id,
  to_industry = ny_18$industry2,
  from_industry = ny_18$industry1,
  value = ny_18$color
)

# Edge = link
# Node = node, vertex
# simpleNetwork(simple_network2)

forceNetwork(Links = edges, Nodes = nodes, Source = "from", Target = "to", 
             NodeID = "to_industry", Group = "id", Value = "value", linkDistance = networkD3::JS("function(d) { return 10*d.value; }"),
             linkWidth = networkD3::JS("function(d) { return d.value/5; }"),opacity = 0.85, zoom = TRUE, opacityNoHover = 0.1, linkColour = color)



forceNetwork(Links = edgeList, Nodes = nodeList, Source = "SourceID", Target = "TargetID",
             Value = "Weight", NodeID = "nName", Nodesize = "nodeBetweenness", Group = "nodeDegree", 
             height = 500, width = 1000, fontSize = 20, linkDistance = networkD3::JS("function(d) { return 10*d.value; }"), 
             linkWidth = networkD3::JS("function(d) { return d.value/5; }"),opacity = 0.85, zoom = TRUE, opacityNoHover = 0.1, 
             linkColour = color)
