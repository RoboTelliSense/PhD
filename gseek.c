/*
$Id: gseek.c,v 1.2 1998/06/24 16:21:50 cbarnes Exp cbarnes $
$Log: gseek.c,v $
Revision 1.2  1998/06/24 16:21:50  cbarnes * NT Port Changes
Revision 1.1  1997/10/23 13:52:42  cbarnes * Initial revision
*/


#include <sys/types.h>
#ifdef SRC_UNIX
#include <unistd.h>
#endif
#ifdef SRC_NT
#include <stdio.h>
#include <io.h>
#endif
#include "const_params.h"


long gseek(
int fd,             /*file discriptor*/
long offset,        /*offset in bytes*/
int start           /*start for offset*/
){
long size;         /*return value of lseek*/


if( start == 0 ){
  #ifdef SRC_UNIX
  size = (long) lseek(fd,(off_t)offset,SEEK_SET);
  #endif
  #ifdef SRC_NT
  size = (long) _lseek(fd,(off_t)offset,SEEK_SET);
  #endif
  if( size < 0L ){
#ifndef REALTIME
   perror("gseek: error in lseek(): ");
#endif
   return(-1);
  }
}
if( start == 1 ){
  #ifdef SRC_UNIX
  size = (long) lseek(fd,(off_t)offset,SEEK_CUR);
  #endif
  #ifdef SRC_NT
  size = (long) _lseek(fd,(off_t)offset,SEEK_CUR);
  #endif
  if( size < 0L ){
#ifndef REALTIME
   perror("gseek: error in lseek(): ");
#endif
   return(-1);
  }
}
if( start == 2 ){
  #ifdef SRC_UNIX
  size = (long) lseek(fd,(off_t)offset,SEEK_END);
  #endif
  #ifdef SRC_NT
  size = (long) _lseek(fd,(off_t)offset,SEEK_END);
  #endif
  if( size < 0L ){
#ifndef REALTIME
   perror("gseek: error in lseek(): ");
#endif
   return(-1);
  }
}
return(size);
}