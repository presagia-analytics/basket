% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.r
\name{plot_pep_graph}
\alias{plot_pep_graph}
\title{Plot a Network Graph of the PEP Matrix}
\usage{
plot_pep_graph(
  x,
  color_by = c("post_prob", "mean_est", "median_est"),
  layout = c("fr", "nicely", "kk", "drl"),
  pep_cutoff = 0
)
}
\arguments{
\item{x}{the exchangeability model.}

\item{color_by}{which variable to color by. One of "post_prob",
"mean_est", "median_est".}

\item{layout}{the layout algorithm to use for the graph. One of}

\item{pep_cutoff}{a value between 0 and 1 indicating the cutoff for
PEP above which edges of the graph will be drawn.}
}
\description{
Plot a Network Graph of the PEP Matrix
}
\examples{
\donttest{
# Create an MEM analysis of the Vemurafenib trial data.
data(vemu_wide)

mem_analysis <- mem_exact(
  vemu_wide$responders,
  vemu_wide$evaluable,
  vemu_wide$baskets
)

plot_pep_graph(mem_analysis)
}
}
