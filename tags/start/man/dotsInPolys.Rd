\name{dotsInPolys}
\alias{dotsInPolys}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Put dots in polygons}
\description{
  Make a list of point coordinate matrices for a dot density map
}
\usage{
dotsInPolys(pl, x, f = csr)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pl}{list of polygons of class \code{polylist}}
  \item{x}{integer vector of counts of same length as pl for dots}
  \item{f}{function to place points in polygons, either \code{csr} - completely spatially random or \code{gridpts} gridded points from the splancs package}
}
\details{
 With f=csr (completely spatially random), the dots are placed in the polygon at random, f=gridpts - in a grid pattern (number of dots not guaranteed to be the same as the count). When the polygon is made up of more than one part, the dots will be placed in proportion to the relative areas of the clockwise rings (anticlockwise are taken as holes). No correction is made for holes in the placing of the dots. 
}
\value{
  The function returns a list of matrices of point coordinates, one matrix for each member of pl. If x[i] is zero, the list element is NULL, and can be tested when plotting - see the examples.
}

\note{Waller and Gotway (2004) Applied Spatial Statistics for Public Health Data (Wiley, Hoboken, NJ) explicitly warn that care is needed in plotting and interpreting dot density maps (pp. 81-83)}

\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link[splancs]{csr}}, \code{\link[splancs]{gridpts}}}
\examples{
x <- read.shape(system.file("shapes/sids.shp", package="maptools")[1])
ncpolys <- Map2poly(x)
try1 <- dotsInPolys(ncpolys, as.integer(x$att.data$SID74))
plot(ncpolys)
xx <- lapply(try1, function(x) {if (!is.null(x)) points(x, pch=18, col="red")})
try2 <- dotsInPolys(ncpolys, as.integer(x$att.data$SID74), f=gridpts)
plot(ncpolys)
xx <- lapply(try2, function(x) {if (!is.null(x)) points(x, pch=18, col="red")})
}
\keyword{spatial}

