gpclibPermit <- function() {
    if (require("gpclib", quietly = TRUE, warn.conflicts = FALSE))
        assign("gpclib", TRUE, envir=.MAPTOOLS_CACHE)
    get("gpclib", envir=.MAPTOOLS_CACHE)
}

gpclibPermitStatus <- function() get("gpclib", envir=.MAPTOOLS_CACHE)

rgeosStatus <- function() get("rgeos", envir=.MAPTOOLS_CACHE)

checkPolygonsHoles <- function(x) {
    if (rgeosStatus()) {
#        require(rgeos)
#        return(checkPolygonsGEOS(x))
    } else {
        stopifnot(isTRUE(gpclibPermitStatus()))
	require(gpclib)
	if (!is(x, "Polygons")) stop("not an Polygons object")
	pls <- slot(x, "Polygons")
	nParts <- length(pls)
	ID <- slot(x, "ID")
	gpc <- as(slot(pls[[1]], "coords"), "gpc.poly")
	if (nParts > 1) for (i in 2:nParts) gpc <- append.poly(gpc, 
		as(slot(pls[[i]], "coords"), "gpc.poly"))
	bb <- get.bbox(gpc)
	bbmat <- matrix(c(rep(bb$x[1], 2), rep(bb$x[2], 2), bb$x[1], bb$y[1], 
		rep(bb$y[2], 2), rep(bb$y[1], 2)), ncol=2)
	gpc_bb <- as(bbmat, "gpc.poly")
	gpc_res <- gpclib:::intersect(gpc, gpc_bb)
	nP <- length(gpc_res@pts)
	Srl <- vector(mode="list", length=nP)
	for (j in 1:nP) {
		crds <- cbind(gpc_res@pts[[j]]$x, gpc_res@pts[[j]]$y)
		crds <- rbind(crds, crds[1,])
		hole <- gpc_res@pts[[j]]$hole
		rD <- .ringDirxy_gpc(crds)
		if (rD == 1 & hole) crds <- crds[nrow(crds):1,]
		if (rD == -1 & !hole)  crds <- crds[nrow(crds):1,]
		Srl[[j]] <- Polygon(coords=crds, hole=hole)
	}
	res <- Polygons(Srl, ID=ID)
	res
    }
}

.ringDirxy_gpc <- function(xy) {
	a <- xy[,1]
	b <- xy[,2]
	nvx <- length(b)

	if((a[1] == a[nvx]) && (b[1] == b[nvx])) {
		a <- a[-nvx]
		b <- b[-nvx]
		nvx <- nvx - 1
	}
	if (nvx < 3) return(1)

	tX <- 0.0
	dfYMax <- max(b)
	ti <- 1
	for (i in 1:nvx) {
		if (b[i] == dfYMax && a[i] > tX) ti <- i
	}
	if ( (ti > 1) & (ti < nvx) ) { 
		dx0 = a[ti-1] - a[ti]
      		dx1 = a[ti+1] - a[ti]
      		dy0 = b[ti-1] - b[ti]
      		dy1 = b[ti+1] - b[ti]
   	} else if (ti == nvx) {
		dx0 = a[ti-1] - a[ti]
      		dx1 = a[1] - a[ti]
      		dy0 = b[ti-1] - b[ti]
      		dy1 = b[1] - b[ti]
   	} else {
#   /* if the tested vertex is at the origin then continue from 0 (1) */ 
     		dx1 = a[2] - a[1]
      		dx0 = a[nvx] - a[1]
      		dy1 = b[2] - b[1]
      		dy0 = b[nvx] - b[1]
   	}
	v3 = ( (dx0 * dy1) - (dx1 * dy0) )
	if ( v3 > 0 ) return(as.integer(1))
   	else return(as.integer(-1))
}

