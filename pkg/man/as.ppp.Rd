\name{as.ppp}
\alias{as.owin.SpatialGridDataFrame}
\alias{as.owin.SpatialPixelsDataFrame}
\alias{as.owin.SpatialPolygons}
\alias{as.im.SpatialGridDataFrame}
\alias{coerce,SpatialGridDataFrame,owin-method}
\alias{coerce,SpatialPixelsDataFrame,owin-method}
\alias{coerce,SpatialPolygons,owin-method}
\alias{as.SpatialPolygons.tess}
\alias{as.SpatialPolygons.owin}
\alias{coerce,tess,SpatialPolygons-method}
\alias{coerce,owin,SpatialPolygons-method}
\alias{coerce,SpatialGridDataFrame,im-method}
\alias{coerce,RasterLayer,im-method}
\alias{as.ppp.SpatialGridDataFrame}
\alias{as.ppp.SpatialPoints}
\alias{as.ppp.SpatialPointsDataFrame}
\alias{coerce,SpatialPoints,ppp-method}
\alias{coerce,SpatialPointsDataFrame,ppp-method}
\alias{as.psp.Line}
\alias{as.psp.Lines}
\alias{as.psp.SpatialLines}
\alias{as.psp.SpatialLinesDataFrame}
\alias{coerce,Line,psp-method}
\alias{coerce,Lines,psp-method}
\alias{coerce,SpatialLines,psp-method}
\alias{coerce,SpatialLinesDataFrame,psp-method}
\alias{as.SpatialLines.psp}
\alias{coerce,psp,SpatialLines-method}
\alias{coerce,im,SpatialGridDataFrame-method}
\alias{coerce,ppp,SpatialGridDataFrame-method}
\alias{coerce,ppp,SpatialPointsDataFrame-method}
\alias{coerce,ppp,SpatialPoints-method}
\alias{as.SpatialPointsDataFrame.ppp}
\alias{as.SpatialGridDataFrame.ppp}
\alias{as.SpatialPoints.ppp}
\alias{as.SpatialGridDataFrame.im}
\alias{as.im.RasterLayer}

\title{coercion between sp objects and spatstat objects}
\description{
S4-style as() coercion works between objects of S4 sp classes to spatstat S3 classes; direct function calls may also be used.
}
\section{Methods}{
  \describe{
\item{coerce}{\code{signature(from = "SpatialPoints", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialPointsDataFrame", to = "ppp")}}
\item{coerce}{\code{signature(from = "Line", to = "psp")}}
\item{coerce}{\code{signature(from = "Lines", to = "psp")}}
\item{coerce}{\code{signature(from = "SpatialLines", to = "psp")}}
\item{coerce}{\code{signature(from = "SpatialLinesDataFrame", to = "psp")}}
\item{coerce}{\code{signature(from = "psp", to = "SpatialLines")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "ppp")}}
\item{coerce}{\code{signature(from = "SpatialPolygons", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialPixelsDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "owin")}}
\item{coerce}{\code{signature(from = "SpatialGridDataFrame", to = "im")}}
%\item{coerce}{\code{signature(from = "RasterLayer", to = "im")}}
\item{coerce}{\code{signature(from = "im", to = "SpatialGridDataFrame")}}
\item{coerce}{\code{signature(from = "ppp", to = "SpatialGridDataFrame")}}
\item{coerce}{\code{signature(from = "ppp", to = "SpatialPointsDataFrame")}}
\item{coerce}{\code{signature(from = "ppp", to = "SpatialPoints")}}
\item{coerce}{\code{signature(from = "owin", to = "SpatialPolygons")}}
\item{coerce}{\code{signature(from = "tess", to = "SpatialPolygons")}}
}
}

\usage{
as.SpatialPoints.ppp(from)
as.SpatialPointsDataFrame.ppp(from)
as.SpatialGridDataFrame.ppp(from)
as.SpatialGridDataFrame.im(from)
as.psp.Line(from, ..., window=NULL, marks=NULL, fatal)
as.psp.Lines(from, ..., window=NULL, marks=NULL, fatal)
as.psp.SpatialLines(from, ..., window=NULL, marks=NULL, characterMarks
                 = FALSE, fatal)
as.psp.SpatialLinesDataFrame(from, ..., window=NULL, marks=NULL, fatal)
as.SpatialLines.psp(from)
as.SpatialPolygons.tess(x)
as.SpatialPolygons.owin(x)
as.im.RasterLayer(from)
}
\arguments{
  \item{from, x}{object to coerce from}
  \item{...}{other arguments to be passed through}
  \item{window}{window as defined in the spatstat package}
  \item{marks}{marks as defined in the spatstat package}
  \item{characterMarks}{default FALSE, if TRUE, do not convert NULL narks to factor from character}
  \item{fatal}{formal coercion argument}
}
\note{When coercing a SpatialPolygons object to an owin object, full 
topology checking is enabled by default. To avoid checking, set 
\code{spatstat.options(checkpolygons=FALSE)} (from spatstat (1.14-6)). 
To perform the checking later, \code{owinpolycheck(W, verbose=TRUE)}.}

\author{Edzer Pebesma \email{edzer.pebesma@uni-muenster.de}, Roger Bivand}
\examples{
if (require(spatstat, quietly=TRUE)) {
data(meuse)
coordinates(meuse) = ~x+y
zn1 <- as(meuse["zinc"], "ppp")
zn1
plot(zn1)
as(as(meuse, "SpatialPoints"), "ppp")
data(meuse.grid)
gridded(meuse.grid) = ~x+y
mg_owin <- as(meuse.grid["dist"], "owin")
zn1a <- ppp(x=zn1$x, y=zn1$y, marks=zn1$marks, window=mg_owin)
zn1a
plot(zn1a)
rev_ppp_SP <- as.SpatialPoints.ppp(zn1a)
summary(rev_ppp_SP)
rev_ppp_SPDF <- as.SpatialPointsDataFrame.ppp(zn1a)
summary(rev_ppp_SPDF)
rev_ppp_SGDF <- as.SpatialGridDataFrame.ppp(zn1a)
summary(rev_ppp_SGDF)
data(meuse.riv)
mr <- Line(meuse.riv)
mr_psp <- as(mr, "psp")
mr_psp
plot(mr_psp)
xx_back <- as(mr_psp, "SpatialLines")
plot(xx_back)
xx <- readShapeLines(system.file("shapes/fylk-val.shp", package="maptools")[1],
 proj4string=CRS("+proj=utm +zone=33 +datum=WGS84"))
xx_psp <- as(xx["LENGTH"], "psp")
xx_psp
plot(xx_psp)
xx_back <- as(xx_psp, "SpatialLines")
plot(xx_back)
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
ho_sp1 <- as(ho, "SpatialPolygons")
all.equal(ho_sp, ho_sp1, check.attributes=FALSE)
A <- tess(xgrid=0:4,ygrid=0:4)
A_sp <- as(A, "SpatialPolygons")
plot(A_sp)
text(coordinates(A_sp), labels=row.names(A_sp), cex=0.6)
mg_dist <- meuse.grid["dist"]
fullgrid(mg_dist) <- TRUE
image(mg_dist, axes=TRUE)
mg_im <- as(mg_dist, "im")
plot(mg_im)
mg2 <- as.SpatialGridDataFrame.im(mg_im)
image(mg2, axes=TRUE)
if (require(raster, quietly=TRUE)) {
r <- as(mg2, "RasterLayer")
r_im <- as.im.RasterLayer(r)
plot(r_im)
}
}
}
\keyword{spatial}
