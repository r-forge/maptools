#include <stdlib.h>
#include <string.h>
#include "shapefil.h"
#include <R.h>
#include <Rinternals.h>

int 	SHPRingDir_2d ( SHPObject *psCShape, int Ring );
/* #if R_VERSION < R_Version(1, 2, 0)
# define STRING_ELT(x,i)        (STRING(x)[i])
# define VECTOR_ELT(x,i)        (VECTOR(x)[i])
# define SET_STRING_ELT(x,i,v)  (STRING(x)[i] = (v))
# define SET_VECTOR_ELT(x,i,v)  (VECTOR(x)[i] = (v))
#endif */
