# data
hs <- get(load("data/hs-vaalikone2017.Rda"))

kunnat <- unique(hs$Kunta)
kunnat <- sort(kunnat)
hs$Puolue <- as.character(hs$Puolue)

# utility
all_na <- function(x) all(is.na(x))
