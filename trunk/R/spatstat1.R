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
