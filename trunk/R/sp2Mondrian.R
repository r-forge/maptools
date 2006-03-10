# Copyright (c) 2006 Patrick Hausmann and Roger Bivand

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sp2Mondrian <- function(SP, file) {
	if (!inherits(SP, "SpatialPolygonsDataFrame"))
		stop("not a SpatialPolygonsDataFrame object")
	pls <- slot(SP, "polygons")
	IDs <- sapply(pls, function(x) slot(x, "ID"))
	n <- length(IDs)
	id <- 1:n
	con <- file(file, open="wt")
	df <- as(SP, "data.frame")
	df <- data.frame("/P_SP_ID"=id, df, check.names=FALSE)
               write.table(df, file = con,
		quote = FALSE, 
               	row.names = FALSE, 
               	col.names = TRUE, sep="\t", dec=".")
        for (i in 1:n) {
		pl <- slot(pls[[i]], "Polygons")
		m <- length(pl)
		if (m > 1) warning("only writing first polygon for multipolygon object")
		crds <- slot(pl[[1]], "coords")
		nc <- nrow(crds)
		lab <- paste(id[i], paste("/P", IDs[i], sep=""), nc, sep="\t")
                cat("\n", file = con)
                writeLines(lab, con = con)
                write.table(crds, file = con, 
                	append = TRUE, 
                	row.names = FALSE, 
                	col.names = FALSE, sep="\t", dec=".")

		
	}
	close(con)
	invisible(NULL)
}


Shape2Mondrian <- function(shape, file, id, export.data = TRUE) {

        fshape <- shape
        xfile  <- file
        idx    <- paste("/P", id, sep="")
        
        #
        # Export "att.data" -- TRUE / FALSE
        #       
        if (is.logical(export.data) && export.data) {
                y               <- fshape$att.data
                names(y)        <- sub(id, idx, names(y))
                write.table(y, file = xfile, 
                append = TRUE, 
                row.names = FALSE, 
                col.names = TRUE, sep="\t", dec=".")
        }       

        for (i in 1:length(fshape$Shapes)) {

                 xnrow <- nrow(fshape$Shapes[[i]]$verts)
                 lab   <- paste(i, idx, xnrow, sep="\t")

                 write.table("\n", file = xfile, 
                append = TRUE, eol = "", 
                quote = FALSE, 
                row.names = FALSE, 
                col.names = FALSE)
                 write.table(lab, file = xfile, 
                append = TRUE, 
                quote = FALSE, 
                row.names = FALSE, 
                col.names = FALSE, sep="\t")
                write.table(fshape$Shapes[[i]]$verts, file = xfile, 
                append = TRUE, 
                row.names = FALSE, 
                col.names = FALSE, sep="\t", dec=".")
        }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#library(maptools)
#x <- read.shape(system.file("shapes/columbus.shp", package="maptools")[1])
#Shape2Mondrian(x, file="c:\\colombus.txt", "POLYID", export.data = TRUE)
#xx <- readShapePoly(system.file("shapes/columbus.shp", package="maptools")[1])
#sp2Mondrian(xx, file="colombus1.txt")

