\name{crepuscule-methods}
\docType{methods}
\alias{crepuscule-methods}
\alias{crepuscule}
\alias{crepuscule,ANY-method}
\alias{crepuscule,SpatialPoints,POSIXct-method}
\alias{crepuscule,matrix,POSIXct-method}
\title{Crepuscule methods}
\description{
 Two crepuscule methods are available for dates given as POSIXct objects and spatial position given either as SpatialPoints in geographical coordinates, or as a matrix of points taken as geographical coordinates. Crepuscule methods give the onset or termination of periods of twilight before sunrise or after sunset.
}
\section{Methods}{
\describe{

\item{"ANY"}{default void method}

\item{"SpatialPoints", dateTime=POSIXct}{Method for SpatialPoints and POSIXct objects}

\item{"matrix", dateTime=POSIXct}{Method for matrix - converted internally into SpatialPoints - and POSIXct objects}

}}

\section{details}{Usage:\\
\code{crepuscule(crds, dateTime, solarDep, direction=c("dawn", "dusk"), POSIXct.out=FALSE)}


Arguments:\\
\itemize{
  \item{\code{crds}}{spatial positions}
  \item{\code{dateTime}}{POSIXct time object}
  \item{\code{solarDep}}{degrees below horizon}
  \item{\code{direction}}{either "dawn" or "dusk"}
  \item\code{{POSIXct.out}}{return a fraction of day vector or a data frame with fraction of day values, and their POSIXct representation}
}
}


\author{Sebastian P. Luque, translated from Greg Pelletier's VBA code,
  who in turn translated it from original Javascript code by NOAA.}

\seealso{\code{\link{sunriset-methods}}, \code{\link{solarnoon-methods}}, \code{\link{solarpos-methods}}}

\examples{
## Location of Helsinki, Finland, in decimal degrees,
## as listed in NOAA's website
hels <- matrix(c(24.97, 60.17), nrow=1)
Hels <- SpatialPoints(hels, proj4string=CRS("+proj=longlat +datum=WGS84"))
d041224 <- as.POSIXct("2004-12-24", tz="EET")
## Astronomical dawn
crepuscule(hels, d041224, solarDep=18, direction="dawn", POSIXct.out=TRUE)
crepuscule(Hels, d041224, solarDep=18, direction="dawn", POSIXct.out=TRUE)
## Nautical dawn
crepuscule(hels, d041224, solarDep=12, direction="dawn", POSIXct.out=TRUE)
crepuscule(Hels, d041224, solarDep=12, direction="dawn", POSIXct.out=TRUE)
## Civil dawn
crepuscule(hels, d041224, solarDep=6, direction="dawn", POSIXct.out=TRUE)
crepuscule(Hels, d041224, solarDep=6, direction="dawn", POSIXct.out=TRUE)

## Using a grid of spatial points for the same point in time
grd <- GridTopology(c(-179,-89), c(1,1), c(359,179))
SP <- SpatialPoints(coordinates(grd),
                    proj4string=CRS("+proj=longlat +datum=WGS84"))
wint <- as.POSIXct("2004-12-21", tz="GMT")
win <- crepuscule(SP, wint, solarDep=6, direction="dawn")
SPDF <- SpatialGridDataFrame(grd,
 proj4string=CRS("+proj=longlat +datum=WGS84"),
 data=data.frame(winter=win))
image(SPDF, axes=TRUE, col=cm.colors(40))
}
\keyword{methods}
\keyword{spatial}
