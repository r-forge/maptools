# Copyright 2000-2001 (c) Nicholas Lewin-Koh 
# modifications 2001-2005 Roger Bivand
# reads an ESRI shapefile into a map object
# set the variables for the header info


read.shape <- function(filen, dbf.data=TRUE, verbose=TRUE, repair=FALSE) {
  filen <- path.expand(filen)
  shinfo <- getinfo.shape(filen)
  if (dbf.data) {
#    library(foreign)
    df <- read.dbf(filen)
    ndf <- as.integer(nrow(df))
  } else ndf <- as.integer(NA)
  if (shinfo[[2]] == 8) {
    if (!dbf.data) stop("to test for multipoint compliance, set dbf.data=TRUE")
    if (ndf != shinfo[[3]]) stop("noncompliant multipoint shapefile")
  }
  shp.lst <- .Call("Rshapeget", as.character(filen), as.logical(repair), 
    PACKAGE="maptools")
  if (verbose) {
    print(shinfo)
  }
  n <- length(shp.lst)
  for (i in 1:n) {
    attr(shp.lst[[i]], "nVerts") <- as.integer(shp.lst[[i]]$nVerts)
    attr(shp.lst[[i]], "nParts") <- as.integer(shp.lst[[i]]$nParts)
    attr(shp.lst[[i]], "shp.type") <- as.integer(shp.lst[[i]]$shp.type)
    attr(shp.lst[[i]], "bbox") <- as.double(shp.lst[[i]]$bbox)
  }
  class(shp.lst) <- "ShapeList"
  if (dbf.data) {
    map <- list(Shapes=shp.lst, att.data=df)
    class(map) <- "Map"
    return(map)
  }
  else {
    return(shp.lst)
  }
}

getinfo.shape <- function(filen) {
  shptype <- 0
  nRecords <- 0
  MinBounds <- c(0,0,0,0)
  MaxBounds <- c(0,0,0,0)
  shapehead <-.C("Rshapeinfo", as.character(filen),
               as.integer(shptype), as.integer(nRecords), as.double(MinBounds),
               as.double(MaxBounds), PACKAGE="maptools")
  class(shapehead) <- "shapehead"
  shapehead
}

print.shapehead <- function(x, ...) {
    types <- c("Point", NA, "PolyLine", NA, "Polygon", NA, NA, "MultiPoint", NA, NA, "PointZ", NA, "PolyLineZ", NA, "PolygonZ", NA, NA, "MultiPointZ", NA, NA, "PointM", NA, "PolyLineM", NA, "PolygonM", NA, NA, "MultiPointM", NA, NA, "MultiPatch")
    cat("Shapefile type: ", types[x[[2]]], ", (", x[[2]], "), # of Shapes: ", 
      x[[3]], "\n", sep="")
}


#write.pointShape <- function(object, file, coordinates, factor2char=TRUE, 
write.pointShape <- function(coordinates, df, file, factor2char=TRUE, 
  strictFilename=FALSE) {
  file <- path.expand(file)
  if (strictFilename && nchar(basename(file)) > 8) 
    stop("shapefile names must conform to the 8.3 format")
  if (!is.matrix(coordinates)) stop("coordinates must be a matrix")
  if (!is.numeric(coordinates)) stop("coordinates must be numeric")
  if (ncol(coordinates) != 2) stop("coordinates must have 2 columns")
  if (nrow(df) != nrow(coordinates))
    stop("different number of rows in coordinates and data frame")
#  library(foreign)
  write.dbf(df, paste(file, ".dbf", sep=""), factor2char=factor2char)
  res <- .Call("shpwritepoint", as.character(file), as.double(coordinates),
    PACKAGE="maptools")
  invisible(res)
}

.isValidPolylist <- function(polylist, verbose=FALSE) {
  if (!inherits(polylist, "polylist")) stop("not a polylist object")
  res <- TRUE
  if (length(polylist) < 1) {
    if (verbose) cat("zero length polylist\n")
    res <- FALSE
  }
  if (!all(sapply(polylist, function(x) is.double(x)))) {
    if (verbose) cat("coordinates not all double\n")
    res <- FALSE
  }
  if (any(sapply(polylist, function(x) is.null(attr(x, "nParts"))))) {
    if (verbose) cat("null polylist nParts attribute\n")
    res <- FALSE
  } else {
    if (any(sapply(polylist, function(x) attr(x, "nParts") < 1))) {
      if (verbose) cat("polylist nParts attribute less than 1\n")
      res <- FALSE
    }
    if (!all(sapply(polylist, function(x) is.integer(attr(x, "nParts"))))) {
      if (verbose) cat("nParts not all integer\n")
      res <- FALSE
    }
  }
  if (any(sapply(polylist, function(x) is.null(attr(x, "pstart"))))) {
    if (verbose) cat("null polylist pstart attribute\n")
    res <- FALSE
  } else {
    if (any(sapply(polylist, function(x) is.null(attr(x, "pstart")$from)))) {
      if (verbose) cat("null polylist pstart$from attribute\n")
      res <- FALSE
    } else {
      if (!all(sapply(polylist, function(x) is.integer(attr(x, 
        "pstart")$from)))) {
        if (verbose) cat("pstart$from not all integer\n")
        res <- FALSE
      }
    }
    if (any(sapply(polylist, function(x) is.null(attr(x, "pstart")$to)))) {
      if (verbose) cat("null polylist pstart$to attribute\n")
      res <- FALSE
    } else {
      if (!all(sapply(polylist, function(x) is.integer(attr(x, 
        "pstart")$to)))) {
        if (verbose) cat("pstart$to not all integer\n")
        res <- FALSE
      }
    }
  }
  res
}

.makePolylistValid <- function(polylist) {
  if (!inherits(polylist, "polylist")) stop("not a polylist object")
  if (length(polylist) < 1) stop("zero length polylist")
  n <- length(polylist)
  if (!all(sapply(polylist, function(x) is.double(x)))) {
    for (i in 1:n) { 
      a <- attributes(polylist[[i]])
      polylist[[i]] <- matrix(as.double(polylist[[i]]), ncol=2)
      attributes(polylist[[i]]) <- a
    }
    warning("coordinates changed to double")
  }
  if (any(sapply(polylist, function(x) is.null(attr(x, "nParts"))))) {
    for (i in 1:n) {
      if (any(is.na(c(polylist[[i]])))) {
	xy <- polylist[[i]]
        NAs <- unclass(attr(na.omit(xy), "na.action"))
	nParts <- length(NAs) + 1
	from <- integer(nParts)
	to <- integer(nParts)
	from[1] <- 1
	to[nParts] <- nrow(xy)
	if (nParts > 1) {
		for (j in 2:nParts) {
			to[(j-1)] <- NAs[(j-1)]-1
			from[j] <- NAs[(j-1)]+1
		}
	}
        attr(polylist[[i]], "nParts") <- as.integer(nParts)
        a <- list()
	a$from <- as.integer(from)
	a$to <- as.integer(to)
        attr(polylist[[i]], "pstart") <- a
      } else {
        attr(polylist[[i]], "nParts") <- as.integer(1)
        a <- list()
	a$from <- as.integer(1)
	a$to <- as.integer(nrow(polylist[[i]]))
        attr(polylist[[i]], "pstart") <- a
      }
      attr(polylist[[i]], "ringDir") <- as.integer(rep(1,
        attr(polylist[[i]], "nParts")))
      attr(polylist[[i]], "plotOrder") <- 
	as.integer(1:attr(polylist[[i]], "nParts"))
    }
    warning("nParts and pstart added")
  }
  if (any(sapply(polylist, function(x) attr(x, "nParts") < 1)))
    stop("polylist nParts attribute less than 1")
  if (!all(sapply(polylist, function(x) is.integer(attr(x, "nParts"))))) {
    for (i in 1:n) attr(polylist[[i]], "nParts") <- 
		as.integer(attr(polylist[[i]], "nParts"))
    warning("nParts changed to integer")
  }
  if (any(sapply(polylist, function(x) is.null(attr(x, "pstart"))))) {
    for (i in 1:n) {
      if (any(is.na(c(polylist[[i]])))) {
	xy <- polylist[[i]]
        NAs <- unclass(attr(na.omit(xy), "na.action"))
	nParts <- length(NAs) + 1
	from <- integer(nParts)
	to <- integer(nParts)
	from[1] <- 1
	to[nParts] <- nrow(xy)
	if (nParts > 1) {
		for (j in 2:nParts) {
			to[(j-1)] <- NAs[(j-1)]-1
			from[j] <- NAs[(j-1)]+1
		}
	}
        attr(polylist[[i]], "nParts") <- as.integer(nParts)
        a <- list()
	a$from <- as.integer(from)
	a$to <- as.integer(to)
        attr(polylist[[i]], "pstart") <- a
      } else {
        attr(polylist[[i]], "nParts") <- as.integer(1)
        a <- list()
	a$from <- as.integer(1)
	a$to <- as.integer(nrow(polylist[[i]]))
        attr(polylist[[i]], "pstart") <- a
      }
      attr(polylist[[i]], "ringDir") <- as.integer(rep(1,
        attr(polylist[[i]], "nParts")))
      attr(polylist[[i]], "plotOrder") <- 
	as.integer(1:attr(polylist[[i]], "nParts"))
    }
    warning("nParts and pstart added")
  }
  if (!all(sapply(polylist, function(x) is.integer(attr(x, "pstart")$from)))) {
    for (i in 1:n) attr(polylist[[i]], "pstart")$from <- 
		as.integer(attr(polylist[[i]], "pstart")$from)
    warning("pstart$from changed to integer")
  }
  if (!all(sapply(polylist, function(x) is.integer(attr(x, "pstart")$to)))) {
    for (i in 1:n) attr(polylist[[i]], "pstart")$to <- 
		as.integer(attr(polylist[[i]], "pstart")$to)
    warning("pstart$to changed to integer")
  }
  polylist
}

write.polylistShape <- function(polylist, df, file, factor2char=TRUE, 
  strictFilename=FALSE, force=FALSE) {
  file <- path.expand(file)
  if (strictFilename && nchar(basename(file)) > 8) 
    stop("shapefile names must conform to the 8.3 format")
  if (!inherits(polylist, "polylist")) stop("not a polylist object")
  if (length(polylist) < 1) stop("zero length polylist")
  if (nrow(df) != length(polylist))
    stop("different number of rows in polylist and data frame")
  if (!.isValidPolylist(polylist)) {
    if (!force)
      stop("Invalid polylist - set force=TRUE to coerce to validity")
    else polylist <- .makePolylistValid(polylist)
  }
#  library(foreign)
  write.dbf(df, paste(file, ".dbf", sep=""), factor2char=factor2char)
  res <- .Call("shpwritepolys", as.character(file), polylist, 
    PACKAGE="maptools")
  invisible(res)
}

write.linelistShape <- function(linelist, df, file, factor2char=TRUE, 
  strictFilename=FALSE) {
  file <- path.expand(file)
  if (strictFilename && nchar(basename(file)) > 8) 
    stop("shapefile names must conform to the 8.3 format")
  if (length(linelist) < 1) stop("zero length linelist")
  if (nrow(df) != length(linelist))
    stop("different number of rows in linelist and data frame")
  if (!all(sapply(linelist, function(x) all(!is.na(x)))))
    stop("NAs in line coordinate data")
  if (!any(sapply(linelist, function(x) is.double(x)))) {
    for (i in 1:length(linelist)) { 
      linelist[[i]] <- matrix(as.double(linelist[[i]]), ncol=2)
    }
    warning("coordinates changed to double")
  }
#  library(foreign)
  write.dbf(df, paste(file, ".dbf", sep=""), factor2char=factor2char)
  res <- .Call("shpwritelines", as.character(file), linelist, 
    PACKAGE="maptools")
  invisible(res)
}

