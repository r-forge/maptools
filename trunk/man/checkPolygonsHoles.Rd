\name{checkPolygonsHoles}
\alias{checkPolygonsHoles}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Check holes in Polygons objects}
\description{
  The function checks holes in Polygons objects, using an intersection between a gpclib package gpc.poly object with one or more polygon contours and its bounding box to set the hole flag. The function will set single polygon contours to hole=FALSE, and if multiple polygon contours are holes, will set them TRUE.
}
\usage{
checkPolygonsHoles(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{An Polygons object as defined in package sp}
}

\value{
  An Polygons object re-created from the input object.
}

\author{Roger Bivand}

\examples{
library(sp)
library(gpclib)
nc1 <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +ellps=clrk66"))
pl <- slot(nc1, "polygons")
sapply(slot(pl[[4]], "Polygons"), function(x) slot(x, "hole"))
pl[[4]] <- Polygons(list(slot(pl[[4]], "Polygons")[[1]],
 Polygon(slot(slot(pl[[4]], "Polygons")[[2]], "coords"), hole=TRUE),
 slot(pl[[4]], "Polygons")[[3]]), slot(pl[[4]], "ID"))
sapply(slot(pl[[4]], "Polygons"), function(x) slot(x, "hole"))
pl_new <- lapply(pl, checkPolygonsHoles)
sapply(slot(pl_new[[4]], "Polygons"), function(x) slot(x, "hole"))
srs <- slot(slot(pl[[1]], "Polygons")[[1]], "coords")
hle2 <- structure(c(-81.64093, -81.38380, -81.34165, -81.66833, -81.64093, 
 36.57865, 36.57234, 36.47603, 36.47894, 36.57865), .Dim = as.integer(c(5, 2)))
hle3 <- structure(c(-81.47759, -81.39118, -81.38486, -81.46705, -81.47759, 
 36.56289, 36.55659, 36.49907, 36.50380, 36.56289), .Dim = as.integer(c(5, 2)))
x <- Polygons(list(Polygon(srs), Polygon(hle2), Polygon(hle3)),
 ID=slot(pl[[1]], "ID"))
sapply(slot(x, "Polygons"), function(x) slot(x, "hole"))
res <- checkPolygonsHoles(x)
sapply(slot(res, "Polygons"), function(x) slot(x, "hole"))
\dontrun{
opar <- par(mfrow=c(1,2))
SPx <- SpatialPolygons(list(x))
plot(SPx)
text(coordinates(SPx),
 labels=sapply(slot(x, "Polygons"), function(i) slot(i, "hole")), cex=0.6)
title(xlab="Hole slot values before checking")
SPres <- SpatialPolygons(list(res))
plot(SPres)
text(coordinates(SPres),
 labels=sapply(slot(res, "Polygons"), function(i) slot(i, "hole")), cex=0.6)
title(xlab="Hole slot values after checking")
par(opar)
}
}
\keyword{spatial}

