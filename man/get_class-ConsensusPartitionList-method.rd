\name{get_class-ConsensusPartitionList-method}
\alias{get_class,ConsensusPartitionList-method}
\title{
Get class from the ConsensusPartitionList object
}
\description{
Get class from the ConsensusPartitionList object
}
\usage{
\S4method{get_class}{ConsensusPartitionList}(object, k)
}
\arguments{

  \item{object}{a \code{\link{ConsensusPartitionList-class}} object}
  \item{k}{number of partitions}

}
\details{
The class IDs are inferred by merging partitions from all methods
by weighting the mean silhouette scores in each method.
}
\value{
A data frame with class IDs, membership, entropy and silhouette scores.
}
\author{
Zuguang Gu <z.gu@dkfz.de>
}
\examples{
# There is no example
NULL

}
