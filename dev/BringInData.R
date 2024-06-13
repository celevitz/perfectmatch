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
                                     ,sheet=2)) %>%
    # remove the people who chose to leave
    filter(!(is.na(person2)))
    matches$id <- as.numeric(row.names(matches))

    # clean the data: matches should be in alphabetical order (1 vs 2)
    # long form
    matcheslong <- matches %>%
        pivot_longer(!c(season,coupling, gender.balance,who.asked,status
                        ,id,note)
                     ,names_to = "personnumber",values_to = "person")

      for (uniqueid in unique(matcheslong$id)) {
        asker <- matcheslong$person[matcheslong$who.asked == matcheslong$personnumber &
                                      matcheslong$id == uniqueid]
        matcheslong$who.asked[matcheslong$id == uniqueid] <- asker

      }

      matcheslong <- matcheslong %>%
        arrange(season,coupling,id,person) %>%
        group_by(season,coupling,id) %>%
        select(!personnumber) %>%
        mutate(personnumber = paste0("person",row_number()) ) %>%
        ungroup()

    # go back to wide form, so that person1 and person2 are always alphabetical
      matches <- matcheslong %>%
        pivot_wider(names_from=personnumber,values_from=person)

  boardroom <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=4))
  boardroomoptions <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx"
                                                ,sep=""),sheet=5))
  games <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=3))
  voting <- as_tibble(read.xlsx(paste(directory,"PerfectMatch.xlsx",sep="")
                                     ,sheet=6))

# Save the data files
  save(contestants, file = "data/contestants.rda")
  save(matches, file = "data/matches.rda")
  save(matcheslong, file = "data/matches_long.rda")
  save(boardroom, file = "data/boardroom.rda")
  save(boardroomoptions, file = "data/boardroomoptions.rda")
  save(games, file = "data/games.rda")
  save(voting, file = "data/voting.rda")



