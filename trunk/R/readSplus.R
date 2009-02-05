#
#Read maps in S-plus format (as exported by WinBUGS)
#
readSplus<-function(file, proj4string=CRS(as.character(NA)) )
{

	lns<-readLines(file)
	nlines<-length(lns)
	nareas<-as.integer(strsplit(lns[1], ":")[[1]][2])

	offset<-1
	if(lns[2]==""){offset<-offset+1}

        scales <- grep("cale", lns[(offset+1):(offset+2)])
	if (length(scales) > 0) {
            if (length(scales) < 2) 
                stop("Only one scale given")
            xsc <- grep("x|X", lns[(offset+1):(offset+2)])
            ysc <- grep("y|Y", lns[(offset+1):(offset+2)])
            xscale <- as.numeric(strsplit(lns[(offset+xsc)], 
                " |\t|\r\n")[[1]][2])
	    yscale <- as.numeric(strsplit(lns[(offset+ysc)],
                " |\t|\r\n")[[1]][2])
            offset <- offset+2
	    if(lns[(offset+1)]==""){offset<-offset+1}
        } else {
            xscale <- 1
            yscale <- 1
        }

	IDs<-lapply(lns[offset+1:nareas], function(X){strsplit(X, " |\t|\r\n")})
	IDs<-matrix(unlist(IDs), ncol=2, byrow=TRUE)

	offset<-offset+nareas

	if(lns[offset]==""){offset<-offset+1}

        END <- 1
        while (lns[nlines - (END-1)] != "END") END <- END+1

	polys<-read.table(file, skip=offset, nrows=nlines-offset-END)

	polys2<-cbind(xscale*as.numeric(polys$V2), yscale*as.numeric(polys$V3))

	lpolys<-.NAmat2xyList(polys2)
	llpolys<-unlist(lapply(lpolys, nrow))

	idx<- c(1, cumsum(2+llpolys[-length(lpolys)]))
	polysIDs<-polys$V1[ idx]

	belongs<-lapply(1:nareas, function(i){which(polysIDs==IDs[i,2])})

	Srl <- vector(mode = "list", length = nareas)

	for (i in 1:nareas) {
		nParts <- length(belongs[[i]])
		srl <- vector(mode = "list", length = nParts)
		for (j in 1:nParts) {
                        crds <- lpolys[[belongs[[i]][j]]]
                        nc <- nrow(crds)
                        if (crds[1,1] != crds[nc,1] || crds[1,2] != crds[nc,2])
                            crds <- rbind(crds, crds[1,,drop=FALSE])
			srl[[j]] <- Polygon(coords = crds)
		}
		Srl[[i]] <- Polygons(srl, ID = IDs[i,2])
	}

	res <- as.SpatialPolygons.PolygonsList(Srl, proj4string = proj4string)
	res
}

