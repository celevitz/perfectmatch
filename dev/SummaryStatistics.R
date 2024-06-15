## Bring in data from Excel file
## Started 6/9/24

#rm(list=ls())

library(tidyverse)

## shows
table(contestants$show,contestants$season)

# Person-specific
    ## Number of couplings per person
      numberofcouplings <- matcheslong %>%
        filter(status == "accepted") %>%
        group_by(season,person) %>%
        summarise(numberofcouplings=n())

    ## number of unique partners
      uniquepartners <- matcheslong %>%
        filter(status == "accepted") %>%
        ungroup() %>%
        select(season,person) %>%
        distinct() %>%
        mutate(numpartners = NA)

      for (seasonnumber in unique(matches$season)) {
        for (ppl in unique(matcheslong$person[matcheslong$season == seasonnumber])) {
          temp <- matches[matches$season == seasonnumber &
                           (matches$person1 == ppl | matches$person2 == ppl ) &
                            !(is.na(matches$person1))
                         ,c("person1","person2")]
          partnernum <- length(unique(c(unique(temp$person1)
                                        ,unique(temp$person2))))-1
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


## How frequently do people switch couples after going on a date?
  haddate <- boardroomoptions %>%
    filter(date != "n/a") %>%
    select(season,coupling,date) %>%
    mutate(wentondate=paste0(coupling,"_",date)) %>%
    # tick up the coupling number, so we can compare their couple after the date
    # to who they were coupled with before
    # Note - this assumes that no one goes on a date in back-to-back couplings
    #   Given the heteronormativity of the show, that is a safe assumption,
    #   since they alternate men and women in the board room as options
    rows_append(boardroomoptions %>%
                  filter(date != "n/a") %>%
                  select(season,coupling,date) %>%
                  mutate(wentondate=paste0(coupling,"_",date)
                    ,coupling=coupling+1)) %>%
    rename(person=date)

  # bring together matches with date info
    temp <- haddate %>%
      rename(person1=person) %>%
      full_join(matches %>%
                  filter(status == "accepted") %>%
                  select(season,coupling,id,person1,person2)) %>%
      filter(!(is.na(person2)))

    temp2 <- haddate %>%
      rename(person2=person) %>%
      full_join(matches %>%
                  filter(status == "accepted") %>%
                  select(season,coupling,id,person1,person2)) %>%
      filter(!(is.na(person1)))

    combined <- temp %>%
      bind_rows(temp2) %>%
      arrange(season,coupling,id) %>%
      filter(!(is.na(wentondate)))

    switchedornot <- combined %>%
      select(!c(coupling,id)) %>%
      group_by(season,wentondate) %>%
      distinct() %>%
      summarise(ifmorethanonetheyswitched=n())

    switchedornot %>%
      group_by(season,ifmorethanonetheyswitched) %>%
      summarise(numberofplayers = n())












