# data, used in server.R
hs <- get(load("data/hs-vaalikone2017.Rda"))
hs$Puolue <- as.character(hs$Puolue)

# parties in the data, used in ui.R
kunnat <- unique(hs$Kunta)
kunnat <- sort(kunnat)

# utility
all_na <- function(x) all(is.na(x))
