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
ny_18 <- read_xlsx("NY_networked_18.xlsx") %>% clean_names() %>% select(1:9) %>% na.omit() 
agg_data <- read_xlsx("aggregated_net_data.xlsx") %>% clean_names()


# Create a data frame that will be used to set up the initial network links. 
edges <- data.frame(
  to=ny_18$from,
  from=ny_18$to,
  value = ny_18$value,
  id = ny_18$id
  #importance=(sample(1:4, 12, replace=T))
)

# Create a data frame that will be used to enrich the network nodes using characteristics. 
nodes <- data.frame(
  to_industry = ny_18$industry2,
  from_industry = ny_18$industry1,
  value = ny_18$value,
  id = ny_18$id
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

visNetwork(nodes, links)
