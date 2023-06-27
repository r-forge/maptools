\name{maptools-deprecated}
\alias{maptools-deprecated}
\alias{pointLabel}
\alias{getinfo.shape}
\alias{print.shapehead}
\alias{readShapeLines}
\alias{writeLinesShape}
\alias{readShapeSpatial}
\alias{writeSpatialShape}
\alias{readShapePoly}
\alias{writePolyShape}
\alias{readShapePoints}
\alias{writePointsShape}
\alias{panel.pointLabel}
\alias{sp.pointLabel}
\alias{sp.pointLabel-methods}
\alias{sp.pointLabel,SpatialPoints-method}
\alias{lineLabel}
\alias{sp.lineLabel}
\alias{label}
\alias{sp.lineLabel-methods}
\alias{label-methods}
\alias{sp.lineLabel,Lines-method}
\alias{sp.lineLabel,SpatialLines-method}
\alias{label,SpatialLines-method}
\alias{crepuscule}
\alias{sunriset}
\alias{solarnoon}
\alias{solarpos}
\alias{crepuscule-methods}
\alias{crepuscule,SpatialPoints,POSIXct-method}
\alias{crepuscule,matrix,POSIXct-method}
\alias{solarnoon-methods}
\alias{solarnoon,SpatialPoints,POSIXct-method}
\alias{solarnoon,matrix,POSIXct-method}
\alias{solarpos-methods}
\alias{solarpos,SpatialPoints,POSIXct-method}
\alias{solarpos,matrix,POSIXct-method}
\alias{sunriset-methods}
\alias{sunriset,SpatialPoints,POSIXct-method}
\alias{sunriset,matrix,POSIXct-method}
\alias{GE_SpatialGrid}
\alias{Sobj_SpatialGrid}
\alias{getKMLcoordinates}
\alias{kmlLine}
\alias{kmlLines}
\alias{kmlOverlay}
\alias{kmlPoints}
\alias{kmlPolygon}
\alias{kmlPolygons}

\title{Deprecated functions and methods}
\description{Cumulative deprecated functions and methods from maptools prior to package retirement/archiving during October 2023.}
\usage{
pointLabel(x, y = NULL, labels = seq(along = x), cex = 1, method = c("SANN", "GA"),
 allowSmallOverlap = FALSE, trace = FALSE, doPlot = TRUE, ...) # moved to car
getinfo.shape(filen)
\method{print}{shapehead}(x, ...)
readShapeLines(fn, proj4string=CRS(as.character(NA)), verbose=FALSE,
 repair=FALSE, delete_null_obj=FALSE)
writeLinesShape(x, fn, factor2char = TRUE, max_nchar=254)
readShapeSpatial(fn, proj4string=CRS(as.character(NA)), 
	verbose=FALSE, repair=FALSE, IDvar=NULL, force_ring=FALSE, 
	delete_null_obj=FALSE, retrieve_ABS_null=FALSE)
writeSpatialShape(x, fn, factor2char = TRUE, max_nchar=254)
readShapePoly(fn, IDvar=NULL, proj4string=CRS(as.character(NA)),
 verbose=FALSE, repair=FALSE, force_ring=FALSE, delete_null_obj=FALSE,
 retrieve_ABS_null=FALSE)
writePolyShape(x, fn, factor2char = TRUE, max_nchar=254)
readShapePoints(fn, proj4string = CRS(as.character(NA)), verbose = FALSE,
 repair=FALSE)
writePointsShape(x, fn, factor2char = TRUE, max_nchar=254)
lineLabel(line, label,
          spar=.6, position = c('above', 'below'),
          textloc = 'constantSlope',
          col = add.text$col,
          alpha = add.text$alpha,
          cex = add.text$cex,
          lineheight = add.text$lineheight,
          font = add.text$font,
          fontfamily = add.text$fontfamily,
          fontface = add.text$fontface,
          lty = add.line$lty,
          lwd = add.line$lwd, 
          col.line = add.line$col,
          identifier = 'lineLabel',
          ...)
sp.lineLabel(object, labels, byid=TRUE,...)
label(object, text, ...)
panel.pointLabel(x, y = NULL,
                              labels = seq(along = x),
                              method = c("SANN", "GA"),
                              allowSmallOverlap = FALSE,
                              col = add.text$col,
                              alpha = add.text$alpha,
                              cex = add.text$cex,
                              lineheight = add.text$lineheight,
                              font = add.text$font,
                              fontfamily = add.text$fontfamily,
                              fontface = add.text$fontface,
                              fill='transparent',
                              ...)
sp.pointLabel(object, labels, ...)
#elide(obj, ...)
\S4method{crepuscule}{SpatialPoints,POSIXct}(crds, dateTime, solarDep, direction=c("dawn", "dusk"),
           POSIXct.out=FALSE)
\S4method{crepuscule}{matrix,POSIXct}(crds, dateTime,
           proj4string=CRS("+proj=longlat +datum=WGS84"), solarDep,
           direction=c("dawn", "dusk"), POSIXct.out=FALSE)
\S4method{sunriset}{SpatialPoints,POSIXct}(crds, dateTime, direction=c("sunrise", "sunset"),
         POSIXct.out=FALSE)
\S4method{sunriset}{matrix,POSIXct}(crds, dateTime,
         proj4string=CRS("+proj=longlat +datum=WGS84"),
         direction=c("sunrise", "sunset"), POSIXct.out=FALSE)
\S4method{solarnoon}{SpatialPoints,POSIXct}(crds, dateTime, POSIXct.out=FALSE)
\S4method{solarnoon}{matrix,POSIXct}(crds, dateTime,
          proj4string=CRS("+proj=longlat +datum=WGS84"),
          POSIXct.out=FALSE)
\S4method{solarpos}{SpatialPoints,POSIXct}(crds, dateTime, ...)
\S4method{solarpos}{matrix,POSIXct}(crds, dateTime,
         proj4string=CRS("+proj=longlat +datum=WGS84"), ...)
GE_SpatialGrid(obj, asp = NA, maxPixels = 600)
Sobj_SpatialGrid(obj, asp=1, maxDim=100, n=NULL)
getKMLcoordinates(kmlfile, ignoreAltitude=FALSE)
kmlLine(obj=NULL, kmlfile=NULL, 
    name="R Line", description="", col=NULL, visibility=1, lwd=1,
    kmlname="", kmldescription="")
kmlLines(obj=NULL, kmlfile=NULL, 
        name="R Lines", description="", col=NULL, visibility=1, lwd=1,
        kmlname="", kmldescription="")
kmlOverlay(obj, kmlfile = NULL, imagefile = NULL, name = "R image")
kmlPoints(obj=NULL, kmlfile=NULL, kmlname="", kmldescription="",
    name=NULL, description="",
    icon="http://www.gstatic.com/mapspro/images/stock/962-wht-diamond-blank.png")
kmlPolygon(obj=NULL, kmlfile=NULL, 
    name="R Polygon", description="", col=NULL, visibility=1, lwd=1, border=1,
    kmlname="", kmldescription="")
kmlPolygons(obj=NULL, kmlfile=NULL, 
    name="KML Polygons", description="", col=NULL, visibility=1, lwd=1,
    border="white", kmlname="", kmldescription="")

}
\arguments{
  \item{filen}{name of file with *.shp extension}
  \item{x, y}{ as with \code{plot.default}, these provide the x and y coordinates for
          the point labels.  Any reasonable way of defining the coordinates is
          acceptable.  See the function \code{xy.coords} for details. }
  \item{labels}{ as with \code{text}, a character vector or expression specifying the text to be
          written.  An attempt is made to coerce other language objects
          (names and calls) to expressions, and vectors and other
          classed objects to character vectors by \code{as.character}. }
  \item{cex}{ numeric character expansion factor as with \code{text}. }
  \item{method}{ the optimization method, either \dQuote{SANN} for simulated
          annealing (the default) or \dQuote{GA} for a genetic algorithm. }
  \item{allowSmallOverlap}{ logical; if \code{TRUE}, labels are allowed
          a small overlap. The overlap allowed is 2\% of the diagonal
          distance of the plot area.}
  \item{trace}{ logical; if \code{TRUE}, status updates are given as the optimization algorithms
          progress.}
  \item{doPlot}{ logical; if \code{TRUE}, the labels are plotted on the
          existing graph with \code{text}.}
  \item{fn}{shapefile layer name, when writing omitting the extensions *.shp, *.shx and *.dbf, which are added in the function}
  \item{proj4string}{Object of class \code{CRS}; holding a valid proj4 string}
  \item{verbose}{default FALSE - report type of shapefile and number of shapes}
  \item{repair}{default FALSE: some shapefiles provided by Geolytics Inc. have values of object sizes stored in the *.shx index file that are eight bytes too large, leading the function to try to read past the end of file. If repair=TRUE, an attempt is made to repair the internal values, permitting such files to be read.}
  \item{delete_null_obj}{if TRUE, null geometries will be removed together with their data.frame rows}
  \item{factor2char}{logical, default TRUE, convert factor columns to character}
  \item{max_nchar}{default 254, may be set to a higher limit and passed through to the DBF writer, please see Details in \code{\link[foreign]{write.dbf}}}
  \item{IDvar}{a character string: the name of a column in the shapefile DBF containing the ID values of the shapes - the values will be converted to a character vector (Polygons only)}
  \item{force_ring}{if TRUE, close unclosed input rings (Polygons only)}
  \item{retrieve_ABS_null}{default FALSE, if TRUE and delete_null_obj also 
TRUE, the function will return a data frame containing the data from any 
null geometries inserted by ABS (Polygons only)}
  \item{object}{A \code{SpatialPoints} object.}
  \item{col, alpha, lineheight, font, fontfamily,
  fontface, fill}{Graphical arguments. See gpar for details}
  \item{line}{a \code{list} of \code{Lines}.}
  \item{label, text}{a string or expression to be printed
    following the path of \code{line}. The \code{names} of \code{labels}
    should match the values of the \code{ID} slot of the lines to
    label. If \code{labels} is missing, the \code{ID} slot is used
    instead. The \code{label} method is a wrapper function to extract
    the \code{ID} slots and create a suitable \code{character} object
    with the correct \code{names} values.}
  \item{byid}{If TRUE (default) only the longest line of each unique
  \code{ID} value will be labelled.}
  \item{textloc}{a character or a numeric. It may be 'constantSlope',
    'minSlope' or 'maxDepth', or the numeric index of the location. If
    it is a numeric, its length must coincide with the number of
    \code{Lines}.}
  \item{spar}{smoothing parameter. With values near zero, the label
    will closely follow the line. Default value is .6. See smooth.spline for details.}
  \item{position}{character string ('above' or 'below') to define where
    the text must be placed.}
  \item{lty, lwd, col.line}{graphical parameters for the line. See gpar for details.}
  \item{identifier}{A character string to identify the grob to be created.}
  \item{...}{other arguments:
  \describe{
    \item{bb}{if NULL, uses bounding box of object, otherwise the given bounding box}
    \item{shift}{values to shift the coordinates of the input object; this is made ineffective by the scale argument}
    \item{reflect}{reverse coordinate axes}
    \item{scale}{if NULL, coordinates not scaled; if TRUE, the longer dimension is scaled to lie within [0,1] and aspect maintained; if a scalar, the output range of [0,1] is multiplied by scale}
    \item{flip}{translate coordinates on the main diagonal}
    \item{rotate}{default 0, rotate angle degrees clockwise around center}
    \item{center}{default NULL, if not NULL, the rotation center, numeric of length two}
    \item{unitsq}{logical, default FALSE, if TRUE and scale TRUE, impose unit square bounding box (currently only points)}
}}
  \item{crds}{a \code{SpatialPoints} or \code{matrix} object, containing
    x and y coordinates (in that order).}

  \item{dateTime}{a POSIXct object with the date and time associated to
    calculate ephemerides for points given in crds.}

  \item{solarDep}{numeric vector with the angle of the sun below the
    horizon in degrees.}

  \item{direction}{one of "dawn", "dusk", "sunrise", or "sunset",
    indicating which ephemerides should be calculated.}

  \item{POSIXct.out}{logical indicating whether POSIXct output should be
    included.}
  \item{obj}{a Spatial* object}
  \item{asp}{if NA, will be set to the latitude corrected value}
  \item{maxPixels}{the maximum dimension of the output PNG}
  \item{maxDim}{the maximum dimension of the output grid; ignored if \code{n} not NULL}
  \item{n}{if not NULL, the minimum number of cells in the returned grid}
  \item{ignoreAltitude}{if set to \code{TRUE} the altitude values of a KML points will be ignored}
  \item{kmlfile}{if not \code{NULL} the name as character string of the kml file to be written}
  \item{name}{the name of the KML line}
  \item{description}{the description of the KML line (HTML tags allowed)}
  \item{visibility}{if set to \code{1} or \code{TRUE} specifies that the KML line should be visible after loading}
  \item{kmlname}{the name of the KML layer}
  \item{kmldescription}{the description of the KML layer (HTML tags allowed)}
  \item{imagefile}{the name of the PNG file containing the image - this should be either relative (same directory as kml file) or abosolute (fully qualified)}
  \item{icon}{a character vector of icon URLs to be used in the style associated with each KML Placemark}
  \item{border}{the stroke color (see also Color Specification) for the KML polygon}


}
\keyword{ package }
\keyword{ spatial }


\examples{
n <- 50
x <- rnorm(n)*10
y <- rnorm(n)*10
plot(x, y, col = "red", pch = 20)
pointLabel(x, y, as.character(round(x,5)), offset = 0, cex = .7)

plot(x, y, col = "red", pch = 20)
pointLabel(x, y, expression(over(alpha, beta[123])), offset = 0, cex = .8)
res <- getinfo.shape(system.file("shapes/fylk-val.shp", package="maptools")[1])
res
str(res)
xx <- readShapeLines(system.file("shapes/fylk-val.shp", package="maptools")[1],
 proj4string=CRS("+proj=utm +zone=33 +datum=WGS84"))
plot(xx, col="blue")
summary(xx)
xxx <- xx[xx$LENGTH > 30000,]
plot(xxx, col="red", add=TRUE)
tmpfl <- paste(tempdir(), "xxline", sep="/")
writeLinesShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
axx <- readShapeLines(tmpfl, proj4string=CRS("+proj=utm +zone=33 +datum=WGS84"))
plot(xxx, col="black", lwd=4)
plot(axx, col="yellow", lwd=1, add=TRUE)
unlink(paste(tmpfl, ".*", sep=""))
xx <- readShapeLines(system.file("shapes/sids.shp", package="maptools")[1],
 proj4string=CRS("+proj=longlat +datum=NAD27"))
plot(xx, col="blue")
library(maptools)
xx <- readShapeSpatial(system.file("shapes/sids.shp", package="maptools")[1],
 IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
summary(xx)
xxx <- xx[xx$SID74 < 2,]
tmpfl <- paste(tempdir(), "xxpoly", sep="/")
writeSpatialShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
unlink(paste(tmpfl, ".*", sep=""))
xx <- readShapeSpatial(system.file("shapes/fylk-val.shp",
 package="maptools")[1], proj4string=CRS("+proj=utm +zone=33 +datum=WGS84"))
summary(xx)
xxx <- xx[xx$LENGTH > 30000,]
plot(xxx, col="red", add=TRUE)
tmpfl <- paste(tempdir(), "xxline", sep="/")
writeSpatialShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
unlink(paste(tmpfl, ".*", sep=""))
xx <- readShapeSpatial(system.file("shapes/baltim.shp", package="maptools")[1])
summary(xx)
xxx <- xx[xx$PRICE < 40,]
tmpfl <- paste(tempdir(), "xxpts", sep="/")
writeSpatialShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
unlink(paste(tmpfl, ".*", sep=""))
library(maptools)
xx <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1],
 IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
plot(xx, border="blue", axes=TRUE, las=1)
text(coordinates(xx), labels=row.names(xx), cex=0.6)
as(xx, "data.frame")[1:5, 1:6]
xxx <- xx[xx$SID74 < 2,]
plot(xxx, border="red", add=TRUE)
tmpfl <- paste(tempdir(), "xxpoly", sep="/")
writePolyShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
axx <- readShapePoly(tmpfl, proj4string=CRS("+proj=longlat +ellps=clrk66"))
plot(xxx, border="black", lwd=4)
plot(axx, border="yellow", lwd=1, add=TRUE)
unlink(paste(tmpfl, ".*", sep=""))
library(maptools)
xx <- readShapePoints(system.file("shapes/baltim.shp", package="maptools")[1])
plot(xx)
summary(xx)
xxx <- xx[xx$PRICE < 40,]
tmpfl <- paste(tempdir(), "xxpts", sep="/")
writePointsShape(xxx, tmpfl)
getinfo.shape(paste(tmpfl, ".shp", sep=""))
axx <- readShapePoints(tmpfl)
plot(axx, col="red", add=TRUE)
unlink(paste(tmpfl, ".*", sep=""))
xx <- readShapePoints(system.file("shapes/pointZ.shp", package="maptools")[1])
dimensions(xx)
plot(xx)
summary(xx)
n <- 15
x <- rnorm(n)*10
y <- rnorm(n)*10
labels <- as.character(round(x, 5))
myTheme <- list(add.text=list(
                  cex=0.7,
                  col='midnightblue',
                  fontface=2,
                  fontfamily='mono'))
library(lattice)
xyplot(y~x,
       labels=labels,
       par.settings=myTheme, 
       panel=function(x, y, labels, ...){
         panel.xyplot(x, y, ...)
         panel.pointLabel(x, y, labels=labels, ...)
       })
data(meuse.grid)
coordinates(meuse.grid) = ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) = TRUE
pts <- spsample(meuse.grid, n=15, type="random")
Rauthors <- readLines(file.path(R.home("doc"), "AUTHORS"))[9:28]
someAuthors <- Rauthors[seq_along(pts)]
sl1 <- list('sp.points', pts, pch=19, cex=.8, col='midnightblue')
sl2 <- list('sp.pointLabel', pts, label=someAuthors,
            cex=0.7, col='midnightblue',
            fontfamily='Palatino')
run <- FALSE
if (require("RColorBrewer", quietly=TRUE)) run <- TRUE
if (run) {
myCols <- adjustcolor(colorRampPalette(brewer.pal(n=9, 'Reds'))(100), .85)
spplot(meuse.grid["dist"], col.regions=myCols, sp.layout=list(sl1, sl2))
}
data(meuse.grid)
coordinates(meuse.grid) = ~x+y
proj4string(meuse.grid) <- CRS("+init=epsg:28992")
gridded(meuse.grid) = TRUE
data(meuse)
coordinates(meuse) = ~x+y
data(meuse.riv)
meuse.sl <- SpatialLines(list(Lines(list(Line(meuse.riv)), "1")))
run <- FALSE
if (require("RColorBrewer", quietly=TRUE)) run <- TRUE
if (run) {
myCols <- adjustcolor(colorRampPalette(brewer.pal(n=9, 'Reds'))(100), .85)
labs <- label(meuse.sl, 'Meuse River')
## Maximum depth
sl1 <- list('sp.lineLabel', meuse.sl, label=labs,
            position='below', textloc='maxDepth',
            spar=.2,
            col='darkblue', cex=1,
            fontfamily='Palatino',
            fontface=2)
spplot(meuse.grid["dist"],
       col.regions=myCols, 
       sp.layout = sl1)
## Constant slope
sl2 <- modifyList(sl1, list(textloc = 'constantSlope')) ## Default
spplot(meuse.grid["dist"],
       col.regions=myCols, 
       sp.layout = sl2)
## Location defined by its numeric index
sl3 <- modifyList(sl1, list(textloc = 140, position='above'))
spplot(meuse.grid["dist"],
       col.regions=myCols, 
       sp.layout = sl3)
}
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
solarnoon(hels, d041224, POSIXct.out=TRUE)
solarnoon(Hels, d041224, POSIXct.out=TRUE)
solarpos(hels, as.POSIXct(Sys.time(), tz="EET"))
solarpos(Hels, as.POSIXct(Sys.time(), tz="EET"))
sunriset(hels, d041224, direction="sunrise", POSIXct.out=TRUE)
sunriset(Hels, d041224, direction="sunrise", POSIXct.out=TRUE)
## Using a sequence of dates
Hels_seq <- seq(from=d041224, length.out=365, by="days")
up <- sunriset(Hels, Hels_seq, direction="sunrise", POSIXct.out=TRUE)
down <- sunriset(Hels, Hels_seq, direction="sunset", POSIXct.out=TRUE)
day_length <- down$time - up$time
plot(Hels_seq, day_length, type="l")
opt_exask <- options(example.ask=FALSE)
qk <- SpatialPointsDataFrame(quakes[, c(2:1)], quakes)
summary(Sobj_SpatialGrid(qk)$SG)
t2 <- Sobj_SpatialGrid(qk, n=10000)$SG
summary(t2)
prod(slot(slot(t2, "grid"), "cells.dim"))
proj4string(qk) <- CRS("+proj=longlat +ellps=WGS84")
tf <- tempfile()
SGqk <- GE_SpatialGrid(qk)
png(file=paste(tf, ".png", sep=""), width=SGqk$width, height=SGqk$height,
  bg="transparent")
par(mar=c(0,0,0,0), xaxs="i", yaxs="i")
plot(qk, xlim=SGqk$xlim, ylim=SGqk$ylim, setParUsrBB=TRUE)
dev.off()
kmlOverlay(SGqk, paste(tf, ".kml", sep=""), paste(tf, ".png", sep=""))
options(example.ask=opt_exask)
data(wrld_simpl)
## creates a KML file containing the polygons of South Africa (plus hole)
sw <- slot(wrld_simpl[wrld_simpl$NAME=="South Africa",], "polygons")[[1]]
tf <- tempfile()
kmlPolygon(sw, kmlfile=tf, name="South Africa", col="#df0000aa", lwd=5, 
    border=4, kmlname="R Test", 
    kmldescription="This is <b>only</b> a <a href='http://www.r-project.org'>R</a> test.")
zz <- getKMLcoordinates(tf, ignoreAltitude=TRUE)
str(zz)
zz <- getKMLcoordinates(system.file("shapes/Testing.kml", package="maptools"))
str(zz)
xx <- readShapeSpatial(system.file("shapes/fylk-val-ll.shp",
      package="maptools")[1], proj4string=CRS("+proj=longlat +ellps=WGS84"))
out <- sapply(slot(xx, "lines"), function(x) { kmlLine(x,
    name=slot(x, "ID"), col="blue", lwd=1.5, 
    description=paste("river:", slot(x, "ID"))) })
tf <- tempfile()
kmlFile <- file(tf, "w")
tf
cat(kmlLine(kmlname="R Test", kmldescription="<i>Hello</i>")$header, 
    file=kmlFile, sep="\n")
cat(unlist(out["style",]), file=kmlFile, sep="\n")
cat(unlist(out["content",]), file=kmlFile, sep="\n")
cat(kmlLine()$footer, file=kmlFile, sep="\n")
close(kmlFile)
rivers <- readShapeSpatial(system.file("shapes/fylk-val-ll.shp",
                           package="maptools")[1], proj4string=CRS("+proj=longlat +ellps=WGS84"))
# create kml file
td <- tempdir()
kmlfile <- paste(td, "rivers.kml", sep="/")
kmlLines(rivers, kmlfile = kmlfile, name = "R Lines", 
         description = "Hello!", col = "blue", visibility = 1, lwd = 1, 
         kmlname = "", kmldescription = "")
opt_exask <- options(example.ask=FALSE)
qk <- SpatialPointsDataFrame(quakes[, c(2:1)], quakes)
proj4string(qk) <- CRS("+proj=longlat +ellps=WGS84")
tf <- tempfile()
SGqk <- GE_SpatialGrid(qk)
png(file=paste(tf, ".png", sep=""), width=SGqk$width, height=SGqk$height,
  bg="transparent")
par(mar=c(0,0,0,0), xaxs="i", yaxs="i")
plot(qk, xlim=SGqk$xlim, ylim=SGqk$ylim, setParUsrBB=TRUE)
dev.off()
kmlOverlay(SGqk, paste(tf, ".kml", sep=""), paste(tf, ".png", sep=""))
options(example.ask=opt_exask)
data(SplashDams)
num <- length(SplashDams)
td <- tempdir()
kmlfile <- paste(td, "OregonSplashDams.kml", sep="/")
kmlname <- "Oregon Splash Dams"
kmldescription <- paste("Data for Splash Dams in western Oregon.",
 "See http://www.fs.fed.us/pnw/lwm/aem/people/burnett.html#projects_activities",
 "for more information.")
icon <- "http://www.gstatic.com/mapspro/images/stock/962-wht-diamond-blank.png"
name <- paste("Dam on",SplashDams$streamName)
description <- paste("<b>owner:</b>", SplashDams$owner, "<br><b>dates:</b>", SplashDams$datesUsed)
kmlPoints(SplashDams, kmlfile=kmlfile, name=name, description=description,
          icon=icon, kmlname=kmlname, kmldescription=kmldescription)
data(wrld_simpl)
## creates a KML file containing the polygons of South Africa (plus hole)
sw <- slot(wrld_simpl[wrld_simpl$NAME=="South Africa",], "polygons")[[1]]
tf <- tempfile()
kmlPolygon(sw, kmlfile=tf, name="South Africa", col="#df0000aa", lwd=5, 
    border=4, kmlname="R Test", 
    kmldescription="This is <b>only</b> a <a href='http://www.r-project.org'>R</a> test.")
tf

## creates a KML file containing the polygons of South Africa, Switzerland, and Canada
sw  <- wrld_simpl[wrld_simpl$NAME \%in\% c("South Africa", "Switzerland", "Canada"),]
out <- sapply(slot(sw, "polygons"), function(x) { kmlPolygon(x,
    name=as(sw, "data.frame")[slot(x, "ID"), "NAME"], 
    col="red", lwd=1.5, border='black', 
    description=paste("ISO3:", slot(x, "ID"))) })
tf <- tempfile()
kmlFile <- file(tf, "w")
tf
cat(kmlPolygon(kmlname="R Test", kmldescription="<i>Hello</i>")$header, 
    file=kmlFile, sep="\n")
cat(unlist(out["style",]), file=kmlFile, sep="\n")
cat(unlist(out["content",]), file=kmlFile, sep="\n")
cat(kmlPolygon()$footer, file=kmlFile, sep="\n")
close(kmlFile)
data(wrld_simpl)
td <- tempdir()
kmlfile <- paste(td, "worldPolitical.kml", sep="/")
## creates a KML file containing the polygons of a political world map
kmlPolygons(wrld_simpl, kmlfile = kmlfile, name = "KML Polygons", 
         description = "the world", col = "red",
         visibility = 1, lwd = 1, border = "white", kmlname = "R Test", 
         kmldescription = "This is <b>only</b> a <a href='http://www.r-project.org'>R</a> test.")

data(wrld_simpl)
## create a KML file containing the polygons of Brazil, Uganda, and Canada
regions <- c("Brazil","Canada","Uganda")
wrld_simpl_subset <- wrld_simpl[wrld_simpl$NAME \%in\% regions,]
kmlfile <- paste(td, "worldPoliticalSubset.kml", sep="/")
kmlPolygons(wrld_simpl_subset, kmlfile = kmlfile,
 name = "KML Polygons subset", description = "three countries", col = "blue", 
 visibility = 1, lwd = 1, border = "white", kmlname = "R Test 2", 
 kmldescription = "This is <b>only</b> a <a href='http://www.r-project.org'>R</a> test.")
## combine to make a list of polygon objects to plot
polList <- c(regions,wrld_simpl)
kmlfile <- paste(td, "worldPoliticalandSubset.kml", sep="/")
kmlPolygons(wrld_simpl_subset, kmlfile = kmlfile,
 name = "KML Polygons subset", description = "three countries highlighted in world", 
 col = sample(colours(), length(polList)), visibility = 1, lwd = 1, border = "white", 
 kmlname = "R Test 2", 
 kmldescription = "This is <b>only</b> a <a href='http://www.r-project.org'>R</a> test.")

}
