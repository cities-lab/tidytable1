## ---- echo=TRUE, eval=FALSE----------------------------------------------
#  devtools::install_github("cities-lab/tidytable1")

## ---- echo=TRUE, eval=TRUE-----------------------------------------------
suppressMessages(library(tidytable1))
suppressMessages(library(dplyr))
suppressMessages(library(pander))

iris_tbl1 <- tidytable1(iris,
                        calc_cols=list(n=function(x) length(x)),
                        num_cols=c(min=min, median=median, max=max)) %>%
  pp_table1(pp_vars=c("n")) 

iris_tbl1 %>%
  pander(missing="")

## ---- echo=TRUE, eval=TRUE, results="asis"-------------------------------
library(htmlTable)

# tidytable1 differentiate numeric and non-numeric variables
mtcars_df <- mtcars %>%
  mutate(cyl=factor(cyl), vs=factor(vs), am=factor(am, labels = c("automatic", "manual"))) %>%
  as_tibble()

num_vars <- mtcars_df %>% select_if(is.numeric) %>% names
cat_vars <- mtcars_df %>% select_if(~!is.numeric(.)) %>% names            
row_order <- list(Name=c(num_vars, cat_vars))

## organized variables by numeric + categorical
mtcars_tbl1 <- tidytable1(mtcars_df,
                       info_cols=list(Label=c(mpg="Miles/(US) gallon", cyl="Number of cylinders", 
                                              disp="Displacement (cu.in.)", hp="Gross horsepower",
                                              drat="Rear axle ratio", wt="Weight (1000 lbs)",
                                              qsec="1/4 mile time", vs="V/S", 
                                              am="Transmission", gear="Number of forward gears",
                                              carb="Number of carburetors"),
                                      Source=c(mpg="1974 Motor Trend")),
                       num_cols=c(mean=mean, sd=sd),
                       row_order = row_order) %>%
  pp_table1(pp_vars=c("Label", "Source", "#missing"))

mtcars_tbl1 %>% 
  htmlTable(rnames = FALSE,
            align="lll rrc rrr",
            rgroup = c("Numeric Variables", "Categorical Variables"),
            n.rgroup = c(length(num_vars), length(cat_vars)))

