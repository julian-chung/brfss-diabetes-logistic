# setup.R
# Common package loading for all analyses.
# Source this at the top of any QMD: source(here::here("R", "setup.R"))

# --- Path management ----------------------------------------------------------
library(here)           # here() for project-relative paths

# --- Shared helpers -----------------------------------------------------------
source(here::here("R", "utils.R"))        # fmt_pval(), n_pct(), miss_summary(), etc.

# --- Plot theme ---------------------------------------------------------------
source(here::here("R", "plot_theme.R"))   # theme_epi(), scale_color_epi(), save_fig()

# --- Core tidyverse -----------------------------------------------------------
library(tidyverse)      # dplyr, ggplot2, readr, tidyr, stringr, forcats, purrr

# --- Data import --------------------------------------------------------------
library(arrow)          # read_parquet()
library(haven)          # read_sas(), read_spss()
library(REDCapR)        # redcap_read() for REDCap API exports

# --- Data cleaning ------------------------------------------------------------
library(janitor)        # clean_names(), tabyl(), remove_empty()
library(fs)             # dir_ls(), file_info() — used by read_latest()

# --- EDA ----------------------------------------------------------------------
library(skimr)          # skim() for quick summary stats

# --- Tables -------------------------------------------------------------------
library(gtsummary)      # tbl_summary(), tbl_regression(), tbl_uvregression()
library(gt)             # gt() for custom table formatting

# --- Modeling -----------------------------------------------------------------
library(broom)          # tidy(), glance(), augment()

# --- Regression-specific (load in regression templates) ----------------------
# library(car)          # vif() for multicollinearity
# library(GGally)       # ggpairs() for correlation matrix
# library(performance)  # check_model() for diagnostics

# --- Survival-specific (load in survival templates) --------------------------
# library(survival)     # Surv(), survfit(), coxph()
# library(survminer)    # ggsurvplot(), ggforest()
