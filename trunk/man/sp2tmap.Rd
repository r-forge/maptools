\name{sp2tmap}
\alias{sp2tmap}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sp2tmap(SP)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{SP}{ ~~Describe \code{SP} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(SP) {
	if (!inherits(SP, "SpatialPolygons"))
		stop("not a SpatialPolygons object")
	pls <- slot(SP, "polygons")
	IDs <- sapply(pls, function(x) slot(x, "ID"))
	oIDs <- order(IDs)
	n <- length(oIDs)
	res <- NULL
	for (i in oIDs) {
		IDi <- IDs[i]
		pl <- slot(pls[[i]], "Polygons")
		m <- length(pl)
		for (j in 1:m) {
			crds <- slot(pl[[j]], "coords")
			nc <- nrow(crds)
			if (is.null(res)) { res <- data.frame(ID=IDi, 
				X=as.numeric(NA), Y=as.numeric(NA))
			} else { res <- rbind(res, data.frame(ID=IDi, 
				X=as.numeric(NA), Y=as.numeric(NA)))
			}
			res <- rbind(res, data.frame(ID=IDi, X=crds[,1], 
				Y=crds[,2]))
		}
	}
	names(res) <- c("_ID", "_X", "_Y")
	res
  }
}
\keyword{ ~kwd1 }% at least one, from doc/KEYWORDS
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
