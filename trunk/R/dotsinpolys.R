# Copyright 2004 (c) Roger Bivand

dotsInPolys <- function(pl, x, f=csr) {
    if (!inherits(pl, "polylist")) stop("not a polylist object")
    if (length(pl) != length(x)) stop("different lengths")
    if (!inherits(x, "integer")) {
        x <- as.integer(x)
        warning("x coerced to integer")
    }
    if (!require(splancs)) stop("splancs package required for this function")
    n <- length(pl)
    if (n < 1) stop("zero length polylist")
    res <- vector(mode="list", length=n)
    for (i in 1:n) {
        if (x[i] > 0) {
            if (is.null(attr(pl[[i]], "nParts")) || 
		attr(pl[[i]], "nParts") == 1) {
                if (attr(pl[[i]], "ringDir") != 1)
                    warning(paste("hole with content at:", i))
                res[[i]] <- f(matrix(c(pl[[i]]), ncol=2), x[i])
            } else if (length(attr(pl[[i]], "nParts")) > 1) {
                areas <- rep(0, attr(pl[[i]], "nParts"))
                for (j in 1:attr(pl[[i]], "nParts")) {
                    if (attr(pl[[i]], "ringDir")[j] == 1) {
                        from <- attr(pl[[i]], "pstart")$from[j]
                        to <- attr(pl[[i]], "pstart")$to[j]
                        areas[j] <- areapl(matrix(c(pl[[i]][from:to,]), 
                            ncol=2))
                    }
                }
                pareas <- areas/sum(areas)
                px <- as.integer(round(pareas*x[i], digits = 0))
                for (j in 1:attr(pl[[i]], "nParts")) {
                    if (px[j] > 0) {
                        from <- attr(pl[[i]], "pstart")$from[j]
                        to <- attr(pl[[i]], "pstart")$to[j]
                        pj <- matrix(c(pl[[i]][from:to,]), ncol=2)
                        res[[i]] <- rbind(res[[i]], f(pj, px[j]))
                    }
                }
                res[[i]] <- matrix(res[[i]], ncol=2)
            }
        }
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


