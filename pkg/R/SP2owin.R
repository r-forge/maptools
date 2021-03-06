.SP2owin <- function(SP) {
    if (!is.na(sp::is.projected(SP)) && !sp::is.projected(SP))
      stop("Only projected coordinates may be converted to spatstat class objects")
    check_spatstat("spatstat.geom")
    pls <- slot(SP, "polygons")
    nParts <- sapply(pls, function(x) length(slot(x, "Polygons")))
    nOwin <- sum(nParts)
    if (nOwin == 1) {
        pl <- slot(pls[[1]], "Polygons")
        crds <- slot(pl[[1]], "coords")
	colnames(crds) <- c("x", "y")
	rD <- pl[[1]]@ringDir
	if (rD == 1) crds <- crds[nrow(crds):1,]
	crds <- crds[-nrow(crds),]
	res <- spatstat.geom::owin(poly=list(x=crds[,1], y=crds[,2]))
    } else if (nOwin > 1) {
        opls <- vector(mode="list", length=nOwin)
        io <- 1
        for (i in seq(along=pls)) {
            pl <- slot(pls[[i]], "Polygons")
            for (j in 1:nParts[i]) {
                crds <- slot(pl[[j]], "coords")
	        colnames(crds) <- c("x", "y")
	        rD <- slot(pl[[j]], "ringDir") # sp:::.spFindCG(crds)$rD
		hole <- slot(pl[[j]], "hole")

	        if (rD == -1 && hole) crds <- crds[nrow(crds):1,]
                else if (rD == 1 && !hole) crds <- crds[nrow(crds):1,]

	        crds <- crds[-nrow(crds),]

                opls[[io]] <- list(x=crds[,1], y=crds[,2])
                io <- io+1
            }
        }
        if (!spatstat.geom::spatstat.options("checkpolygons")) 
        	res <- spatstat.geom::owin(bbox(SP)[1,], bbox(SP)[2,], poly = opls,
			check=FALSE)
# 070718 added check avoidance
	else res <- spatstat.geom::owin(poly=opls)
    } else stop("no valid polygons")
    res
}
