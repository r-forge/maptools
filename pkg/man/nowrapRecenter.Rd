\name{nowrapRecenter}
\alias{nowrapRecenter}
\alias{nowrapSpatialPolygons}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Break polygons at meridian for recentering}
\description{
  When recentering a world map, say to change an "Atlantic" view with longitude range -180 to 180, to a "Pacific" view, with longitude range 0 to 360, polygons crossed by the new offset, here 0/360, need to be clipped into left and right sub.polygons to avoid horizontal scratches across the map. The \code{nowrapSpatialPolygons} function performs this operation using polygon intersection, and \code{nowrapRecenter} recenters the output SpatialPolygons object. 
}
\usage{
nowrapRecenter(obj, offset = 0, eps = rep(.Machine$double.eps^(1/2), 2),
 avoidGEOS = FALSE)
nowrapSpatialPolygons(obj, offset = 0, eps=rep(.Machine$double.eps^(1/2), 2),
 avoidGEOS = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{obj}{ A SpatialPolygons object }
  \item{offset}{ offset from the Greenwich meridian }
  \item{eps}{vector of two (left and right) fuzz factors to retract the ring from the offset (square root to accommodate \pkg{rgeos} precision rules)}
  \item{avoidGEOS}{use \pkg{gpclib} code even if \pkg{rgeos} is available}
}

\value{
  A SpatialPolygons object
}

\author{Roger Bivand}


\seealso{\code{\link[sp]{recenter-methods}}, \code{\link[sp]{nowrapSpatialLines}}}

\examples{
\dontrun{
library(maps)
world <- map("world", fill=TRUE, col="transparent", plot=FALSE)
worldSpP <- map2SpatialPolygons(world, world$names, CRS("+proj=longlat"))
worldSpP <- worldSpP[-grep("Antarctica", row.names(worldSpP)),]
# incomplete polygons
worldSpP <- worldSpP[-grep("Ghana", row.names(worldSpP)),]
# self-intersection mouth of Volta
worldSpP <- worldSpP[-grep("UK:Great Britain", row.names(worldSpP)),]
# self-intersection Humber estuary
worldSpPr <- recenter(worldSpP)
plot(worldSpPr)
title("Pacific view without polygon splitting")
worldSpPnr <- nowrapRecenter(worldSpP)
plot(worldSpPnr)
title("Pacific view with polygon splitting")
}
if (rgeosStatus()) {
crds <- matrix(c(-1, 1, 1, -1, 50, 50, 52, 52), ncol=2)
rcrds <- rbind(crds, crds[1,])
SR <- SpatialPolygons(list(Polygons(list(Polygon(rcrds)), ID="r1")),
 proj4string=CRS("+proj=longlat"))
bbox(SR)
SRr <- recenter(SR)
bbox(SRr)
SRnr <- nowrapRecenter(SR)
bbox(SRnr)
}
}

\keyword{spatial}

