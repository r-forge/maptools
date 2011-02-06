.MAPTOOLS_CACHE <- new.env(FALSE, parent=globalenv())

.onLoad <- function(lib, pkg) {
    require(methods, quietly = TRUE, warn.conflicts = FALSE)
    require("sp")
    assign("gpclib", FALSE, envir=.MAPTOOLS_CACHE)
    Smess <- paste("\n\tNote: polygon geometry computations in maptools\n",
              "\tdepend on the package gpclib, which has a\n",
              "\trestricted licence. It is disabled by default;\n",
              "\tto enable gpclib, type gpclibPermit()\n")
    Smess <- paste(Smess,
        "\nChecking rgeos availability as gpclib substitute:\n")
    rgeosI <- "rgeos" %in% .packages(all = TRUE)
    Smess <- paste(Smess, rgeosI, "\n", sep="")
    packageStartupMessage(Smess, appendLF = FALSE)
    assign("rgeos", rgeosI, envir=.MAPTOOLS_CACHE)
}

.onUnload <- function(libpath) {
    rm(.MAPTOOLS_CACHE)
}


