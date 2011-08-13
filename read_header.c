/*
$Id: read_header.c,v 1.1 1997/10/27 19:34:25 cbarnes Exp cbarnes $
$Log: read_header.c,v $
Revision 1.1  1997/10/27 19:34:25  cbarnes * Initial revision
*/


#include <stdio.h>
#include "const_params.h"
#include "ip.h"
#include "dssa.h"


/*--------------------------------------------------------------
read_header() - reads a 512 byte block that contains a header
and returns -1 if read error or if wrong header type is read.
--------------------------------------------------------------*/
int read_header(
int fd,                                 /*file descriptor*/
unsigned char *hdr,                     /*header location*/
enum header_types hdr_type              /*header type flag*/
){
enum header_types file_hdr_type;       /*header type in file*/


/*Read header into header buffer.*/
if( gread(fd,hdr,UCH,UCH,HDR_SIZ,NO) != HDR_SIZ ) return -1;


/*Determine header type read into hdr buffer.*/
file_hdr_type = *((enum header_types *)hdr);
switch( hdr_type ){
  case IMG:
   if( file_hdr_type != IMG ){
#ifndef REALTIME
    fprintf(stderr,"warning: not an image header\n");
#endif
    return -1;
   }
   else return 0;
  case TSH:
   if( file_hdr_type != TSH ){
#ifndef REALTIME
    fprintf(stderr,"warning: not a training set header\n");
#endif
    return -1;
   }
   else return 0;
  case MCBK :
   if( file_hdr_type != MCBK ){
#ifndef REALTIME
    fprintf(stderr,"warning: not a master code book header\n");
#endif
    return -1;
   }
   else return 0;
  case CBK:
   if( file_hdr_type != CBK ){
#ifndef REALTIME
    fprintf(stderr,"warning: not a code book header\n");
#endif
    return -1;
   }
   else return 0;
  default:
#ifndef REALTIME
   fprintf(stderr,"warning: header type unrecognized\n");
#endif
   return -1;
}
}