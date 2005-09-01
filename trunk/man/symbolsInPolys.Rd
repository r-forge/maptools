\name{symbolsInPolys}
\alias{symbolsInPolys}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Place grids of points over polygons}
\description{
  Place grids of points over polygons with chosen density and/or symbols (suggested by Michael Wolf) - the function uses functions from the splancs package internally.
}
\usage{
symbolsInPolys(pl, dens, symb = "+")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{pl}{list of polygons of class \code{polylist}}
  \item{dens}{number of symbol plotting points per unit area; either a single numerical value for all polygons, or a numeric vector the same length as pl with values for each polygon}
  \item{symb}{plotting symbol; either a single value for all polygons, or a vector the same length as pl with values for each polygon}
}
\details{
  The dots are placed in a grid pattern with the number of points per polygon being polygon area times density (number of dots not guaranteed to be the same as the count). When the polygon is made up of more than one part, the dots will be placed in proportion to the relative areas of the clockwise rings (anticlockwise are taken as holes). No correction is made for holes in the placing of the dots. 
}

\value{
The function returns a list of matrices of point coordinates, one matrix for each member of pl; each matrix has a \code{symb} attribute that can be used for setting the \code{pch} argument for plotting. If the count of points for the given density and polygon area is zero, the list element is NULL, and can be tested when plotting - see the examples.
}

\note{Extension to plot pixmaps at the plotting points using addlogo() from the pixmap package is left as an exercise for the user.}

\author{Roger Bivand \email{Roger.Bivand@nhh.no}}

\seealso{\code{\link[splancs]{areapl}}, \code{\link[splancs]{gridpts}}}

\examples{
x <- read.shape(system.file("shapes/sids.shp", package="maptools")[1])
ncpolys <- Map2poly(x)
np <- sapply(ncpolys, function(x) attr(x, "nPart"))
symbs <- c("-", "+", "*")
try1 <- symbolsInPolys(ncpolys, 70, symb=symbs[np])
plot(ncpolys)
xx <- lapply(try1, function(x) {if (!is.null(x)) points(x, pch=attr(x, "symb"))})
}
\keyword{spatial}

