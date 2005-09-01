/* Copyright (c) 2000-2004, Nicholas J. Lewin-Koh and Roger Bivand */

/*
  Opens an ESRI shape file and reads the information into a shapelist
  object
*/

#include "maptools.h"
#include <R.h>
#include <Rdefines.h>
/* #include <R_ext/PrtUtil.h> */

/*#define DEBUG 1*/
SEXP Rshapeget(SEXP);

SEXP Rshapeget(SEXP shpnm)

{
    SHPHandle	hSHP;
    int    nShapeType, nEntities, i, pc=0;
    double  adfMinBound[4], adfMaxBound[4];
    int j, pz=0;
    SHPObject *psShape;

    SEXP  Rshplst, shplistnms;
    SEXP temp0, temp1, temp2, temp3;

#ifdef DEBUG
    PT Cent;
    double Area;
#endif

/* -------------------------------------------------------------------- */
/*      Open the passed shapefile.                                      */
/* -------------------------------------------------------------------- */

    hSHP = SHPOpen(CHAR(STRING_ELT(shpnm,0)), "rb" );
    if( hSHP == NULL )    
	error("unable to open file");


/* -------------------------------------------------------------------- */
/*      Print out the file bounds.                                      */
/* -------------------------------------------------------------------- */
      SHPGetInfo( hSHP, &nEntities, &nShapeType, adfMinBound, adfMaxBound ); 
/*      Rprintf("Shapefile Type: %s   # of Shapes: %d\n\n",
            SHPTypeName( nShapeType ), nEntities );*/

        PROTECT(Rshplst=allocVector(VECSXP, nEntities)); pc++;

        PROTECT(temp0=allocVector(STRSXP, 1)); pc++;
        
	if(nShapeType==1){ /* POINT */
		SET_STRING_ELT(temp0, 0, mkChar("point"));
	        setAttrib(Rshplst, install("shp.type"), temp0);
	}
	else if(nShapeType==11){ /* POINTZ */
		SET_STRING_ELT(temp0, 0, mkChar("point"));
	        setAttrib(Rshplst, install("shp.type"), temp0);
		pz=1;
	}
	else if(nShapeType==3){  /* ARC */
		SET_STRING_ELT(temp0, 0,  mkChar("arc"));
	        setAttrib(Rshplst, install("shp.type"), temp0);
	}
	else if(nShapeType==13){  /* ARCZ */
		SET_STRING_ELT(temp0, 0,  mkChar("arc"));
	        setAttrib(Rshplst, install("shp.type"), temp0);
	}
	else if(nShapeType==5){/* POLYGON */
		SET_STRING_ELT(temp0, 0, mkChar("poly"));
	        setAttrib(Rshplst, install("shp.type"), temp0);
	}
	else if(nShapeType==15){/* POLYGONZ */
		SET_STRING_ELT(temp0, 0, mkChar("poly"));
	        setAttrib(Rshplst, install("shp.type"), temp0);
	}
	else {
	  Rprintf("Shapefile type: %s (%d), # of Shapes: %d\n\n",
            SHPTypeName( nShapeType ), nShapeType, nEntities );
	  error("Shapefile type not (yet) handled by this function");
	}


        PROTECT(temp1=allocVector(INTSXP,1)); pc++;
        INTEGER(temp1)[0] = nEntities;
	setAttrib(Rshplst,install("nshps"),temp1);


        PROTECT(temp2=allocVector(REALSXP,4)); pc++;
	REAL(temp2)[0] = adfMinBound[0];
	REAL(temp2)[1] = adfMinBound[1];
	REAL(temp2)[2] = adfMinBound[2];
	REAL(temp2)[3] = adfMinBound[3];
	setAttrib(Rshplst,install("minbb"),temp2);


        PROTECT(temp3=allocVector(REALSXP,4)); pc++;
	REAL(temp3)[0] = adfMaxBound[0];
	REAL(temp3)[1] = adfMaxBound[1];
	REAL(temp3)[2] = adfMaxBound[2];
	REAL(temp3)[3] = adfMaxBound[3];
	setAttrib(Rshplst,install("maxbb"),temp3);



/*--------------------------------------------------------------------
	Skim over the list of shapes, printing all the vertices.	
 --------------------------------------------------------------------*/

   PROTECT(shplistnms = allocVector(STRSXP,7)); pc++;
   SET_STRING_ELT(shplistnms,0,mkChar("Pstart"));
   SET_STRING_ELT(shplistnms,1,mkChar("verts")); 
   SET_STRING_ELT(shplistnms,2,mkChar("shp.type")); 
   SET_STRING_ELT(shplistnms,3,mkChar("nVerts")); 
   SET_STRING_ELT(shplistnms,4,mkChar("nParts")); 
   SET_STRING_ELT(shplistnms,5,mkChar("bbox"));
   SET_STRING_ELT(shplistnms,6,mkChar("shpID"));
   for( i = 0; i < nEntities; i++ ) 
     { 
	psShape = SHPReadObject( hSHP, i);
        SET_VECTOR_ELT(Rshplst, i, allocVector(VECSXP, 7));
        SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),0, 
	  allocVector(INTSXP,psShape->nParts));	
        if (pz == 0) SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),1,
	  allocMatrix(REALSXP,psShape->nVertices,2));
	else SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),1,
	  allocMatrix(REALSXP,psShape->nVertices,3));
        SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),2,
		allocVector(INTSXP,1));
        SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),3,
		allocVector(INTSXP,1));
        SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),4,
		allocVector(INTSXP,1));
        SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),5,
		allocVector(REALSXP,4));
        SET_VECTOR_ELT(VECTOR_ELT(Rshplst,i),6,
		allocVector(INTSXP,1));
	INTEGER(VECTOR_ELT(VECTOR_ELT(Rshplst,i),2))[0]=psShape->nSHPType;
	INTEGER(VECTOR_ELT(VECTOR_ELT(Rshplst,i),3))[0]=psShape->nVertices;
	INTEGER(VECTOR_ELT(VECTOR_ELT(Rshplst,i),4))[0]=psShape->nParts;
	INTEGER(VECTOR_ELT(VECTOR_ELT(Rshplst,i),6))[0]=psShape->nShapeId;


	REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),5))[0]=psShape->dfXMin;
	REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),5))[1]=psShape->dfYMin;
	REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),5))[2]=psShape->dfXMax;
	REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),5))[3]=psShape->dfYMax;

	setAttrib(VECTOR_ELT(Rshplst,i),R_NamesSymbol,shplistnms);


	for( j = 0; j < psShape->nVertices; j++ )
	{
	    REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),1))[j]=psShape->padfX[j];
	    REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),1))[j+psShape->nVertices]=
	                                  psShape->padfY[j];
	    if (pz == 1) REAL(VECTOR_ELT(VECTOR_ELT(Rshplst,i),1))[j +
			2*(psShape->nVertices)]=psShape->padfZ[j];
	}
	
        
        if(psShape->nParts > 0 ){
       
	  if(psShape->nParts == 1){
	    INTEGER(VECTOR_ELT(VECTOR_ELT(Rshplst,i),0))[0]=0;

	  }
	  else{
	    for(j = 0; j < psShape->nParts; j++ )
	      {
		INTEGER(VECTOR_ELT(VECTOR_ELT(Rshplst,i),0))[j]=
		  psShape->panPartStart[j];
	      }
	  }

	} 
	SHPDestroyObject( psShape );
     }
     SHPClose(hSHP);
     UNPROTECT(pc);


    return(Rshplst);
}



