\name{solarpos-methods}
\docType{methods}
\alias{solarpos-methods}
\alias{solarpos}
\alias{solarpos,ANY-method}
\alias{solarpos,SpatialPoints,POSIXct-method}
\alias{solarpos,matrix,POSIXct-method}
\title{Solar position methods}
\description{
 The solarpos methods return values of azimuth and elevation for solar position for spatial position and date/time values.
}
\section{Methods}{
\describe{

\item{"ANY"}{default void method}

\item{"SpatialPoints", dateTime=POSIXct}{Method for SpatialPoints and POSIXct objects}

\item{"matrix", dateTime=POSIXct}{Method for matrix - converted internally into SpatialPoints - and POSIXct objects}

}}


\author{Sebastian P. Luque, translated from Greg Pelletier's VBA code,
  who in turn translated it from original Javascript code by NOAA.}

\seealso{\code{\link{crepuscule-methods}}, \code{\link{solarnoon-methods}}, \code{\link{sunriset-methods}}}

\examples{
## Location of Helsinki, Finland, in decimal degrees,
## as listed in NOAA's website
hels <- matrix(c(24.97, 60.17), nrow=1)
Hels <- SpatialPoints(hels, proj4string=CRS("+proj=longlat +datum=WGS84"))
d041224 <- as.POSIXct("2004-12-24", tz="EET")
solarpos(hels, as.POSIXct(Sys.time(), tz="EET"))
solarpos(Hels, as.POSIXct(Sys.time(), tz="EET"))
}
\keyword{methods}
\keyword{spatial}
