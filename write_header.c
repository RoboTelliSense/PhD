

/*
$Id: write_header.c,v 1.1 1997/10/27 19:44:46 cbarnes Exp cbarnes $
$Log: write_header.c,v $
Revision 1.1  1997/10/27 19:44:46  cbarnes * Initial revision
*/


#include <stdio.h>
#include "const_params.h"
#include "ip.h"
#include "dssa.h"


/*-------------------------------------------------------------------
write_header() - writes a HDR_SIZE byte block that contains a header.
-------------------------------------------------------------------*/
int write_header(
int fd,                                        /*file descriptor*/
unsigned char *hdr,                /*header location*/
enum header_types hdr_type     /*header type flag*/
){
if( gwrite(fd,hdr,UCH,UCH,HDR_SIZ,NO) < 0 ) return -1;
else return 0;
}