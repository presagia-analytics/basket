% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accessors.r
\name{cluster_baskets}
\alias{cluster_baskets}
\title{Get the Cluster Members of MEM Models}
\usage{
cluster_baskets(x)
}
\arguments{
\item{x}{either an exchangeability model or basket object.}
}
\value{
A named list is returned where the name is the cluster name and
each element of the list is comprise do a character vector of the
baskets in each cluster.
}
\description{
Object returned by the `mem_mcmc()` and `mem_exact()` include
information about the arms in the trials and the cluster
composed of sets of similar arms. This function returns the name
of each arm in a cluster.
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

# Get the baskets in the clusters.
cluster_baskets(mem_analysis)
}
}
