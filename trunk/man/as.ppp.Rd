\name{as.ppp}
\alias{as.ppp}
\alias{as.ppp.Spatial}
\alias{as.owin.SpatialGridDataFrame}
\alias{as.owin.SpatialPixelsDataFrame}
\alias{as.owin.SpatialPolygons}
\alias{coerce,SpatialGridDataFrame,owin-method}
\alias{coerce,SpatialPixelsDataFrame,owin-method}
\alias{coerce,SpatialPolygons,owin-method}
\alias{as.ppp.SpatialGridDataFrame}
\alias{as.ppp.SpatialPoints}
\alias{as.ppp.SpatialPointsDataFrame}
\alias{coerce,SpatialPoints,ppp-method}
\alias{coerce,SpatialPointsDataFrame,ppp-method}

\title{coercion from sp objects to spatstat objects}
\description{
}
\section{Methods}{
  \describe{
\item{coerce}{\code{signature(from = "SpatialPoints", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialPointsDataFrame", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialPolygons", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialPixelsDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "owin")}}
}
}

\author{Edzer Pebesma \email{e.pebesma@geo.uu.nl}, Roger Bivand}
\examples{
library(spatstat)
data(meuse)
coordinates(meuse) = ~x+y
zn1 <- as(meuse["zinc"], "ppp")
zn1
plot(zn1)
as(as(meuse, "SpatialPoints"), "ppp")
data(meuse.grid)
gridded(meuse.grid) = ~x+y
mg_owin <- as(meuse.grid, "owin")
zn1a <- ppp(x=zn1$x, y=zn1$y, marks=zn1$marks, window=mg_owin)
zn1a
plot(zn1a)
# as.owin(meuse.grid)
# --- will only work if as.owin is method...
as(as(meuse.grid["ffreq"], "SpatialPixelsDataFrame"), "owin")
ho_sp <- SpatialPolygons(list(Polygons(list(Polygon(cbind(c(0,1,1,0,0),
  c(0,0,1,1,0))), Polygon(cbind(c(0.6,0.4,0.4,0.6,0.6), 
  c(0.2,0.2,0.4,0.4,0.2)), hole=TRUE)), ID="ho")))
plot(ho_sp, col="red", pbg="pink")
ho <- as(ho_sp, "owin")
plot(ho)
pp <- runifpoint(500, win=ho)
plot(pp)
ho_orig <- owin(poly=list(list(x=c(0,1,1,0), y=c(0,0,1,1)),
  list(x=c(0.6,0.4,0.4,0.6), y=c(0.2,0.2,0.4,0.4))))
identical(ho, ho_orig)
}
}
\keyword{spatial}
