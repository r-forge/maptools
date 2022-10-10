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
\title{Deprecated functions and methods}
\description{Cumulative deprecated functions and methods from maptools prior to package retirement/archiving during 2023.}
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
  \item{...}{ arguments passed along to \code{text} to specify
          labeling parameters such as \code{col}. }
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
}
