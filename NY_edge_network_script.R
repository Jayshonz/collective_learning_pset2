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

# Read in the network data
ny_network_data <- read_xlsx("NY_networked.xlsx") %>% clean_names() %>% select(1:9) %>% na.omit()  %>% filter(value > 19) 

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
  id = ny_network_data$id
  )

# Data structure that combines both for a simple network
simple_network <- data.frame(
  to=ny_network_data$from,
  from=ny_network_data$to,
  id = ny_network_data$id,
  to_industry = ny_network_data$industry2,
  from_industry = ny_network_data$industry1,
  value = ny_network_data$value
)


layouts <- grep("^layout_", ls("package:igraph"), value=TRUE)[-1] 

# Remove layouts that do not apply to our graph.

layouts <- layouts[!grepl("bipartite|merge|norm|sugiyama|tree", layouts)]
par(mfrow=c(3,3), mar=c(1,1,1,1))


# Edge = link
# Node = node, vertex
graph=simpleNetwork(simple_network)

# Create graphable structure from the DF
edge_network <- graph_from_data_frame(d=simple_network, directed=F) 

# Plot the data
plot(edge_network, 
     # Node formatting
     vertex.size=simple_network$value*.5, 
     vertex.color=simple_network$from_industry, 
     vertex.label=" ",
     layout = layout_with_lgl)

plot(edge_network)

