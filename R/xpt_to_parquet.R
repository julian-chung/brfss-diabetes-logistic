# xpt_to_parquet.R
# One-time helper: converts LLCP2024.XPT → LLCP2024.parquet for DuckDB.
# Run this once before executing the SQL stage.
#
# Usage:
#   Rscript R/xpt_to_parquet.R
#   or source(here::here("R", "xpt_to_parquet.R"))

library(haven)
library(arrow)
library(here)

xpt_path     <- here("data", "raw", "LLCP2024.XPT")
parquet_path <- here("data", "raw", "LLCP2024.parquet")

message("Reading XPT: ", xpt_path)
df <- haven::read_xpt(xpt_path)

message("Writing parquet: ", parquet_path)
arrow::write_parquet(df, parquet_path)

message("Done: ", nrow(df), " rows, ", ncol(df), " columns written to ", parquet_path)
