# Copyright 2000-2001 (c) Nicholas Lewin-Koh 
# modifications 2001-2004 Roger Bivand
# reads an ESRI shapefile into a map object
# set the variables for the header info


read.shape <- function(filen, dbf.data=TRUE, verbose=TRUE) {
  filen <- path.expand(filen)
  shp.lst <- .Call("Rshapeget", as.character(filen), PACKAGE="maptools")
  if (verbose) {
    shinfo <- getinfo.shape(filen)
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
    library(foreign)
    df <- read.dbf(filen)
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


write.pointShape <- function(object, file, coordinates, factor2char=TRUE, 
  strictFilename=FALSE) {
  file <- path.expand(file)
  if (strictFilename && nchar(basename(file)) > 8) 
    stop("shapefile names must conform to the 8.3 format")
  if (!is.matrix(coordinates)) stop("coordinates must be a matrix")
  if (!is.numeric(coordinates)) stop("coordinates must be numeric")
  if (ncol(coordinates) != 2) stop("coordinates must have 2 columns")
  if (nrow(object) != nrow(coordinates))
    stop("different number of rows in coordinates and data frame")
  library(foreign)
  write.dbf(object, paste(file, ".dbf", sep=""), factor2char=factor2char)
  res <- .Call("shpwritepoint", as.character(file), as.double(coordinates),
    PACKAGE="maptools")
  invisible(res)
}

write.polylistShape <- function(polylist, df, file, factor2char=TRUE, 
  strictFilename=FALSE) {
  file <- path.expand(file)
  if (strictFilename && nchar(basename(file)) > 8) 
    stop("shapefile names must conform to the 8.3 format")
  if (!inherits(polylist, "polylist")) stop("not a polylist object")
  if (length(polylist) < 1) stop("zero length polylist")
  if (nrow(df) != length(polylist))
    stop("different number of rows in polylist and data frame")
  if (!all(sapply(polylist, function(x) is.double(x)))) {
    for (i in 1:length(polylist)) { 
      a <- attributes(polylist[[i]])
      polylist[[i]] <- matrix(as.double(polylist[[i]]), ncol=2)
      attributes(polylist[[i]]) <- a
    }
    warning("coordinates changed to double")
  }
  if (!all(sapply(polylist, function(x) is.integer(attr(x, "nParts"))))) {
    for (i in 1:length(polylist)) attr(polylist[[i]], "nParts") <- 
		as.integer(attr(polylist[[i]], "nParts"))
    warning("nParts changed to integer")
  }
  if (!all(sapply(polylist, function(x) is.integer(attr(x, "pstart")$from)))) {
    for (i in 1:length(polylist)) attr(polylist[[i]], "pstart")$from <- 
		as.integer(attr(polylist[[i]], "pstart")$from)
    warning("pstart$from changed to integer")
  }
  if (!all(sapply(polylist, function(x) is.integer(attr(x, "pstart")$to)))) {
    for (i in 1:length(polylist)) attr(polylist[[i]], "pstart")$to <- 
		as.integer(attr(polylist[[i]], "pstart")$to)
    warning("pstart$to changed to integer")
  }
  library(foreign)
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
  library(foreign)
  write.dbf(df, paste(file, ".dbf", sep=""), factor2char=factor2char)
  res <- .Call("shpwritelines", as.character(file), linelist, 
    PACKAGE="maptools")
  invisible(res)
}

