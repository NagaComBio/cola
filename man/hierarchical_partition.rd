\name{hierarchical_partition}
\alias{hierarchical_partition}
\title{
Hierarchical detection of subgroups
}
\description{
Hierarchical detection of subgroups
}
\usage{
hierarchical_partition(data, top_method = "MAD", partition_method = "kmeans",
    PAC_cutoff = 0.2, min_samples = 6, k = 2:4, ...)
}
\arguments{

  \item{data}{a numeric matrix where subgroups are found by samples.}
  \item{top_method}{a single top method. Available methods are in \code{\link{all_top_value_methods}}.}
  \item{partition_method}{a single partition method. Available ialble methods are in \code{\link{all_partition_methods}}.}
  \item{PAC_cutoff}{the cutoff of PAC scores to determine whether to continuou looking to subgroups.}
  \item{min_samples}{the cutoff of number of samples to determine whether to continuou looking to subgroups.}
  \item{k}{a list number of partitions.}
  \item{...}{pass to \code{\link{consensus_partition}}}

}
\details{
The function looks for subgroups in a hierarchical way.
}
\value{
A \code{\link{HierarchicalPartition-class}} object
}
\author{
Zuguang Gu <z.gu@dkfz.de>
}
\examples{
# There is no example
NULL

}
