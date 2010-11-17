\name{unionSpatialPolygons}
\alias{unionSpatialPolygons}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Aggregate Polygons in a SpatialPolygons object}
\description{
  The function aggregates Polygons in a SpatialPolygons object, according to the IDs vector specifying which input Polygons belong to which output Polygons; internal boundaries are dissolved using the gpclib package union() function. If the rgeos package is available, \code{unionSpatialPolygonsGEOS} will be used with partial topology preservation instead of the R implementation here by passing arguments through.
}
\usage{
unionSpatialPolygons(SpP, IDs, threshold=NULL, avoidGEOS=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SpP}{A SpatialPolygons object as defined in package sp}
  \item{IDs}{A vector defining the output Polygons objects, equal in length to the length of the polygons slot of SpRs; it may be character, integer, or factor (try table(factor(IDs)) for a sanity check)}
  \item{threshold}{if not NULL, an area measure below which slivers will be discarded (some polygons have non-identical boundaries, for instance along rivers, generating slivers on union which are artefacts, not real sub-polygons)}
  \item{avoidGEOS}{default FALSE; if TRUE force use of gpclib even when GEOS is available}
}

\value{
  Returns an aggregated SpatialPolygons object named with the aggregated IDs values in their sorting order; see the ID values of the output object to view the order.
}

\section{Warning}{When using GEOS Unary Union, it has been found that some polygons are not dissolved correctly when the absolute values of the coordinates are very small. No work-around is available at present.}

\author{Roger Bivand}
%\seealso{\code{\link[rgeos]{unionSpatialPolygonsGEOS}}}
\examples{
gpclibPermit()
require(gpclib)
nc1 <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1],
 proj4string=CRS("+proj=longlat +datum=NAD27"))
lps <- coordinates(nc1)
ID <- cut(lps[,1], quantile(lps[,1]), include.lowest=TRUE)
reg4 <- unionSpatialPolygons(nc1, ID)
sapply(slot(reg4, "polygons"), function(i) slot(i, "ID"))
}
\keyword{spatial}
