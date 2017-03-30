# data
hs <- get(load("data/hs-vaalikone2017.Rda"))

kunnat <- unique(hs$Kunta)
kunnat <- sort(kunnat)
puolueet <- sort(as.character(unique(hs$Puolue)))

# utility
all_na <- function(x) all(is.na(x))

kunta <- "Helsinki"
puolue <- "Vihreät"

df <- dplyr::filter(hs, Kunta %in% kunta)
# filter out items for which there are no answers
no_answers <- sapply(df, all_na)
df <- dplyr::select(df, -which(no_answers))

groups <- df$Puolue
groups[!groups %in% puolue] <- "Muut"

items <- df[, -(1:5)]
items_ <- items[, 1:5]
lf <- likert::likert(items_, grouping = groups)
windows();plot(lf)
