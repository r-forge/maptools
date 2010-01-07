.MAPTOOLS_CACHE <- new.env(FALSE, parent=globalenv())

.onLoad <- function(lib, pkg) {
    require(methods, quietly = TRUE, warn.conflicts = FALSE)
    require("sp")
    assign("gpclib", FALSE, envir=.MAPTOOLS_CACHE)
    cat(paste("\n\tNote: polygon geometry computations in maptools\n",
              "\tdepend on the package gpclib, which has a\n",
              "\trestricted licence. It is disabled by default;\n",
              "\tto enable gpclib, type", sQuote("gpclibPermit()"), "\n"))
    rgeosI <- require(rgeos, quietly = TRUE, warn.conflicts = FALSE)
    assign("rgeos", rgeosI, envir=.MAPTOOLS_CACHE)
}

.onUnload <- function(libpath) {
    rm(.MAPTOOLS_CACHE)
}


