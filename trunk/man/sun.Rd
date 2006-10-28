\name{sunriset}

\alias{crepuscule}
\alias{sunriset}
\alias{solarnoon}
\alias{solarpos}

\alias{Crepuscule_t}
\alias{Sunriset_t}
\alias{Solarnoon_t}
\alias{Solarpos_t}

% -------------------------------------------------------------------------
\title{Calculation of sun transit times}



\description{Functions for calculating sunrise, sunset, and times of
  dawn and dusk, with flexibility for the various formal definitions.
  They use algorithms provided by the National Oceanic & Atmospheric
  Administration (NOAA).}


\usage{
Crepuscule_t(crds, time, solarDep, direction=c("dawn", "dusk"),
                           POSIXct_output=FALSE)
Sunriset_t(crds, time, direction=c("sunrise", "sunset"),
                         POSIXct_output=FALSE)
Solarnoon_t(crds, time, POSIXct_output=FALSE)
Solarpos_t(crds, time)
crepuscule(lon, lat, year, month, day, timezone, dlstime,
           solarDep, direction=c("dawn", "dusk"))
sunriset(lon, lat, year, month, day, timezone,
         dlstime, direction=c("sunrise", "sunset"))
solarnoon(lon, lat, year, month, day, timezone, dlstime)
solarpos(lon, lat, year, month, day, hours, minutes, seconds,
         timezone, dlstime)
}


\arguments{

  \item{crds}{an object of class \code{SpatialPoints} in geographical coordinates (\code{is.projected(crds)} must be \code{FALSE})}
  \item{time}{an object of class \code{POSIXct} with time zone set}
  \item{solarDep}{Numeric vector with the angle of the sun below the
    horizon in degrees.}
  \item{direction}{Character string to indicate whether to return
    dawn/dusk or sunrise/sunset times.}
  \item{POSIXct_output}{default FALSE, if TRUE, return a data frame of day fraction values and their POSIXct representations}

  \item{lon, lat}{Numeric vectors providing longitude and latitude,
    respectively.  Use standard convention of positive E longitudes, and
    negative S latitudes.}

  \item{year}{Numeric vector with four-digit year.}

  \item{month}{Numeric vector with the month number: 1-12.}

  \item{day}{Numeric vector with the day number: 1-31.}

  \item{hours, minutes, seconds}{Numeric vectors with the integer hours
    (0-23), minutes (0-59), and seconds (0-59).}

  \item{timezone}{Integer vector, time zone relative to UTC (hours).}

  \item{dlstime}{Integer vector; either 1 or 0, to indicate whether
    daylight savings time is in effect or not.}


}


\details{\code{Crepuscule_t}, \code{Sunriset_t}, \code{Solarnoon_t} and \code{Solarpos_t}, are wrappers for the underlying \code{crepuscule}, \code{sunriset}, \code{solarnoon} and \code{solarpos} functions. They allow for the use of standard objects to representing positions in space and time.

NOAA used the reference below to develop their Sunrise/Sunset
\url{http://www.srrb.noaa.gov/highlights/sunrise/sunrise.html} and Solar
Position \url{http://www.srrb.noaa.gov/highlights/sunrise/azel.html}
Calculators.  The algorithms include corrections for atmospheric
refraction effects.}


\section{Warning}{Compared to NOAA's original Javascript code, the
sunrise and sunset estimates from this translation may differ by +/- 1
minute, based on tests using selected locations spanning the globe.

This translation does not include calculation of prior or next
sunrises/sunsets for locations above the Arctic Circle or below the
Antarctic Circle.}


\value{A numeric vector representing time in day units.

  \code{solarpos} returns an n by 2 matrix with the solar azimuth (in
  degrees from North), and solar elevation.}


\note{NOAA notes that \dQuote{for latitudes greater than 72 degrees N
and S, calculations are accurate to within 10 minutes.  For latitudes
less than +/- 72 degrees, accuracy is approximately one minute.}}


\references{
  Meeus, J.  (1991)  Astronomical Algorithms.  Willmann-Bell, Inc.
}


\author{Sebastian P. Luque, translated from Greg Pelletier's VBA code,
  who in turn translated it from original Javascript code by NOAA.}

% -------------------------------------------------------------------------
\examples{
## Location of Helsinki, Finland, in decimal degrees,
## as listed in NOAA's website
hels <- c(lon=24.97, lat=60.17)
Hels <- SpatialPoints(matrix(hels, nrow=1), proj4string=CRS("+proj=longlat +datum=WGS84"))
d041224 <- as.POSIXct("2004-12-24", tz="EET")

## Astronomical dawn
crepuscule(lon=hels[1], lat=hels[2], year=2004, mon=12, day=24,
           timez=2, dls=0, solarDep=18, dir="dawn")
Crepuscule_t(Hels, d041224, solarDep=18, direction="dawn", POSIXct_output=TRUE)
## Nautical dawn
crepuscule(lon=hels[1], lat=hels[2], year=2004, mon=12, day=24,
           timez=2, dls=0, solarDep=12, dir="dawn")
Crepuscule_t(Hels, d041224, solarDep=12, direction="dawn", POSIXct_output=TRUE)
## Civil dawn
crepuscule(lon=hels[1], lat=hels[2], year=2004, mon=12, day=24,
           timez=2, dls=0, solarDep=6, dir="dawn")
Crepuscule_t(Hels, d041224, solarDep=6, direction="dawn", POSIXct_output=TRUE)

## Sunrise
sunriset(lon=hels[1], lat=hels[2], year=2004, mon=12, day=24,
         timez=2, dls=0, dir="sunrise")
Sunriset_t(Hels, d041224, direction="sunrise", POSIXct_output=TRUE)
## Sunset
sunriset(lon=hels[1], lat=hels[2], year=2004, mon=12, day=24,
         timez=2, dls=0, dir="sunset")
Sunriset_t(Hels, d041224, direction="sunset", POSIXct_output=TRUE)

## Using a grid of spatial points for the same point in time
grd <- GridTopology(c(-179,-89), c(1,1), c(359,179))
SP <- SpatialPoints(coordinates(grd),
                    proj4string=CRS("+proj=longlat +datum=WGS84"))
wint <- as.POSIXct("2004-12-21", tz="GMT")
win <- Crepuscule_t(SP, wint, solarDep=6, "dawn")
SPDF <- SpatialGridDataFrame(grd,
 proj4string=CRS("+proj=longlat +datum=WGS84"),
 data=data.frame(winter=win))
image(SPDF, axes=TRUE, col=cm.colors(40))

## Using a sequence of dates
Hels_seq <- seq(from=d041224, length.out=365, by="days")
up <- Sunriset_t(Hels, Hels_seq, direction="sunrise", POSIXct_output=TRUE)
down <- Sunriset_t(Hels, Hels_seq, direction="sunset", POSIXct_output=TRUE)
day_length <- down$time - up$time
plot(Hels_seq, day_length, type="l")

## Using a matrix of locations and dates
helsarea <- cbind(hels[1] + runif(20), hels[2] + runif(20),
                  1986:2005, rep(1:2, 10), 6:25)

## Civil dusk
crepuscule(lon=helsarea[, 1], lat=helsarea[, 2],
           year=helsarea[, 3], mon=helsarea[, 4], day=helsarea[, 5],
           timez=2, dls=0, sol=6, dir="dusk")
## Nautical dawn
crepuscule(lon=helsarea[, 1], lat=helsarea[, 2],
           year=helsarea[, 3], mon=helsarea[, 4], day=helsarea[, 5],
           timez=2, dls=0, sol=12, dir="dusk")

## Solar noon
solarnoon(lon=helsarea[, 1], lat=helsarea[, 2],
          year=helsarea[, 3], mon=helsarea[, 4], day=helsarea[, 5],
          timez=2, dls=0)

## Solar position
solarpos(lon=helsarea[, 1], lat=helsarea[, 2],
         year=helsarea[, 3], mon=helsarea[, 4], day=helsarea[, 5],
         hours=9, min=0, sec=30, timez=2, dls=0)

}



\keyword{manip}
\keyword{math}
\keyword{utilities}
