# utils.R
# Shared helper functions used across analyses.
# Sourced automatically via setup.R.

# =============================================================================
# OPERATORS
# =============================================================================

#' Not-in operator
#' @examples c(1, 2, 3) %nin% c(2, 3)  # TRUE FALSE FALSE
`%nin%` <- function(x, table) !x %in% table


# =============================================================================
# FORMATTING
# =============================================================================

#' Format a p-value for display
#'
#' @param p     Numeric p-value
#' @param digits Decimal places when p >= threshold
#' @param threshold Values below this are shown as "< threshold"
#' @return Character string
#'
#' @examples
#' fmt_pval(0.043)    # "0.043"
#' fmt_pval(0.00003)  # "< 0.001"
#' fmt_pval(1)        # "> 0.999"
fmt_pval <- function(p, digits = 3, threshold = 0.001) {
  dplyr::case_when(
    is.na(p)           ~ NA_character_,
    p < threshold      ~ paste0("< ", threshold),
    p > (1 - threshold) ~ paste0("> ", round(1 - threshold, digits)),
    TRUE               ~ as.character(round(p, digits))
  )
}


#' Format n (%) as a single string
#'
#' @param n   Count
#' @param N   Total (denominator)
#' @param digits Decimal places for percentage
#' @return Character string, e.g. "42 (31.3%)"
#'
#' @examples
#' n_pct(42, 134)   # "42 (31.3%)"
n_pct <- function(n, N, digits = 1) {
  pct <- round(n / N * 100, digits)
  paste0(n, " (", pct, "%)")
}


#' Format a confidence interval as a string
#'
#' @param lo  Lower bound
#' @param hi  Upper bound
#' @param digits Decimal places
#' @param sep Separator string
#' @return Character string, e.g. "(1.23, 4.56)"
#'
#' @examples
#' fmt_ci(1.23, 4.56)          # "(1.23, 4.56)"
#' fmt_ci(1.23, 4.56, sep = " to ")  # "(1.23 to 4.56)"
fmt_ci <- function(lo, hi, digits = 2, sep = ", ") {
  paste0("(", round(lo, digits), sep, round(hi, digits), ")")
}


#' Format estimate with CI: "1.23 (0.98, 1.54)"
#'
#' @param est Point estimate
#' @param lo  Lower bound
#' @param hi  Upper bound
#' @param digits Decimal places
#' @return Character string
#'
#' @examples
#' fmt_est_ci(1.23, 0.98, 1.54)   # "1.23 (0.98, 1.54)"
fmt_est_ci <- function(est, lo, hi, digits = 2) {
  paste0(round(est, digits), " ", fmt_ci(lo, hi, digits))
}


# =============================================================================
# DATA CHECKING
# =============================================================================

#' Tabulate missingness by column
#'
#' @param df A data frame
#' @return A tibble with n_miss and pct_miss per variable, sorted descending
#'
#' @examples
#' miss_summary(df)
miss_summary <- function(df) {
  df |>
    dplyr::summarise(dplyr::across(dplyr::everything(),
                                   \(x) sum(is.na(x)))) |>
    tidyr::pivot_longer(dplyr::everything(),
                        names_to  = "variable",
                        values_to = "n_miss") |>
    dplyr::mutate(
      pct_miss = round(n_miss / nrow(df) * 100, 1)
    ) |>
    dplyr::arrange(dplyr::desc(n_miss)) |>
    dplyr::filter(n_miss > 0)
}


#' Check for duplicate rows on a key
#'
#' @param df  A data frame
#' @param ... Columns that form the key (unquoted)
#' @return Prints a message; invisibly returns duplicate rows if any
#'
#' @examples
#' check_dupes(df, subject_id, visit)
check_dupes <- function(df, ...) {
  dupes <- df |> dplyr::filter(dplyr::n() > 1, .by = c(...))
  n <- nrow(dupes)
  if (n == 0) {
    message("No duplicates found.")
  } else {
    message(n, " duplicate row(s) on the specified key.")
    print(dupes)
  }
  invisible(dupes)
}


#' Quick value count with percentage — wrapper around tabyl
#'
#' @param df  A data frame
#' @param var Column name (unquoted)
#' @param sort Sort by frequency descending?
#' @return A tibble with n, percent, and valid_percent
#'
#' @examples
#' freq(df, site)
freq <- function(df, var, sort = TRUE) {
  df |>
    janitor::tabyl({{ var }}) |>
    janitor::adorn_pct_formatting(digits = 1) |>
    { if (sort) dplyr::arrange(., dplyr::desc(n)) else . }()
}


# =============================================================================
# DATA WRANGLING
# =============================================================================

#' Read the most recently modified file matching a glob pattern
#'
#' Useful when REDCap or a data warehouse drops timestamped exports.
#'
#' @param pattern Glob pattern, e.g. "data/raw/export_*.csv"
#' @param read_fn Function to read the file (default: readr::read_csv)
#' @param ...     Additional arguments passed to read_fn
#' @return The result of read_fn on the newest matching file
#'
#' @examples
#' df <- read_latest("data/raw/redcap_export_*.csv")
#' df <- read_latest("data/raw/*.parquet", read_fn = arrow::read_parquet)
read_latest <- function(pattern, read_fn = readr::read_csv, ...) {
  files <- fs::dir_ls(
    path = here::here(dirname(pattern)),
    glob = basename(pattern)
  )
  if (length(files) == 0) stop("No files matched: ", pattern)
  newest <- files[which.max(fs::file_info(files)$modification_time)]
  message("Reading: ", newest)
  read_fn(newest, ...)
}


#' Winsorize a numeric vector at given quantile bounds
#'
#' @param x     Numeric vector
#' @param lower Lower quantile (default 0.01)
#' @param upper Upper quantile (default 0.99)
#' @return Winsorized numeric vector
#'
#' @examples
#' df <- df |> mutate(bmi = winsorize(bmi))
winsorize <- function(x, lower = 0.01, upper = 0.99) {
  lo <- quantile(x, lower, na.rm = TRUE)
  hi <- quantile(x, upper, na.rm = TRUE)
  dplyr::case_when(
    x < lo ~ lo,
    x > hi ~ hi,
    TRUE   ~ x
  )
}
