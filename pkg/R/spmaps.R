.NAmat2xyList <- function(xy) {
	NAs <- unclass(attr(na.omit(xy), "na.action"))
	if ((length(NAs) == 1L) && (NAs == nrow(xy))) {
		xy <- xy[-nrow(xy)]
		NAs <- NULL
	}
# NA problem found by Edzer Pebesma, 24/8-06
	diffNAs <- diff(NAs)
	if (any(diffNAs == 1)) {
		xy <- xy[-(NAs[which(diffNAs == 1)] + 1), ]
		NAs <- unclass(attr(na.omit(xy), "na.action"))
	}
	nParts <- length(NAs) + 1L
# two NAs at end of file 070905 RSB
# no NAs at all RSB 080814
	if (!is.null(NAs) && nrow(xy) == NAs[length(NAs)])
            nParts <- nParts - 1
	res <- vector(mode="list", length=nParts)
	from <- integer(nParts)
	to <- integer(nParts)
	from[1] <- 1
	to[nParts] <- nrow(xy)
# two NAs at end of file 070905 RSB
# no NAs at all RSB 080814
	if (!is.null(NAs) && nrow(xy) == NAs[length(NAs)])
            to[nParts] <- to[nParts] - 1
	if (nParts > 1) {
		for (i in 2:nParts) {
			to[(i-1)] <- NAs[(i-1)]-1
			from[i] <- NAs[(i-1)]+1
		}
	}
	for (i in 1:nParts) res[[i]] <- xy[from[i]:to[i],, drop = FALSE]
	res
}

map2SpatialLines <- function(map, IDs=NULL, proj4string=CRS(as.character(NA))) {
	require(maps)
	xyList <- .NAmat2xyList(cbind(map$x, map$y))
	if (is.null(IDs)) IDs <- as.character(1:length(xyList))

	if (length(xyList) != length(IDs)) stop("map and IDs differ in length")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
# assemble the list of Lines
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		nParts <- length(belongs[[i]])
		srl <- vector(mode="list", length=nParts)
		for (j in 1:nParts) {
			crds <- xyList[[belongs[[i]][j]]]
			if (nrow(crds) > 1) srl[[j]] <- Line(coords=crds)
			else srl[[j]] <- Line(coords=rbind(crds, crds))
		}
		Srl[[i]] <- Lines(srl, ID=IDss[i])
	}
	res <- SpatialLines(Srl, proj4string=proj4string)
	res
}

pruneMap <- function(map, xlim=NULL, ylim=NULL) {
	candx <- NULL
	if (!is.null(xlim)) {
		if (length(xlim) != 2L) stop("xlim must be of length 2")
		candx <- which(map$x < xlim[1] | map$x > xlim[2])
	}
	candy <- NULL
	if (!is.null(ylim)) {
		if (length(ylim) != 2L) stop("ylim must be of length 2")
		candy <- which(map$y < ylim[1] | map$y > ylim[2])
	}
	if (is.null(candx) && is.null(candy)) return(map)
	cand <- unique(sort(c(candx, candy)))
	map$x <- map$x[-cand]
	map$y <- map$y[-cand]
	map
}

# to be moved to glue with maps:

map2SpatialPolygons <- function(map, IDs, proj4string=CRS(as.character(NA))) {
	require(maps)
	if (missing(IDs)) stop("IDs required")
	xyList <- .NAmat2xyList(cbind(map$x, map$y))
	if (length(xyList) != length(IDs)) stop("map and IDs differ in length")
	tab <- table(factor(IDs))
	n <- length(tab)
	IDss <- names(tab)
	reg <- match(IDs, IDss)
	belongs <- lapply(1:n, function(x) which(x == reg))
# assemble the list of Srings
	Srl <- vector(mode="list", length=n)
	for (i in 1:n) {
		nParts <- length(belongs[[i]])
		srl <- vector(mode="list", length=nParts)
		for (j in 1:nParts) {
                        crds <- xyList[[belongs[[i]][j]]]
                        if (nrow(crds) == 3) crds <- rbind(crds, crds[1,])
			srl[[j]] <- Polygon(coords=crds)
		}
		Srl[[i]] <- Polygons(srl, ID=IDss[i])
	}
	res <- as.SpatialPolygons.PolygonsList(Srl, proj4string=proj4string)
	res
}

SpatialPolygons2map <- function(spol) {
    stopifnot(inherits(spol, "SpatialPolygons"))
    p4str <- proj4string(spol)
    if (is.na(p4str)) {
        warning("no coordinate reference system")
    } else {
        if (is.projected(spol)) warning("projected coordinates")
    }
    pls <- slot(spol, "polygons")
    n <- length(pls)
    names <- NULL
    range <- c(t(bbox(spol)))
    x <- NULL
    y <- NULL
    for (i in 1:n) {
        nm <- slot(pls[[i]], "ID")
        Pls <- slot(pls[[i]], "Polygons")
        ni <- length(Pls)
        for (j in 1:ni) {
            if (ni == 1) {
                names <- c(names, nm)
            } else {
                names <- c(names, paste(nm, j, sep=":"))
            }
            crds <- slot(Pls[[j]], "coords")
            x <- c(x, crds[,1])
            y <- c(y, crds[,2])
            if (j < ni) {
                x <- c(x, as.numeric(NA))
                y <- c(y, as.numeric(NA))
            }
        }
        if (i < n) {
            x <- c(x, as.numeric(NA))
            y <- c(y, as.numeric(NA))
        }
    }
    res <- list(x=x, y=y, range=range, names=names)
    class(res) <- "map"
    res
}

