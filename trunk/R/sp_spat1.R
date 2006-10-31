# sp functions:
if (!isClass("ppp"))
	setClass("ppp")

if (!isClass("owin"))
	setClass("owin")

as.SpatialPoints.ppp =  function(from) SpatialPoints(cbind(from$x, from$y))
setAs("ppp", "SpatialPoints", as.SpatialPoints.ppp)

as.SpatialPointsDataFrame.ppp = function(from) 
	SpatialPointsDataFrame(SpatialPoints(cbind(from$x, from$y)), 
		list(marks = from$marks))
setAs("ppp", "SpatialPointsDataFrame", as.SpatialPointsDataFrame.ppp)

as.SpatialGridDataFrame.ppp = function(from) {
	require(spatstat)
	w = from$window
	if (w$type != "mask")
		stop("window is not of type mask")
	offset = c(w$xrange[1] + 0.5 * w$xstep, w$yrange[1] + 0.5 * w$ystep)
	cellsize = c(diff(w$xrange)/w$dim[2], diff(w$yrange)/w$dim[1])
	dim = c(w$dim[2], w$dim[1])
	gt = GridTopology(offset, cellsize, dim)
	m = t(w$m[nrow(w$m):1,])
	m[!m] = NA
	data = data.frame(mask = as.vector(m))
	SpatialGridDataFrame(gt, data)
}
setAs("ppp", "SpatialGridDataFrame", as.SpatialGridDataFrame.ppp)
