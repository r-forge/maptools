nowrapSpatialPolygons <- function(obj, offset=0, eps=rep(.Machine$double.eps, 2)) {
    rgeosI <- rgeosStatus()
    if (rgeosI) {
#        require(rgeos)
    } else {
        stopifnot(isTRUE(gpclibPermitStatus()))
	require(gpclib)
    }
	if (!is(obj, "SpatialPolygons")) stop("obj not a SpatialPolygons object")
	proj <- is.projected(obj)
	if (is.na(proj)) stop("unknown coordinate reference system")
	if (proj) stop("cannot recenter projected coordinate reference system")
	bblong <- bbox(obj)[1,]
	inout <- bblong[1] < offset && bblong[2] >= offset
	if (inout) {
		pls <- slot(obj, "polygons")
		Srl <- lapply(pls, .nowrapPolygons, offset=offset, eps=eps,
                    rgeosI=rgeosI)
		res <- as.SpatialPolygons.PolygonsList(Srl,
			proj4string=CRS(proj4string(obj)))
	} else res <- obj
	res
}

.nowrapPolygons <- function(obj, offset=0, eps=rep(.Machine$double.eps, 2),
     rgeosI) {
	if (!is(obj, "Polygons")) stop("not an Polygons object")
	bbo <- bbox(obj)
	inout <- bbo[1,1] < offset && bbo[1,2] >= offset
	if (inout) {
            if (rgeosI) {
                 bb <- bbox(obj)
                 bb <- list(x=bb[1,], y=bb[2,])
                 bbmatW <- matrix(c(rep(bb$x[1], 2), rep(offset-eps[1], 2), 
                     bb$x[1], bb$y[1], rep(bb$y[2], 2), rep(bb$y[1], 2)), 
                     ncol=2)
                 bbmatE <- matrix(c(rep(offset+eps[2], 2), rep(bb$x[2], 2), 
                     offset+eps[2], bb$y[1], rep(bb$y[2], 2), 
                     rep(bb$y[1], 2)), ncol=2)
#                 resW <- PolygonsIntersections(obj,
#                     Polygons(list(Polygon(bbmatW)), ID="W"))
#                 resE <- PolygonsIntersections(obj,
#                     Polygons(list(Polygon(bbmatE)), ID="E"))
#                 res <- Polygons(c(slot(resW, "Polygons"),
#                     slot(resE, "Polygons")), ID=slot(obj, "ID"))
            } else {
		pls <- slot(obj, "Polygons")
		nParts <- length(pls)
		ID <- slot(obj, "ID")
		gpc <- as(slot(pls[[1]], "coords"), "gpc.poly")
		if (nParts > 1) for (i in 2:nParts) gpc <- append.poly(gpc, 
			as(slot(pls[[i]], "coords"), "gpc.poly"))
		bb <- get.bbox(gpc)
		bbmat1 <- matrix(c(rep(bb$x[1], 2), rep(offset-eps[1], 2), 
			bb$x[1], bb$y[1], rep(bb$y[2], 2), rep(bb$y[1], 2)), 
			ncol=2)
		bbmat2 <- matrix(c(rep(offset+eps[2], 2), rep(bb$x[2], 2), 
			offset+eps[2], bb$y[1], rep(bb$y[2], 2), 
			rep(bb$y[1], 2)), ncol=2)
		gpc_left <- gpclib:::intersect(gpc, as(bbmat1, "gpc.poly"))
		gpc_right <- gpclib:::intersect(gpc, as(bbmat2, "gpc.poly"))
		gpc_res <- append.poly(gpc_left, gpc_right)
		nP <- length(gpc_res@pts)
		if (nP == 0)
			return(obj)
		Srl <- vector(mode="list", length=nP)
		for (j in 1:nP) {
			crds <- cbind(gpc_res@pts[[j]]$x, gpc_res@pts[[j]]$y)
			crds <- rbind(crds, crds[1,])
			hole <- gpc_res@pts[[j]]$hole
			rD <- .ringDirxy(crds)
			if (rD == 1 & hole) crds <- crds[nrow(crds):1,]
			if (rD == -1 & !hole)  crds <- crds[nrow(crds):1,]
			Srl[[j]] <- Polygon(coords=crds, hole=hole)
		}
		res <- Polygons(Srl, ID=ID)
            }
	} else res <- obj
	res
}

nowrapRecenter <- function(obj, offset=0, eps=rep(.Machine$double.eps, 2)) {
	res <- recenter(nowrapSpatialPolygons(obj, offset=offset, eps=eps))
	res
}
