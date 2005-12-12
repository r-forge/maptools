readShapePoints <- function(fn, proj4string=CRS(as.character(NA)), 
	verbose=FALSE) {
	.Map2SPDF(read.shape(filen=fn, verbose=verbose), 
		proj4string=proj4string)
}

.Map2SPDF <- function(Map, IDs, proj4string=CRS(as.character(NA))) {
	if (missing(IDs))
		IDs <- as.character(sapply(Map$Shapes, function(x) x$shpID))
	coords <- Map2points(Map)
	oldClass(coords) <- NULL
	rownames(coords) <- IDs
	df <- Map$att.data
	rownames(df) <- IDs
	res <- SpatialPointsDataFrame(coords=coords, data=df, 
		proj4string=proj4string, match.ID=TRUE)
	res
}

writePointsShape <- function(x, fn, factor2char = TRUE) {
	df <- as(x, "data.frame")
	coords <- coordinates(x)
	write.pointShape(coordinates=coords, df=df, file=fn,  
		factor2char = factor2char)
}


