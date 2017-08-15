#------------------------------------------------------
#' \code{remove_dups}  replaces duplicate information with NA for each variable, to be called inside `dplyr::mutate`.
#'
#' @param x A column in a data frame.
#' @return A data frame column with duplicate information replaced by NA.
#' @importFrom dplyr lag
#'
remove_dups <- function(x)
  ifelse(!is.na(lag(x, 1)) & lag(x, 1)==x, NA, x)

#------------------------------------------------------
#' pretty prints tidy table1 data frame returned from \code{tidy_table1}
#'
#' \code{pp_table1} pretty print the tidy table1 data frame produced by \code{tidy_table1} by removing duplicate information.
#'
#' @param table1_df A data_frame returned from tidy_table1.
#' @param pp_vars A vector of table1 columns to be pretty print in addition to the 'Name' column.
#' @return A data frame with duplicate information removed and ready for print out (e.g. pass it to \code{pander::pander(ret, missing="")}).
#' @import dplyr
#' @export
#'
pp_table1 <- function(table1_df, pp_vars=c("#missing")) {
  if (!is.null(pp_vars))
    table1_df <- table1_df %>%
      group_by(Name) %>%
      mutate_at(pp_vars, funs(remove_dups)) %>%
      #mutate(`#missing`=ifelse(!is.na(lag(Name, 1)) & lag(Name, 1)==Name, NA, `#missing`)
      #       ) %>%
      ungroup()

  table1_df %>%
    mutate(Name=remove_dups(Name)) %>%
    as.data.frame() #%>%
  #pander::pander(missing="")
  #knitr::kable()
  #mutate_if(is.character, ~ifelse(is.na(.), "", .))
}
