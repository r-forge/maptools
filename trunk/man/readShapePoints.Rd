\name{readShapePoints}
\alias{readShapePoints}
\alias{writePointsShape}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Read points shape files into SpatialPointsDataFrame objects}
\description{
  The \code{readShapePoints} reads data from a points shapefile into a \code{SpatialPointsDataFrame} object. The \code{writePointsShape} function writes data from a \code{SpatialPointsDataFrame} object to a shapefile.
}
\usage{
readShapePoints(fn, proj4string = CRS(as.character(NA)), verbose = FALSE)
writePointsShape(x, fn, factor2char = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fn}{shapefile layer name, without extension}
  \item{proj4string}{Object of class \code{CRS}; holding a valid proj4 string}
  \item{verbose}{default TRUE - report type of shapefile and number of shapes}
  \item{x}{a \code{SpatialLinesDataFrame} object}
  \item{factor2char}{logical, default TRUE, convert factor columns to character}
}

\value{
  a SpatialPointsDataFrame object
}

\author{ Roger Bivand }

\examples{
library(maptools)
xx <- readShapePoints(system.file("shapes/baltim.shp", package="maptools")[1])
plot(xx)
summary(xx)
xxx <- xx[xx$PRICE < 40,]
tmpfl <- paste(tempdir(), "xxpts", sep="/")
writePointsShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
axx <- readShapePoints(tmpfl)
plot(axx, col="red", add=TRUE)
unlink(paste(tmpfl, ".*", sep=""))
}
\keyword{spatial}

