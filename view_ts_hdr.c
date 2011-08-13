/*
$Id: view_ts_hdr.c,v 1.1 1997/10/27 19:43:15 cbarnes Exp cbarnes $
$Log: view_ts_hdr.c,v $
Revision 1.1  1997/10/27 19:43:15  cbarnes
Initial revision


*/


#include <stdio.h>
#include "const_params.h"
#include "ip.h"
#include "dssa.h"


void view_ts_hdr( structTrgHeader *ts_hdr ){
int i;


printf("\t\tTRAINING SET NAME          = %s\n",ts_hdr->ts_name);
printf("\t\tTRAINING SET # OF VECTORS  = %s\n",ts_hdr->num_vecs);
printf("\t\tTRAINING SET VECTOR WIDTH  = %d\n",ts_hdr->sw);
printf("\t\tTRAINING SET VECTOR HEIGHT = %d\n",ts_hdr->shc);


switch(ts_hdr->dt){
  case(UCH):  printf("\t\tTRAINING SET DATA TYPE     = unsigned character\n"); break;
  case(USRT): printf("\t\tTRAINING SET DATA TYPE     = unsigned short\n"); break;
  case(dsINT):  printf("\t\tTRAINING SET DATA TYPE     = integer\n"); break;
  case(FLT):  printf("\t\tTRAINING SET DATA TYPE     = float\n"); break;
  case(DBL):  printf("\t\tTRAINING SET DATA TYPE     = double\n"); break;
  default: printf("\t\tTRAINING SET DATA TYPE     = unkown\n"); break;
}
switch(ts_hdr->cf){
  case(REAL): printf("\t\tTRAINING SET DATA          = real\n"); break;
  case(CPLX): printf("\t\tTRAINING SET DATA          = complex\n"); break;
  default: printf("\t\tNEITHER REAL NOR COMPLEX\n"); break;
}
printf("\n\t\tTRAINING SET HEADER COMMENT:\n\n");
for(i=0; i<240; i++){
  if( 0x20 <= ts_hdr->comment[i] && ts_hdr->comment[i] <= 0x7E ){
   printf("%c",ts_hdr->comment[i]);
   if( (i+1)%80 == 0 ) printf("\n");
  }else break;
}
printf("\n");
}