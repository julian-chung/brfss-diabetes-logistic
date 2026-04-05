# plot_theme.R
# Custom ggplot2 theme and color palettes for consistent figure styling.
# Source this alongside setup.R, or add source(here::here("R", "plot_theme.R"))
# to your setup chunk.
#
# Usage:
#   ggplot(...) + theme_epi()
#   ggplot(...) + scale_color_epi()
#   ggplot(...) + scale_fill_epi()
#   save_fig("fig01_km-curve")

library(ggplot2)

# =============================================================================
# COLOR PALETTE — Okabe-Ito (colorblind-safe, print-friendly)
# =============================================================================
# Reference: Okabe & Ito (2008), https://jfly.uni-koeln.de/color/

palette_epi <- c(
  orange    = "#E69F00",
  sky_blue  = "#56B4E9",
  green     = "#009E73",
  yellow    = "#F0E442",
  blue      = "#0072B2",
  vermillion = "#D55E00",
  pink      = "#CC79A7",
  black     = "#000000"
)

# Two-group default: blue (control) vs vermillion (treatment)
palette_2group <- unname(palette_epi[c("blue", "vermillion")])

# Three-group default
palette_3group <- unname(palette_epi[c("blue", "vermillion", "green")])

# =============================================================================
# THEME
# =============================================================================

theme_epi <- function(base_size = 12, base_family = "",
                      grid = c("both", "x", "y", "none"),
                      legend_position = "bottom") {

  grid <- match.arg(grid)

  t <- theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      # --- Titles and labels --------------------------------------------------
      plot.title      = element_text(size = base_size + 2, face = "bold",
                                     margin = margin(b = 6)),
      plot.subtitle   = element_text(size = base_size, color = "grey40",
                                     margin = margin(b = 8)),
      plot.caption    = element_text(size = base_size - 2, color = "grey50",
                                     hjust = 0, margin = margin(t = 8)),
      axis.title      = element_text(size = base_size, face = "plain"),
      axis.title.x    = element_text(margin = margin(t = 8)),
      axis.title.y    = element_text(margin = margin(r = 8)),
      axis.text       = element_text(size = base_size - 1, color = "grey30"),

      # --- Legend -------------------------------------------------------------
      legend.position  = legend_position,
      legend.title     = element_text(size = base_size - 1, face = "bold"),
      legend.text      = element_text(size = base_size - 1),
      legend.key.size  = unit(0.9, "lines"),
      legend.margin    = margin(t = 4),

      # --- Panel --------------------------------------------------------------
      panel.border     = element_blank(),
      panel.spacing    = unit(1, "lines"),

      # --- Facet labels -------------------------------------------------------
      strip.text       = element_text(size = base_size - 1, face = "bold",
                                      margin = margin(b = 4)),
      strip.background = element_blank(),

      # --- Plot margins -------------------------------------------------------
      plot.margin = margin(t = 10, r = 10, b = 10, l = 10)
    )

  # Grid lines
  if (grid == "none") {
    t <- t + theme(panel.grid = element_blank())
  } else if (grid == "x") {
    t <- t + theme(panel.grid.major.y = element_blank(),
                   panel.grid.minor   = element_blank())
  } else if (grid == "y") {
    t <- t + theme(panel.grid.major.x = element_blank(),
                   panel.grid.minor   = element_blank())
  } else {
    t <- t + theme(panel.grid.minor = element_blank())
  }

  t
}

# Set as session default so every ggplot picks it up automatically
theme_set(theme_epi())

# =============================================================================
# SCALES
# =============================================================================

#' Discrete color scale using the Okabe-Ito palette
scale_color_epi <- function(...) {
  scale_color_manual(values = unname(palette_epi), ...)
}

#' Discrete fill scale using the Okabe-Ito palette
scale_fill_epi <- function(...) {
  scale_fill_manual(values = unname(palette_epi), ...)
}

#' Two-group color scale (blue = control, vermillion = treatment)
scale_color_2group <- function(labels = c("Control", "Treatment"), ...) {
  scale_color_manual(values = palette_2group, labels = labels, ...)
}

#' Two-group fill scale
scale_fill_2group <- function(labels = c("Control", "Treatment"), ...) {
  scale_fill_manual(values = palette_2group, labels = labels, ...)
}

# =============================================================================
# FIGURE SAVING
# =============================================================================

#' Save a ggplot to output/figures/ in both PNG and PDF
#'
#' @param name   Filename without extension, e.g. "fig01_km-curve"
#' @param plot   ggplot object; defaults to last plot
#' @param width  Width in inches (default 8)
#' @param height Height in inches (default 6)
#' @param dpi    Resolution for PNG (default 300)
#'
#' @examples
#' ggplot(df, aes(x, y)) + geom_point()
#' save_fig("fig01_scatter")
save_fig <- function(name, plot = ggplot2::last_plot(),
                     width = 8, height = 6, dpi = 300) {

  dir <- here::here("output", "figures")

  ggplot2::ggsave(
    filename = file.path(dir, paste0(name, ".png")),
    plot = plot, width = width, height = height, dpi = dpi
  )

  ggplot2::ggsave(
    filename = file.path(dir, paste0(name, ".pdf")),
    plot = plot, width = width, height = height
  )

  invisible(plot)
}
