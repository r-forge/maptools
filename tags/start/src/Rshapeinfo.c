#include "shapefil.h"
#include <R.h>
#include <R_ext/PrtUtil.h>

/* INTERFACE */ void Rshapeinfo(char **, int *, int *, double *, double *);

void Rshapeinfo(char **shpnm, int *Shapetype, int *Entities, double
		*MinBound, double *MaxBound)

{
    SHPHandle	hSHP;
    int    nShapeType, nEntities, i;
    double  adfMinBound[4], adfMaxBound[4];
/*      const char 	*pszPlus; */
/* -------------------------------------------------------------------- */
/*      Open the passed shapefile.                                      */
/* -------------------------------------------------------------------- */
    hSHP = SHPOpen( shpnm[0] , "rb" );

    if( hSHP == NULL )
    {
/*	REprintf( "Unable to open:%s\n", shpnm[0] );
	exit( 1 ); */
	error("No such file");
    }

/* -------------------------------------------------------------------- */
/*      Print out the file bounds.                                      */
/* -------------------------------------------------------------------- */
      SHPGetInfo( hSHP, &nEntities, &nShapeType, adfMinBound, adfMaxBound ); 
    
      *Entities = nEntities; 
      *Shapetype = nShapeType;
      for (i=0;i<4;i++){ 
        MinBound[i]=adfMinBound[i];
        MaxBound[i]=adfMaxBound[i];
    }

/*    Rprintf ("Info for %s\n", shpnm[0]);
    Rprintf("Shapefile Type: %s(%d)   # of Shapes: %ld\n\n",
            SHPTypeName( nShapeType ), nShapeType, nEntities );
    Rprintf("File Bounds: (%15.10lg,%15.10lg)\n\t(%15.10lg,%15.10lg)\n",
	    MinBound[0], MinBound[1], MaxBound[0], MaxBound[1] );*/
    

    SHPClose( hSHP );   
    return;
}
