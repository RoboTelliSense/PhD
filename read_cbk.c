/*
$Id: read_cbk.c,v 1.3 1998/06/24 16:31:38 cbarnes Exp cbarnes $
$Log: /CacSDL/Code/Classifier/read_cbk.c $
//
//2     6/29/98 5:02p Fisherde
//Incorporated GTRI's classifier changes, UNIX vs. NT, and REALTIME
//wrapper for GUI DLL.
Revision 1.3  1998/06/24 16:31:38  cbarnes * NT Port Changes
Revision 1.2  1997/10/27 19:27:18  cbarnes
Revision 1.1  1997/01/06 16:01:27  cbarnes
Initial revision
*/
/*============================================================================*/
#include <stdio.h>
#ifdef SRC_NT
#include <stdlib.h>
#include <malloc.h>
#endif
#include "const_params.h"
#include "dssa.h"
/*============================================================================*/
int read_cbk(
int fd,              /*file descriptor of input file*/
structCodebook *pcbk,     /*pointer to codebook buffer*/
enum data_types dt,  /*data type*/
int num_vecs         /*number of vectors in codebook*/
){
/* int dt_size;*/         /*data type size in bytes*/
int nobj;            /*number of objects to read*/


/*Get header first.*/
if( read_header(fd,(byte*)&(pcbk->hdr),CBK) < 0){
  #ifndef REALTIME
  printf("read_cbk: error reading header: ");
  #endif
  return -1;
};


/*
switch( dt ){
  case UCH: dt_size = sizeof(byte); break;
  case INT: dt_size = sizeof(int); break;
  case FLT: dt_size = sizeof(float); break;
  case DBL: dt_size = sizeof(double); break;
  default:
   #ifndef REALTIME
   printf("read_cbk: cannont recognize data type\n");
   #endif
   return -1;
   break;
}
num_vecs = MAX(num_vecs,atoi(pcbk->hdr.num_vecs));
nobj = num_vecs * pcbk->sw * pcbk->shc;
pcbk->dblBUF_codevectors = (byte *)calloc(nobj,dt_size);
if( pcbk->dblBUF_codevectors == 0 ){
  #ifndef REALTIME
  perror("read_cbk: cannot allocate space for codebook vectors: ");
  #endif
  return -1;
}
*/


/*Allocate buffer for codevectors.*/
nobj = num_vecs * pcbk->sw * pcbk->shc;
pcbk->dblBUF_codevectors = (double *)malloc(nobj*sizeof(double));
if( pcbk->dblBUF_codevectors == NULL ){
  #ifndef REALTIME
  perror("read_cbk:cannot allocate space for codebook vectors:");
  #endif
  return -1;
}


/*Read codevectors.*/
if( gread(fd,(byte*)pcbk->dblBUF_codevectors,pcbk->hdr.dt,DBL,nobj,NO) != nobj )
  return -1;
else
  return nobj;


}/*read_cbk*/