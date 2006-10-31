\name{sunriset-methods}
\docType{methods}
\alias{sunriset-methods}
\alias{sunriset}
\alias{sunriset,ANY-method}
\alias{sunriset,SpatialPoints,POSIXct-method}
\alias{sunriset,matrix,POSIXct-method}
\title{Sunriset methods}
\description{
  Two sunriset methods are available for dates given as POSIXct objects and spatial position given either as SpatialPoints in geographical coordinates, or as a matrix of points taken as geographical coordinates. 
}
\section{Methods}{
\describe{

\item{"ANY"}{default void method}

\item{"SpatialPoints", dateTime=POSIXct}{Method for SpatialPoints and POSIXct objects}

\item{"matrix", dateTime=POSIXct}{Method for matrix - converted internally into SpatialPoints - and POSIXct objects}

}}

\section{details}{Usage:\\
\code{sunriset(crds, dateTime, direction=c("sunrise", "sunset"), POSIXct.out=FALSE)}


Arguments:\\
\itemize{
  \item{\code{crds}}{spatial positions}
  \item{\code{dateTime}}{POSIXct time object}
  \item{\code{direction}}{either "sunrise" or "sunset"}
  \item\code{{POSIXct.out}}{return a fraction of day vector or a data frame with fraction of day values, and their POSIXct representation}
}
}


\author{Sebastian P. Luque, translated from Greg Pelletier's VBA code,
  who in turn translated it from original Javascript code by NOAA.}

\seealso{\code{\link{crepuscule-methods}}, \code{\link{solarnoon-methods}}, \code{\link{solarpos-methods}}}

\examples{
## Location of Helsinki, Finland, in decimal degrees,
## as listed in NOAA's website
hels <- matrix(c(24.97, 60.17), nrow=1)
Hels <- SpatialPoints(hels, proj4string=CRS("+proj=longlat +datum=WGS84"))
d041224 <- as.POSIXct("2004-12-24", tz="EET")
sunriset(hels, d041224, direction="sunrise", POSIXct.out=TRUE)
sunriset(Hels, d041224, direction="sunrise", POSIXct.out=TRUE)

## Using a sequence of dates
Hels_seq <- seq(from=d041224, length.out=365, by="days")
up <- sunriset(Hels, Hels_seq, direction="sunrise", POSIXct.out=TRUE)
down <- sunriset(Hels, Hels_seq, direction="sunset", POSIXct.out=TRUE)
day_length <- down$time - up$time
plot(Hels_seq, day_length, type="l")
}

\keyword{methods}
\keyword{spatial}
