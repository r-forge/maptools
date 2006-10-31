MapGen2SL <- function(file, proj4string=CRS(as.character(NA))) {
	con <- file(file, "r")
	hold <- readLines(con)
	close(con)
	if (length(hold) == 500000) warning("500,000 point limit reached")
	starts <- which(hold == "# -b")
	n <- length(starts)
	if (n < 1) stop("Not a Mapgen format file")
	res <- vector(mode="list", length=n)
	IDs <- paste("L", 1:n, sep="_")
	for (i in 1:n) {
		if (i < n) {
			x <- t(sapply(strsplit(hold[(starts[i]+1):
				(starts[i+1]-1)], "\t"), as.numeric))
		} else {
			x <- t(sapply(strsplit(hold[(starts[i]+1):
				length(hold)], "\t"), as.numeric))
		}
		res[[i]] <- Lines(list(Line(x
#, proj4string=proj4string
)), ID=IDs[i])
	}
	SL <- SpatialLines(res, proj4string=proj4string)
	SL
}

ArcObj2SLDF <- function(arc, proj4string=CRS(as.character(NA)), IDs) {
	df <- data.frame(arc[[1]])
	n <- length(arc[[2]])
	LinesList <- vector(mode="list", length=n)
	if (missing(IDs)) IDs <- paste("L", 1:n, sep="_")
	if (length(IDs) != n) stop("IDs length differs from number of arcs")
	row.names(df) <- IDs
	for (i in 1:n) {
		crds <- cbind(arc[[2]][[i]][[1]], arc[[2]][[i]][[2]])
		LinesList[[i]] <- Lines(list(Line(coords=crds
#, proj4string=proj4string
)), ID=IDs[i])
	}
	SL <- SpatialLines(LinesList, proj4string=proj4string)
	res <- SpatialLinesDataFrame(SL, data=df)
	res
}

ContourLines2SLDF <- function(cL, proj4string=CRS(as.character(NA))) {
	if (length(cL) < 1) stop("cL too short")
	cLstack <- tapply(1:length(cL), sapply(cL, function(x) x[[1]]), 
		function(x) x, simplify=FALSE)
	df <- data.frame(level=names(cLstack))
	m <- length(cLstack)
	res <- vector(mode="list", length=m)
	IDs <- paste("C", 1:m, sep="_")
	row.names(df) <- IDs
	for (i in 1:m) {
		res[[i]] <- Lines(.contourLines2LineList(cL[cLstack[[i]]]#, 
#			proj4string=proj4string
), ID=IDs[i])
	}
	SL <- SpatialLines(res, proj4string=proj4string)
	res <- SpatialLinesDataFrame(SL, data=df)
	res
}
.contourLines2LineList <- function(cL#, proj4string=CRS(as.character(NA))
) {
	n <- length(cL)
	res <- vector(mode="list", length=n)
	for (i in 1:n) {
		crds <- cbind(cL[[i]][[2]], cL[[i]][[3]])
		res[[i]] <- Line(coords=crds#, proj4string=proj4string
)
	}
	res
}

