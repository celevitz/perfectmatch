library(tidyverse)

games %>%
  filter(for.board.room == "yes") %>%
  select(!c(game.name,description,for.board.room)) %>%
  pivot_longer(!c(season,coupling)
               ,names_to="characteristic",values_to="value") %>%
  mutate(value2 = ifelse(value == "yes",1,0)) %>%
  group_by(season,characteristic) %>%
  summarise(count=sum(value2)) %>%
  pivot_wider(names_from=characteristic
              ,values_from=count)
