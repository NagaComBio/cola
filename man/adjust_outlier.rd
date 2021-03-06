\name{adjust_outlier}
\alias{adjust_outlier}
\title{
Adjust outliers
}
\description{
Adjust outliers
}
\usage{
adjust_outlier(x, q = 0.05)
}
\arguments{

  \item{x}{a numeric vector}
  \item{q}{percential to adjust}

}
\details{
Vaules larger than percential \code{1 - q} are adjusted to \code{1 - q} and 
values smaller than percential \code{q} are adjusted to \code{q}.
}
\value{
A numeric vector with same length as the original one.
}
\author{
Zuguang Gu <z.gu@dkfz.de>
}
\examples{
x = rnorm(10)
x[1] = 100
adjust_outlier(x)
}
