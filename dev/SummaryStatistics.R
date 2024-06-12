## Bring in data from Excel file
## Started 6/9/24

#rm(list=ls())

library(tidyverse)

## shows
table(contestants$show,contestants$season)

# Person-specific
    ## Number of couplings per person
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

    ## Bring data together
      summaries <- numberofcouplings %>%
        full_join(uniquepartners) %>%
        full_join(wasasker)

## Info about couples
    ## people never partnered
      contestants %>%
        filter(First.coupling.cycle == `Coupling.cycle.in.which.they.didn't.match`) %>%
        group_by(show) %>%
        summarise(n=n())

    ## shows of the people never partnered
      contestants %>%
        filter(First.coupling.cycle == `Coupling.cycle.in.which.they.didn't.match`) %>%
        group_by(season)

    ## Length of matches
      timestogether <- matches %>%
        filter(status == "accepted") %>%
        group_by(season,person1,person2) %>%
        summarise(times=n()) %>%
        arrange(desc(times))

    ## Length of first couples
      firstcouples <- matches %>%
        # flag for first couple
        filter(status == "accepted") %>%
        mutate(first=ifelse(coupling == 1,1,0)) %>%
        group_by(season,person1,person2) %>%
        summarise(first=max(first)) %>%
        full_join(matches %>%
              select(!c(gender.balance,who.asked,status,note,id)) ) %>%
        filter(first == 1) %>%
        group_by(season,person1,person2) %>%
        summarise(lengthofcouple=n()) %>%
        arrange(desc(lengthofcouple))



