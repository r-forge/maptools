# as.ppp method to be used in spatstat:

as.ppp.SpatialPoints = function(X) {
	require(spatstat)
        bb <- bbox(X)
        colnames(bb) <- NULL
	W = owin(bb[1,], bb[2,])
	cc = coordinates(X)
	return(ppp(cc[,1], cc[,2], window = W, marks = NULL))
}

setAs("SpatialPoints", "ppp", function(from) as.ppp.SpatialPoints(from))

as.ppp.SpatialPointsDataFrame = function(X) {
	require(spatstat)
	W = owin(bbox(X)[1,], bbox(X)[2,])
	if (ncol(X) > 1)
	  stop("ppp objects only accept a single attribute column; please select one")
	marks = X[[1]]
	cc = coordinates(X)
	return(ppp(cc[,1], cc[,2], window = W, marks = marks))
}

setAs("SpatialPointsDataFrame", "ppp", function(from) as.ppp.SpatialPointsDataFrame(from))

as.owin.SpatialGridDataFrame = function(W, ..., fatal) {
	require(spatstat)
	# W = from
	m = t(!is.na(as(W, "matrix")))
	owin(bbox(W)[1,], bbox(W)[2,], mask = m[nrow(m):1,])
}

setAs("SpatialGridDataFrame", "owin", function(from) as.owin.SpatialGridDataFrame(from))

as.owin.SpatialPixelsDataFrame = function(W, ..., fatal) {
	require(spatstat)
	# W = from
	m = t(!is.na(as(W, "matrix")))
	owin(bbox(W)[1,], bbox(W)[2,], mask = m[nrow(m):1,])
}

setAs("SpatialPixelsDataFrame", "owin", function(from) as.owin.SpatialPixelsDataFrame(from))

as.owin.SpatialPolygons = function(W, ..., fatal) {
	require(spatstat)
	# W = from
	if (!inherits(W, "SpatialPolygons")) 
		stop("W must be a SpatialPolygons object")
	res <- .SP2owin(W)
	res
}

setAs("SpatialPolygons", "owin", function(from) as.owin.SpatialPolygons(from))

# methods for 'as.psp' for sp classes

as.psp.Line <- function(from, ..., window=NULL, marks=NULL, fatal) {
  xy <- from@coords
  xrange <- range(xy[,1])
  yrange <- range(xy[,2])
  df <- as.data.frame(cbind(xy[-nrow(xy), , drop=FALSE], xy[-1, ,
drop=FALSE]))
  if(is.null(window))
    window <- owin(xrange, yrange)
  return(as.psp(df, window=window, marks=marks))
}

setAs("Line", "psp", function(from) as.psp.Line(from))
  
as.psp.Lines <- function(from, ..., window=NULL, marks=NULL, fatal) {
  y <- lapply(from@Lines, as.psp.Line, window=window)
  z <- superimposePSP(y, window=window)
  if(!is.null(marks))
    marks(z) <- marks
  return(z)
}

setAs("Lines", "psp", function(from) as.psp.Lines(from))

as.psp.SpatialLines <- function(from, ..., window=NULL, marks=NULL, fatal) {
  lin <- from@lines
  y <- lapply(lin, as.psp.Lines)
  id <- unlist(lapply(lin, function(s) { s@ID }))
  if(is.null(marks))
    for(i in seq(y)) 
      marks(y[[i]]) <- id[i]
  if(is.null(window)) {
    w <- from@bbox
    window <- owin(w[1,], w[2,])
  }
  z <- do.call("superimposePSP", list(y, window=window))
  if(!is.null(marks))
    marks(z) <- marks
  return(z)
}

setAs("SpatialLines", "psp", function(from) as.psp.SpatialLines(from))

as.psp.SpatialLinesDataFrame <- function(from, ..., window=NULL, marks=NULL, fatal) {
  y <- as(from, "SpatialLines")
  z <- as.psp(y, window=window, marks=marks)
  if(is.null(marks)) {
    # extract marks from first column of data frame
    df <- from@data
    if(is.null(df))
      return(z)
    if((nc <- ncol(df)) > 1) 
      warning(paste(nc-1, "columns of data frame discarded"))
    marx <- df[,1]
    nseg.Line  <- function(x) { return(nrow(x@coords)-1) }
    nseg.Lines <- function(x) { return(unlist(lapply(x@Lines, nseg.Line))) }
    nrep <- unlist(lapply(y@lines, nseg.Lines))
    marks(z) <- rep(marx, nrep)
  }
  return(z)
}

setAs("SpatialLinesDataFrame", "psp", function(from) as.psp.SpatialLinesDataFrame(from))


