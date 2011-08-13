#include <stdio.h>
#include <process.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>

#include <stdio.h>
#include <conio.h>
#include <process.h>


#include "const_params.h"
#include "ip.h"
#include "dssa.h"

#pragma warning(disable : 4996)

#define MAXNUMSTAGES 256

#define Usage "\n\
Usage: %s in_file oper \n\
\n\
\tin_file - name of input file to edit\n\
\toper - operation to perform:\n\
\t\ta - add a header\n\
\t\tr - remove a header\n\
\t\structTrg - show a header\n\
\t\tc - change a header\n\
\n"

typedef struct{
 char in_file[256];	/*input filename*/
 int oper;		/*operation to perform*/
}rp;

parse_command_line(argc,argv,p)
int argc;
char *argv[];
rp *p;				/*command line parameters*/
{
 if( argc < 3 ){
  if( argc > 1 )
   fprintf(stderr,"Command line does not have required arguments:\n");
  fprintf(stderr,Usage,argv[0]);
  exit(-1);
 }
 strcpy(p->in_file,argv[1]);	/*get input filename*/
 p->oper = *argv[2];	 	/*get operation in integer*/
}/*parse_command_line*/


//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
main(argc,argv) int argc; char *argv[];
{
 char sys_cmd[256];     /*buffer for system commands*/
 char buf[256];
 int i,j,k,l;
 int nobj;
 int char_int;
 int char_cnt=0;
 int in_fd;		/*input file descriptor*/
 int hdr_d;		/*header descriptor*/
 int it_d;		/*image type descriptor*/
 int dt_d;		/*display type descriptor*/
 int st_d;		/*display type descriptor*/
 int dyt_d;		/*display type descriptor*/
 int ct_d;		/*display type descriptor*/
 double *cb[MAXNUMSTAGES];
 rp p;			/*command line parameters*/
 image_header img_hdr;	/*image header*/
 structTrgHeader ts_hdr;	/*training set header*/
 structCodebookMasterHeader cbk_mhdr;	/*code book master header*/
 structCodebook cbks[MAXNUMSTAGES];/*code books*/

 //char *args[4];

 parse_command_line(argc,argv,&p);
 
 /*PERFORM DIFFERENT HEADER OPERATIONS.*/
 /*------------------------------------*/
 switch(p.oper){
  /*Add headers.*/
  case('a'):
   /*Prompt for type of header to add.*/
   printf("\nEnter type of header to add (0-3):\n\n");
   printf("\t0 - image header\n");
   printf("\t1 - training set header\n");
   printf("\t2 - code book header\n");
   printf("\t3 - master code book header\n");
   printf("-> ");
   hdr_d = atoi(gets(buf));

   /*Add different types of headers.*/
   switch(hdr_d){
    /*Add image header.*/
    case(0):
     img_hdr.hdr_type = IMG;

     printf("\nEnter image name: ");
     gets(img_hdr.name);

     printf("\nEnter image width in pixels: ");
     gets(img_hdr.width);

     printf("\nEnter image height in pixels: ");
     gets(img_hdr.height);

     printf("\nEnter image type (0-2):\n\n");
     printf("\t0 - intensity image\n");
     printf("\t1 - density image\n");
     printf("\t2 - gamma corrected image\n");
     printf("-> ");
     it_d = atoi(gets(buf));
     switch(it_d){
      case(0):img_hdr.img_type = ITN; break;
      case(1):img_hdr.img_type = DEN; break;
      case(2):img_hdr.img_type = GMC; break;
      default:
       fprintf(stderr,"edithead: image type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter display type (0-1):\n\n");
     printf("\t0 - monochrome image\n");
     printf("\t1 - color image\n");
     printf("-> ");
     dt_d = atoi(gets(buf));
     switch(dt_d){
      case(0):img_hdr.dis_type = MONO; break;
      case(1):img_hdr.dis_type = COLOR; break;
      default:
       fprintf(stderr,"edithead: display type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter image source type (0-4):\n\n");
     printf("\t0 - electro-optical\n");
     printf("\t1 - synthetic array radar\n");
     printf("\t2 - sonar\n");
     printf("\t3 - infrared\n");
     printf("-> ");
     st_d = atoi(gets(buf));
     switch(st_d){
      case(0):img_hdr.sen_type = EO; break;
      case(1):img_hdr.sen_type = SAR; break;
      case(2):img_hdr.sen_type = SONAR; break;
      case(3):img_hdr.sen_type = FLIR; break;
      default:
       fprintf(stderr,"edithead: source type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter image data type (0-3):\n\n");
     printf("\t0 - unsigned character (1 byte)\n");
     printf("\t1 - unsigned short     (2 bytes)\n");
     printf("\t2 - integer            (4? bytes)\n");
     printf("\t3 - float              (4 bytes)\n");
     printf("\t4 - double             (8 bytes)\n");
     printf("-> ");
     dyt_d = atoi(gets(buf));
     switch(dyt_d){
      case(0):img_hdr.dt = UCH; break;
      case(1):img_hdr.dt = USRT; break;
      case(2):img_hdr.dt = dsINT; break;
      case(3):img_hdr.dt = FLT; break;
      case(4):img_hdr.dt = DBL; break;
      default:
       fprintf(stderr,"edithead: data type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter real or complex (0-1):\n\n");
     printf("\t0 - real\n");
     printf("\t1 - complex\n");
     printf("-> ");
     ct_d = atoi(gets(buf));
     switch(ct_d){
      case(0):img_hdr.cf = REAL; break;
      case(1):img_hdr.cf = CPLX; break;
      default:
       fprintf(stderr,"edithead: data type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter a character string no longer than 240 characters:\n");
     printf("(Terminate string with a RETURN)\n");
     printf("-> ");
     /*Get characters until a new line is entered.*/
     char_cnt = 0;
     do{
      char_int = getc(stdin);
      img_hdr.comment[char_cnt++] = (char)char_int;
     }while( char_int != '\n' );
     /*Pad remainder of character buffer with spaces.*/
     for(i=char_cnt; i<240; i++) img_hdr.comment[i] = (char)' ';

	 _flushall();

     /*Move file without header to a temporary file.*/
     strcpy(sys_cmd,"move ");
     strcat(sys_cmd,p.in_file);
     strcat(sys_cmd," tmp.xx");
	 system(sys_cmd);	/*perform command*/

	 _flushall();

     /*Open a new file with same name.*/
     in_fd = gopen(p.in_file,W);

     /*Write header to empty file with orignal filename.*/
     write_header(in_fd,(byte*)&img_hdr,IMG);

	 close(in_fd);

	 _flushall();

     /*Catenate temporary data file to file with header.*/
     strcpy(sys_cmd,"type ");
     strcat(sys_cmd,"tmp.xx >> ");
     strcat(sys_cmd,p.in_file);
     system(sys_cmd);		/*perform command*/

	 _flushall();

     /*Remove temporary file.*/
     strcpy(sys_cmd,"del tmp.xx");
     system(sys_cmd);		/*perform command*/

	 _flushall();

     break;

    /*Add training set header.*/
    /*------------------------*/
    case(1):
     ts_hdr.hdr_type = TSH;

     printf("\nEnter training set name: ");
     gets(ts_hdr.ts_name);

     printf("\nEnter number of vectors in training set: ");
     gets(ts_hdr.num_vecs);

     printf("\nEnter training set vector width in pixels: ");
     ts_hdr.sw = atoi(gets(buf));

     printf("\nEnter training set vector height in pixels: ");
     ts_hdr.shc = atoi(gets(buf));

     printf("\nEnter training set data type (0-3):\n\n");
     printf("\t0 - unsigned character (1 byte)\n");
     printf("\t1 - unsigned short     (2 bytes)\n");
     printf("\t2 - integer            (4? bytes)\n");
     printf("\t3 - float              (4 bytes)\n");
     printf("\t4 - double             (8 bytes)\n");
     printf("-> ");
     dyt_d = atoi(gets(buf));
     switch(dyt_d){
      case(0):ts_hdr.dt = UCH; break;
      case(1):ts_hdr.dt = USRT; break;
      case(2):ts_hdr.dt = dsINT; break;
      case(3):ts_hdr.dt = FLT; break;
      case(4):ts_hdr.dt = DBL; break;
      default:
       fprintf(stderr,"edithead: data type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter real or complex (0-1):\n\n");
     printf("\t0 - real\n");
     printf("\t1 - complex\n");
     printf("-> ");
     ct_d = atoi(gets(buf));
     switch(ct_d){
      case(0):ts_hdr.cf = REAL; break;
      case(1):ts_hdr.cf = CPLX; break;
      default:
       fprintf(stderr,"edithead: data type unclear");
       exit(-1);
     }/*switch*/

     printf("\nEnter a character string no longer than 240 characters:\n");
     printf("(Terminate string with a RETURN)\n");
     printf("-> ");
     /*Get characters until a new line is entered.*/
     char_cnt = 0;
     do{
      char_int = getc(stdin);
      ts_hdr.comment[char_cnt++] = (char)char_int;
     }while( char_int != '\n' );
     /*Pad remainder of character buffer with spaces.*/
     for(i=char_cnt; i<240; i++) ts_hdr.comment[i] = (char)' ';

     /*Move file without header to a temporary file.*/
     strcpy(sys_cmd,"copy ");
     strcat(sys_cmd,p.in_file);
     strcat(sys_cmd," /B tmp.xx /B");
     system(sys_cmd);		/*perform command*/

     /*Open a new file with same name.*/
     in_fd = gopen("tmp2.xx",W);

     /*Write header to empty file with orignal filename.*/
     write_header(in_fd,(byte*)&ts_hdr,TSH);

	 _close(in_fd);

     /*Catenate temporary data file to file with header.*/
     strcpy(sys_cmd,"copy tmp2.xx /B + tmp.xx /B ");
     //strcat(sys_cmd,"tmp.xx >> ");
     strcat(sys_cmd,p.in_file);
	 strcat(sys_cmd," /B");
     system(sys_cmd);		/*perform command*/

     /*Remove temporary file.*/
//     strcpy(sys_cmd,"del tmp.xx");
//     system(sys_cmd);		/*perform command*/
//	 strcpy(sys_cmd,"del tmp2.xx");
//     system(sys_cmd);		/*perform command*/

     break;

    default:
     fprintf(stderr,"edithead: header type to add unclear");
     exit(-1);
   }/*switch*/
   break;

  /*Show different types of headers.*/
  case('s'):
   /*Prompt for type of header to show.*/
   printf("\nEnter type of header to show (0-3):\n\n");
   printf("\t0 - image header\n");
   printf("\t1 - training set header\n");
   printf("\t2 - code book header\n");
   printf("\t3 - master code book header\n");
   printf("-> ");
   hdr_d = atoi(gets(buf));

   switch(hdr_d){
    /*Show image header.*/
    case(0):
     /*Open file and read header from disk.*/
     in_fd = gopen(argv[1],R);
     read_header(in_fd,(byte*)&img_hdr,IMG);

     if( img_hdr.hdr_type == IMG ) printf("\n\tIMAGE HEADER:\n");
     else printf("\nWARNING: not an image header\n");
     view_img_hdr(&img_hdr);

     break;

    /*Show training set header.*/
    case(1):
     /*Open file and read header from disk.*/
     in_fd = gopen(argv[1],R);
     read_header(in_fd,(byte*)&ts_hdr,TSH);
     if( ts_hdr.hdr_type == TSH ) printf("\n\tTRAINING SET HEADER:\n");
     else printf("\nWARNING: not an training set header\n");
     view_ts_hdr(&ts_hdr);
     break;

    /*Show code book header.*/
    case(2):
     /*Open file and read header from disk.*/
     in_fd = gopen(argv[1],R);
     read_header(in_fd,(byte*)&cbk_mhdr,MCBK);
     if( cbk_mhdr.hdr_type == MCBK ){
      printf("\n\tCODE BOOK MASTER HEADER:\n");
      view_cbk_mhdr(&cbk_mhdr);
     }/*if*/
     else{
      printf("\nWARNING: not a code book master header\n");
      exit(-1);
     }/*else*/

     for(i=0; i<(int)cbk_mhdr.num_cbks; i++){
      read_header(in_fd,(byte*)&(cbks[i].hdr),CBK);
      if( cbks[i].hdr.hdr_type == CBK ){
       printf("\n\tCODE BOOK HEADER:\n");
       view_cbk_hdr(&cbks[i].hdr);
      }
      else{
       printf("\nWARNING: not a code book header\n");
       exit(-1);
      }
      nobj = cbks[i].num_vectors*cbks[i].sw*cbks[i].shc;
      cbks[i].dblBUF_codevectors = (double *)malloc(nobj*sizeof(double));
      if( cbks[i].dblBUF_codevectors == NULL ){
       perror("edithead:cannot allocate space for code vectors:");
       exit(-1);
      }
      /*Read code books.*/
      if( gread(in_fd,(byte *)cbks[i].dblBUF_codevectors,DBL,DBL,nobj,NO) != nobj ){
       perror("error reading code books: ");
       exit(-1);
      }
      cb[i] = cbks[i].dblBUF_codevectors;
      printf("Code Book #%d\n",i);
      for(j=0; j<cbks[i].num_vectors; j++){
       printf("\nCode Vector #%d\n",j);
       for(k=0; k<MIN(8,cbks[i].shc); k++){
        for(l=0; l<MIN(8,cbks[i].sw); l++)
		/*
         printf("%+4.2e ", *(cb[i] + 
		 */
         printf("%+10.8e ", *(cb[i] + 
			    j*cbks[i].shc*cbks[i].sw + 
			    k*cbks[i].sw + l));
        printf("\n");
       }
      }
     }/*i*/
     break;
    /*Show master code book header.*/
    case(3):
     /*Open file and read header from disk.*/
     in_fd = gopen(argv[1],R);
     read_header(in_fd,(byte*)&cbk_mhdr,MCBK);
     if( cbk_mhdr.hdr_type == MCBK ){
      printf("\n\tCODE BOOK MASTER HEADER:\n");
      view_cbk_mhdr(&cbk_mhdr);
     }
     else printf("\nWARNING: not a code book master header\n");
     break;
   }/*switch*/ 

   break;

  /*Remove header.*/
  case('r'):
   /*Move the file to a temporary file.*/
   strcpy(sys_cmd,"move ");
   strcat(sys_cmd,p.in_file);
   strcat(sys_cmd," tmp.xx");
   system(sys_cmd);		/*perform command*/

   /*Copy the tail (all but header) to the original file name.*/
   strcpy(sys_cmd,"tail +513c tmp.xx > ");
   strcat(sys_cmd,p.in_file);
   system(sys_cmd);		/*perform command*/

   /*Remove temporary file.*/
   strcpy(sys_cmd,"del tmp.xx");
   system(sys_cmd);		/*perform command*/
    
   break;

  case('c'):
   /*Prompt for type of header to show.*/
   printf("\nEnter type of header to change (0-3):\n\n");
   printf("\t0 - master code book header\n");
   printf("-> ");
   hdr_d = atoi(gets(buf));

   switch(hdr_d){
    /*Change master code book header.*/
    case(0):
     /*Open file and read header from disk.*/
     if( (in_fd = gopen(argv[1],R)) < 3 ){
      perror("error opening codebook ");
      exit(-1);
     }
     read_header(in_fd,(byte*)&cbk_mhdr,MCBK);
     if( cbk_mhdr.hdr_type == MCBK ){
      printf("\n\tCODE BOOK MASTER HEADER:\n");
      view_cbk_mhdr(&cbk_mhdr);
     }
     else printf("\nWARNING: not a code book master header\n");

     printf("\nEnter new value of NUMBER OF CODE BOOKS:\n\n");
     printf("-> ");
     cbk_mhdr.num_cbks = atoi(gets(buf));

     for(i=0; i<(int)cbk_mhdr.num_cbks; i++){
      /*Read existing code books.*/
      if( read_cbk(in_fd,&cbks[i],FLT,-1) < 0 ){
       perror("get_cbks: error reading code books: ");
       exit(-1);
      }
      //if( 0 ) view_cbk_hdr(cbks[i].hdr);
     }

     close(in_fd);

     /*Remove old copy of codebook.*/
     strcpy(sys_cmd,"del ");
     strcat(sys_cmd,p.in_file);
     system(sys_cmd);		/*perform command*/

     /*Open codebook file for writing.*/
     if( (in_fd = gopen(argv[1],W)) < 3 ){
      perror("error opening codebook ");
      exit(-1);
     }
     /*Write the master header to the file.*/
     if( write_header(in_fd,(byte*)&cbk_mhdr,MCBK) < 0 ){
      perror("write_cbks: error writing master code book header: ");
      exit(-1);
     }
     /*Write the code books to disk.*/
     for(i=0; i<(int)cbk_mhdr.num_cbks; i++)
      if( write_cbk(in_fd,&cbks[i],cbks[i].hdr.dt) < 0 ){
       perror("write_cbks: error writing code books: ");
       exit(-1);
      }
     close(in_fd);
     break;
   default:
    fprintf(stderr,"edithead: change operation unclear\n");
    exit(-1);
    break;
   }/*switch*/ 

   break;

  default:
   fprintf(stderr,"edithead: header operation unclear\n");
   exit(-1);
   break;
 }/*switch*/
}/*main*/
