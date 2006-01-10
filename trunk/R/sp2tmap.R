sp2tmap <- function(SP) {
	if (!inherits(SP, "SpatialPolygons"))
		stop("not a SpatialPolygons object")
	pls <- slot(SP, "polygons")
	IDs <- sapply(pls, function(x) slot(x, "ID"))
	aIDs <- make.names(abbreviate(IDs, 1), unique=TRUE)
	oIDs <- order(aIDs)
	n <- length(oIDs)
	cID <- NULL
	cX <- NULL
	cY <- NULL
	for (i in oIDs) {
		IDi <- aIDs[i]
		pl <- slot(pls[[i]], "Polygons")
		m <- length(pl)
		for (j in 1:m) {
			crds <- slot(pl[[j]], "coords")
			nc <- nrow(crds)
			if (is.null(cID)) { 
				cID <- IDi
				cX <- as.numeric(NA)
				cY=as.numeric(NA)
			} else { 
				cID <- c(cID, IDi)
				cX <- c(cX, as.numeric(NA))
				cY <- c(cY, as.numeric(NA))
			}
			cID <- c(cID, rep(IDi, nrow(crds)))
			cX <- c(cX, crds[,1])
			cY <- c(cY, crds[,2])
		}
	}
	res <- data.frame("_ID"=cID, "_X"=cX, "_Y"=cY, check.names=FALSE)
	attr(res, "mangled_names") <- aIDs
	res
}
