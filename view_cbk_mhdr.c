/*
$Id: view_cbk_mhdr.c,v 1.1 1997/10/27 19:36:55 cbarnes Exp cbarnes $
$Log: view_cbk_mhdr.c,v $
Revision 1.1  1997/10/27 19:36:55  cbarnes
Initial revision


*/


#include <stdio.h>
#include "const_params.h"
#include "ip.h"
#include "dssa.h"


void view_cbk_mhdr( structCodebookMasterHeader *cbk_mhdr ){
int i;
printf("\t\tCODE BOOK NAME       = %s\n",cbk_mhdr->name);
printf("\t\tNUMBER OF CODE BOOKS = %d\n",cbk_mhdr->num_cbks);
printf("\t\tTRAINING SET FILE    = %s\n",cbk_mhdr->structTrg);
printf("\t\tDATE GENERATED       = %s\n",cbk_mhdr->date);
printf("\n");
printf("\t\tMASTER CODE BOOK HEADER COMMENT:\n\n");
for(i=0; i<240; i++){
  printf("%c",cbk_mhdr->comment[i]);
  if( (i+1)%80 == 0 ) printf("\n");
}
printf("\n");
}