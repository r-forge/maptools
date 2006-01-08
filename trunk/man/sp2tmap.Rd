\name{sp2tmap}
\alias{sp2tmap}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Convert SpatialPolygons object for Stata tmap command}
\description{
  The function converts a SpatialPolygons object for use with the Stata tmap command, by creating a data frame with the required columns.
}
\usage{
sp2tmap(SP)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SP}{a SpatialPolygons object}
}

\value{
 a data frame with three columns:
  \item{\_ID}{a factor of polygon identifiers in alphanumeric order of labels}
  \item{\_X}{numeric x coordinate}
  \item{\_Y}{numeric y coordinate}
}
\references{\url{http://www.stata.com/search.cgi?query=tmap}, \url{http://huebler.blogspot.com/2005/11/creating-maps-with-stata.html}}
\author{Roger Bivand}
\seealso{\code{\link[foreign]{write.dta}}}
\examples{
\dontrun{
xx <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1], IDvar="FIPSNO", proj4string=CRS("+proj=longlat +ellps=clrk66"))
plot(xx, border="blue", axes=TRUE, las=1)
write.dta(sp2tmap(as(xx, "SpatialPolygons"), file="NCmap.dta"))
write.dta(as(xx, "data.frame"), file="NC.dta")
x <- readAsciiGrid(system.file("grids/test.ag", package="maptools")[1])
xp <- as(x, "SpatialPixelsDataFrame")
pp <- as.SpatialPolygons.SpatialPixels(xp)
write.dta(sp2tmap(pp, file="testmap.dta")
dfile <- paste(tempfile(), "zip", sep=".")
download.file("http://www.cipotato.org/DIVA/data/misc/world_adm0.zip", dfile, mode="wb")
zip.file.extract(paste(tempdir(), "world_adm0.shx", sep=.Platform$file.sep), zipname = basename(dfile))
zip.file.extract(paste(tempdir(), "world_adm0.shp", sep=.Platform$file.sep), zipname = basename(dfile))
zip.file.extract(paste(tempdir(), "world_adm0.dbf", sep=.Platform$file.sep), zipname = basename(dfile))
wrld <- readShapePoly(paste(tempdir(), "world_adm0.shp", sep=.Platform$file.sep), IDvar="NAME")
write.dta(sp2tmap(as(wrld, "SpatialPolygons"), file="wrldmap.dta"))
write.dta(as(wrld, "data.frame"), file="wrld.dta")
}
}
\keyword{spatial}

