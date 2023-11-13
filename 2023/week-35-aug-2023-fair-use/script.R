library(tidyverse)
library(tidymodels)
library(httr)
library(hrbrthemes)
library(tidytuesdayR)
library(fuzzyjoin)

tuesdata <- tidytuesdayR::tt_load('2023-08-29')
fair_use_cases <- tuesdata$fair_use_cases
fair_use_findings <- tuesdata$fair_use_findings

# How many per year
fair_use_cases %>% 
  mutate(year = as.factor(year)) %>% 
  group_by(year) %>% 
  summarise(sum = n()) %>% 
  ggplot(aes(year, sum)) + 
  geom_histogram(stat="identity") + 
  theme_ipsum()

# Word embeddings for matrix
embeddings_url <- "https://api.openai.com/v1/embeddings"
auth <- add_headers(Authorization = paste("Bearer", Sys.getenv("OPEN_AI_KEY")))
body <- list(model = "text-embedding-ada-002", input = fair_use_findings$key_facts)

resp <- POST(
  embeddings_url,
  auth,
  body = body,
  encode = "json"
)

embeddings <- content(resp, as = "text", encoding = "UTF-8") %>%
  jsonlite::fromJSON(flatten = TRUE) %>%
  pluck("data", "embedding")

fair_use_findings <- fair_use_findings %>% 
  mutate(embeddings = embeddings)

fair_use_embeddings_mat <- matrix(
  unlist(fair_use_findings$embeddings),
  ncol = 1536, byrow = TRUE
)

embeddings_similarity <- fair_use_embeddings_mat / sqrt(rowSums(fair_use_embeddings_mat * fair_use_embeddings_mat))
embeddings_similarity <- embeddings_similarity %*% t(embeddings_similarity)

set.seed(234)
use_pca <- irlba::prcomp_irlba(fair_use_embeddings_mat, n = 32)


augmented_pca <- 
  as_tibble(use_pca$x) %>%
  bind_cols(fair_use_findings)

augmented_pca %>%
  ggplot(aes(PC1, PC2, color = outcome)) +
  geom_point(size = 1.3, alpha = 0.8) +
  scale_color_viridis_d() +
  theme(legend.position = "none")

## Join with cases

joined_fair <- fair_use_findings %>% fuzzy_inner_join(fair_use_cases, by = c("title" = "case"), match_fun = str_detect)
