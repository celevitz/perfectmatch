## Bring in data from Excel file
## Started 6/9/24

rm(list=ls())

library(openxlsx)
library(tidyverse)

directory <- "/Users/carlylevitz/Documents/Data/"

# Bring in the data
  contestants <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=1))
  matches <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=2))
  boardroom <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=3))
  boardroomoptions <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx"
                                                ,sep=""),sheet=4))
  games <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=5))
  voting <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=6))

# Save the data files
  save(contestants, file = "data/contestants.rda")
  save(matches, file = "data/matches.rda")
  save(boardroom, file = "data/boardroom.rda")
  save(boardroomoptions, file = "data/boardroomoptions.rda")
  save(games, file = "data/games.rda")
  save(voting, file = "data/voting.rda")



