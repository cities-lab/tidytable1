require(dplyr)
library(tidytable1)
library(pander)

mtcars %>%
   tidytable1()

iris_species <- iris %>%
  as_tibble() %>%
  select(Species)

tidytable1(iris_species)

iris %>%
  tidytable1()

mtcars_df <- mtcars %>%
  mutate(cyl=factor(cyl), vs=factor(vs), am=factor(am)) %>%
  as_tibble()

## organized by numeric + categorical
mtcars_tbl1 <- tidytable1(mtcars_df,
                       info_cols=list(Label=c(mpg="Mileage per Gallon", cyl="Cylinders"),
                                      Source=c(vs="EPA", am="EPA")),
                       num_cols=c(mean=mean, sd=sd),
                       row_order = list(Name=c(mtcars_df %>% select_if(is.numeric) %>% names,
                                               mtcars_df %>% select_if(is.factor) %>% names))
) %>%
  pp_table1(pp_vars=c("Label", "Source", "#missing")) %>%
  pander(missing="")

iris_tbl1 <- tidytable1(iris,
                         calc_cols=list(n=function(x) length(x)),
                         num_cols=c(min=min, median=median, max=max)
                         ) %>%
  pp_table1(pp_vars=c("n")) %>%
  pander(missing="")
