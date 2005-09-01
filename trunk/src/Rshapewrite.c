/* Copyright (c) 2004, Nicholas J. Lewin-Koh and Roger Bivand */

#include "maptools.h"

#include <R.h>
#include <Rdefines.h>

SEXP shpwritepoint(SEXP fname, SEXP shapes)

{
    SHPHandle   hSHP;
    SHPObject   *psShape;
    int         nShapeType, i, nShapes;
 
    nShapeType = SHPT_POINT;

/* -------------------------------------------------------------------- */
/*      Create the requested layer.                                     */
/* -------------------------------------------------------------------- */

    hSHP = SHPCreate(R_ExpandFileName(CHAR(STRING_ELT(fname,0))), nShapeType);

    if( hSHP == NULL )
    {
         error("Unable to create:%s\n", CHAR(STRING_ELT(fname,0)) );
    }

    nShapes = LENGTH(shapes)/2;
    for (i = 0; i < nShapes; i++) {
      psShape = SHPCreateObject(nShapeType, -1, 0, NULL, NULL, 1, 
        &NUMERIC_POINTER(shapes)[i], &NUMERIC_POINTER(shapes)[i + nShapes], 
	NULL, NULL);

      SHPWriteObject(hSHP, -1, psShape);
      SHPDestroyObject(psShape);
    }

    SHPClose(hSHP);

    return R_NilValue;
}


