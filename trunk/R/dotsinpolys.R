# Copyright 2004-5 (c) Roger Bivand

dotsInPolys <- function(pl, x, f="random", compatible=FALSE) {
    if (!is.character(f)) stop("f must be a character string")
    if (f != "random" && f != "regular") stop(paste(f, "not supported"))
    if (inherits(pl, "polylist")) pl <- .polylist2SpP(pl)
    if (!is(pl, "SpatialPolygons")) stop("unknown class of input polygons")
    pls <- getSpPpolygonsSlot(pl)
    IDs <- getSpPPolygonsIDSlots(pl)
    if (length(pls) != length(x)) stop("different lengths")
    if (!inherits(x, "integer")) {
        x <- as.integer(x)
        warning("x coerced to integer")
    }
    n <- length(pls)
    if (n < 1) stop("zero Polygons")
    res <- vector(mode="list", length=n)
    ID_out <- NULL
    for (i in 1:n) {
cat("i", i, "\n")
        if (x[i] > 0) {
            res[[i]] <- sample.Polygons(pls[[i]], x[i], type=f)
	    ID_out <- c(ID_out, IDs[i])
	}
    }
    if (!compatible) {
        resa <- do.call("rbind", lapply(res, function(x) 
	    if(!is.null(x)) coordinates(x)))
	reps <- unlist(sapply(res, function(x) 
	    if(!is.null(x)) nrow(coordinates(x))))
	res <- data.frame(resa, rep(ID_out, reps))
	names(res) <- c("x", "y", "ID")
	coordinates(res) <- c("x", "y")
    }
    res
}

symbolsInPolys <- function(pl, dens, symb="+") {
    if (!inherits(pl, "polylist")) stop("not a polylist object")
    library(splancs)
    n <- length(pl)
    if (n < 1) stop("zero length polylist")
    if (n != length(dens)) dens <- rep(dens[1], n)
    if (n != length(symb)) symb <- rep(symb[1], n)
    areas <- vector(mode="list", n)
    for (i in 1:n) {
        if (is.null(attr(pl[[i]], "nParts")) || 
	    attr(pl[[i]], "nParts") == 1) {
            areas[[i]] <- areapl(matrix(c(pl[[i]]), ncol=2))
        } else if (length(attr(pl[[i]], "nParts")) > 1) {
            res <- rep(0, attr(pl[[i]], "nParts"))
            for (j in 1:attr(pl[[i]], "nParts")) {
                if (attr(pl[[i]], "ringDir")[j] == 1) {
                    from <- attr(pl[[i]], "pstart")$from[j]
                    to <- attr(pl[[i]], "pstart")$to[j]
                    res[j] <- areapl(matrix(c(pl[[i]][from:to,]), ncol=2))
                }
            }
            areas[[i]] <- res
        }
    }
    counts <- vector(mode="list", n)
    for (i in 1:n) 
        if (!is.null(areas[[i]])) 
            counts[[i]] <- as.integer(areas[[i]] * dens[i])
    points <- vector(mode="list", n)
    for (i in 1:n) {
        if (is.null(attr(pl[[i]], "nParts")) || 
	    attr(pl[[i]], "nParts") == 1) {
            if (counts[[i]] > 0) {
                points[[i]] <- gridpts(matrix(c(pl[[i]]), ncol=2), counts[[i]])
                attr(points[[i]], "symb") <- symb[i]
            }
        } else if (length(attr(pl[[i]], "nParts")) > 1) {
            for (j in 1:attr(pl[[i]], "nParts")) {
                px <- counts[[i]][j]
                if (px > 0) {
                    from <- attr(pl[[i]], "pstart")$from[j]
                    to <- attr(pl[[i]], "pstart")$to[j]
                    pj <- matrix(c(pl[[i]][from:to,]), ncol=2)
                    points[[i]] <- rbind(points[[i]], gridpts(pj, px))
                }
            }
            points[[i]] <- matrix(points[[i]], ncol=2)
            attr(points[[i]], "symb") <- symb[i]
        }
    }
    points
}


