/* Copyright (c) 2004, Nicholas J. Lewin-Koh and Roger Bivand */

#include "maptools.h"

#include <R.h>
#include <Rdefines.h>

SEXP shpwritepolys(SEXP fname, SEXP shapes)
{
    SHPHandle   hSHP;
    SHPObject   *psShape;
    int         nShapeType, i, j, k, kk;
    int		nShapes, maxnParts=0, maxnVerts=0, pc=0;
    int		*nParts, *nVerts, *panPartStart, *from, *to;
    double      *padfX, *padfY;
    SEXP	SnParts, Spstart;
 
    nShapeType = SHPT_POLYGON;

/* -------------------------------------------------------------------- */
/*      Create the requested layer.                                     */
/* -------------------------------------------------------------------- */

    hSHP = SHPCreate(R_ExpandFileName(CHAR(STRING_ELT(fname,0))), nShapeType );

    if( hSHP == NULL )
    {
         error("Unable to create:%s\n", CHAR(STRING_ELT(fname,0)) );
    }

    nShapes = LENGTH(shapes);
    nParts = (int *) R_alloc((long) nShapes, sizeof(int));
    nVerts = (int *) R_alloc((long) nShapes, sizeof(int));
    PROTECT(SnParts = NEW_CHARACTER(1)); pc++;
    SET_STRING_ELT(SnParts, 0, COPY_TO_USER_STRING("nParts"));
    PROTECT(Spstart = NEW_CHARACTER(1)); pc++;
    SET_STRING_ELT(Spstart, 0, COPY_TO_USER_STRING("pstart"));

    for (i = 0; i < nShapes; i++) {
      nParts[i] = INTEGER_POINTER(GET_ATTR(VECTOR_ELT(shapes, i), SnParts))[0];
      if (nParts[i] > maxnParts) maxnParts = nParts[i];
      nVerts[i] = INTEGER_POINTER(VECTOR_ELT(GET_ATTR(VECTOR_ELT(shapes, i), 
		    Spstart), 1))[(nParts[i]-1)] - (nParts[i]-1);
      if (nVerts[i] > maxnVerts) maxnVerts = nVerts[i];
    } 
    panPartStart = (int *) R_alloc((long) maxnParts, sizeof(int));
    from = (int *) R_alloc((long) maxnParts, sizeof(int));
    to = (int *) R_alloc((long) maxnParts, sizeof(int));
    if (maxnVerts > 1000000 || maxnVerts < 1)
      error("Old polylist object cannot be exported");
    padfX = (double *) R_alloc((long) maxnVerts, sizeof(double));
    padfY = (double *) R_alloc((long) maxnVerts, sizeof(double)); 

    for (i = 0; i < nShapes; i++) {
      kk = 0;
      for (j = 0; j < nParts[i]; j++) {
        from[j] = INTEGER_POINTER(VECTOR_ELT(GET_ATTR(VECTOR_ELT(shapes, i), 
		    Spstart), 0))[j] - 1;
        panPartStart[j] = from[j] - j;
        to[j] = INTEGER_POINTER(VECTOR_ELT(GET_ATTR(VECTOR_ELT(shapes, i), 
		    Spstart), 1))[j] - 1;
        for (k=from[j]; k<=to[j]; k++) {
          padfX[kk] = NUMERIC_POINTER(VECTOR_ELT(shapes, i))[k];
          padfY[kk] = NUMERIC_POINTER(VECTOR_ELT(shapes,
                        i))[k+nVerts[i]+(nParts[i]-1)];
          kk++;
        }
      }
      if (kk != nVerts[i]) error("wrong number of vertices in polylist");

      psShape = SHPCreateObject(nShapeType, -1, nParts[i], panPartStart, 
                    NULL, nVerts[i], padfX, padfY, NULL, NULL);

      SHPWriteObject( hSHP, -1, psShape );
      SHPDestroyObject( psShape );
    } 



    SHPClose( hSHP );
    UNPROTECT(pc);

    return R_NilValue;
}


SEXP shpwritelines(SEXP fname, SEXP shapes)
{
    SHPHandle   hSHP;
    SHPObject   *psShape;
    int         nShapeType, i, j;
    int		nShapes, maxnVerts=0;
    int		*nVerts;
    double      *padfX, *padfY;
 
    nShapeType = SHPT_ARC;

/* -------------------------------------------------------------------- */
/*      Create the requested layer.                                     */
/* -------------------------------------------------------------------- */

    hSHP = SHPCreate(R_ExpandFileName(CHAR(STRING_ELT(fname,0))), nShapeType );

    if( hSHP == NULL )
    {
         error("Unable to create:%s\n", CHAR(STRING_ELT(fname,0)) );
    }

    nShapes = GET_LENGTH(shapes);
    nVerts = (int *) R_alloc((long) nShapes, sizeof(int));

    for (i = 0; i < nShapes; i++) {
      nVerts[i] = INTEGER_POINTER(GET_DIM(VECTOR_ELT(shapes, i)))[0];
      if (nVerts[i] > maxnVerts) maxnVerts = nVerts[i];
    } 
    if (maxnVerts < 1)
      error("list object cannot be exported");
    padfX = (double *) R_alloc((long) maxnVerts, sizeof(double));
    padfY = (double *) R_alloc((long) maxnVerts, sizeof(double)); 

    for (i = 0; i < nShapes; i++) {
      for (j = 0; j < nVerts[i]; j++) {
          padfX[j] = NUMERIC_POINTER(VECTOR_ELT(shapes, i))[j];
          padfY[j] = NUMERIC_POINTER(VECTOR_ELT(shapes, i))[j+nVerts[i]];
      }

      psShape = SHPCreateObject(nShapeType, -1, 0, NULL, NULL, nVerts[i], 
        padfX, padfY, NULL, NULL);

      SHPWriteObject( hSHP, -1, psShape );
      SHPDestroyObject( psShape );
    } 

    SHPClose( hSHP );

    return R_NilValue;
}


