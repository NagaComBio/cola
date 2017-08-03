\name{test_to_known_factors-HierarchicalPartition-method}
\alias{test_to_known_factors,HierarchicalPartition-method}
\title{
Test correspondance between predicted and known classes
}
\description{
Test correspondance between predicted and known classes
}
\usage{
\S4method{test_to_known_factors}{HierarchicalPartition}(object, known = object@list[[1]]@known_anno)
}
\arguments{

  \item{object}{a \code{\link{HierarchicalPartition-class}} object}
  \item{known}{a vector or a data frame with known factors}

}
\value{
A matrix of p-values.
}
\author{
Zuguang Gu <z.gu@dkfz.de>
}
\examples{
# There is no example
NULL

}