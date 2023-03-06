


library(tidyverse)

ltas <- unique(data$MAP_UNIT_S)


# try to outputs
purrr::map(
  .x = ltas,  # vector of param values
  .f = ~rmarkdown::render(
    input = "demo_report.Rmd",  # RMarkdown filepath
    params = list(MAP_UNIT_S = .x),  # iterated parameter value
    output_file = stringr::str_glue("output/", .x, "-report.html")  # iterated output path
  )
)
