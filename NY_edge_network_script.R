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
ny_network_data <- read_xlsx("NY_networked.xlsx") %>% clean_names() %>% select(1:9) %>% na.omit()  %>% filter(value > 19) 
ny_18 <- read_xlsx("NY_networked_18.xlsx") %>% clean_names() %>% select(1:9) %>% na.omit() 


# Edge = link
# Node = node, vertex
# Create a data frame that will be used to set up the initial network links. 
links <- data.frame(
  to=ny_network_data$from,
  from=ny_network_data$to,
  id = ny_network_data$id
  #importance=(sample(1:4, 12, replace=T))
)

# Create a data frame that will be used to enrich the network nodes using characteristics. 
nodes <- data.frame(
  to_industry = ny_network_data$industry2,
  from_industry = ny_network_data$industry1,
  value = ny_network_data$value,
  id = ny_network_data$id,
  title = as.character(ny_network_data$industry2) 
  )

# Data structure that combines both for a simple network
simple_network <- data.frame(
  to=ny_network_data$from,
  from=ny_network_data$to,
  id = ny_network_data$id,
  to_industry = ny_network_data$industry2,
  from_industry = ny_network_data$industry1,
  value = ny_network_data$value, 
  title = as.character(ny_network_data$industry2)
)

simple_network2 <- data.frame(
  to=ny_18$from,
  from=ny_18$to,
  id = ny_18$id,
  to_industry = ny_18$industry2,
  from_industry = ny_18$industry1,
  value = ny_18$value
)


# Create graphable structure from the DF
edge_network <- graph_from_data_frame(d=simple_network, directed=F) 
name_list <-simple_network %>% group_by(from_industry) %>% count(from_industry) %>% select(from_industry)
# Plot the data
par(mfrow=c(2,3))
plot(edge_network, vertex.size=simple_network$value*.5, vertex.color=simple_network$from_industry, vertex.label=" ", layout=layout.random, main="Random")
plot(edge_network, vertex.size=simple_network$value*.5, vertex.color=simple_network$from_industry, vertex.label=" ", layout=layout.fruchterman.reingold, main="fruchterman.reingold")
plot(edge_network, vertex.size=simple_network$value*.5, vertex.color=simple_network$from_industry, vertex.label=" ", layout = layout_with_mds, main = "MDS")
plot(edge_network, vertex.size=simple_network$value*.5, vertex.color=simple_network$from_industry, vertex.label=" ", layout = layout_with_graphopt, main = "Graph OPT")
plot(edge_network, vertex.size=simple_network$value*.5, vertex.color=simple_network$from_industry, vertex.label=" ", layout = layout.sphere, main="Sphere")
plot(edge_network, vertex.size=simple_network$value*.5, vertex.color=simple_network$from_industry, vertex.label=" ", layout=layout.circle, main="Circle") 






