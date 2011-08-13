/*
$Id: gwrite.c,v 1.2 1998/06/24 16:17:17 cbarnes Exp cbarnes $
$Log: gwrite.c,v $
Revision 1.2  1998/06/24 16:17:17  cbarnes * NT Port Changes
Revision 1.1  1997/10/23 14:28:30  cbarnes * Initial revision
*/


#include <stdio.h>
#include <fcntl.h>
#include <math.h>
#ifdef SRC_UNIX
#include <floatingpoint.h>
#endif
#ifdef SRC_NT
#include <stdlib.h>
#include <io.h>
#endif
#include "const_params.h"


int gwrite(
int fd,                         /*file descriptor*/
byte *buf,                      /*bufer to write data from*/
enum data_types buf_dt,         /*type of data buffer*/
enum data_types disk_dt,        /*type of data to write to disk*/
unsigned nobj,                  /*number of objects*/
enum yin_yang swap              /*swap flag*/
){
unsigned char *uch_ptr,        /*pointer to unisgned character*/
               *tmp_buf;        /*temporary bufer*/
char *chr_ptr,                 /*pointer to char*/
      *aflt_ptr;                /*pointer to ascii float*/
byte tmp_char;
unsigned short *usrt_ptr;      /*pointer to integer*/
short *srt_ptr;                /*pointer to integer*/
int *int_ptr;                  /*pointer to integer*/
unsigned i,n1,n2,              /*looping varables*/
     buf_size,                  /*num of bytes in buf_dt*/
     disk_size,                 /*num of bytes in disk_dt*/
     tot_num_writ,              /*total number written*/
     num_writ;                  /*number written*/
long *lng_ptr;                 /*pointer to long*/
unsigned long *ulng_ptr;       /*pointer to unsigned long*/
float *flt_ptr;                /*pointer to float*/
double *dbl_ptr;               /*pointer to double*/
double dbl_tmp;


/*Set parameters for different buf data types.*/
switch( buf_dt ){
  case UCH:
   buf_size = sizeof(byte);
   uch_ptr = buf;
   break;
  case CHR:
   buf_size = sizeof(char);
   chr_ptr = (char *)buf;
   break;
  case USRT:
   buf_size = sizeof(unsigned short);
   usrt_ptr = (unsigned short *)buf;
   break;
  case SRT:
   buf_size = sizeof(short);
   srt_ptr = (short *)buf;
   break;
  case dsINT:
   buf_size = sizeof(int);
   int_ptr = (int *)buf;
   break;
  case LNG:
   buf_size = sizeof(long);
   lng_ptr = (long *)buf;
   break;
  case ULNG:
   buf_size = sizeof(unsigned long);
   ulng_ptr = (unsigned long *)buf;
   break;
  case FLT:
   buf_size = sizeof(float);
   flt_ptr = (float *)buf;
   break;
  case DBL:
   buf_size = sizeof(double);
   dbl_ptr = (double *)buf;
   break;
  case AFLT:
   buf_size = ASCII_FLT_SIZE;
   aflt_ptr = (char *)buf;
   break;
  default:
#ifndef REALTIME
   fprintf(stderr,"gwrite: undefined data type specifier.\n");
#endif
   return -1;
}/*switch*/


/*Set parameters for different disk_buf data types.*/
switch(disk_dt){
  case UCH:
   disk_size = sizeof(byte);
   break;
  case CHR:
   disk_size = sizeof(char);
   break;
  case USRT:
   disk_size = sizeof(unsigned short);
   break;
  case SRT:
   disk_size = sizeof(short);
   break;
  case dsINT:
   disk_size = sizeof(int);
   break;
  case LNG:
   disk_size = sizeof(long);
   break;
  case ULNG:
   disk_size = sizeof(unsigned long);
   break;
  case FLT:
   disk_size = sizeof(float);
   break;
  case DBL:
   disk_size = sizeof(double);
   break;
  default:
#ifndef REALTIME
   fprintf(stderr,"gwrite: undefined data type specifier.\n");
#endif
   return -1;
}/*switch*/


if( buf_size != disk_size ){
  /*Allocate memory for temporary buffer to write data from.*/
  tmp_buf = (byte *)malloc(BUFSIZ*disk_size);
  if( tmp_buf == NULL ){
#ifndef REALTIME
   printf("gwrite: cannot allocate memory for tmp_buf");
#endif
   return -1;
  }


  n1 = nobj;
  tot_num_writ = 0;
  while( (n2 = MIN(n1,BUFSIZ)) > 0 ){
   /*Cast data before writing to disk.*/
   switch( disk_dt ){
    case UCH:
     uch_ptr = tmp_buf;
     switch( buf_dt ){
      case USRT:
       for(i=0; i<n2; i++) *uch_ptr++ = (unsigned char)*usrt_ptr++;
       break;
      case SRT:
       for(i=0; i<n2; i++) *uch_ptr++ = (unsigned char)*srt_ptr++;
       break;
      case dsINT:
       for(i=0; i<n2; i++) *uch_ptr++ = (unsigned char)*int_ptr++;
       break;
      case FLT:
       for(i=0; i<n2; i++){
                *flt_ptr += (float)0.5;
        if( *flt_ptr >= (float)256.0 ) *flt_ptr = (float)255.0;
        if( *flt_ptr <  (float)  0.0 ) *flt_ptr = (float)  0.0;
        *uch_ptr++ = (byte)floor(*flt_ptr);
                ++flt_ptr;
       }
       break;
      case AFLT:
       for(i=0; i<n2; i++){
        dbl_tmp = atof(aflt_ptr) + 0.5;
        if( dbl_tmp >= 256.0 ) dbl_tmp = 255.0;
        if( dbl_tmp <    0.0 ) dbl_tmp =   0.0;
        *uch_ptr++ = (byte)floor(dbl_tmp);
        aflt_ptr += ASCII_FLT_SIZE;
       }         
       break;
      case DBL:
       for(i=0; i<n2; i++){
                *dbl_ptr += 0.5;
        if( *dbl_ptr >= 256.0 ) *dbl_ptr = 255.0;
        if( *dbl_ptr <    0.0 ) *dbl_ptr =   0.0;
        *uch_ptr++ = (byte)floor(*dbl_ptr);
                ++dbl_ptr;
       }
       break;
      default:
#ifndef REALTIME
       printf("gwrite: buf data type unknown 1\n");
#endif
       return -1;
     }/*switch*/
     break;
    case USRT:
     usrt_ptr = (unsigned short *)tmp_buf;
     switch( buf_dt ){
      case UCH:
       for(i=0; i<n2; i++) *usrt_ptr++ = (unsigned short)*uch_ptr++;
       break;
      case dsINT:
       for(i=0; i<n2; i++) *usrt_ptr++ = (unsigned short)*int_ptr++;
       break;
      case FLT:
       for(i=0; i<n2; i++){
                *flt_ptr += (float)0.5;
        if( *flt_ptr >= (float)65536.0 ) *flt_ptr = (float)65535.0;
        if( *flt_ptr <  (float)    0.0 ) *flt_ptr = (float)    0.0;
        *usrt_ptr++ = (unsigned short)floor(*flt_ptr);
                ++flt_ptr;
       }
       break;
      case DBL:
       for(i=0; i<n2; i++){
                *dbl_ptr += 0.5;
        if( *dbl_ptr >= 65536.0 ) *dbl_ptr = 65535.0;
        if( *dbl_ptr <      0.0 ) *dbl_ptr =     0.0;
        *usrt_ptr++ = (unsigned short)floor(*dbl_ptr);
                ++dbl_ptr;
       }
       break;
      default:
#ifndef REALTIME
       printf("gwrite: buf data type unknown\n");
#endif
       return -1;
     }/*switch*/
     break;
    case SRT:
     srt_ptr = (short *)tmp_buf;
     switch( buf_dt ){
      case FLT:
       for(i=0; i<n2; i++) *srt_ptr++ = (short)*flt_ptr++;
       break;
     }/*switch*/
     break;
    case FLT:
     flt_ptr = (float *)tmp_buf;
     switch( buf_dt ){
      case UCH:
       for(i=0; i<n2; i++) *flt_ptr++ = (float)*uch_ptr++;
       break;
      case SRT:
       for(i=0; i<n2; i++) *flt_ptr++ = (float)*srt_ptr++;
       break;
      case USRT:
       for(i=0; i<n2; i++) *flt_ptr++ = (float)*usrt_ptr++;
       break;
      case AFLT:
       for(i=0; i<n2; i++){
        *flt_ptr++ = (float)atof(aflt_ptr);
        aflt_ptr += ASCII_FLT_SIZE;
       }         
       break;
      case DBL:
       for(i=0; i<n2; i++) *flt_ptr++ = (float)*dbl_ptr++;
       break;
      default:
#ifndef REALTIME
       printf("gwrite: buf data type unknown 2\n");
#endif
       return -1;
     }/*switch*/
     break;
    case DBL:
     dbl_ptr = (double *)tmp_buf;
     switch( buf_dt ){
      case FLT:
       for(i=0; i<n2; i++) *dbl_ptr++ = (double)*flt_ptr++;
       break;
      default:
#ifndef REALTIME
       printf("gwrite: buf data type unknown 3\n");
#endif
       return -1;
     }/*switch*/
     break;
    default:
#ifndef REALTIME
     printf("gwrite: disk data type unknown\n");
#endif
     return -1;
   }/*switch*/


   /*SWAP data is requested.*/
   if( swap == YES ){
    if( disk_dt == SRT ){
     for(i=0; i<n2; i++)
      SWAP( *(tmp_buf + i*2), *(tmp_buf + i*2 + 1), tmp_char);
    }
   }


   #ifdef SRC_UNIX
   if( (num_writ = write(fd,tmp_buf,n2*disk_size)) != n2*disk_size ){
   #endif
   #ifdef SRC_NT
   if( (num_writ = _write(fd,tmp_buf,n2*disk_size)) != n2*disk_size ){
   #endif
#ifndef REALTIME
    perror("gwrite: error writing data");
#endif
    return -1;
   }/*if*/
   tot_num_writ += num_writ;


   n1 -= n2;
  }/*while*/


  /*Free dynamic memory.*/
  free(tmp_buf);


}/*if*/
else{
  n1 = nobj;
  tot_num_writ = 0;
  while( (n2 = MIN(n1,BUFSIZ)) > 0 ){


   /*SWAP HERE*/


   #ifdef SRC_UNIX
   if((num_writ=write(fd,buf+tot_num_writ,n2*buf_size)) != n2*buf_size){
   #endif
   #ifdef SRC_NT
   if((num_writ=_write(fd,buf+tot_num_writ,n2*buf_size)) != n2*buf_size){
   #endif
#ifndef REALTIME
    perror("gwrite: error writing data");
#endif
    return -1;
   }
   tot_num_writ += num_writ;


   n1 -= n2;
  }/*while*/
}/*else*/


return tot_num_writ/disk_size;


}/*gwrite*/