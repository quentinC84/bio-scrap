library(targets)

tar_option_set(
  tidy_eval = NULL,
  packages = c("readr", "magrittr"),
  error = NULL,
  garbage_collection = T,
)

source("scripts/functions.R", encoding = "utf-8")

groups_of_interest <- c(
  "unclassified",
  "root",
  "eukaryota",
  "homo sapiens",
  "viruses",
  "bacteria",
  "xylella"
) %>% tolower()

