\name{sp2Mondrian}
\alias{sp2Mondrian}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{write map data for Mondrian}
\description{
  The function outputs a SpatialPolygonsDataFrame object to be used by Mondrian
}
\usage{
sp2Mondrian(SP, file)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SP}{a SpatialPolygonsDataFrame object}
  \item{file}{file where output is written}
}


\references{\url{http://www.theusrus.de/Mondrian/index.html}}
\author{Patrick Hausmann and Roger Bivand}
\note{
 At this release, the function only passes out the first polygon of multi-polygon spatial objects
}

\examples{
\dontrun{
xx <- readShapePoly(system.file("shapes/columbus.shp", package="maptools")[1])
sp2Mondrian(xx, file="columbus1.txt")
}
}
\keyword{spatial}
