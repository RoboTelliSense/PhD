// IOlib.cpp: implementation of the CIOlib class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#include "App.h"

#include <fcntl.h>
#include <stdio.h>
#include <math.h>
#include <io.h>
#include <stdlib.h>

#include "IOlib.h"

#include "const_params.h"
#include "dssa.h"
#include "dssa_params.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#pragma warning(disable : 4996)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CIOlib::CIOlib()
{
}

CIOlib::~CIOlib()
{
}

int CIOlib::gread(
	int fd,                         /*file descriptor*/
	byte *in_buf,                   /*bufer to read/cast data to*/
	enum data_types disk_dt,        /*type of data on disk*/
	enum data_types in_dt,          /*type of data to cast to*/
	int nobj,                       /*number of objects*/
	enum yin_yang swap              /*swap flag*/
){
	char *chr_ptr,                  /*pointer to char*/
		  *aflt_ptr;                /*pointer to ascii floats*/
	short *srt_ptr;                 /*pointer to shorts*/
	unsigned short *usrt_ptr;       /*pointer to unsigned short*/
	unsigned char *uch_ptr,         /*pointer to unsigned character*/
				   *tmp_buf,        /*temporary buffer*/
				   tmp_byte;        /*temporary character buffer*/
	int *int_ptr;                   /*pointer to integer*/
	unsigned long *ulng_ptr;        /*pointer to unsigned long*/
	long *lng_ptr;                  /*pointer to long*/
	unsigned i,n1,n2,               /*looping varables*/
		  disk_size,                /*num of bytes in disk_dt*/
		  in_size,                  /*num of bytes in in_dt*/
		  tot_num_read,             /*total number of bytes read*/
		  num_read = 0;             /*number of bytes read*/
	float *flt_ptr;                 /*pointer to float*/
	double *dbl_ptr,                /*pointer to double*/
			dbl_tmp;                /*double temp space*/


	/*Set parameters for different disk_buf data types.*/
	switch( disk_dt ){
	  case UCH:
	   disk_size = sizeof(unsigned char);
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
	  case SPECIAL_AFLT:
	   disk_size = SPECIAL_ASCII_FLT_SIZE;
	   break;
	  default:
	   return(-1);
	}/*switch*/


	/*Set parameters for different in_buf data types.*/
	switch( in_dt ){
	  case CHR:
	   in_size = sizeof(char);
	   chr_ptr = (char *)in_buf;
	   break;
	  case UCH:
	   in_size = sizeof(unsigned char);
	   uch_ptr = in_buf;
	   break;
	  case USRT:
	   in_size = sizeof(unsigned short);
	   usrt_ptr = (unsigned short *)in_buf;
	   break;
	  case SRT:
	   in_size = sizeof(short);
	   srt_ptr = (short *)in_buf;
	   break;
	  case dsINT:
	   in_size = sizeof(int);
	   int_ptr = (int *)in_buf;
	   break;
	  case LNG:
	   in_size = sizeof(long);
	   lng_ptr = (long *)in_buf;
	   break;
	  case ULNG:
	   in_size = sizeof(unsigned long);
	   ulng_ptr = (unsigned long *)in_buf;
	   break;
	  case FLT:
	   in_size = sizeof(float);
	   flt_ptr = (float *)in_buf;
	   break;
	  case DBL:
	   in_size = sizeof(double);
	   dbl_ptr = (double *)in_buf;
	   break;
	  default:
	   return(-1);
	}/*switch*/


	if( in_size != disk_size ){
	  /*Allocate memory for temporary buffer to read disk data into.*/
	  tmp_buf = (unsigned char *)calloc(BUFSIZ,disk_size);
	  if( tmp_buf == 0 ){
	   return -1;
	  }/*if*/


	  n1 = nobj;
	  tot_num_read = 0;
	  while( (n2 = MIN(n1,BUFSIZ)) > 0 ){
	   #ifdef SRC_UNIX
	   if( (num_read = read(fd,tmp_buf,n2*disk_size)) != n2*disk_size )
	   #endif
	   #ifdef SRC_NT
	   if( (num_read = _read(fd,tmp_buf,n2*disk_size)) != n2*disk_size )
	   #endif
		if( num_read != 0 ){
	     return -1;
		}
		else return 0;
	   tot_num_read += num_read;


	   /*Swap data if requested.*/
	   if( swap == YES ){
		if( disk_dt == SRT || disk_dt == USRT ){
			for(i=0; i<n2; i++)
			{
				SWAP( (*(tmp_buf + i*2)), (*(tmp_buf + i*2 + 1)), tmp_byte);
			}
		}
	   }


	   switch(disk_dt){
		case UCH:
		 uch_ptr = tmp_buf;
		 switch(in_dt){
		  case USRT:
		   for(i=0; i<n2; i++) *usrt_ptr++ = (unsigned short)*uch_ptr++;
		   break;
		  case dsINT:
		   for(i=0; i<n2; i++) *int_ptr++ = (int)*uch_ptr++;
		   break;
		  case FLT:
		   for(i=0; i<n2; i++) *flt_ptr++ = (float)*uch_ptr++;
		   break;
		  case DBL:
		   for(i=0; i<n2; i++) *dbl_ptr++ = (double)*uch_ptr++;
		   break;
		  default:
		   return(-1);
		 }/*switch*/  
		 break;
		case USRT:
		 usrt_ptr = (unsigned short *)tmp_buf;
		 switch(in_dt){
		  case UCH:
		   for(i=0; i<n2; i++) *uch_ptr++ = (unsigned char)*usrt_ptr++;
		   break;
		  case dsINT:
		   for(i=0; i<n2; i++) *int_ptr++ = (int)*usrt_ptr++;
		   break;
		  case FLT:
		   for(i=0; i<n2; i++) *flt_ptr++ = (float)*usrt_ptr++;
		   break;
		  case DBL:
		   for(i=0; i<n2; i++) *dbl_ptr++ = (double)*usrt_ptr++;
		   break;
		  default:
		   return(-1);
		 }/*switch*/  
		 break;
		case SRT:
		 srt_ptr = (short *)tmp_buf;
		 switch(in_dt){
		  case dsINT:
		   for(i=0; i<n2; i++) *int_ptr++ = (int)*srt_ptr++;
		   break;
		  case FLT:
		   for(i=0; i<n2; i++) *flt_ptr++ = (float)*srt_ptr++;
		   break;
		  default:
		   return(-1);
		 }/*switch*/  
		 break;
		case FLT:
		 flt_ptr = (float *)tmp_buf;
		 switch(in_dt){
		  case dsINT:
		   for(i=0; i<n2; i++) *int_ptr++ = (int)*flt_ptr++;
		   break;
		  case FLT:
		   for(i=0; i<n2; i++) *flt_ptr++ = (float)*flt_ptr++;
		   break;
		  case DBL:
		   for(i=0; i<n2; i++) *dbl_ptr++ = (double)*flt_ptr++;
		   break;
		  default:
		   return(-1);
		 }/*switch*/  
		 break;
		case DBL:
		 dbl_ptr = (double *)tmp_buf;
		 switch(in_dt){
		  case dsINT:
		   for(i=0; i<n2; i++) *int_ptr++ = (int)*dbl_ptr++;
		   break;
		  case FLT:
		   for(i=0; i<n2; i++) *flt_ptr++ = (float)*dbl_ptr++;
		   break;
		  default:
		   return(-1);
		 }/*switch*/  
		 break;
		case SPECIAL_AFLT:
		 aflt_ptr = (char *)tmp_buf;
		 switch(in_dt){
		  case UCH:
		   for(i=0; i<n2; i++,aflt_ptr+=SPECIAL_ASCII_FLT_SIZE){
			dbl_tmp = atof(aflt_ptr) + 0.5;
			if( dbl_tmp >= 256.0) dbl_tmp = 255.0;
			if( dbl_tmp <    0.0) dbl_tmp = 0.0;
			*uch_ptr++ = (unsigned char)floor(dbl_tmp);
		   }
		   break;
		  case USRT:
		   for(i=0; i<n2; i++,aflt_ptr+=SPECIAL_ASCII_FLT_SIZE){
			dbl_tmp = atof(aflt_ptr) + 0.5;
			if( dbl_tmp >= 65536.0) dbl_tmp = 65535.0;
			if( dbl_tmp <      0.0) dbl_tmp = 0.0;
			*usrt_ptr++ = (unsigned short)floor(dbl_tmp);
		   }
		   break;
		  case FLT:
		   for(i=0; i<n2; i++){
			*flt_ptr++ = (float)atof(aflt_ptr);
			aflt_ptr += SPECIAL_ASCII_FLT_SIZE;
		   }
		   break;
		  default:
		   return(-1);
		 }/*switch*/  
		 break;
		default:
		 return(-1);
	   }/*switch*/
	   n1 -= n2;
	  }/*while*/


	  /*Free dynamic memory.*/
	  free(tmp_buf);									// SRC_NT BUG!!!!!!!!!!!!!!!!!!!!!!!!!


	}/*if*/
	else{
	  n1 = nobj;
	  tot_num_read = 0;
	  while( (n2 = MIN(n1,BUFSIZ)) > 0 ){
	   #ifdef SRC_UNIX
	   if( (num_read = read(fd,(void*)(in_buf+tot_num_read),(unsigned int)n2*disk_size)) != n2*disk_size)
	   #endif
	   #ifdef SRC_NT
	   if( (num_read = _read(fd,(void*)(in_buf+tot_num_read),(unsigned int)n2*disk_size)) != n2*disk_size)
	   #endif
		if( num_read != 0 ){
			 return -1;
		}
		else return 0;
 
	   /*SWAP HERE*/
	   if( swap == YES ){
		if( disk_dt == SRT || disk_dt == USRT ){
		 for(i=0; i<n2; i++){


		  SWAP( *(in_buf + tot_num_read + i*2), 
							*(in_buf + tot_num_read + i*2 + 1), tmp_byte);
		 }
		}
	   }


	   tot_num_read += num_read;


	   n1 -= n2;


	  }/*while*/
	}/*else*/
	return tot_num_read/disk_size;

}

int CIOlib::gopen(
	char *filename,
	enum rw_perm flags
	){
	int fd = 0;
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
	   return -1;
	}
	return fd;

}
