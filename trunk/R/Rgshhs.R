# Copyright (c) 2005-8 Roger Bivand

Rgshhs <- function(fn, xlim=NULL, ylim=NULL, level=4, minarea=0, 
	shift=FALSE, verbose=TRUE, no.clip = FALSE) {
	if (!is.character(fn)) stop("file name must be character string")
	if (length(fn) != 1) stop("file name must be single character string")
	dolim <- FALSE
	dolim <- (!is.null(xlim) || !is.null(ylim))
	if (!is.null(xlim)) lim <- xlim
	else lim <- c(-180, 360)
	if (!is.null(ylim)) lim <- c(lim, ylim)
	else lim <- c(lim, c(-90, 90))
	polydata <- .Call("Rgshhs", as.character(fn), as.integer(1), 
		as.logical(dolim), as.numeric(lim), as.integer(level), 
		as.double(minarea), PACKAGE="maptools")
        line <- median(polydata$line)
        if (verbose) cat("Data are", ifelse(line == 0, "polygon", "line"),
                "data\n")
	chosen_0 <- .Call("Rgshhs", as.character(fn), as.integer(2), 
		as.logical(dolim), as.numeric(lim), as.integer(level), 
		as.double(minarea), PACKAGE="maptools")
	if (dolim) clip <- .Call("Rgshhs", as.character(fn), as.integer(3), 
		as.logical(dolim), as.numeric(lim), as.integer(level), 
		as.double(minarea), PACKAGE="maptools")
	else clip <- NULL
	polys <- .Call("Rgshhs", as.character(fn), as.integer(5), 
		as.logical(dolim), as.numeric(lim), as.integer(level), 
		as.double(minarea), PACKAGE="maptools")

	Antarctica <- which(polydata$area[(chosen_0+1)] > 1.3e+07 & 
		polydata$area[(chosen_0+1)] < 1.4e+07)
	if (length(Antarctica) == 1) {
		if (verbose) cat("Polygon", which(chosen_0 == (Antarctica-1)), 
			"is Antarctica\n")
		if (verbose) cat("  area", polydata$area[Antarctica], "\n")
		if (verbose) cat("  dropping south edge to", lim[3], "\n")
		crds <- polys[[which(chosen_0 == (Antarctica-1))]]
#	    	if (verbose) print(crds[c(1,2,(nrow(crds)-5):nrow(crds)),])
		crds <- rbind(crds[1:(nrow(crds)-2),], 
			c(0, crds[(nrow(crds)-2),2]), c(0, lim[3]), 
			c(360, lim[3]), crds[1,,drop=FALSE])
#	    	if (verbose) print(crds[c(1,2,(nrow(crds)-5):nrow(crds)),])
		polys[[which(chosen_0 == (Antarctica-1))]] <- crds
	}

	if (!no.clip && dolim && any(clip == 1) && line == 0) {
		limbb <- cbind(c(lim[1], lim[1], lim[2], lim[2], lim[1]), 
			c(lim[3], lim[4], lim[4], lim[3], lim[3]))
		require("gpclib")
		limgp <- as(limbb, "gpc.poly")
		which_null <- NULL
		opolys <- vector(mode="list", length=length(polys))
		ic <- 1
		if (verbose) cat("Rgshhs: clipping", sum(clip), "of", 
			length(polys), "polygons ...\n")
		for (i in seq(along=polys)) {
			if (clip[i] == 1) {
				tp <- as(polys[[i]], "gpc.poly")
				rp <- gpclib:::intersect(tp, limgp)
				l <- length(rp@pts)
				if (l > 0) {
				    outl <- vector(mode="list", length=l)
				    for (j in 1:l) 
					outl[[j]] <- as(rp[j], "matrix")
				    opolys[[ic]] <- outl
				    if (i < length(polys)) ic <- ic+1
				} else {
					which_null <- c(which_null, i)
					if (verbose) cat("null polygon: [[",i,
					    "]]\n", sep="");
				}
			} else {
			    opolys[[ic]] <- list(polys[[i]])
			    if (i < length(polys)) ic <- ic+1
			}
		}
		polys <- opolys[1:ic]
	} else {
		for (i in seq(along=polys)) polys[[i]] <- list(polys[[i]])
		which_null <- NULL
	}

	if (!is.null(which_null)) chosen_0 <- chosen_0[-which_null]
	chosen_1 <- chosen_0+1
	levels <- polydata$level[chosen_1]
	if (line == 0) {
	  belongs <- matrix(1:length(chosen_1), ncol=1)
#	  belonged_to <- as.numeric(rep(NA, length(chosen_1)))


	  if (level > 1 && any(levels > 1)) {
	    if (verbose) {
		cat("Rgshhs: assigning enclosed polygons to their enclosers\n")
		cat("  level tallies:\n")
		print(table(levels))
		cat("...\n")
	    }
	    mlevel <- as.integer(max(levels))
	    belongs <- matrix(rep(1:length(chosen_1), mlevel), ncol=mlevel)
	    first_time <- TRUE
	    require("gpclib")
	    for (il in mlevel:2) {
		w_il <- which(levels == il)
		w_il_1 <- which(levels == (il-1))
		if (length(w_il) > 0) {
			if (length(w_il_1) == 1) {
			    belongs[w_il, (il-1)] <- w_il_1
			    if (!first_time) {
				prom <- which(!is.na(match(belongs[,il], w_il)))
				belongs[prom, (il-1)] <- rep(w_il_1, 
				    length(prom))
			    }
			    first_time <- FALSE
			} else {
			    l_1 <- vector(mode="list", length=length(w_il_1))
			    for (i in 1:length(w_il_1)) {
				ii <- w_il_1[i]
				lp1 <- as(polys[[ii]][[1]], "gpc.poly")
				if (length(polys[[ii]]) > 1) {
				    for (j in 2:length(polys[[ii]])) {
					lpj <- as(polys[[ii]][[j]], "gpc.poly")
					lp1 <- append.poly(lp1, lpj)
				    }
				}
				l_1[[i]] <- lp1
			    }
			    for (i in 1:length(w_il)) {
				ii <- w_il[i]
				lp1 <- as(polys[[ii]][[1]], "gpc.poly")
				if (length(polys[[ii]]) > 1) {
				    for (j in 2:length(polys[[ii]])) {
					lpj <- as(polys[[ii]][[j]], "gpc.poly")
					lp1 <- append.poly(lp1, lpj)
				    }
				}
				for (j in 1:length(l_1)) {
				    tp <- gpclib:::intersect(l_1[[j]], lp1)
				    if (length(tp@pts) > 0) {
					belongs[w_il[i], (il-1)] <- w_il_1[j]
			    		if (!first_time) {
					    prom <- which(!is.na(match(
						belongs[,il], w_il[i])))
					    belongs[prom, (il-1)] <- w_il_1[j]
					}
					break
				    }
				}
			    }
			    first_time <- FALSE
			}
		}
	    }
	  }

	  if (verbose) cat("Rgshhs: constructing SpatialPolygons ...\n")
	  holes <- !as.logical(levels %% 2)
	  nps <- sapply(polys, length)
	  IDs <- polydata$id[chosen_1[belongs[,1]]]
	  tab <- table(factor(IDs))
	  n <- length(tab)
	  IDss <- names(tab)
	  reg <- match(IDs, IDss)
	  new_belongs <- lapply(1:n, function(x) which(x == reg))
	  Srl <- vector(mode="list", length=n)
	  require("sp")
	  for (i in 1:n) {
		nParts <- length(new_belongs[[i]])
		srl <- NULL
		for (j in 1:nParts) {
		    this <- new_belongs[[i]][j]
		    for (k in 1:nps[this]) {
			crds <- polys[[this]][[k]]
			if (!identical(crds[1,], crds[nrow(crds),])) {
			    crds <- rbind(crds, crds[1,,drop=FALSE])
			    if (verbose) 
			        cat("  closing polygon", this, ":", k, "\n")
			}
			if (shift) crds[,1] <- ifelse(crds[,1] > 180, 
			    crds[,1] - 360, crds[,1])
			jres <- list(Polygon(crds, hole=holes[this]))
			srl <- c(srl, jres)
		    }
		}
		Srl[[i]] <- Polygons(srl, ID=IDss[i])
	  }
	  res <- as.SpatialPolygons.PolygonsList(Srl, 
		proj4string=CRS("+proj=longlat +datum=WGS84"))
	  list(polydata=data.frame(polydata)[chosen_1,], belongs=belongs,
		new_belongs=new_belongs, SP=res)
	} else {
	  Sll <- lapply(1:length(polys), function(i) {
              ID <- as.character(i)
              crds <- polys[[i]][[1]]
		if (shift) crds[,1] <- ifelse(crds[,1] > 180, 
		    crds[,1] - 360, crds[,1])
              Ln <- Line(crds)
              Lines(list(Ln), ID=ID)
            })
          res <- SpatialLines(Sll, 
            proj4string=CRS("+proj=longlat +datum=WGS84"))
	  list(SP=res)
	}
}
