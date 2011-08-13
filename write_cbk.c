/*
$Id: write_cbk.c,v 1.2 1997/10/27 19:31:19 cbarnes Exp cbarnes $
$Log: write_cbk.c,v $
Revision 1.2  1997/10/27 19:31:19  cbarnes * NT-port changes
Revision 1.1  1997/01/06 16:01:42  cbarnes * Initial revision
*/
/*============================================================================*/
#include <stdio.h>
#ifdef SRC_NT
#include <stdlib.h>
#endif
#include "const_params.h"
#include "dssa.h"
/*============================================================================*/
int write_cbk(
int fd,               /*file descriptor of input file*/
structCodebook *pcbk,      /*pointer to codebook buffer*/
enum data_types dt    /*data type to write*/
){
int nobj;             /*number of objects to read*/


/*Write header first.*/
if( write_header(fd,(byte*)&(pcbk->hdr),CBK) < 0 ){
  perror("write_cbk:error writting header:");
  exit(-1);
}


/*Determine number of bytes to write.*/
nobj = pcbk->num_vectors * pcbk->sw * pcbk->shc;
if( nobj == 0 ) fprintf(stderr,"Warning: codebooks are empty\n");


/*Write codevectors.*/
if( gwrite(fd,(byte*)pcbk->dblBUF_codevectors,pcbk->hdr.dt,dt,nobj,NO) != nobj ) 
  return -1;
else  
  return 0;


}