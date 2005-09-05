readShapePoly <- function(fn, proj4string=CRS(as.character(NA)), 
	verbose=FALSE) {
	.Map2PolyDF(read.shape(filen=fn, verbose=verbose), 
		proj4string=proj4string)
}

writePolyShape <- function(x, fn, factor2char = TRUE) {
	df <- as(x, "data.frame")
	df <- data.frame(SP_ID=I(row.names(df)), df)
	pls <- .SpP2polylist(as(x, "SpatialPolygons"))
	write.polylistShape(pls, df, file=fn, factor2char = factor2char)
}

.Map2PolyDF <- function(Map, IDs, proj4string=CRS(as.character(NA))) {
	if (missing(IDs))
		IDs <- as.character(sapply(Map$Shapes, function(x) x$shpID))
	SR <- .asSpatialPolygonsShapes(Map$Shapes, IDs, 
		proj4string=proj4string)
	df <- Map$att.data
	rownames(df) <- IDs
	res <- SpatialPolygonsDataFrame(Sr=SR, data=df)
	res
}

.asSpatialPolygonsShapes <- function(shapes, IDs, 
	proj4string=CRS(as.character(NA))) {
	if (attr(shapes, "shp.type") != "poly")
		stop("Not polygon shapes")
	if (missing(IDs))
		IDs <- as.character(sapply(shapes, function(x) x$shpID))
	if (length(IDs) != attr(shapes,'nshps')) 
		stop("Number of shapes and IDs differ")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
# assemble the list of Srings
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		nParts <- length(belongs[[i]])
		srl <- NULL
		for (j in 1:nParts) {
			jres <- .shp2srsI(shapes[[belongs[[i]][j]]], 
				.nParts.shpI(shapes[[belongs[[i]][j]]]))
			srl <- c(srl, jres)
		}
		Srl[[i]] <- Polygons(srl, ID=IDss[i])
	}
	res <- as.SpatialPolygons.PolygonsList(Srl, proj4string=proj4string)
	res
}

.shp2srsI <- function(shp, nParts) {
	Pstart <- shp$Pstart
	nVerts <- nrow(shp$verts)
	from <- integer(nParts)
	to <- integer(nParts)
	from[1] <- 1
	for (j in 1:nParts) {
		if (j == nParts) to[j] <- nVerts
		else {
			to[j] <- Pstart[j+1]
			from[j+1] <- to[j]+1
		}
	}
	srl <- vector(mode="list", length=nParts)
	for (j in 1:nParts) {
		srl[[j]] <- Polygon(coords=shp$verts[from[j]:to[j],])
	}
	srl
}

.nParts.shpI <- function(shp) attr(shp, "nParts")

.xyList2NAmat <- function(xyList) {
	nParts <- length(xyList)
	res <- xyList[[1]]
	if (nParts > 1) {
		for(i in 2:nParts) 
			res <- rbind(res, c(NA,NA), xyList[[i]])
	}
	res
}

.SpP2polylist <- function(x) {
	pls <- getSpPpolygonsSlot(x)
	n <- length(pls)
	res <- vector(mode="list", length=n)
	for (i in 1:n) {
		xyL <- lapply(getPolygonsPolygonsSlot(pls[[i]]), 
			getPolygonCoordsSlot)
		nP <- length(xyL)
		nVs <- sapply(xyL, nrow)
		res[[i]] <- .xyList2NAmat(xyL)
		attr(res[[i]], "nParts") <- as.integer(nP)
		from <- integer(nP)
		to <- integer(nP)
		from[1] <- 1
		to[1] <- nVs[1]
		if (nP > 1) for (j in 2:nP) {
			from[j] <- to[(j-1)] + 2
			to[j] <- from[j] + nVs[j] - 1
		}
		attr(res[[i]], "pstart") <- list(from=as.integer(from), 
			to=as.integer(to))
		attr(res[[i]], "bbox") <- c(bbox(pls[[i]]))
	}
	attr(res, "region.id") <- getSpPPolygonsIDSlots(x)
	class(res) <- "polylist"
	invisible(res)
}


