library(tidyverse)
library(fs)
library(rvest)

urls <- paste0(
  "https://www.snopes.com/fact-check/category/horrors/?pagenum=",
  1:15
)

extract_rating <- function(article_page) {
  rating <- article_page |> 
    rvest::html_element(".rating_title_wrap") |> 
    rvest::html_text2() |> 
    stringr::str_remove("About this rating")
  if (is.na(rating)) {
    rating <- article_page |> 
      rvest::html_element(".status_color") |> 
      rvest::html_text2()
  }
  if (is.na(rating)) {
    rating <- article_page |> 
      rvest::html_elements("noindex") |> 
      rvest::html_text2() |> 
      stringr::str_squish() |> 
      stringr::str_subset("^Status:") |> 
      stringr::str_remove("Status:")
  }
  rating <- tolower(rating) |> 
    stringr::str_squish() |> 
    stringr::str_remove("\\.|\\:")
  rating <- dplyr::case_match(
    rating,
    c(
      "a number of real entries, one unknown, and one fiction",
      "multiple",
      "multiple — see below",
      "two real entries, the others are fiction"
    ) ~ "mixture",
    .default = rating
  )
  return(rating)
}

extract_claim <- function(article_page) {
  claim <- article_page |> 
    rvest::html_element(".claim_cont") |> 
    rvest::html_text2() |> 
    stringr::str_squish()
  if (is.na(claim)) {
    claim <- rvest::html_elements(article_page, "p") |> 
      rvest::html_text2() |> 
      stringr::str_subset("^Claim:") |> 
      stringr::str_remove("Claim:") |> 
      stringr::str_squish()
  }
  return(claim)
}

extract_article_text <- function(article_page) {
  text <- article_page |>
    rvest::html_elements("#article-content p") |>
    rvest::html_text2() |>
    purrr::discard(~ stringr::str_detect(., "About this rating")) |>
    purrr::reduce(paste, sep = " ")
  return(text)
}




horror_articles <- urls |>
  purrr::map(
    \(article_list_url) {
      article_list_url |> 
        rvest::read_html() |> 
        rvest::html_elements(".article_wrapper") |> 
        purrr::map(
          \(article) {
            # Grabbbing info from this page can result in truncation. Instead grab the
            # URL and dig into that.
            url <- article |>
              rvest::html_element("a") |>
              rvest::html_attr("href")
            article_page <- rvest::read_html(url)
            tibble::tibble(
              title = article_page |>
                rvest::html_element("h1") |> 
                rvest::html_text2(),
              url = url,
              # Failed for some articles <= 2015-05-16
              rating = extract_rating(article_page),
              subtitle = article_page |>
                rvest::html_element("h2") |> 
                rvest::html_text2(),
              author = article_page |> 
                rvest::html_element(".author_name") |> 
                rvest::html_text() |> 
                stringr::str_squish(),
              published = article |> 
                rvest::html_element(".article_date") |> 
                rvest::html_text2() |> 
                lubridate::mdy(),
              # Failed for some articles <= 2015-05-16
              claim = extract_claim(article_page),
              article_text = extract_article_text(article_page)
            )
          }
        ) |> 
        purrr::list_rbind()
    }
  ) |> 
  purrr::list_rbind()
horror_articles %>% 
  mutate(article_text = str_remove_all(article_text, "Claim:.*?(\\.(\\s|$)|$)")) %>%
  mutate(article_text = str_remove_all(article_text, "Status:.*?(\\.(\\s|$)|$)")) %>% 
readr::write_csv(
  fs::path("horror_articles.csv")
)
