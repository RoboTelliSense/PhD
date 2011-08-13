/*
$Id: gsizeof.c,v 1.3 1998/06/24 16:18:25 cbarnes Exp cbarnes $
$Log: gsizeof.c,v $
Revision 1.3  1998/06/24 16:18:25  cbarnes * NT Port Changes
Revision 1.2  1998/02/25 16:05:58  cbarnes
Revision 1.1  1997/10/23 14:14:33  cbarnes * Initial revision
*/


#include <sys/types.h>
#ifdef SRC_UNIX
#include <unistd.h>
#endif
#ifdef SRC_NT
#include <stdio.h>
#include <stdlib.h>
#include <io.h>
#endif
#include "const_params.h"

#pragma warning(disable : 4996)

long gsizeof(char *file)
{
int fd;        /*file discriptor*/
long size;     /*return value of lseek*/


if( (fd = gopen(file,R)) < 3 ){
#ifndef REALTIME
  perror("gsizeof:error opening file:");
#endif
  return -1;
}
#ifdef SRC_UNIX
size = (long) lseek(fd,(off_t)0,SEEK_END);
#endif
#ifdef SRC_NT
size = (long) _lseek(fd,(off_t)0,SEEK_END);
#endif
if( size < 0 ){
#ifndef REALTIME
  perror("gsizeof: error in lseek(): ");
#endif
}
close(fd);
return(size);
}