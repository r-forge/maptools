# PBSmapping utilities

SpatialPolygons2PolySet <- function(SpP) {
	require(PBSmapping)
	pls <- getSpPpolygonsSlot(SpP)
	n <- length(pls)
	PID <- NULL
	SID <- NULL
	POS <- NULL
	X <- NULL
	Y <- NULL
	for (i in 1:n) {
		srs <- getPolygonsPolygonsSlot(pls[[i]])
		m <- length(srs)
		for (j in 1:m) {
			crds <- getPolygonCoordsSlot(srs[[j]])
			k <- nrow(crds)
			PID <- c(PID, rep(i, k))
			SID <- c(SID, rep(j, k))
			POS <- c(POS, 1:k)
			X <- c(X, crds[,1])
			Y <- c(Y, crds[,2])
		}
	}
	PID <- as.integer(PID)
	SID <- as.integer(SID)
	POS <- as.integer(POS)
	X <- as.double(X)
	Y <- as.double(Y)
	require(PBSmapping)
	pj <- .pbsproj(SpP)
	zn <- NULL
	if (pj == "UTM") {
		zn <- attr(pj, "zone")
		attr(pj, "zone") <- NULL
	}
	res <- as.PolySet(data.frame(PID=PID, SID=SID, POS=POS, X=X, Y=Y),
		projection=pj, zone=zn)
	res
}

SpatialLines2PolySet <- function(SL) {
	require(maps)
	pls <- getSLlinesSlot(SL)
	n <- length(pls)
	PID <- NULL
	SID <- NULL
	POS <- NULL
	X <- NULL
	Y <- NULL
	for (i in 1:n) {
		srs <- getLinesLinesSlot(pls[[i]])
		m <- length(srs)
		for (j in 1:m) {
			crds <- coordinates(srs[[j]])
			k <- nrow(crds)
			PID <- c(PID, rep(i, k))
			SID <- c(SID, rep(j, k))
			POS <- c(POS, 1:k)
			X <- c(X, crds[,1])
			Y <- c(Y, crds[,2])
		}
	}
	PID <- as.integer(PID)
	SID <- as.integer(SID)
	POS <- as.integer(POS)
	X <- as.double(X)
	Y <- as.double(Y)
	require(PBSmapping)
	pj <- .pbsproj(SL)
	zn <- NULL
	if (pj == "UTM") {
		zn <- attr(pj, "zone")
		attr(pj, "zone") <- NULL
	}
	res <- as.PolySet(data.frame(PID=PID, SID=SID, POS=POS, X=X, Y=Y),
		projection=pj, zone=zn)
	res
}

.pbsproj <- function(Sobj) {
	p4str <- proj4string(Sobj)
	if (is.na(p4str)) return("1")
	res <- grep("longlat", p4str, fixed=TRUE)
	if (length(res) > 0) return("LL")
	res <- regexpr("utm", p4str, fixed=TRUE)
	if (res > 0) {
		val <- "UTM"
		res <- regexpr("+zone=", p4str, fixed=TRUE)
		sres <- substring(p4str, res+attr(res, "match.length"))
		zn0 <- regexpr("[[:digit:]]+", sres)
		attr(val, "zone") <- as.integer(substring(sres, zn0, 
			zn0+attr(zn0, "match.length")))
	} else val <- "1"
	val
}


