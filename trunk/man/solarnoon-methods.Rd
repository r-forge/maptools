\name{solarnoon-methods}
\docType{methods}
\alias{solarnoon-methods}
\alias{solarnoon}
\alias{solarnoon,ANY-method}
\alias{solarnoon,SpatialPoints,POSIXct-method}
\alias{solarnoon,matrix,POSIXct-method}
\title{Solarnoon methods}
\description{
 The methods return the solar noon value as a day fraction and clock time.
}
\section{Methods}{
\describe{

\item{"ANY"}{default void method}

\item{"SpatialPoints", dateTime=POSIXct}{Method for SpatialPoints and POSIXct objects}

\item{"matrix", dateTime=POSIXct}{Method for matrix - converted internally into SpatialPoints - and POSIXct objects}

}}


\section{details}{Usage:\\
\code{sunriset(crds, dateTime, POSIXct.out=FALSE)}


Arguments:\\
\itemize{
  \item{\code{crds}}{spatial positions}
  \item{\code{dateTime}}{POSIXct time object}
  \item\code{{POSIXct.out}}{return a fraction of day vector or a data frame with fraction of day values, and their POSIXct representation}
}
}


\author{Sebastian P. Luque, translated from Greg Pelletier's VBA code,
  who in turn translated it from original Javascript code by NOAA.}

\seealso{\code{\link{crepuscule-methods}}, \code{\link{sunriset-methods}}, \code{\link{solarpos-methods}}}

\examples{
## Location of Helsinki, Finland, in decimal degrees,
## as listed in NOAA's website
hels <- matrix(c(24.97, 60.17), nrow=1)
Hels <- SpatialPoints(hels, proj4string=CRS("+proj=longlat +datum=WGS84"))
d041224 <- as.POSIXct("2004-12-24", tz="EET")
solarnoon(hels, d041224, POSIXct.out=TRUE)
solarnoon(Hels, d041224, POSIXct.out=TRUE)
}

\keyword{methods}
\keyword{spatial}
