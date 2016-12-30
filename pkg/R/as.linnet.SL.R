#' convert 'SpatialLines' object to spatstat 'linnet' object
#' 
#' If fuse=TRUE, the code searches for pairs of points with the same (x,y)
#'               coordinates that occur in different polylines,
#'               and merges them together as identical vertices of the network.

if (!isClass("linnet"))
	setClass("linnet")

as.linnet.SpatialLines <- function(X, ..., fuse=TRUE) {
    if(!requireNamespace("spatstat", quietly = TRUE)) 
      stop("package spatstat is required for as.linnet.SpatialLines")
    #' extract bounding box to use as window
    bb <- bbox(X)
    BB <- spatstat::owin(bb[1,], bb[2,])
    #'
#    lin <- slot(X, "lines")
    n <- length(X)
    if(n > 0) {
#      getcoords <- function(x, id2, id1) {
#      df <- as.data.frame(x@coords)
#      colnames(df) <- c("x", "y")
#      n <- nrow(df)
#      if(n > 0) {
#        df$id1 <- id1
#        df$id2 <- id2
#        df$id3 <- seq_len(n)
#      } else {
#        df$id1 <- df$id2 <- df$id3 <- integer(0)
#      }
#      return(df)
#      }

#      getLines <- function(x, id1) {
#        Lin <- x@Lines
#         dflist <- mapply(getcoords, x=Lin, id2=seq_along(Lin), id1=id1,
#                     SIMPLIFY=FALSE)
#        df <- do.call(rbind, unname(dflist))
#        return(df)
#      }

#      dflist <- mapply(getLines, x=lin, id1=seq_len(n), SIMPLIFY=FALSE)

      crdlists <- coordinates(X)
      dflist <- vector(mode="list", length=sum(sapply(crdlists, length)))
      dfli <- 1
      for (id1 in seq_along(crdlists)) {
        for (id2 in seq_along(crdlists[[id1]])) {
          crdmat <- crdlists[[id1]][[id2]]
          dflist[[dfli]] <- data.frame(x=crdmat[,1], y=crdmat[,2],
            id1=id1, id2=id2, id3=1:nrow(crdmat))
          dfli <- dfli + 1
        }
      }
      df <- do.call(rbind, unname(dflist))
    } else {
      df <- data.frame(x=numeric(0), y=numeric(0),
                       id1=integer(0), id2=integer(0), id3=integer(0))
    }
    #' extract vertices 
    V <- spatstat::ppp(df$x, df$y, window=BB, check=!fuse)
    nV <- spatstat::npoints(V)
    #' join them
    if(nV > 1) {
      seqn <- seq_len(nV)
      from <- seqn[-nV]
      to   <- seqn[-1]
      ok   <- with(df, diff(id1) == 0 & diff(id2) == 0)
      from <- from[ok]
      to   <- to[ok]
      if(fuse && any(dup <- spatstat::duplicated.ppp(V))) {
        retain <- !dup
        vmap <- cumsum(retain)
        U <- V[retain]
        vmap[dup] <- spatstat::nncross(V[dup], U, what="which")
        from <- vmap[from]
        to   <- vmap[to]
        V <- U
      }
      edges <- cbind(from, to)
    } else edges <- NULL
    result <- spatstat::linnet(vertices=V, edges = edges, sparse=TRUE)
    return(result)
}

setAs("SpatialLines", "linnet", function(from) as.linnet.SpatialLines(from))

setAs("SpatialLinesDataFrame", "linnet", function(from) as.linnet.SpatialLines(from))



  

