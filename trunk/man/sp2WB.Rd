\name{sp2WB}
\alias{sp2WB}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Export SpatialPolygons object as S-Plus map for WinBUGS}
\description{
  The function exports an sp SpatialPolygons object into a S-Plus map
format to be import by WinBUGS.
}
\usage{
sp2WB(map, filename, Xscale = 1, Yscale = Xscale, plotorder = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{map}{a SpatialPolygons object}
  \item{filename}{file where output is written}
  \item{Xscale, Yscale}{scales to be written in the output file}
  \item{plotorder}{default=FALSE, if TRUE, export polygons in plotting order}
}

\references{\url{http://www.mrc-bsu.cam.ac.uk/bugs/winbugs/geobugs12manual.pdf}}
\author{Virgilio Gómez Rubio, partly derived from earlier code by Thomas Jagger}


\examples{
\dontrun{
xx <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
plot(xx, border="blue", axes=TRUE, las=1)
sp2WB(as(xx, "SpatialPolygons"), filename="NC.map")
x <- readAsciiGrid(system.file("grids/test.ag", package="maptools")[1])
xp <- as(x, "SpatialPixelsDataFrame")
pp <- as.SpatialPolygons.SpatialPixels(xp)
sp2WB(pp, filename="test.map")
}
}
\keyword{spatial}
