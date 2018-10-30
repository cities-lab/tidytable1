Creates a Table1 for Descriptive Statistics with tidyverse utils

Installation
============

    devtools::install_github("cities-lab/tidytable1")

Usage
=====

    library(tidytable1)
    library(dplyr)
    library(pander)

    iris_tbl1 <- tidytable1(iris,
                            calc_cols=list(n=function(x) length(x)),
                            num_cols=c(min=min, median=median, max=max)) %>%
      pp_table1(pp_vars=c("n")) 

    iris_tbl1 %>%
      pander(missing="")

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 8%" />
<col style="width: 12%" />
<col style="width: 8%" />
<col style="width: 18%" />
<col style="width: 9%" />
<col style="width: 11%" />
<col style="width: 11%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: center;">Name</th>
<th style="text-align: center;">min</th>
<th style="text-align: center;">median</th>
<th style="text-align: center;">max</th>
<th style="text-align: center;">Category</th>
<th style="text-align: center;">freq</th>
<th style="text-align: center;">%</th>
<th style="text-align: center;">n</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;">Sepal.Length</td>
<td style="text-align: center;">4.3</td>
<td style="text-align: center;">5.8</td>
<td style="text-align: center;">7.9</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">150</td>
</tr>
<tr class="even">
<td style="text-align: center;">Sepal.Width</td>
<td style="text-align: center;">2</td>
<td style="text-align: center;">3</td>
<td style="text-align: center;">4.4</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">150</td>
</tr>
<tr class="odd">
<td style="text-align: center;">Petal.Length</td>
<td style="text-align: center;">1</td>
<td style="text-align: center;">4.35</td>
<td style="text-align: center;">6.9</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">150</td>
</tr>
<tr class="even">
<td style="text-align: center;">Petal.Width</td>
<td style="text-align: center;">0.1</td>
<td style="text-align: center;">1.3</td>
<td style="text-align: center;">2.5</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">150</td>
</tr>
<tr class="odd">
<td style="text-align: center;">Species</td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">150</td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">setosa</td>
<td style="text-align: center;">50</td>
<td style="text-align: center;">33.33</td>
<td style="text-align: center;"></td>
</tr>
<tr class="odd">
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">versicolor</td>
<td style="text-align: center;">50</td>
<td style="text-align: center;">33.33</td>
<td style="text-align: center;"></td>
</tr>
<tr class="even">
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;"></td>
<td style="text-align: center;">virginica</td>
<td style="text-align: center;">50</td>
<td style="text-align: center;">33.33</td>
<td style="text-align: center;"></td>
</tr>
</tbody>
</table>

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

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Name
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Label
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Source
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
mean
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
sd
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Category
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
freq
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
%
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
\#missing
</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="9" style="font-weight: 900;">
Numeric Variables
</td>
</tr>
<tr>
<td style="text-align: left;">
mpg
</td>
<td style="text-align: left;">
Miles/(US) gallon
</td>
<td style="text-align: left;">
1974 Motor Trend
</td>
<td style="text-align: right;">
20.09
</td>
<td style="text-align: right;">
6.03
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
disp
</td>
<td style="text-align: left;">
Displacement (cu.in.)
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
230.72
</td>
<td style="text-align: right;">
123.94
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
hp
</td>
<td style="text-align: left;">
Gross horsepower
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
146.69
</td>
<td style="text-align: right;">
68.56
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
drat
</td>
<td style="text-align: left;">
Rear axle ratio
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
3.6
</td>
<td style="text-align: right;">
0.53
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
wt
</td>
<td style="text-align: left;">
Weight (1000 lbs)
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
3.22
</td>
<td style="text-align: right;">
0.98
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
qsec
</td>
<td style="text-align: left;">
1/4 mile time
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
17.85
</td>
<td style="text-align: right;">
1.79
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
gear
</td>
<td style="text-align: left;">
Number of forward gears
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
3.69
</td>
<td style="text-align: right;">
0.74
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
carb
</td>
<td style="text-align: left;">
Number of carburetors
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
2.81
</td>
<td style="text-align: right;">
1.62
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td colspan="9" style="font-weight: 900;">
Categorical Variables
</td>
</tr>
<tr>
<td style="text-align: left;">
cyl
</td>
<td style="text-align: left;">
Number of cylinders
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: center;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
0
</td>
</tr>
<tr>
<td style="text-align: left;">
</td>
<td style="text-align: left;">
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: center;">
4
</td>
<td style="text-align: right;">
11
</td>
<td style="text-align: right;">
34.38
</td>
<td style="text-align: right;">
</td>
</tr>
<tr>
<td style="text-align: left;">
</td>
<td style="text-align: left;">
</td>
<td style="text-align: left;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: right;">
</td>
<td style="text-align: center;">
6
</td>
<td style="text-align: right;">
7
</td>
<td style="text-align: right;">
21.88
</td>
<td style="text-align: right;">
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: center;">
8
</td>
<td style="background-color: NA; text-align: right;">
14
</td>
<td style="background-color: NA; text-align: right;">
43.75
</td>
<td style="background-color: NA; text-align: right;">
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; text-align: left;">
vs
</td>
<td style="background-color: NA; text-align: left;">
V/S
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: center;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
0
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: center;">
0
</td>
<td style="background-color: NA; text-align: right;">
18
</td>
<td style="background-color: NA; text-align: right;">
56.25
</td>
<td style="background-color: NA; text-align: right;">
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: center;">
1
</td>
<td style="background-color: NA; text-align: right;">
14
</td>
<td style="background-color: NA; text-align: right;">
43.75
</td>
<td style="background-color: NA; text-align: right;">
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; text-align: left;">
am
</td>
<td style="background-color: NA; text-align: left;">
Transmission
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: center;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
0
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: left;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: right;">
</td>
<td style="background-color: NA; text-align: center;">
automatic
</td>
<td style="background-color: NA; text-align: right;">
19
</td>
<td style="background-color: NA; text-align: right;">
59.38
</td>
<td style="background-color: NA; text-align: right;">
</td>
</tr>
<tr style="background-color: NA;">
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: left;">
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: left;">
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: left;">
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: right;">
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: right;">
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: center;">
manual
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: right;">
13
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: right;">
40.62
</td>
<td style="background-color: NA; border-bottom: 2px solid grey; text-align: right;">
</td>
</tr>
</tbody>
</table>
TODO
====

-   Enable stats by a grouping variable similar the behavior in
    `tableone`
-   Add hypothesis testing functionality

Related Projects
================

-   [Gmisc](https://github.com/gforge/Gmisc)
-   [tableone](https://github.com/kaz-yos/tableone)
-   [stargazer](https://cran.r-project.org/web/packages/stargazer/)

Build Status
============

[![Build
Status](https://travis-ci.org/cities-lab/tidytable1.svg?branch=master)](travis-ci.org/cities-lab/tidytable1)
