/*
$Id: dssa.h,v 1.1 1996/12/06 15:52:22 cbarnes Exp cbarnes $
$Log: /CacSDL/Code/Classifier/dssa.h $
* 
* 2     6/29/98 5:04p Fisherde
* Incorporated GTRI's classifier changes, UNIX vs. NT, and REALTIME
* wrapper for GUI DLL.
* 
* 1     11/17/97 9:49a Lmrs7
* Original source code for classifier.
Revision 1.1  1996/12/06 15:52:22  cbarnes
Initial revision


*/


#ifndef __INCdssah
#define __INCdssah


/*-------------------------------------------------------------------
training set header - to be used for training sets.
-------------------------------------------------------------------*/
typedef struct{
enum header_types hdr_type;    /*(4 bytes) header type flag*/
char ts_name[32];              /*(32 bytes) training set name*/
char num_vecs[8];              /*(8 bytes) number of vectors in structTrg*/
int sw;                 /*(4 bytes) vector width in pixels*/
int shc;                /*(4 bytes) vector height in pixels*/
enum data_types dt;            /*(4 bytes) data types flag*/
enum complex_flag cf;          /*(4 bytes) complex or real flag*/
char comment[3*80];            /*(240 bytes) text comment space*/
char a[212];                   /*space to fill up 512 total bytes*/
}structTrgHeader;


/* CODE BOOK AND RELATED STRUCTURES */
/*----------------------------------*/
/*      A code book file may correspond to a single stage
        vector quantizer or to a many stage residual quantizer.
        To create a structure that is general enough for both
        single stage and multistage VQ, we assume
        the code book file has the following organization:


                MASTER CODE BOOK HEADER
                CODE BOOK HEADER        #1
                CODE BOOK VECTORS
                CODE BOOK HEADER        #2
                CODE BOOK VECTORS
                :
                :
                CODE BOOK HEADER        #N
                CODE BOOK VECTORS


        We proceed to define three different structures, one each
        for the MASTER CODE BOOK HEADER, CODE BOOK HEADER and CODE
        BOOK VECTORS.
*/


/*-------------------------------------------------------------------
master code book header - to be used for all code book files,
                          both single stage and multistage VQ.
-------------------------------------------------------------------*/
typedef struct{
enum header_types hdr_type;    /*(4 bytes) header type flag*/
char name[32];                 /*(32 bytes) master code book name*/
unsigned num_cbks;             /*(4 bytes) number of cbks in file*/
char structTrg[32];                   /*(32 bytes) training set file*/
char date[32];                 /*(32 bytes) date generated*/
int switch_stage;              /*(4 bytes) switch stage for RVQ*/
char comment[3*80];            /*(240 bytes) text comment space*/
char a[164];                   /*space to fill up 512 total bytes*/
}structCodebookMasterHeader;


/*-------------------------------------------------------------------
code book header - to be used in before code book structure.
-------------------------------------------------------------------*/
typedef struct{
enum header_types hdr_type;    /*(4 bytes) header type flag*/
char cbk_name[32];             /*(32 bytes) code book name*/
char num_vecs[8];              /*(8 bytes) number of vectors in cbk*/
char sw[4];             /*(4 bytes) vector width in pixels*/
char shc[4];            /*(4 bytes) vector height in pixels*/
enum data_types dt;            /*(4 bytes) data types flag*/
enum complex_flag cf;          /*(4 bytes) complex or real flag*/
char comment[3*80];            /*(240 bytes) text comment space*/
}structCodebookHeader;


/*-------------------------------------------------------------------
code book structure
-------------------------------------------------------------------*/
typedef struct{
structCodebookHeader hdr;                /*(300 bytes) code book header*/
int num_vectors;               /*(4 bytes) current number of vectors*/
double threshold;              /*(8 bytes) vrrvq threshold*/
int sw;                 /*(4 bytes) vector width in pixels*/
int shc;                /*(4 bytes) vector height in pixels*/
int vec_buf_siz;               /*(4 bytes) vector buffer size...*/
                                /*specifies maximum number of vectors*/
                                /*allowed in current vector buffer...*/
                                /*used to allocate new memory for*/
                                /*growing larger code books*/
double *dblBUF_codevectors;                  /*(4 bytes) pointer to cbk vectors...*/
                                /*points to vector buffer in core*/
                                /*memory, meaningless when cbk is*/
                                /*stored on disk, allows us to reference*/
                                /*code book vectors from this structure*/
                                /*without allocating memory here*/
char a[200];                   /*space to fill up 512 total bytes*/
}structCodebook;


extern void block_slice(byte*,byte*,int,int,int,enum data_types);
extern void unblock_slice(byte*,byte*,int,int,int,enum data_types);
extern int read_cbk(int,structCodebook*,enum data_types,int);
extern int write_cbk(int,structCodebook*,enum data_types);
extern void set_up_cbk(structCodebook*,char*,int,int,int,enum data_types,enum complex_flag);
extern int read_header(int,byte*,enum header_types);
extern int write_header(int,byte*,enum header_types);
extern void view_cbk_hdr(structCodebookHeader*);
extern void view_cbk_mhdr(structCodebookMasterHeader*);
extern void view_ts_hdr(structTrgHeader*);


#endif /* __INCdssah */