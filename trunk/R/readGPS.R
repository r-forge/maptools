# Copyright (c) 2007 Patrick Giraudoux and Roger Bivand

readGPS <- function(i="garmin", f="usb:", type="w", invisible=TRUE) {

    if (.Platform$OS.type == "windows") 
	gpsdata <- system(paste("gpsbabel -", type, " -i ", i, " -f ", f,
	" -o tabsep -F -", sep=""), intern=TRUE, invisible=invisible)
    else gpsdata <- system(paste("gpsbabel -", type, " -i ", i, " -f ", f,
	" -o tabsep -F -", sep=""), intern=TRUE)
    if (any(grep("Can't init", gpsdata))) 
	stop("Cannot read GPS: check connexion")
    gpsdf <- read.table(textConnection(gpsdata), fill=TRUE)
    gpsdf
}

