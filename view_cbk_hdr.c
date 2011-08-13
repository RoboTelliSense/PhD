/*
$Id: view_cbk_hdr.c,v 1.1 1997/10/27 19:35:42 cbarnes Exp cbarnes $
$Log: view_cbk_hdr.c,v $
Revision 1.1  1997/10/27 19:35:42  cbarnes
Initial revision
*/


#include <stdio.h>
#include "const_params.h"
#include "ip.h"
#include "dssa.h"


void view_cbk_hdr( structCodebookHeader *cbk_hdr ){
int i;


printf("\t\tCODE BOOK NAME         = %s\n",cbk_hdr->cbk_name);
printf("\t\tNUMBER OF VECTORS      = %s\n",cbk_hdr->num_vecs);
printf("\t\tVECTOR WIDTH           = %s\n",cbk_hdr->sw);
printf("\t\tVECTOR HEIGHT          = %s\n",cbk_hdr->shc);


switch(cbk_hdr->dt){
  case(UCH): printf("\t\tCODE BOOK DATA TYPE    = unsigned character\n"); break;
  case(dsINT): printf("\t\tCODE BOOK DATA TYPE    = integer\n"); break;
  case(FLT): printf("\t\tCODE BOOK DATA TYPE    = float\n"); break;
  case(DBL): printf("\t\tCODE BOOK DATA TYPE    = double\n"); break;
  default: printf("\t\tCODE BOOK DATA TYPE    = unkown\n"); break;
}
switch(cbk_hdr->cf){
  case(REAL): printf("\t\tCOMPLEX FLAG           = real\n"); break;
  case(CPLX): printf("\t\tCOMPLEX FLAG           = complex\n"); break;
  default: printf("\t\tNEITHER REAL NOR COMPLEX\n"); break;
}
printf("\n\t\tCODE BOOK HEADER COMMENT:\n\n");
for(i=0; i<240; i++){
  if( 0x20 <= cbk_hdr->comment[i] && cbk_hdr->comment[i] <= 0x7E ){
   printf("%c",cbk_hdr->comment[i]);
   if( (i+1)%80 == 0 ) printf("\n");
  }else break;
}
printf("\n");
}