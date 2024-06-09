## Bring in data from Excel file

rm(list=ls())

library(openxlsx)
library(tidyverse)

directory <- "/Users/carlylevitz/Documents/Data/"

contestants <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                   ,sheet=1))
matches <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                   ,sheet=2))
boardroom <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                   ,sheet=3))
boardroomoptions <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                   ,sheet=4))
games <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                   ,sheet=5))
voting <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                   ,sheet=6))

