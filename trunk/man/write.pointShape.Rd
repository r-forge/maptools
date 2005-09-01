\name{write.pointShape}
\alias{write.pointShape}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Write a point-type shapefile}
\description{
  The function calls code from shapelib to write a point-type shapefile.
}
\usage{
write.pointShape(object, file, coordinates, factor2char = TRUE, strictFilename=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{a data frame object}
  \item{file}{a file name of maximum 8 chararacters, numbers or the underscore symbol to be written, omitting the extensions *.shp, *.shx and *.dbf, which are added in the function}
  \item{coordinates}{a 2-column numeric matrix of coordinates}
  \item{factor2char}{logical, default TRUE, convert factor columns to character}
  \item{strictFilename}{if TRUE, impose file basename length limit of 8 characters}
}

\details{
  The function calls code from shapelib to write a point-type shapefile (both the geometry file with a *.shp extension, the index file with a *.shx extension, and the database file with a *.dbf extension - see \code{\link[foreign]{write.dbf}} for details of the data frame export within this function.
}
\value{
  no return value.
}

\references{\url{http://shapelib.maptools.org/}}

\author{Nicholas J. Lewin-Koh, modified by Roger Bivand; shapelib by Frank Warmerdam}

\note{From maptools 0.4-7, this function is placed in the user-visible namespace on a trial basis, and reports of any malfunction should be sent to the package maintainer, Roger Bivand \email{Roger.Bivand@nhh.no}. It is likely that this function and its arguments will be changed.}

\seealso{\code{\link[foreign]{write.dbf}}}
\examples{
balt_orig <- read.shape(system.file("shapes/baltim.shp", package="maptools")[1])
plot(balt_orig)
balt_df <- balt_orig$att.data
balt_cheap <- balt_df[balt_df$PRICE < 40,]
file <- tempfile("")
write.pointShape(balt_cheap, file, coordinates=cbind(balt_cheap$X, balt_cheap$Y))
getinfo.shape(paste(file, ".shp", sep=""))
balt_new <- read.shape(paste(file, ".shp", sep=""))
plot(balt_new, fg="red", glyph=1, add=TRUE)
}
\keyword{spatial}

