.SP2owin <- function(SP) {
    require(spatstat)
    nParts <- getSpPnParts(SP)
    nOwin <- sum(nParts)
    pls <- getSpPpolygonsSlot(SP)
    if (nOwin == 1) {
        pl <- getPolygonsPolygonsSlot(pls[[1]])
        crds <- getPolygonCoordsSlot(pl[[1]])
	colnames(crds) <- c("x", "y")
	rD <- pl[[1]]@ringDir
	if (rD == 1) crds <- crds[nrow(crds):1,]
	crds <- crds[-nrow(crds),]
	res <- owin(poly=list(x=crds[,1], y=crds[,2]))
    } else if (nOwin > 1) {
        opls <- vector(mode="list", length=nOwin)
        io <- 1
        for (i in seq(along=pls)) {
            pl <- getPolygonsPolygonsSlot(pls[[i]])
            for (j in 1:nParts[i]) {
                crds <- getPolygonCoordsSlot(pl[[j]])
	        colnames(crds) <- c("x", "y")
	        rD <- sp:::.spFindCG(crds)$rD
		hole <- getPolygonHoleSlot(pl[[j]])

	        if (rD == -1 && hole) crds <- crds[nrow(crds):1,]
                else if (rD == 1 && !hole) crds <- crds[nrow(crds):1,]

	        crds <- crds[-nrow(crds),]

                opls[[io]] <- list(x=crds[,1], y=crds[,2])
                io <- io+1
            }
        }
        res <- owin(poly=opls)
    } else stop("no valid polygons")
    res
}


