\name{elide-methods}
\docType{methods}
\alias{elide-methods}
\alias{elide,SpatialPoints-method}
\alias{elide,SpatialPointsDataFrame-method}
\alias{elide,SpatialLines-method}
\alias{elide,SpatialLinesDataFrame-method}
\alias{elide,SpatialPolygons-method}
\alias{elide,SpatialPolygonsDataFrame-method}
\alias{elide}
\title{Methods for Function elide in Package `maptools'}
\description{
 Methods for function \code{elide} to translate and disguise coordinate placing in the real world. 
}
\section{Methods}{
\describe{

\item{obj = "SpatialPoints"}{elides object}

\item{obj = "SpatialPointsDataFrame"}{elides object}

\item{obj = "SpatialLines"}{elides object}

\item{obj = "SpatialLinesDataFrame"}{elides object}

\item{obj = "SpatialPolygons"}{elides object}

\item{obj = "SpatialPolygonsDataFrame"}{elides object}
}}

\usage{
elide(obj, ...)
% (obj, bb=NULL, shift=c(0, 0), reflect=c(FALSE, FALSE), scale=NULL, flip=FALSE)
}

\arguments{
  \item{obj}{object to be elided}
  \item{...}{other arguments:
  \describe{
    \item{bb}{if NULL, uses bounding box of object, otherwise the given bounding box}
    \item{shift}{values to shift the coordinates of the input object; this is made ineffective by the scale argument}
    \item{reflect}{reverse coordinate axes}
    \item{scale}{if NULL, coordinates not scaled; if TRUE, the longer dimension is scaled to lie within [0,1] and aspect maintained; if a scalar, the output range of [0,1] is multiplied by scale}
    \item{flip}{translate coordinates on the main diagonal}
}}
}

\value{
The methods return objects of the input class object with elided coordinates; the coordinate reference system is not set. Note that if the input coordinates or centroids are in the data slot data.frame of the input object, they should be removed before the use of these methods, otherwise they will betray the input positions.
}

\examples{
data(meuse)
coordinates(meuse) <- c("x", "y")
proj4string(meuse) <- CRS("+init=epsg:28992")
data(meuse.riv)
river_polygon <- Polygons(list(Polygon(meuse.riv)), ID="meuse")
rivers <- SpatialPolygons(list(river_polygon))
proj4string(rivers) <- CRS("+init=epsg:28992")
rivers1 <- elide(rivers, reflect=c(TRUE, TRUE), scale=TRUE)
meuse1 <- elide(meuse, bb=bbox(rivers), reflect=c(TRUE, TRUE), scale=TRUE)
opar <- par(mfrow=c(1,2))
plot(rivers, axes=TRUE)
plot(meuse, add=TRUE)
plot(rivers1, axes=TRUE)
plot(meuse1, add=TRUE)
par(opar)
}

\keyword{methods}
\keyword{spatial}
