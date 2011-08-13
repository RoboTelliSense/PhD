/*
$Id: gopen.c,v 1.2 1998/06/24 16:14:18 cbarnes Exp cbarnes $
$Log: gopen.c,v $
Revision 1.2  1998/06/24 16:14:18  cbarnes * NT Port Changes
Revision 1.1  1997/10/23 13:38:50  cbarnes * Initial revision
*/


#include <fcntl.h>
#include <stdio.h>
#ifdef SRC_NT
#include <io.h>
#endif
#include "const_params.h"

#pragma warning(disable : 4996)

int gopen(
char *filename,
enum rw_perm flags
){
int fd;
switch(flags){
  case(R):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_RDONLY)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_RDONLY)) < 0) return -1;
   #endif
   break;
  case(W):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_WRONLY|O_CREAT|O_TRUNC,0666)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_WRONLY|_O_CREAT|_O_TRUNC,0666)) < 0) return -1;
   #endif
   break;
  case(A):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_WRONLY|O_CREAT|O_APPEND,0666)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_WRONLY|_O_CREAT|_O_APPEND,0666)) < 0) return -1;
   #endif
   break;
  case(RA):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_RDWR|O_CREAT|O_APPEND,0666)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_RDWR|_O_CREAT|_O_APPEND,0666)) < 0) return -1;
   #endif
   break;
  case(AR):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_RDWR|O_CREAT|O_APPEND,0666)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_RDWR|_O_CREAT|_O_APPEND,0666)) < 0) return -1;
   #endif
   break;
  case(WR):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_RDWR|O_CREAT,0666)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_RDWR|_O_CREAT,0666)) < 0) return -1;
   #endif
   break;
  case(RW):
   #ifdef SRC_UNIX
   if( (fd=open(filename,O_RDWR|O_CREAT,0666)) < 0) return -1;
   #endif
   #ifdef SRC_NT
   if( (fd=_open(filename,_O_BINARY|_O_RDWR|_O_CREAT,0666)) < 0) return -1;
   #endif
   break;
  default:
#ifndef REALTIME
   printf("gopen: cannot recognize file-state:");
#endif
   return -1;
}
return fd;
}