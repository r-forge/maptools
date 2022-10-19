check_spatstat <- function(pkg="spatstat.geom") {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(paste("package ", pkg,
     " required; please install it (or the full spatstat package) first"))
  } else {
    spst_ver <- try(packageVersion("spatstat"), silent = TRUE)
    if(!inherits(spst_ver, "try-error") && spst_ver < 2.0-0) {
      stop(paste("You have an old version of spatstat installed which is",
        " incompatible with ", pkg,
        ". Please update spatstat (or uninstall it).", sep=""))
    }
  }
}


# as.ppp method to be used in spatstat:

as.ppp.SpatialPoints = function(X) {
        if (!is.na(sp::is.projected(X)) && !sp::is.projected(X))
          stop("Only projected coordinates may be converted to spatstat class objects")
	check_spatstat("spatstat.geom")
        bb <- bbox(X)
        colnames(bb) <- NULL
	W = spatstat.geom::owin(bb[1,], bb[2,])
	cc = coordinates(X)
	spatstat.geom::ppp(cc[,1], cc[,2], window = W, marks = NULL, check=FALSE)
}

setAs("SpatialPoints", "ppp", function(from) as.ppp.SpatialPoints(from))

# Mike Sumner 20101011
as.ppp.SpatialPointsDataFrame = function(X) {
        if (!is.na(sp::is.projected(X)) && !sp::is.projected(X))
          stop("Only projected coordinates may be converted to spatstat class objects")
	check_spatstat("spatstat.geom")
	bb <- bbox(X)
        colnames(bb) <- NULL
	W  <- spatstat.geom::owin(bb[1,], bb[2,])
	nc <- ncol(X)
        marks <- if(nc == 0) NULL else slot(X, "data")
#        if(nc > 1)
#          warning(paste(nc-1, "columns of data frame discarded"))
	cc <- coordinates(X)
	spatstat.geom::ppp(cc[,1], cc[,2], window = W, marks = marks, check=FALSE)
}

setAs("SpatialPointsDataFrame", "ppp", function(from) as.ppp.SpatialPointsDataFrame(from))

as.owin.SpatialGridDataFrame = function(W, ..., fatal) {
        if (!is.na(sp::is.projected(W)) && !sp::is.projected(W))
          stop("Only projected coordinates may be converted to spatstat class objects")
	check_spatstat("spatstat.geom")
	# W = from
	m = t(!is.na(as(W, "matrix")))
	spatstat.geom::owin(bbox(W)[1,], bbox(W)[2,], mask = m[nrow(m):1,])
}

setAs("SpatialGridDataFrame", "owin", function(from) as.owin.SpatialGridDataFrame(from))

as.owin.SpatialPixelsDataFrame = function(W, ..., fatal) {
        if (!is.na(sp::is.projected(W)) && !sp::is.projected(W))
          stop("Only projected coordinates may be converted to spatstat class objects")
	check_spatstat("spatstat.geom")
	# W = from
	m = t(!is.na(as(W, "matrix")))
	spatstat.geom::owin(bbox(W)[1,], bbox(W)[2,], mask = m[nrow(m):1,])
}

setAs("SpatialPixelsDataFrame", "owin", function(from) as.owin.SpatialPixelsDataFrame(from))

as.owin.SpatialPolygons = function(W, ..., fatal) {
	# W = from
        if (!is.na(sp::is.projected(W)) && !sp::is.projected(W))
          stop("Only projected coordinates may be converted to spatstat class objects")
	if (!inherits(W, "SpatialPolygons")) 
		stop("W must be a SpatialPolygons object")
	res <- .SP2owin(W)
	res
}

setAs("SpatialPolygons", "owin", function(from) as.owin.SpatialPolygons(from))

# methods for coercion to Spatial Polygons by Adrian Baddeley

owin2Polygons <- function(x, id="1") {
	check_spatstat("spatstat.geom")
  stopifnot(spatstat.geom::is.owin(x))
  x <- spatstat.geom::as.polygonal(x)
  closering <- function(df) { df[c(seq(nrow(df)), 1), ] }
  check_spatstat("spatstat.utils")
  pieces <- lapply(x$bdry,
      function(p) {Polygon(coords=closering(cbind(p$x,p$y)),
                   hole=spatstat.utils::is.hole.xypolygon(p))  })
  z <- Polygons(pieces, id)
  return(z)
}

as.SpatialPolygons.tess <- function(x) {
  check_spatstat("spatstat.geom")
  stopifnot(spatstat.geom::is.tess(x))
  y <- spatstat.geom::tiles(x)
  nam <- names(y)
  z <- list()
  for(i in seq(y)) {
    zi <- try(owin2Polygons(y[[i]], nam[i]), silent=TRUE)
    if (inherits(zi, "try-error")) {
      warning(paste("tile", i, "defective\n", as.character(zi)))
    } else {
      z[[i]] <- zi
    }
  }
  return(SpatialPolygons(z))
}

setAs("tess", "SpatialPolygons", function(from) as.SpatialPolygons.tess(from))


as.SpatialPolygons.owin <- function(x) {
  check_spatstat("spatstat.geom")
  stopifnot(spatstat.geom::is.owin(x))
  y <- owin2Polygons(x)
  z <- SpatialPolygons(list(y))
  return(z)
}

setAs("owin", "SpatialPolygons", function(from) as.SpatialPolygons.owin(from))



# methods for 'as.psp' for sp classes by Adrian Baddeley

as.psp.Line <- function(from, ..., window=NULL, marks=NULL, fatal) {
  check_spatstat("spatstat.geom")
  xy <- slot(from, "coords")
  df <- as.data.frame(cbind(xy[-nrow(xy), , drop=FALSE], xy[-1, ,
drop=FALSE]))
  if(is.null(window)) {
    xrange <- range(xy[,1])
    yrange <- range(xy[,2])
    window <- spatstat.geom::owin(xrange, yrange)
  }
  return(spatstat.geom::as.psp(df, window=window, marks=marks))
}

setAs("Line", "psp", function(from) as.psp.Line(from))
  
as.psp.Lines <- function(from, ..., window=NULL, marks=NULL, fatal) {
  check_spatstat("spatstat.geom")
  y <- lapply(slot(from, "Lines"), as.psp.Line, window=window)
  z <- do.call(spatstat.geom::superimpose,c(y,list(W=window)))
  if(!is.null(marks))
    spatstat.geom::marks(z) <- marks
  return(z)
}

setAs("Lines", "psp", function(from) as.psp.Lines(from))

as.psp.SpatialLines <- function(from, ..., window=NULL, marks=NULL,
                                 characterMarks=FALSE, fatal) {
  if (!is.na(sp::is.projected(from)) && !sp::is.projected(from))
    stop("Only projected coordinates may be converted to spatstat class objects")
  check_spatstat("spatstat.geom")
  if(is.null(window)) {
    w <- slot(from, "bbox")
    window <- spatstat.geom::owin(w[1,], w[2,])
  }
  lin <- slot(from, "lines")
  y <- lapply(lin, as.psp.Lines, window=window)
  id <- row.names(from)
  if(is.null(marks))
    for (i in seq(y)) 
      spatstat.geom::marks(y[[i]]) <- if(characterMarks) id[i] else factor(id[i])
# modified 110401 Rolf Turner
  z <- do.call(spatstat.geom::superimpose, c(y, list(W = window)))
  if(!is.null(marks))
    spatstat.geom::marks(z) <- marks
  return(z)
}

setAs("SpatialLines", "psp", function(from) as.psp.SpatialLines(from))

as.psp.SpatialLinesDataFrame <- function(from, ..., window=NULL, marks=NULL, fatal) {
  if (!is.na(sp::is.projected(from)) && !sp::is.projected(from))
    stop("Only projected coordinates may be converted to spatstat class objects")
  check_spatstat("spatstat.geom")
  y <- as(from, "SpatialLines")
  z <- spatstat.geom::as.psp(y, window=window, marks=marks)
  if(is.null(marks)) {
    # extract marks from first column of data frame
    df <- from@data
    if(is.null(df) || (nc <- ncol(df)) == 0)
      return(z)
    if(nc > 1) 
      warning(paste(nc-1, "columns of data frame discarded"))
    marx <- df[,1]
    nseg.Line  <- function(x) { return(nrow(x@coords)-1) }
    nseg.Lines <- function(x) { return(sum(unlist(lapply(x@Lines, nseg.Line)))) }
    nrep <- unlist(lapply(y@lines, nseg.Lines))
    spatstat.geom::marks(z) <- rep(marx, nrep)
  }
  return(z)
}

setAs("SpatialLinesDataFrame", "psp", function(from) as.psp.SpatialLinesDataFrame(from))

# 111117 from psp to SpatialLines, Rolf Turner, Adrian Baddeley, Mathieu Rajerison

as.SpatialLines.psp <- function(from) {

     ends2line <- function(x) Line(matrix(x, ncol=2, byrow=TRUE))
     munch <- function(z) { Lines(ends2line(as.numeric(z[1:4])), ID=z[5]) }
  
     ends <- as.data.frame(from)[,1:4]
     ends[,5] <- row.names(ends)
     y <- apply(ends, 1, munch)
     SpatialLines(y)
}

setAs("psp", "SpatialLines", function(from) as.SpatialLines.psp(from))
