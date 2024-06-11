## Bring in data from Excel file
## Started 6/9/24

rm(list=ls())

library(tidyverse)

## shows
table(contestants$show,contestants$season)

## people never partnered
  contestants %>%
    filter(First.coupling.cycle == `Coupling.cycle.in.which.they.didn't.match`) %>%
    group_by(season) %>%
    summarise(n=n())

## Number of couplings
  numberofcouplings <- matcheslong %>%
    group_by(season,person) %>%
    summarise(numberofcouplings=n())

## number of unique partners
  uniquepartners <- matcheslong %>%
    ungroup() %>%
    select(season,person) %>%
    distinct() %>%
    mutate(numpartners = NA)

  for (seasonnumber in unique(matches$season)) {
    for (ppl in unique(matcheslong$person[matcheslong$season == seasonnumber])) {
      temp <- matches[matches$season == seasonnumber &
                         (matches$person1 == ppl | matches$person2 == ppl )
                     ,c("person1","person2")]
      partnernum <- length(c(unique(temp$person1),unique(temp$person2)))-1
      uniquepartners$numpartners[uniquepartners$season == seasonnumber &
                                   uniquepartners$person == ppl] <- partnernum
    }
  }

## number of times they asked
## need to divide by 2 because there are two rows for each couple
  wasasker <- matcheslong %>%
    group_by(season,who.asked,status) %>%
    summarise(n=n()/2) %>%
    mutate(status = case_when(status == "accepted" ~ "personsaidyestothem"
                           ,status == "rejected" ~ "personsaidnotothem"
                           ,TRUE ~ status)) %>%
    pivot_wider(names_from=status,values_from=n) %>%
    mutate(personsaidnotothem=ifelse(is.na(personsaidnotothem)
                                     ,0,personsaidnotothem))

## Length of matches

## Length of first couples

## Bring data together
  summaries <- numberofcouplings %>%
    full_join(uniquepartners) %>%
    full_join(wasasker)
