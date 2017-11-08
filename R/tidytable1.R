#------------------------------------------------------
#' Creates Table1 Descriptive Statistics with tidyverse
#'
#' \code{tidytable1} produces a tidy data frame that contains the common information included in Table 1 of academic papers for an input data frame. Inspired by [tableone](https://cran.r-project.org/web/packages/tableone/), tidytable1 uses the tidyverse functions for easy customization.
#'
#' @param input_df A data_frame for which table1 (the descriptive stats) is produced.
#' @param info_cols A list that will be used for informational columns in table1, for example, the label (description) and data source of variables. The names of the list will be used as column names in table1, while the names of value vector will be matched to column names in input_df.
#' @param calc_cols A list of table1 columns to be calculated from functions.
#' @param num_cols A list of table1 columns to be calculated from functions for numeric variables.
#' @param custom_vars A vector of input_df columns for which custom_cols will be added.
#' @param custom_cols A list of table1 columns to be calculated from functions for custom variables (custom_vars).
#' @param col_order A vector according to which table1 columns will be ordered.
#' @param row_order A list according to which table1 rows (variables in input_df) will be ordered.
#' @param digits Number of digits for stats in table1 (Default 2).
#' @param add_cat_header_row Whether to add a header row for categorical variable (Default TRUE).
#' @return A data frame containing the descriptive stats, by default containing mean and sd for numeric variables, Category, frequency, and `%` for categorical variables, and #missing for all variables.
#' @import dplyr
#' @import tibble
#' @importFrom purrr map map_lgl map2_dbl
#' @import tidyr
#' @importFrom stats sd
#' @export
#'
tidytable1 <- function(input_df,
                        info_cols=list(),
                        calc_cols=list("#missing"=function(x) sum(is.na(x))),
                        num_cols=list(mean=mean, sd=sd),
                        #cat_cols=list(),
                        custom_vars=c(),
                        custom_cols=list(),
                        col_order=c(),
                        row_order=list(),
                        digits=2,
                        add_cat_header_row=TRUE) {

  trpx_df <- input_df %>%
    as.list() %>%
    enframe() %>%
    rename(Name=name) %>%
    mutate(._numeric=map_lgl(value, is.numeric))

  if (!is.null(info_cols) & length(info_cols)>0) {
    info_df <- info_cols %>%
      unlist %>%
      enframe %>%
      separate(name, c("col", "Name")) %>%
      spread(col, value)

    trpx_df <- trpx_df %>%
      left_join(info_df, by = "Name")
  }

  if (!is.null(calc_cols) & length(calc_cols)>0) {
    calc_cols_df <- trpx_df %>%
      crossing(calc_cols %>% enframe(name="colname", value="func")) %>%
      mutate(colval=map2_dbl(value, func, ~`.y(.x)`(.x, .y))) %>%
      select(Name, colname, colval) %>%
      spread(colname, colval)
  }

  part_numeric <- NULL
  if (sum(trpx_df$._numeric) > 0)
    part_numeric <- trpx_df %>%
      filter(._numeric) %>%
      crossing(num_cols %>% enframe(name="colname", value="func")) %>%
      mutate(colval=map2_dbl(value, func, ~`.y(.x)`(.x, .y, na.rm=T))) %>%
      select(-c(value, func)) %>%
      #mutate(mean=map_dbl(value, mean, na.rm=T),
      #       sd = map_dbl(value, sd, na.rm=T)
      #       )
      spread(colname, colval)

  part_categorical <- NULL
  if (sum(!trpx_df$._numeric) > 0) {
    part_categorical_label <- trpx_df %>%
      filter(!._numeric) %>%
      select(-value, -._numeric)

    part_categorical <- trpx_df %>%
      filter(!._numeric) %>%
      select(-starts_with("._")) %>%
      mutate(freq_df=map(value, ~table(.x, dnn="Category") %>% as.data.frame),
             Category=map(freq_df, "Category"),
             Category=map(Category, as.character),
             freq=map(freq_df, "Freq"),
             `%` = map(freq, ~100 * .x /sum(.x))
             ) %>%
      #mutate(Category=map(value, ~(table(.) %>% dimnames(.))[[1]]),
      #       freq=map(value, ~table(.) %>% as.integer),
      #       `%` = map(freq, ~100 * .x /sum(.x))) %>%
      select(-c(value, freq_df)) %>%
      unnest()

    if (add_cat_header_row)
      part_categorical <- bind_rows(part_categorical_label, part_categorical) %>%
        arrange(Name)
  }

  combined_df <- NULL
  if (!is.null(part_numeric) && nrow(part_numeric) > 0)
    combined_df <- part_numeric
  if (!is.null(part_categorical) && nrow(part_categorical) > 0 )
    combined_df <- bind_rows(combined_df, part_categorical)

  if (!is.null(calc_cols))
    combined_df <- combined_df %>% left_join(calc_cols_df, by="Name")

  if (!is.null(custom_vars) & length(custom_vars)>0) {
    stopifnot(length(custom_cols)>0)

    custom_cols_df <- trpx_df %>%
      filter(Name %in% custom_vars) %>%
      crossing(custom_cols %>% enframe(name="colname", value="func")) %>%
      mutate(colval=map2_dbl(value, func, ~`.y(.x)`(.x, .y))) %>%
      select(Name, colname, colval) %>%
      spread(colname, colval)

    combined_df <- combined_df %>% left_join(custom_cols_df, by="Name")
  }

  if (is.null(col_order))
    col_order <- c("Name",
                   names(info_cols),
                   names(num_cols),
                   c("Category", "freq", "%"),
                   names(calc_cols), names(custom_cols))

  col_order <- col_order[col_order %in% names(combined_df)]
  combined_df <- combined_df %>%
    select(one_of(col_order))

  if (is.null(row_order) | length(row_order)==0) {
    row_order <- trpx_df %>% select(Name)
  } else
    row_order <- as_data_frame(row_order)

  row_order <- row_order %>%
    mutate(._n=1:n())

  combined_df <- combined_df %>%
    left_join(row_order, by="Name") %>%
    arrange(._n) %>%
    select(-._n)

  combined_df %>%
    mutate_if(is.numeric, round, digits=digits)
}



#------------------------------------------------------
#' helper function call `.y(.x)` for functional programming, replacing `purrr::at_depth(.x, 0, .y, ...)` which is deprecated.
#'
#' @param .x The first argument for function/formula passed as `.y`.
#' @param .y The function/formula to be called with argument `.x`.
#' @param ... Additional arguments to `.y()`.
#' @return Whatever is returned from `.y(.x, ...)`.
#'

`.y(.x)` <- function(.x, .y, ...) {
  #at_depth(.x, 0, .y, ...)
  map(list(.x), .y, ...)[[1]]
}
