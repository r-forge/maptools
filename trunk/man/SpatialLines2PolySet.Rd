\name{SpatialLines2PolySet}
\alias{SpatialLines2PolySet}
\alias{SpatialPolygons2PolySet}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Convert sp line and polygon objects to PBSmapping PolySet objects}
\description{
  Functions \code{SpatialLines2PolySet} and \code{SpatialPolygons2PolySet} convert objects of sp classes to \code{PolySet} class objects as defined in the PBSmapping package.
}
\usage{
SpatialLines2PolySet(SL)
SpatialPolygons2PolySet(SpP)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SL}{a SpatialLines object as defined in the sp package}
  \item{SpP}{a SpatialPolygons object as defined in the sp package}
}

\value{
  PolySet objects as defined in the PBSmapping package
}

\author{Roger Bivand}


\seealso{\code{\link[PBSmapping]{as.PolySet}}, \code{\link{MapGen2SL}}}

\examples{
library(PBSmapping)
library(maps)
nor_coast_lines <- map("world", interior=FALSE, plot=FALSE, xlim=c(4,32), ylim=c(58,72))
nor_coast_lines <- pruneMap(nor_coast_lines, xlim=c(4,32), ylim=c(58,72))
nor_coast_lines_sp <- map2SpatialLines(nor_coast_lines, proj4string=CRS("+proj=longlat +datum=wgs84"))
nor_coast_lines_PS <- SpatialLines2PolySet(nor_coast_lines_sp)
summary(nor_coast_lines_PS)
plotLines(nor_coast_lines_PS)
nor_coast_poly <- map("world", "norway", fill=TRUE, col="transparent", plot=FALSE, ylim=c(58,72))
IDs <- sapply(strsplit(nor_coast_poly$names, ":"), function(x) x[1])
nor_coast_poly_sp <- map2SpatialPolygons(nor_coast_poly, IDs=IDs, proj4string=CRS("+proj=longlat +datum=wgs84"))
nor_coast_poly_PS <- SpatialPolygons2PolySet(nor_coast_poly_sp)
summary(nor_coast_poly_PS)
plotPolys(nor_coast_poly_PS)
}
\keyword{spatial}

