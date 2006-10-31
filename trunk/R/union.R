unionSpatialPolygons <- function(SpP, IDs, threshold=NULL) {
	require(gpclib)
	if (!is(SpP, "SpatialPolygons")) stop("not a SpatialPolygons object")
	pl <- getSpPpolygonsSlot(SpP)
	proj4CRS <- CRS(proj4string(SpP))
	SrnParts <- getSpPnParts(SpP)
	if (missing(IDs)) stop("IDs required")
	if (length(pl) != length(IDs)) stop("input lengths differ")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		ii <- belongs[[i]]
		nParts <- length(ii)
		if (nParts == 1) {
			Srl[[i]] <- Polygons(
				getPolygonsPolygonsSlot(pl[[ii[1]]]), 
				ID=IDss[i])
		} else {
			nPi <- SrnParts[belongs[[i]]]
			m <- sum(nPi)
			pli <- vector(mode="list", length=m)
			jj <- 1
			for (j in 1:nParts) {
				SrSrj <- getPolygonsPolygonsSlot(pl[[ii[j]]])
				for (k in 1:nPi[j]) {
					pli[[jj]] <- getPolygonCoordsSlot(
						SrSrj[[k]])
					if (jj <= m) jj <- jj + 1
					else stop("jj out of range")
				}
			}
			iin <- length(pli)
			resi <- as(pli[[1]], "gpc.poly")
			for (j in 2:iin) 
				resi <- gpclib:::union(resi, as(pli[[j]], "gpc.poly"))
			if (!is.null(threshold)) {
				areas <- sapply(resi@pts, function(x) {
				    area.poly(as(cbind(x$x, x$y), "gpc.poly"))})
				resi@pts <- resi@pts[areas > threshold]
			}
			nP <- length(resi@pts)
			Srli <- vector(mode="list", length=nP)
			for (j in 1:nP) {
				crds <- cbind(resi@pts[[j]]$x, resi@pts[[j]]$y)
				crds <- rbind(crds, crds[1,])
				hole <- resi@pts[[j]]$hole
				Srli[[j]] <- Polygon(coords=crds, hole=hole)
			}
			Srl[[i]] <- Polygons(Srli, ID=IDss[i])
		}
	}
	res <- as.SpatialPolygons.PolygonsList(Srl, proj4string=proj4CRS)
	res
}

