\name{readAsciiGrid}
\alias{readAsciiGrid}
\alias{writeAsciiGrid}
\title{ read/write to/from (ESRI) asciigrid format }
\description{ read/write to/from ESRI asciigrid format }
\usage{ 
readAsciiGrid(fname, as.image = FALSE, plot.image = FALSE, 
 colname = basename(fname), proj4string = CRS(as.character(NA)))
writeAsciiGrid(x, fname, attr = 1, na.value = -9999, ...)
}

\arguments{
\item{fname}{ file name }
\item{as.image}{logical; if TRUE, a list is returned, ready to be
shown with the \code{image} command; if FALSE an object of
class \link[sp]{SpatialGridDataFrame-class} is returned }
\item{plot.image}{logical; if TRUE, an image of the map is plotted}
\item{colname}{alternative name for data column if not file basename}
\item{proj4string}{A CRS object setting the projection arguments of the Spatial Grid returned}
\item{x}{ object of class \link[sp]{SpatialGridDataFrame}}
\item{attr}{attribute column; if missing, the first
column is taken; a name or a column number may be given}
\item{na.value}{numeric; value given to missing valued cells in the
resulting map}
\item{...}{ arguments passed to \link{write.table}, which is used
to write the numeric data }
}
\value{
	\code{readAsciiGrid} returns the grid map read; either as
	an object of class \link[sp]{SpatialGridDataFrame-class} or, if
	as.image is TRUE, as list with components \code{x}, \code{y} and {z}.
}
\seealso{ \link[sp]{as.image.SpatialGridDataFrame}, \link[graphics]{image} }
\author{Edzer J.\ Pebesma, e.pebesma@geo.uu.nl}
\examples{
x <- readAsciiGrid(system.file("grids/test.ag", package="maptools")[1])
summary(x)
image(x)
xp <- as(x, "SpatialPixelsDataFrame")
abline(h=332000, lwd=3)
xpS <- xp[coordinates(xp)[,2] < 332000,]
summary(xpS)
xS <- as(xpS, "SpatialGridDataFrame")
summary(xS)
tmpfl <- paste(tempdir(), "testS.ag", sep="/")
writeAsciiGrid(xS, tmpfl)
axS <- readAsciiGrid(tmpfl)
opar <- par(mfrow=c(1,2))
image(xS, main="before export")
image(axS, main="after import")
par(opar)
unlink(tmpfl)
}
\keyword{programming}
