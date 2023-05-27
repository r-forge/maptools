.MAPTOOLS_CACHE <- new.env(FALSE, parent=globalenv())

register_s3_method <- function(pkg, generic, class, fun = NULL) {
  stopifnot(is.character(pkg), length(pkg) == 1L)
  stopifnot(is.character(generic), length(generic) == 1L)
  stopifnot(is.character(class), length(class) == 1L)

  if (is.null(fun)) {
    fun <- get(paste0(generic, ".", class), envir = parent.frame())
  } else {
    stopifnot(is.function(fun))
  }

  if (isNamespaceLoaded(pkg)) {
    registerS3method(generic, class, fun, envir = asNamespace(pkg))
  }

  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, fun, envir = asNamespace(pkg))
    }
  )
}

load_stuff <- function() {
    Smess <- paste("Please note that 'maptools' will be retired during October 2023,\nplan transition at your earliest convenience (see\nhttps://r-spatial.org/r/2023/05/15/evolution4.html and earlier blogs\nfor guidance);some functionality will be moved to 'sp'.\n", sep="")
    Smess <- paste(Smess, "Checking rgeos availability: ")
    rgeosI <- rgeosStatus()
    Smess <- paste(Smess, rgeosI, "\n", sep="")
    packageStartupMessage(Smess, appendLF = FALSE)
}

.onLoad <- function(lib, pkg) {
    rgeosI <- setRgeosStatus()
    if (getRversion() < "3.6.0") {
      register_s3_method("spatstat.geom", "as.im", "RasterLayer")
      register_s3_method("spatstat.geom", "as.im", "SpatialGridDataFrame")
      register_s3_method("spatstat.linnet", "as.linnet", "SpatialLines")
      register_s3_method("spatstat.geom", "as.owin", "SpatialGridDataFrame")
      register_s3_method("spatstat.geom", "as.owin", "SpatialPixelsDataFrame")
      register_s3_method("spatstat.geom", "as.owin", "SpatialPolygons")
      register_s3_method("spatstat.geom", "as.ppp", "SpatialPoints")
      register_s3_method("spatstat.geom", "as.ppp", "SpatialPointsDataFrame")
      register_s3_method("spatstat.geom", "as.psp", "Line")
      register_s3_method("spatstat.geom", "as.psp", "Lines")
      register_s3_method("spatstat.geom", "as.psp", "SpatialLines")
      register_s3_method("spatstat.geom", "as.psp", "SpatialLinesDataFrame")
    }
    load_stuff()
    invisible(NULL)
}

.onAttach <- function(lib, pkg) {
}

.onUnload <- function(libpath) {
    rm(.MAPTOOLS_CACHE)
}


