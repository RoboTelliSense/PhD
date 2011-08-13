/*
$Id: const_params.h,v 1.1 1996/12/06 15:54:06 cbarnes Exp cbarnes $
$Log: /CacSDL/Code/Classifier/const_params.h $
* 
* 4     4/20/98 2:04a Patelsr
* 
* 3     1/20/98 1:57p Lmrs7
* 
* 2     1/20/98 1:41p Lmrs7
* 
* 1     11/17/97 9:49a Lmrs7
* Original source code for classifier.
Revision 1.1  1996/12/06 15:54:06  cbarnes
Initial revision
*/


#ifndef __INCconst_paramsh
#define __INCconst_paramsh

enum yin_yang {dsTRUE, dsFALSE,YES,NO,OK,NOT_OK};


enum rw_perm {R,W,A,AR,RA,WR,RW};
/*----------------------------------------------*/
/*Tags for different read/write permissions     */
/*      R - read only                           */
/*      W - write only (overwrites!)            */
/*      A - write only                          */
/*      AR - append and read                    */
/*      RA - append and read                    */
/*      WR - read and write                     */
/*      RW - read and write                     */
/*----------------------------------------------*/


enum data_types {CHR,UCH,SRT,USRT,dsINT,dsUINT,LNG,ULNG,FLT,DBL,ALNG,AFLT,SPECIAL_AFLT};
/*------------------------------------------------------*/
/*Tags for different data types:                        */
/*      CHR  - character                (1  byte)       */
/*      UCH  - unsigned character       (1  byte)       */
/*      SRT  - short integer            (2  bytes)      */
/*      USRT - unsigned short integer   (2  bytes)      */
/*      INT  - integer                  (4  bytes)      */
/*      UINT - unsigned integer         (4  bytes)      */
/*      LNG  - long integer             (8  bytes)      */
/*      ULNG - unsigned long integer    (8  bytes)      */
/*      FLT  - float                    (4  bytes)      */
/*      DBL  - double                   (8  bytes)      */
/*      ALNG - ASCII long integer       (16 bytes)      */
/*      AFLT - ASCII float              (16 bytes)      */
/* SPECIAL_AFLT - ASCII float           (7  bytes)      */
/*------------------------------------------------------*/


enum sensor_types {EO,SAR,SONAR,FLIR,ACOUST,XRAY,MRI,CAT};
/*----------------------------------------------*/
/*Tags for different image sources:             */
/*      EO - Light                              */
/*      SAR - Synthetic Array Radar             */
/*      SONAR - Sonar                           */
/*      FLIR - Infrared                         */
/*      ACOUST - Acoustic                       */
/*      XRAY - X-Ray                            */
/*      MRI - Magnetic Resonance                */
/*      CAT - Computer Assisted Tomography      */
/*----------------------------------------------*/


enum header_types {IMG,TSH,CBK,MCBK};
/*--------------------------------------*/
/*Tags for different header types       */
/*      IMG - image header              */
/*      TSH - training set header       */
/*      CBK - code book header          */
/*      MCBK - master code book header  */
/*--------------------------------------*/


enum complex_flag {REAL,CPLX};
/*------------------------------*/
/*Tags for real or complex      */
/*------------------------------*/


/* STRUCTURE DEFINITIONS */
typedef unsigned char byte;
//typedef struct{
//float r;                       /*real part*/
//float i;                       /*imaginary part*/
//} complex;

/* MISCELLANEOUS DEFINITIONS */
#define ZERO 0
#define ONE 1
#define TWO 2
#define THREE 3
#define PI 3.14159265358979323846264338327950288419716939937510
#define LOG_TWO 0.6931471805599452862268
#define C 2.997925e8             /*speed of light m/s*/
#define FLT_INF 1.0e38
#define DBL_INF 1.0e38
#define myINFINITY 1.0e38		//reason for this is that under Linux, if you define INFINITY, you get error that it's already been defined.
#define BIG 1.0e+10
#define BIG_INT 100000000
#define SMALL 1.0e-10
#define PFINITE_PREC  0.000001  /*finite precision positive bound*/
#define NFINITE_PREC -0.000001  /*finite precision negative bound*/
#define HDR_SIZ 512             /*number of bytes in a header*/
#define HST_SIZ 512             /*number of bytes in a history*/
#ifndef gBUFSIZ 
#define gBUFSIZ 1024 
#endif
#ifndef ASCII_FLT_SIZE 
#define ASCII_FLT_SIZE 16 
#endif
#define SPECIAL_ASCII_FLT_SIZE 7 
#ifndef STRLEN 
#define STRLEN 256             /*string buffer length*/
#endif


/*MACRO DEFINITIONS*/
#ifndef MIN 
#define MIN(A,B) ( (A) > (B) ? (B) : (A) ) 
#endif
#ifndef MAX 
#define MAX(A,B) ( (A) > (B) ? (A) : (B) ) 
#endif
#ifndef SQR 
#define SQR(A) ( (A) * (A) )
#endif
#ifndef CUBE 
#define CUBE(A) ( (A) * (A) * (A) )
#endif
#ifndef SWAP 
#define SWAP(a,b,temp) temp=(a);(a)=(b);(b)=temp;
#endif


#endif