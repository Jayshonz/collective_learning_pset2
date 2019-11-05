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
node_size <- ny_18 %>% count(to)
ny_18<-ny_18 %>% full_join(size, by="to")
# Create a data frame that will be used to set up the initial network links. 
edges <- data.frame(
  to=ny_18$from,
  from=ny_18$to,
  value = ny_18$value,
  id = ny_18$id,
  size = ny_18$n
  #importance=(sample(1:4, 12, replace=T))
)

# Create a data frame that will be used to enrich the network nodes using characteristics. 
nodes <- data.frame(
  to_industry = ny_18$industry2,
  from_industry = ny_18$industry1,
  value = ny_18$value,
  id = ny_18$id,
  size = ny_18$n
)

# Data structure that combines both for a simple network


simple_network2 <- data.frame(
  to=ny_18$from,
  from=ny_18$to,
  id = ny_18$id,
  to_industry = ny_18$industry2,
  from_industry = ny_18$industry1,
  value = ny_18$value
)

# Edge = link
# Node = node, vertex
# simpleNetwork(simple_network2)

forceNetwork(Links = edges, Nodes = nodes, Source = "from", Target = "to", 
             NodeID = "to_industry", Group = "id", Value = "value", linkDistance = networkD3::JS("function(d) { return 10*d.value; }"),
             Nodesize = "size",
             linkWidth = networkD3::JS("function(d) { return d.value/5; }"),opacity = 0.85, zoom = TRUE, opacityNoHover = 0.1)



forceNetwork(Links = edgeList, Nodes = nodeList, Source = "SourceID", Target = "TargetID",
             Value = "Weight", NodeID = "nName", Nodesize = "nodeBetweenness", Group = "nodeDegree", 
             height = 500, width = 1000, fontSize = 20, linkDistance = networkD3::JS("function(d) { return 10*d.value; }"), 
             linkWidth = networkD3::JS("function(d) { return d.value/5; }"),opacity = 0.85, zoom = TRUE, opacityNoHover = 0.1, 
             linkColour = edges_col)
