.MAPTOOLS_CACHE <- new.env(FALSE, parent=globalenv())

#.onLoad <- function(lib, pkg) {
#    assign("gpclib", FALSE, envir=.MAPTOOLS_CACHE)
#}

.onLoad <- function(lib, pkg) {
    assign("gpclib", FALSE, envir=.MAPTOOLS_CACHE)
    rgeosI <- setRgeosStatus()
    invisible(NULL)
}

.onAttach <- function(lib, pkg) {
#    assign("gpclib", FALSE, envir=.MAPTOOLS_CACHE)
    Smess <- paste("Checking rgeos availability: ")
#    rgeosI <- setRgeosStatus()
    rgeosI <- rgeosStatus()
    Smess <- paste(Smess, rgeosI, "\n", sep="")
    if (!rgeosI) Smess <- paste(Smess, 
              "\tNote: when rgeos is not available, polygon geometry",
              "\tcomputations in maptools depend on gpclib,\n",
              "\twhich has a restricted licence. It is disabled by default;\n",
              "\tto enable gpclib, type gpclibPermit()\n")
    packageStartupMessage(Smess, appendLF = FALSE)
}

.onUnload <- function(libpath) {
    rm(.MAPTOOLS_CACHE)
}


