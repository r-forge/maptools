# Copyright (c) 2007 Patrick Giraudoux and Roger Bivand

readGPS <- function(i="garmin", f="usb:") {

    gpsdata <- system(paste("gpsbabel -i ", i, " -f ", f,
	" -o tabsep -F -", sep=""), intern=TRUE)
    if (any(grep("Can't init", gpsdata))) 
	stop("Cannot read GPS: check connexion")
    gpsdf <- read.table(textConnection(gpsdata), fill=TRUE)
    gpsdf
}

