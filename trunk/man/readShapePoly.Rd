\name{readShapePoly}
\alias{readShapePoly}
\alias{writePolyShape}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read polygon shape files into SpatialPolygonsDataFrame objects}
\description{
   The \code{readShapePoly} reads data from a polygon shapefile into a \code{SpatialPolygonsDataFrame} object. The \code{writePolyShape} function writes data from a \code{SpatialPolygonsDataFrame} object to a shapefile.
}
\usage{
readShapePoly(fn, proj4string=CRS(as.character(NA)), verbose=FALSE)
writePolyShape(x, fn, factor2char = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fn}{shapefile layer name, without extension}
  \item{proj4string}{Object of class \code{CRS}; holding a valid proj4 string}
  \item{verbose}{default TRUE - report type of shapefile and number of shapes}
  \item{x}{a \code{SpatialPolygonsDataFrame} object}
  \item{factor2char}{logical, default TRUE, convert factor columns to character}
}
\details{The shpID values of the shapefile will be used as \code{Polygons} ID values; when writing shapefiles, the object data slot rownames are added to the DBF file as column SP\_ID.}
\value{
   a SpatialPolygonsDataFrame object
}

\author{ Roger Bivand }

\examples{
library(maptools)
xx <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], proj4string=CRS("+proj=longlat +datum=NAD27"))
plot(xx, border="blue", axes=TRUE, las=1)
text(getSpPPolygonsLabptSlots(xx), labels=getSpPPolygonsIDSlots(xx), cex=0.6)
as(xx, "data.frame")[1:5, 1:6]
xxx <- xx[xx$SID74 < 2,]
plot(xxx, border="red", add=TRUE)
tmpfl <- paste(tempdir(), "xxline", sep="/")
writePolyShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
axx <- readShapePoly(tmpfl, proj4string=CRS("+proj=utm +zone=33 +datum=WGS84"))
plot(xxx, border="black", lwd=4)
plot(axx, border="yellow", lwd=1, add=TRUE)
unlink(paste(tmpfl, ".*", sep=""))
}
\keyword{spatial}
