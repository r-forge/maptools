\name{as.ppp}
\alias{as.owin.SpatialGridDataFrame}
\alias{as.owin.SpatialPixelsDataFrame}
\alias{as.owin.SpatialPolygons}
\alias{as.im.SpatialGridDataFrame}
\alias{coerce,SpatialGridDataFrame,owin-method}
\alias{coerce,SpatialPixelsDataFrame,owin-method}
\alias{coerce,SpatialPolygons,owin-method}
\alias{coerce,SpatialGridDataFrame,im-method}
\alias{as.ppp.SpatialGridDataFrame}
\alias{as.ppp.SpatialPoints}
\alias{as.ppp.SpatialPointsDataFrame}
\alias{coerce,SpatialPoints,ppp-method}
\alias{coerce,SpatialPointsDataFrame,ppp-method}
\alias{coerce,im,SpatialGridDataFrame-method}
\alias{coerce,ppp,SpatialGridDataFrame-method}
\alias{coerce,ppp,SpatialPointsDataFrame-method}
\alias{coerce,ppp,SpatialPoints-method}
\alias{as.SpatialPointsDataFrame.ppp}
\alias{as.SpatialGridDataFrame.ppp}
\alias{as.SpatialPoints.ppp}
\alias{as.SpatialGridDataFrame.im}

\title{coercion between sp objects and spatstat objects}
\description{
S4-style as() coercion works from objects of S4 sp classes to spatstat S3 classes, but not the reverse. Coercion to sp classes uses direct function calls.
}
\section{Methods}{
  \describe{
\item{coerce}{\code{signature(from = "SpatialPoints", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialPointsDataFrame", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialPolygons", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialPixelsDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "im")}}
\item{coerce}{\code{signature(from = "im", to = "SpatialGridDataFrame")}}
\item{coerce}{\code{signature(from = "ppp", to = "SpatialGridDataFrame")}}
\item{coerce}{\code{signature(from = "ppp", to = "SpatialPointsDataFrame")}}
\item{coerce}{\code{signature(from = "ppp", to = "SpatialPoints")}}
}
}

\usage{
as.SpatialPoints.ppp(from)
as.SpatialPointsDataFrame.ppp(from)
as.SpatialGridDataFrame.ppp(from)
as.SpatialGridDataFrame.im(from)
}
\arguments{
  \item{from}{spatstat object of class ppp or im}
}
\note{When coercing a SpatialPolygons object to an owin object, full topology
checking is enabled by default. To avoid checking, set \code{.spatstat_check}
to FALSE in the global environment. This work-around may not be required 
from spatstat version 2, and is used at the risk of garbled topology breaking 
other functions in spatstat.}

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
rev_ppp_SP <- as.SpatialPoints.ppp(zn1a)
summary(rev_ppp_SP)
rev_ppp_SPDF <- as.SpatialPointsDataFrame.ppp(zn1a)
summary(rev_ppp_SPDF)
rev_ppp_SGDF <- as.SpatialGridDataFrame.ppp(zn1a)
summary(rev_ppp_SGDF)
# as.owin(meuse.grid)
# --- will only work if as.owin is method...
mg_owin <- as(as(meuse.grid["ffreq"], "SpatialPixelsDataFrame"), "owin")
mg_owin
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
mg_dist <- meuse.grid["dist"]
fullgrid(mg_dist) <- TRUE
image(mg_dist, axes=TRUE)
mg_im <- as(mg_dist, "im")
plot(mg_im)
mg2 <- as.SpatialGridDataFrame.im(mg_im)
image(mg2, axes=TRUE)
}
}
\keyword{spatial}
