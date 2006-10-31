/*	$Id$
 *
 * PROGRAM:	gshhs.c
 * AUTHOR:	Paul Wessel (pwessel@hawaii.edu)
 * CREATED:	JAN. 28, 1996
 * PURPOSE:	To extract ASCII data from binary shoreline data
 *		as described in the 1996 Wessel & Smith JGR Data Analysis Note.
 * VERSION:	1.1 (Byte flipping added)
 *		1.2 18-MAY-1999:
 *		   Explicit binary open for DOS systems
 *		   POSIX.1 compliant
 *		1.3 08-NOV-1999: Released under GNU GPL
 *		1.4 05-SEPT-2000: Made a GMT supplement; FLIP no longer needed
 *		1.5 14-SEPT-2004: Updated to deal with latest GSHHS database (1.3)
 *
 *	Copyright (c) 1996-2004 by P. Wessel and W. H. F. Smith
 *	See COPYING file for copying and redistribution conditions.
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; version 2 of the License.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	Contact info: www.soest.hawaii.edu/pwessel */

/*
This modification of gshhs.c is Copyright (c) 2005 Roger Bivand
*/

#include "Rgshhs.h"
#include <R.h>
#include <Rdefines.h>
#include <R_ext/Applic.h>

SEXP Rgshhs(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);

int getNpols(FILE *);

int gshhs_pipbb(double pt1, double pt2, double *bbs);

int gshhs_between(double x, double low, double up); 


SEXP Rgshhs(SEXP fn, SEXP mode, SEXP dolim, SEXP lim, SEXP level, SEXP minarea) 
{
	FILE *fp;
	double w, e, s, n, area, lon, lat;
	char source;
	char msg[255];
	int k, n_read, flip, max_east = 270000000;
	struct POINT p;
	struct GSHHS h;
	int npols, pc=0;
	SEXP res, resnames, resa, plist, choice, chosen, clip, subset;
	int i, ipols;
	signed int fpos;
	double bb[4], bbi[4];
	int k1[4], k2[4], j, j1, j2;

	fp = fopen (CHAR(STRING_ELT(fn, 0)), "rb");
	if (fp == NULL ) {
		sprintf(msg, "Could not find file %s", CHAR(STRING_ELT(fn, 0)));
		error(msg);

	}

	npols = getNpols(fp);
	if (INTEGER_POINTER(mode)[0] == 0) {
		fclose (fp);

		PROTECT(res = NEW_INTEGER(1)); pc++;
		INTEGER_POINTER(res)[0] = npols;
		UNPROTECT(pc); /* res */
		return(res);

	} else if (INTEGER_POINTER(mode)[0] > 0) {

		rewind(fp);

		PROTECT(res = NEW_LIST(11)); pc++;

		PROTECT(resnames = NEW_CHARACTER(11)); pc++;
		SET_VECTOR_ELT(resnames, 0, COPY_TO_USER_STRING("id"));
		SET_VECTOR_ELT(resnames, 1, COPY_TO_USER_STRING("n"));
		SET_VECTOR_ELT(resnames, 2, COPY_TO_USER_STRING("level"));
		SET_VECTOR_ELT(resnames, 3, COPY_TO_USER_STRING("source"));
		SET_VECTOR_ELT(resnames, 4, COPY_TO_USER_STRING("greenwich"));
		SET_VECTOR_ELT(resnames, 5, COPY_TO_USER_STRING("fpos"));
		SET_VECTOR_ELT(resnames, 6, COPY_TO_USER_STRING("area"));
		SET_VECTOR_ELT(resnames, 7, COPY_TO_USER_STRING("west"));
		SET_VECTOR_ELT(resnames, 8, COPY_TO_USER_STRING("east"));
		SET_VECTOR_ELT(resnames, 9, COPY_TO_USER_STRING("south"));
		SET_VECTOR_ELT(resnames, 10, COPY_TO_USER_STRING("north"));
		setAttrib(res, R_NamesSymbol, resnames);

		SET_VECTOR_ELT(res, 0, NEW_INTEGER(npols));
		SET_VECTOR_ELT(res, 1, NEW_INTEGER(npols));
		SET_VECTOR_ELT(res, 2, NEW_INTEGER(npols));
		SET_VECTOR_ELT(res, 3, NEW_INTEGER(npols));
		SET_VECTOR_ELT(res, 4, NEW_INTEGER(npols));
		SET_VECTOR_ELT(res, 5, NEW_INTEGER(npols));
		SET_VECTOR_ELT(res, 6, NEW_NUMERIC(npols));
		SET_VECTOR_ELT(res, 7, NEW_NUMERIC(npols));
		SET_VECTOR_ELT(res, 8, NEW_NUMERIC(npols));
		SET_VECTOR_ELT(res, 9, NEW_NUMERIC(npols));
		SET_VECTOR_ELT(res, 10, NEW_NUMERIC(npols));

		fpos =  (signed int) ftell(fp);
		n_read = fread ((void *)&h, (size_t)sizeof (struct GSHHS), 
			(size_t)1, fp);
		flip = (! (h.level > 0 && h.level < 5));	
/* Take as sign that byte-swabbing is needed */
		i = 0;
		while (n_read == 1) {
		    if (flip) {
			h.id = swabi4 ((unsigned int)h.id);
			h.n  = swabi4 ((unsigned int)h.n);
			h.level = swabi4 ((unsigned int)h.level);
			h.west  = swabi4 ((unsigned int)h.west);
			h.east  = swabi4 ((unsigned int)h.east);
			h.south = swabi4 ((unsigned int)h.south);
			h.north = swabi4 ((unsigned int)h.north);
			h.area  = swabi4 ((unsigned int)h.area);
			h.version  = swabi4 ((unsigned int)h.version);
			h.greenwich = swabi2 ((unsigned int)h.greenwich);
			h.source = swabi2 ((unsigned int)h.source);
		    }
		    w = h.west  * 1.0e-6;	
/* Convert from microdegrees to degrees */
		    e = h.east  * 1.0e-6;
		    s = h.south * 1.0e-6;
		    n = h.north * 1.0e-6;
		    area = 0.1 * h.area;			
/* Now im km^2 */
		    INTEGER_POINTER(VECTOR_ELT(res, 0))[i] = (signed int) h.id;
		    INTEGER_POINTER(VECTOR_ELT(res, 1))[i] = (signed int) h.n;
		    INTEGER_POINTER(VECTOR_ELT(res, 2))[i] = 
			(signed int) h.level;
		    INTEGER_POINTER(VECTOR_ELT(res, 3))[i] = 
			(signed int) h.source;
		    INTEGER_POINTER(VECTOR_ELT(res, 4))[i] = 
			(signed int) h.greenwich;
		    INTEGER_POINTER(VECTOR_ELT(res, 5))[i] = (signed int) fpos;
		    NUMERIC_POINTER(VECTOR_ELT(res, 6))[i] = area;
		    NUMERIC_POINTER(VECTOR_ELT(res, 7))[i] = w;
		    NUMERIC_POINTER(VECTOR_ELT(res, 8))[i] = e;
		    NUMERIC_POINTER(VECTOR_ELT(res, 9))[i] = s;
		    NUMERIC_POINTER(VECTOR_ELT(res, 10))[i] = n;

		    fseek (fp, (long)(h.n * sizeof(struct POINT)), SEEK_CUR);

		    fpos =  (signed int) ftell(fp);
		    n_read = fread((void *)&h, (size_t)sizeof (struct GSHHS), 
			(size_t)1, fp);
		    i++;
		}

	}
	if (INTEGER_POINTER(mode)[0] == 1) {
		fclose (fp);
		UNPROTECT(pc);
		return(res);
	} else {
		if (INTEGER_POINTER(mode)[0] > 1) {

		    PROTECT(subset = NEW_INTEGER(npols)); pc++;
		    for (i=0; i<npols; i++) {
			INTEGER_POINTER(subset)[i] = 1;
			if (INTEGER_POINTER(VECTOR_ELT(res, 2))[i] > 
			    INTEGER_POINTER(level)[0]) 
			    INTEGER_POINTER(subset)[i] = 0;
			if (NUMERIC_POINTER(VECTOR_ELT(res, 6))[i] < 
			    NUMERIC_POINTER(minarea)[0]) 
			    INTEGER_POINTER(subset)[i] = 0;
		    }

		    if (LOGICAL_POINTER(dolim)[0] == TRUE) {
			PROTECT(choice = NEW_LIST(2)); pc++;
			SET_VECTOR_ELT(choice, 0, NEW_INTEGER(npols));
			SET_VECTOR_ELT(choice, 1, NEW_INTEGER(npols));
			for (i=0; i<npols; i++) {
			    INTEGER_POINTER(VECTOR_ELT(choice, 0))[i] = 0;
			    INTEGER_POINTER(VECTOR_ELT(choice, 1))[i] = 0;
			}
			ipols = 0;
			bb[0] = NUMERIC_POINTER(lim)[0];
			bb[1] = NUMERIC_POINTER(lim)[1];
			bb[2] = NUMERIC_POINTER(lim)[2];
			bb[3] = NUMERIC_POINTER(lim)[3];
			for (i=0; i<npols; i++) {
			  if (INTEGER_POINTER(subset)[i] == 1) {
			    j = 0;
			    bbi[0] = NUMERIC_POINTER(VECTOR_ELT(res, 7))[i];
			    bbi[1] = NUMERIC_POINTER(VECTOR_ELT(res, 8))[i];
			    bbi[2] = NUMERIC_POINTER(VECTOR_ELT(res, 9))[i];
			    bbi[3] = NUMERIC_POINTER(VECTOR_ELT(res, 10))[i];
			    for (k=0; k<4; k++) k1[k] = 0;
			    for (k=0; k<4; k++) k2[k] = 0;
			    k1[0] = gshhs_pipbb(bb[0], bb[2], bbi);
			    k1[1] = gshhs_pipbb(bb[0], bb[3], bbi);
			    k1[2] = gshhs_pipbb(bb[1], bb[2], bbi);
			    k1[3] = gshhs_pipbb(bb[1], bb[3], bbi);
			    k2[0] = gshhs_pipbb(bbi[0], bbi[2], bb);
			    k2[1] = gshhs_pipbb(bbi[0], bbi[3], bb);
			    k2[2] = gshhs_pipbb(bbi[1], bbi[2], bb);
			    k2[3] = gshhs_pipbb(bbi[1], bbi[3], bb);
			    for (k=0, j1=0; k<4; k++) j1+= k1[k];
			    for (k=0, j2=0; k<4; k++) j2+= k2[k];
			    INTEGER_POINTER(VECTOR_ELT(choice, 0))[i] = j1;
			    INTEGER_POINTER(VECTOR_ELT(choice, 1))[i] = j2;
			    if (j1 != 0 || j2 != 0) ipols++;
			  }
			} /* npols */
			PROTECT(chosen = NEW_INTEGER(ipols)); pc++;
			PROTECT(clip = NEW_INTEGER(ipols)); pc++;
			for (i=0, j=0; i<npols; i++) {
			    if (INTEGER_POINTER(VECTOR_ELT(choice, 0))[i] != 0
				|| INTEGER_POINTER(VECTOR_ELT(choice, 1))[i] 
				!= 0) {
				INTEGER_POINTER(chosen)[j] = i;
				INTEGER_POINTER(clip)[j] = 0;
				if (INTEGER_POINTER(VECTOR_ELT(choice, 1))[i] 
				    != 4) INTEGER_POINTER(clip)[j] = 1;
				j++;
			    }
			}


		        if (INTEGER_POINTER(mode)[0] == 4) {
		            fclose (fp);

		            UNPROTECT(pc);
		            return(choice);
		        }

		        if (INTEGER_POINTER(mode)[0] == 3) {
		            fclose (fp);

		            UNPROTECT(pc);
		            return(clip);
		        }

		    } /* dolim */ else {
			for (i=0, ipols=0; i<npols; i++)
			    ipols += INTEGER_POINTER(subset)[i];
			PROTECT(chosen = NEW_INTEGER(ipols)); pc++;
			for (i=0, j=0; i<npols; i++) {
			    if (INTEGER_POINTER(subset)[i] == 1) {
			        INTEGER_POINTER(chosen)[j] = i;
				j++;
			    }
			}
		    }

		    if (INTEGER_POINTER(mode)[0] == 2) {
		        fclose (fp);

		        UNPROTECT(pc);
		        return(chosen);
		    }

		    rewind(fp);
		    PROTECT(plist = NEW_LIST(ipols)); pc++;
		    for (i=0; i < ipols; i++) {
			j = INTEGER_POINTER(chosen)[i];
			if (j > 1) max_east = 180000000;
			j1 = INTEGER_POINTER(VECTOR_ELT(res, 1))[j];
			j2 = INTEGER_POINTER(VECTOR_ELT(res, 5))[j];
			fseek (fp, (long)(sizeof(struct GSHHS) + j2), SEEK_SET);
			SET_VECTOR_ELT(plist, i, allocMatrix(REALSXP, j1, 2));
			for (k = 0; k < j1; k++) {
			    if (fread ((void *)&p, 
				(size_t) sizeof(struct POINT), 
				(size_t) 1, fp) != 1) {
					sprintf (msg, 
			"Error reading file %s for polygon %d, point %d.\n", 
			CHAR(STRING_ELT(fn, 0)), 
			INTEGER_POINTER(VECTOR_ELT(res, 0))[j], k);
					error(msg);
			    }
			    if (flip) {
				p.x = swabi4 ((unsigned int)p.x);
				p.y = swabi4 ((unsigned int)p.y);
			    }
			    lon = (INTEGER_POINTER(VECTOR_ELT(res, 4))[j] 
			    	&& p.x > max_east) ? 
				p.x * 1.0e-6 - 360.0 : p.x * 1.0e-6;
			    lat = p.y * 1.0e-6;
			    NUMERIC_POINTER(VECTOR_ELT(plist, i))[k] =  lon;
			    NUMERIC_POINTER(VECTOR_ELT(plist, i))[k+j1] =  lat;
			}
		    }
		    fclose (fp);

		    UNPROTECT(pc);
		    return(plist);
		}
	}
}

int getNpols(FILE *fp) {
	struct GSHHS h;
	int n_read, flip;
	int npols;
	int n;

	n_read = fread ((void *)&h, (size_t)sizeof (struct GSHHS), 
		(size_t)1, fp);
	flip = (! (h.level > 0 && h.level < 5));	
/* Take as sign that byte-swabbing is needed */
	
	n=0;
	while (n_read == 1) {
		if (flip) {
			h.n  = swabi4 ((unsigned int)h.n);
		}
		fseek (fp, (long)(h.n * sizeof(struct POINT)), SEEK_CUR);
		n_read = fread((void *)&h, (size_t)sizeof (struct GSHHS), 
			(size_t)1, fp);
		n++;
	}

	return(n);
}

int gshhs_between(double x, double low, double up) {
	if (x >= low && x <= up) return(1);
	else return(0);
}

int gshhs_pipbb(double pt1, double pt2, double *bbs) {
	if ((gshhs_between(pt1, bbs[0], bbs[1]) == 1) && 
		(gshhs_between(pt2, bbs[2], bbs[3]) == 1)) return(1);
	else return(0);
} 

