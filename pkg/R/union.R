unionSpatialPolygons <- function(SpP, IDs, threshold=NULL, avoidGEOS=FALSE, avoidUnaryUnion=FALSE) {
    if (!is(SpP, "SpatialPolygons")) stop("not a SpatialPolygons object")
    if (storage.mode(IDs) != "character") IDs <- as.character(IDs)
    if (missing(IDs)) stop("IDs required")
    if (length(slot(SpP, "polygons")) != length(IDs))
        stop("input lengths differ")
    rgeosI <- rgeosStatus()
    if (rgeosI && !avoidGEOS) {
        # require(rgeos)
    	if (!requireNamespace("rgeos", quietly = TRUE))
			stop("package rgeos required for unionSpatialPolygons")
        if (avoidUnaryUnion || rgeos::version_GEOS0() < "3.3.0")
            res <- rgeos::gUnionCascaded(spgeom=SpP, id=IDs)
        else
            res <- rgeos::gUnaryUnion(spgeom=SpP, id=IDs)
    }
    res
}

