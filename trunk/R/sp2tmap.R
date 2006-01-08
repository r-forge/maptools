sp2tmap <- function(SP) {
	if (!inherits(SP, "SpatialPolygons"))
		stop("not a SpatialPolygons object")
	pls <- slot(SP, "polygons")
	IDs <- sapply(pls, function(x) slot(x, "ID"))
	oIDs <- order(IDs)
	n <- length(oIDs)
	res <- NULL
	for (i in oIDs) {
		IDi <- IDs[i]
		pl <- slot(pls[[i]], "Polygons")
		m <- length(pl)
		for (j in 1:m) {
			crds <- slot(pl[[j]], "coords")
			nc <- nrow(crds)
			if (is.null(res)) { res <- data.frame(ID=IDi, 
				X=as.numeric(NA), Y=as.numeric(NA))
			} else { res <- rbind(res, data.frame(ID=IDi, 
				X=as.numeric(NA), Y=as.numeric(NA)))
			}
			res <- rbind(res, data.frame(ID=IDi, X=crds[,1], 
				Y=crds[,2]))
		}
	}
	names(res) <- c("_ID", "_X", "_Y")
	res
}
