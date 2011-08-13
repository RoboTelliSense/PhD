/*
$Id: view_img_hdr.c,v 1.1 1997/10/27 19:40:58 cbarnes Exp cbarnes $
$Log: view_img_hdr.c,v $
Revision 1.1  1997/10/27 19:40:58  cbarnes
Initial revision
*/


#include <stdio.h>
#include "const_params.h"
#include "ip.h"
#include "dssa.h"


void view_img_hdr( image_header *img_hdr ) {
int i;
printf("\t\tIMAGE NAME         = %s\n",img_hdr->name);
printf("\t\tIMAGE WIDTH        = %s\n",img_hdr->width);
printf("\t\tIMAGE HEIGHT       = %s\n",img_hdr->height);
switch(img_hdr->img_type){
  case(ITN): printf("\t\tIMAGE TYPE         = intensity\n"); break;
  case(DEN): printf("\t\tIMAGE TYPE         = density\n"); break;
  case(GMC): printf("\t\tIMAGE TYPE         = gamma corrected\n"); break;
  default: printf("\t\tIMAGE TYPE = unkown\n"); break;
}
switch(img_hdr->dis_type){
  case(MONO): printf("\t\tIMAGE DISPLAY TYPE = monochrome\n"); break;
  case(COLOR): printf("\t\tIMAGE DISPLAY TYPE = color\n"); break;
  default: printf("\t\tIMAGE DISPLAY TYPE = unkown\n"); break;
}
switch(img_hdr->sen_type){
  case(EO): printf("\t\tIMAGE SOURCE TYPE  = light\n"); break;
  case(SAR): printf("\t\tIMAGE SOURCE TYPE  = SAR\n"); break;
  case(SONAR): printf("\t\tIMAGE SOURCE TYPE  = sonar\n"); break;
  case(FLIR): printf("\t\tIMAGE SOURCE TYPE  = infrared\n"); break;
  default: printf("\t\tIMAGE SOURCE TYPE  = unkown\n"); break;
}
switch(img_hdr->dt){
  case(UCH): printf("\t\tIMAGE DATA TYPE    = unsigned character\n"); break;
  case(USRT): printf("\t\tIMAGE DATA TYPE    = unsigned short\n"); break;
  case(dsINT): printf("\t\tIMAGE DATA TYPE    = integer\n"); break;
  case(FLT): printf("\t\tIMAGE DATA TYPE    = float\n"); break;
  case(DBL): printf("\t\tIMAGE DATA TYPE    = double\n"); break;
  default: printf("\t\tIMAGE DATA TYPE    = unkown\n"); break;
}
switch(img_hdr->cf){
  case(REAL): printf("\t\tIMAGE DATA         = real\n"); break;
  case(CPLX): printf("\t\tIMAGE DATA         = complex\n"); break;
  default: printf("\t\tNEITHER REAL NOR COMPLEX\n"); break;
}
printf("\n\t\tIMAGE HEADER COMMENT:\n\n");
for(i=0; i<240; i++){
  if( 0x20 <= img_hdr->comment[i] && img_hdr->comment[i] <= 0x7E ){
   printf("%c",img_hdr->comment[i]);
   if( (i+1)%80 == 0 ) printf("\n");
  }
  else break;
}
printf("\n");
}