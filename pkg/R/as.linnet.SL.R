# Convert 'SpatialLines*' object to spatstat 'linnet' object
# 
# For 'SpatialLinesDataFrame', the data columns are copied 
# to the network as marks associated with the network segments.
#
# If fuse=TRUE, the code searches for pairs of points with the same (x,y)
#               coordinates that occur in different polylines,
#               and merges them together as identical vertices of the network.

if (!isClass("linnet"))
	setClass("linnet")

as.linnet.SpatialLines <- function(X, ..., fuse=TRUE) {
  if (!is.na(sp::is.projected(X)) && !sp::is.projected(X))
    stop("Only projected coordinates may be converted to spatstat class objects")
  if(!requireNamespace("spatstat", quietly = TRUE)) 
    stop("package spatstat is required for as.linnet.SpatialLines")
  #' extract bounding box to use as window
  bb <- bbox(X)
  BB <- spatstat::owin(bb[1,], bb[2,])
  #' 
  n <- length(X)
  xx <- yy <- numeric(0)
  ii <- jj <- integer(0)
  if(n > 0) {
    #' concatenate coordinates of all vertices
    crdlists <- coordinates(X)
    ntot <- sum(sapply(crdlists, function(x) { sum(sapply(x, nrow)) }))
    xx <- yy <- numeric(ntot)
    ii <- jj <- integer(ntot)
    last <- 0
    for (id1 in seq_along(crdlists)) {
      for (id2 in seq_along(crdlists[[id1]])) {
        crdmat <- crdlists[[id1]][[id2]]
        m <- nrow(crdmat)
        if(m > 0) {
          relevant <- last + seq_len(m)
          xx[relevant] <- crdmat[,1]
          yy[relevant] <- crdmat[,2]
          ii[relevant] <- id1
          jj[relevant] <- id2
          last <- last + m
        }
      }
    }
  }
  #' extract vertices 
  V <- spatstat::ppp(xx, yy, window=BB, check=!fuse)
  nV <- length(xx)
  #' join them
  edges <- NULL
  if(nV > 1) {
    seqn <- seq_len(nV)
    from <- seqn[-nV]
    to   <- seqn[-1]
    ok   <- diff(ii) == 0 & diff(jj) == 0
    from <- from[ok]
    to   <- to[ok]
    iii  <- ii[c(ok, FALSE)] #' indices backward
    jjj  <- jj[c(ok, FALSE)]
    if(fuse) {
      umap <- spatstat::uniquemap(V)
      retain <- (umap == seq_along(umap))
      V <- V[retain]
      renumber <- cumsum(retain)
      from <- renumber[umap[from]]
      to   <- renumber[umap[to]]
    }
    edges <- cbind(from, to)
  } 
  if(!is.null(edges)) {
    up <- (from < to)
    ee <- cbind(ifelse(up, from , to), ifelse(up, to, from))
    if(anyDuplicated(ee)) {
      u <- !duplicated(ee)
      from <- from[u]
      to   <- to[u]
      iii  <- iii[u]
      jjj  <- jjj[u]
    }
  }
  result <- spatstat::linnet(vertices=V, edges = edges, sparse=TRUE)
  if(spatstat::nsegments(result) == length(iii)) {
    df <- data.frame(LinesIndex=iii, LineIndex=jjj)
    if(.hasSlot(X, "data")) {
      DF <- slot(X, "data")
      df <- cbind(DF[iii,,drop=FALSE], df)
    }
    spatstat::marks(result$lines) <- df
  } else warning("Internal error: could not map data frame to lines")
  return(result)
}

setAs("SpatialLines", "linnet", function(from) as.linnet.SpatialLines(from))

setAs("SpatialLinesDataFrame", "linnet", function(from) as.linnet.SpatialLines(from))



  

