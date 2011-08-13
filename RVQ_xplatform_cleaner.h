#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include <math.h>
using namespace std;

			//RVQ_xplatform_const_params.h
			//----------------------------
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
					#define myINFINITY 1.0e38		//reason for this is that under Linux, if you define INFINITY, you get err that it's already been defined.
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


			//RVQ_xplatform_dssa.h
			//--------------------							
					/*-------------------------------------------------------------------
					training set header - to be used for training sets.
					-------------------------------------------------------------------*/
					typedef struct
					{
						enum	header_types hdr_type;		/*(4 bytes) header type flag*/
						char	ts_name[32];				/*(32 bytes) training set name*/
						char	Nstrippixels[8];					/*(8 bytes) number of vectors in structTrg*/
						int		sw;							/*(4 bytes) vector width in pixels*/
						int		shc;						/*(4 bytes) vector height in pixels*/
						enum	data_types dt;				/*(4 bytes) data types flag*/
						enum	complex_flag cf;			/*(4 bytes) complex or real flag*/
						char	comment[3*80];				/*(240 bytes) text comment space*/
						char	a[212];						/*space to fill up 512 total bytes*/
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
					unsigned N_T;             /*(4 bytes) number of cbks in file*/
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
					char Nstrippixels[8];              /*(8 bytes) number of vectors in cbk*/
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
						structCodebookHeader hdr;					/*(300 bytes) code book header*/
						int num_vectors;				/*(4 bytes) current number of vectors*/
						double threshold;				/*(8 bytes) vrrvq threshold*/
						int sw;							/*(4 bytes) vector width in pixels*/
						int shc;						/*(4 bytes) vector height in pixels*/
						int vec_buf_siz;				/*(4 bytes) vector buffer size...*/
														/*specifies maximum number of vectors*/
														/*allowed in current vector buffer...*/
														/*used to allocate new memory for*/
														/*growing larger code books*/
						double *dblBUF_codevectors;		/*(4 bytes) pointer to cbk vectors...*/
														/*points to vector buffer in core*/
														/*memory, meaningless when cbk is*/
														/*stored on disk, allows us to reference*/
														/*code book vectors from this structure*/
														/*without allocating memory here*/
						char a[200];					/*space to fill up 512 total bytes*/
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


					

			//RVQ_xplatform_dssa_params.h
			//---------------------------						
					#define JGRQ  0

					#define SSFR  0

					#define SEQUENTIAL_SEARCH_RVQ 1
					#define EXHAUSTIVE_SEARCH_RVQ 0

					#define VARIABLE_STOP_RVQ  1
					#define VARIABLE_START_RVQ 1

					#define ESFR  0
					#define ESVR  0
					/*---------------------------------------------------------------------------*/
					#define VERBOSE 1
					/*---------------------------------------------------------------------------*/
					#define L2
					/*---------------------------------------------------------------------------*/
					#define MAXNUMSTAGES 8		/*max number of stages*/
					#define MAXCBKSIZE 17		/*max codebook size*/
					#define MAXVECSIZE 32768		/*max vector size in pixels*/
					#define MAXNUMDSCELLS 1024  /*max number of direct sum cells*/
				/*===========================================================================*/

				#if ( VARIABLE_START_RVQ )
					enum node_state_types { NONVALID, VALID };
				#endif

					/*---------------------------------------------------------------------------*/
					#define USAGE "\n\
					Usage: %s ts_file ecbk_file dcbk_file Mp1 [-OPTIONS]\n\
					\n\
					\tts_file     - filename of training set or data-to-be-encoded\n\
					\tecbk_file   - filename of encoder codebooks\n\
					\tdcbk_file   - filename of decoder codebooks\n\
					\tcbk_size    - number of codevectors per stage\n\
					\n\
					\tOPTIONS - must be last and each must be preceeded by a dash:\n\
					\n\
					\t\t-l : encode only flag (leaves index file)\n\
					\t\t-p : peak SQNR flag\n\
					\t\t-r : remove input vectors' mean values\n\
					\t\t-iNUM : joint encoder-decoder opt threshold (default = 0.05)\n\
					\t\t-jNUM : decoder only optimization threshold (default = 0.05)\n\
					\t\t-mNUM : number of structTrg vectors to use (default set by structTrg header)\n\
					\t\t-SNUM : variable stop-type code (NUM=Stopping threshold in dB)\n\
					\n"
					/*---------------------------------------------------------------------------*/

				#if ( VARIABLE_START_RVQ )
					struct structClassTreeNode
					{
						struct structClassTreeNode *child[MAXCBKSIZE];
					};
				#endif

					typedef struct
					{
						char			*cfn;						//training set filename
						unsigned		Nstrippixels;				//number of training set vectors
						unsigned		Nstripbytes;				//number of training set samples
						double			*dblBUF_trgStrip;				//training set buffer
						double			energy;						//training set energy level
						double			max_pxl;					//training set maximum pixel level
						structTrgHeader tsh;						//training set header
					}
					structTrgParameters;



					typedef struct
					{
						char*							cfn_ecbk;				//filename
						char*							cfn_dcbk;				//filename
						ifstream						ifs_ecbk;				//encoder codebook file descriptor
						ifstream						ifs_dcbk;				//decoder codebook file descriptor
						unsigned						N_T;					//number of stages
						unsigned						Mp1;					//M+1, old comment looks wrong: number of codevectors per codebook
						unsigned						N_posnegPixelsInSnippet;				//vector size
						structCodebookMasterHeader		enc_cbk_mhdr;			//encoder codebook master header
						structCodebookMasterHeader		dec_cbk_mhdr;			//decoder codebook master header
						structCodebook					enc_cbks[MAXNUMSTAGES];	//encoder codebooks
						structCodebook					dec_cbks[MAXNUMSTAGES];	//decoder codebooks
#if ( VARIABLE_START_RVQ )
						struct structClassTreeNode		*root_node;
						unsigned						num_active_nodes;
#endif
					}
					structCodebookParameters;



					typedef struct{
						enum yin_yang prev_cbks;          /*previously existing codebook flag*/
						byte *uchrBUF_soc;                    /*codevector index buffer*/
				#if ( VARIABLE_START_RVQ )
						char node_file[STRLEN];
						byte *uchrBUF_stages;                    /*codevector index buffer*/
				#endif
				#if( EXHAUSTIVE_SEARCH_RVQ )
						unsigned *equiv_idx;              /*equivalent index buffer*/
				#endif
						unsigned num_ds_cells;            /*number of direct sum codevectors/cells*/
						unsigned desired_num_ts_vecs;     /*desired number of training set vectors*/
						unsigned num_primed_stages;       /*pivot stage variable*/
						unsigned cell_cnt[MAXNUMSTAGES][MAXCBKSIZE]; /*cell counts*/
						int mean;                         /*process mean flag*/
						int markov_stage;                 /*markov stage index*/
						int peak_sqnr;                    /*peak SQNR flag*/
						int encode_only;                  /*encode only flag*/
						int switch_stage;                 /*pivot stage variable*/
						int newly_primed;
						int bpp;                          /*bytes per pixel (sample)*/
						int no_null;
						double *tr_buf;                   /*total residual buffer*/
						double *cent_buf;                 /*centroids buffer*/
				#if( EXHAUSTIVE_SEARCH_RVQ )
						double *equiv_cbk;                /*equivalent index buffer*/
				#endif
						double threshold;
						double stop_snr;
						double shell_snr;
						double interior_snr;
						double epsilon;                   /*stopping threshold for enc/dec opt*/
						double d_epsilon;                 /*stopping threshold for decoder opt*/
						double enc_old_cum_dist;          /*encoder old cummulative distortion*/
						double enc_rel_chge_dist;         /*encoder old cummulative distortion*/
						double dec_rel_chge_dist;         /*decoder old cummulative distortion*/
					}structControlParameters;




using namespace std;

#define FALSE   0
#define TRUE    1

#define STRIP_HEIGHT 8

struct cpoint
{
	int x;
	int y;
};
#define INFINITY_DIST 2.0




int		read_header_xplatform	(ifstream&,unsigned char*, enum header_types);
int		read_cbk_xplatform		(ifstream&,structCodebook*,enum data_types,int);
int		gread_xplatform			(ifstream&,unsigned char*,enum data_types, enum data_types,int,enum yin_yang);
int		gwrite_xplatform		(ofstream& fd, byte *buf, enum data_types buf_dt, enum data_types disk_dt, unsigned nobj, enum yin_yang swap);


void get_bnds(
	int last_stage,
	unsigned char *ptr_uchrBUF_Ttuple,
	int *stage,
	struct structClassTreeNode *node,
	enum yin_yang *valid_flag);
int		read_node				(structCodebookParameters *structCodebook, struct structClassTreeNode **node,FILE *node_fp,unsigned int *node_cnt);
void	set_up_cbk				(structCodebook*, char*,int,int,int,enum data_types, enum complex_flag);
int		get_cbks				(structTrgParameters*, structCodebookParameters*, structControlParameters*);




	cpoint ptCropEnd;
	cpoint ptCropStart;
	bool bCropMode;
	int nCropWidth;

	std::string	strNumTemplatesPerStage;
	std::string strSnippetWidth;
	std::string strSnippetHeight;
	std::string strDataPakFidelity;

	// output file parameters
	std::string	strCorrelationFilename;
	std::string strStageMapFilename;
	std::string strDSSAIndexFilename;
	std::string strDSSAStreamFilename;
	std::string strInParameterFilename;

	bool BSaveOutputState=true;
	int nTotalProcessedPixels;
	byte* pbytImageBuf;
	byte* pbytFeatureMapBuf;
	byte* pbytSnippetDisplayBuf;
	byte* pbytDSSAPtupleBuf;
	int nFileNameLength;














//-------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------
int gread_xplatform	(
			ifstream&	fd,						//file descriptor
			byte		*in_buf,				//bufer to read/cast data to
			enum		data_types disk_dt,		//type of data on disk
			enum		data_types in_dt,		//type of data to cast to
			int			nobj,					//number of objects
			enum		yin_yang swap			//swap flag
			)
{
	char			*chr_ptr,					//pointer to char
					*aflt_ptr;					//pointer to ascii floats
	short			*srt_ptr;					//pointer to shorts
	unsigned short	*usrt_ptr;					//pointer to unsigned short
	unsigned char	*uch_ptr,					//pointer to unsigned character
					*tmp_buf,					//temporary buffer
					tmp_byte;					//temporary character buffer
	int				*int_ptr;                   //pointer to integer
	unsigned long	*ulng_ptr;					//pointer to unsigned long
	long			*lng_ptr;					//pointer to long
	unsigned		i,n1,n2,					//looping varables
					disk_size,					//num of bytes in disk_dt
					in_size,					//num of bytes in in_dt
					tot_num_read,				//total number of bytes read
					num_read = 0;				//number of bytes read
	float			*flt_ptr;					//pointer to float
	double			*dbl_ptr,					//pointer to double
					dbl_tmp;					//double temp space


	//Set parameters for different disk_buf data types
		switch( disk_dt )
		{
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
		}

	//Set parameters for different in_buf data types
	switch( in_dt )
	{
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
	}//switch



	if( in_size != disk_size )
	{
		//Allocate memory for temporary buffer to read disk data into.
		tmp_buf = (unsigned char *)calloc(BUFSIZ,disk_size);
		if( tmp_buf == 0 )
		{
			return -1;
		}//if


	  n1 = nobj;
	  tot_num_read = 0;
	  while( (n2 = MIN(n1,BUFSIZ)) > 0 )
	  {																		//replaced legacy code
																			//#ifdef SRC_UNIX
																			//	if( (num_read = read(fd,tmp_buf,n2*disk_size)) != n2*disk_size )
																			//#endif
																			//#ifdef SRC_NT
																			//if( (num_read = fread(fd,tmp_buf,n2*disk_size)) != n2*disk_size )
																			//#endif

		fd.read((char*)tmp_buf,n2*disk_size);
		num_read = fd.gcount();
																			//err checking
																			if( num_read != n2*disk_size )
																			{
																				return -1;
																			}
																			




	   tot_num_read += num_read;


	   //Swap data if requested
		if( swap == YES )
		{
			if( disk_dt == SRT || disk_dt == USRT )
			{
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
		 }//switch
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
		 }//switch
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
		 }//switch
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
		 }//switch
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
		 }//switch
		 break;
		default:
		 return(-1);
	   }//switch
	   n1 -= n2;
	  }//while


	  //free dynamic memory
	  free(tmp_buf);									// SRC_NT BUG!!!!!!!!!!!!!!!!!!!!!!!!!


	}//if
	else
	{
		n1 = nobj;
		tot_num_read = 0;
		while( (n2 = MIN(n1,BUFSIZ)) > 0 )
		{
			//#ifdef SRC_UNIX
			//if( (num_read = fread(fd,(void*)(in_buf+tot_num_read),(unsigned int)n2*disk_size)) != n2*disk_size)
			//#endif
			//#ifdef SRC_NT
			//if( (num_read = fread(fd,(void*)(in_buf+tot_num_read),(unsigned int)n2*disk_size)) != n2*disk_size)
			//#endif
			
			fd.read((char*)in_buf+tot_num_read, (unsigned int)n2*disk_size);
			num_read = fd.gcount();


									if( num_read != n2*disk_size )
									{
										cout<<"not enough bytes read from header"<<endl;
											return -1;
									}
									

			//swap here
			if( swap == YES )
			{
				if( disk_dt == SRT || disk_dt == USRT )
				{
					for(i=0; i<n2; i++)
					{
						SWAP( *(in_buf + tot_num_read + i*2),
							  *(in_buf + tot_num_read + i*2 + 1), tmp_byte);
					}
				}
			}


			tot_num_read += num_read;
			n1 -= n2;
		}//while
	}//else
	return tot_num_read/disk_size;
}

//-------------------------------------------------------------------------------------
//2 steps: (a) read header, (b) read codebook
//if all goes well, it returns OK which is 4
//-------------------------------------------------------------------------------------
int get_cbks(
				structTrgParameters *structTrg,
				structCodebookParameters *structCodebook,
				structControlParameters *structControl
			)
{
	//---------------------------
	//INITIALIZATIONS
	//---------------------------
		//declarations

			char		enc_name[STRLEN];
			char		dec_name[STRLEN];
			int			num_enc, num_dec; //salman, i declared these
#if TYPE2
			byte		*ptr_uchrBUF_stages;
#endif
#if CLASSIFY
			byte		*ptr_uchrBUF_stages;
#endif
			unsigned	stage;
			unsigned	setup_start;
			int			vec_cnt;


		//open codebook files.
			structCodebook->ifs_ecbk.open(structCodebook->cfn_ecbk, ios::binary);
			structCodebook->ifs_dcbk.open(structCodebook->cfn_ecbk, ios::binary);

							if (!structCodebook->ifs_ecbk.is_open())
								cout<<"could not open encoder codebook\n";
							if (!structCodebook->ifs_dcbk.is_open())
								cout<<"could not open decoder codebook\n";


	//---------------------------
	//OPERATIONS
	//---------------------------
		//1. read codebook headers if they exist
			if( read_header_xplatform(structCodebook->ifs_ecbk,(byte*)&(structCodebook->enc_cbk_mhdr),MCBK) < 0 ||
				read_header_xplatform(structCodebook->ifs_dcbk,(byte*)&(structCodebook->dec_cbk_mhdr),MCBK) < 0 )
			{
											//err checking: code books do not exist, so prepare to generate new codebooks
											structControl->prev_cbks = dsFALSE;    /*unset so new codebooks will be primed*/
											structControl->num_primed_stages = 0;
											structControl->switch_stage = 0;
											setup_start = 0;


											#if TYPE2
											//Initialize significance map to enable first-stage seeding operation.
											ptr_uchrBUF_stages = structControl->uchrBUF_stages; vec_cnt = structTrg->Nstrippixels;
											while( vec_cnt-- ) *ptr_uchrBUF_stages++ = ONE;
											#endif
											#if CLASSIFY
											//Initialize significance map to enable first-stage seeding operation.
											ptr_uchrBUF_stages = structControl->uchrBUF_stages; vec_cnt = structTrg->Nstrippixels;
											while( vec_cnt-- ) *ptr_uchrBUF_stages++ = ONE;
											#endif
			}
			else
			{
											//err checking: check to see if number of stages is sufficient to read exiting codebooks.
											if( structCodebook->enc_cbk_mhdr.N_T > MAXNUMSTAGES ||
												structCodebook->dec_cbk_mhdr.N_T > MAXNUMSTAGES )
											{

												return NOT_OK;
											}

				structControl->prev_cbks = dsTRUE;     //set so new codebooks will not be primed
				structControl->num_primed_stages = structCodebook->enc_cbk_mhdr.N_T;
				structControl->switch_stage = structCodebook->enc_cbk_mhdr.switch_stage;
				setup_start = structControl->num_primed_stages;

		//2. read actual existing codebooks
				for(stage=0; stage<structControl->num_primed_stages; stage++)
				{
					num_enc = read_cbk_xplatform(structCodebook->ifs_ecbk,   &(structCodebook->enc_cbks[stage]),  DBL,   structCodebook->Mp1);
					num_dec = read_cbk_xplatform(structCodebook->ifs_dcbk,   &(structCodebook->dec_cbks[stage]),  DBL,   structCodebook->Mp1);
						
						
												//err checking: 
													if (num_enc < 0)
														return NOT_OK;

													if (num_dec < 0)
														return NOT_OK;

													//check parameters to see if codebook and training set are compatable.
													if( structCodebook->enc_cbks[stage].num_vectors > MAXCBKSIZE ||
														structCodebook->dec_cbks[stage].num_vectors > MAXCBKSIZE )
														return NOT_OK;

													if( structCodebook->enc_cbks[stage].num_vectors > (int)structCodebook->Mp1 ||
														structCodebook->enc_cbks[stage].num_vectors > (int)structCodebook->Mp1 )
														return NOT_OK;

													if( structCodebook->enc_cbks[stage].sw != structTrg->tsh.sw ||
														structCodebook->dec_cbks[stage].sw != structTrg->tsh.sw ||
														structCodebook->enc_cbks[stage].shc != structTrg->tsh.shc ||
														structCodebook->dec_cbks[stage].shc != structTrg->tsh.shc )
														return NOT_OK;

				}//stage
			}//else

	// Miner specific patch
	structCodebook->N_T = structCodebook->enc_cbk_mhdr.N_T;

	//Set up structures for new codebooks.
	for(stage=setup_start; stage<structCodebook->N_T; stage++)
	{
		sprintf(enc_name,"RVQ Encoder Code Book #%d",stage);
		sprintf(dec_name,"RVQ Decoder Code Book #%d",stage);
		set_up_cbk(
			&(structCodebook->enc_cbks[stage]),   //pointer to codebook
			enc_name,                   //codebook name
			structCodebook->Mp1,             //number of vectors
			structTrg->tsh.sw,          //vector width
			structTrg->tsh.shc,         //vector height
			DBL,                        //codevectors are floats
			REAL);                      //codevectors are real
		set_up_cbk(
			&(structCodebook->dec_cbks[stage]),   //pointer to codebook
			dec_name,                   //codebook name
			structCodebook->Mp1,             //number of vectors
			structTrg->tsh.sw,          //vector width
			structTrg->tsh.shc,         //vector height
			DBL,                        //codevectors are floats
			REAL);                      /*codevectors are real*/

		structCodebook->enc_cbks[stage].num_vectors = 0;  //number of current codevectors
		structCodebook->dec_cbks[stage].num_vectors = 0;  //number of current codevectors
	}

	//Allocate memory.
	structControl->uchrBUF_soc = (byte *)malloc(sizeof(byte)*structCodebook->N_T*structTrg->Nstrippixels);
											if( structControl->uchrBUF_soc == NULL )
											{
												return NOT_OK;
											}


	structControl->tr_buf = (double *)malloc(sizeof(double)*structTrg->Nstripbytes);
											if( structControl->tr_buf == NULL )
											{
												return NOT_OK;
											}


	structControl->cent_buf = (double *)malloc(sizeof(double)*structCodebook->Mp1*structCodebook->N_posnegPixelsInSnippet);
											if( structControl->cent_buf == NULL )
											{
											  return NOT_OK;
											}

	#if( ESFR || ESVR )
	structControl->equiv_idx = (unsigned *)malloc(sizeof(unsigned)*structTrg->Nstrippixels);
	if( structControl->equiv_idx == NULL ){
	  return NOT_OK;
	}

	//Determine number of direct sum codevectors.
	structControl->num_ds_cells = structCodebook->enc_cbks[0].num_vectors;
	for(stage=1; stage<structControl->num_primed_stages; stage++){
	  structControl->num_ds_cells *= structCodebook->enc_cbks[stage].num_vectors;
	  if( structControl->num_ds_cells > MAXNUMDSCELLS )
	  {
	   return NOT_OK;
	  }
	}

	structControl->equiv_cbk = (double *)malloc(sizeof(double)*structControl->num_ds_cells);
	if( structControl->equiv_cbk == NULL ){
	  return NOT_OK;
	}
	#endif

	return OK;

} //get_cbks








////------------------------------------------------------------------------------------
////
////------------------------------------------------------------------------------------
void set_up_cbk(
	structCodebook *pcbk,           /*pointer to code book*/
	char *cbk_name,            /*code book name*/
	int Nstrippixels,              /*number of vectors to allocate memory for*/
	int sw,             /*vector width*/
	int shc,            /*vector height*/
	enum data_types dt,        /*data type*/
	enum complex_flag cf       /*complex flag*/
){
	/*
	int dt_size;
	*/

	/*Initialize code book header.*/
	pcbk->hdr.hdr_type = CBK;
	strncpy(pcbk->hdr.cbk_name,cbk_name,32);
	sprintf(pcbk->hdr.Nstrippixels,"%d",Nstrippixels);
	sprintf(pcbk->hdr.sw,"%d",sw);
	sprintf(pcbk->hdr.shc,"%d",shc);
	pcbk->hdr.dt = dt;
	pcbk->hdr.cf = cf;
	pcbk->sw = sw;
	pcbk->shc = shc;
	pcbk->vec_buf_siz = Nstrippixels;
	pcbk->dblBUF_codevectors = (double *)malloc(Nstrippixels*sw*shc*sizeof(double));
	if( pcbk->dblBUF_codevectors == NULL ){
	  return;
	}


	/*
	switch( dt ){
	  case UCH: dt_size = sizeof(unsigned char); break;
	  case INT: dt_size = sizeof(int); break;
	  case FLT: dt_size = sizeof(float); break;
	  case DBL: dt_size = sizeof(double); break;
	  default:
	#ifndef REALTIME
	   fprintf(stderr,"set_up_cbk: cannont recognize data type\n");
	#endif
	   return;
	   break;
	}


	pcbk->dblBUF_codevectors = (byte *)malloc(Nstrippixels*sw*shc*dt_size);
	if( pcbk->dblBUF_codevectors == NULL ){
	#ifndef REALTIME
	  perror("set_up_cbk: cannot allocate space for code vectors");
	#endif
	  return;
	}
	*/

}





////------------------------------------------------------------------------------------
////
////------------------------------------------------------------------------------------
int read_cbk_xplatform	(
				ifstream&			fd,			//file descriptor of input file
				structCodebook			*pcbk,		//pointer to codebook buffer
				enum data_types		dt,			//data type
				int					Nstrippixels	//number of vectors in codebook
				)
{
	

	// int dt_size;		//data type size in bytes
	int nobj;			//number of objects to read


	//get header first
	if( read_header_xplatform(fd,(byte*)&(pcbk->hdr),CBK) < 0)
	{
		#ifndef REALTIME
		printf("read_cbk_xplatform: err reading header: ");
		#endif
		return -1;
	};


	/*
	switch( dt ){
	  case UCH: dt_size = sizeof(byte); break;
	  case INT: dt_size = sizeof(int); break;
	  case FLT: dt_size = sizeof(float); break;
	  case DBL: dt_size = sizeof(double); break;
	  default:
	   #ifndef REALTIME
	   printf("read_cbk_xplatform: cannont recognize data type\n");
	   #endif
	   return -1;
	   break;
	}
	Nstrippixels = MAX(Nstrippixels,atoi(pcbk->hdr.Nstrippixels));
	nobj = Nstrippixels * pcbk->sw * pcbk->shc;
	pcbk->dblBUF_codevectors = (byte *)calloc(nobj,dt_size);
	if( pcbk->dblBUF_codevectors == 0 ){
	  #ifndef REALTIME
	  perror("read_cbk_xplatform: cannot allocate space for codebook vectors: ");
	  #endif
	  return -1;
	}
	*/


	//allocate buffer for codevectors
		nobj = Nstrippixels * pcbk->sw * pcbk->shc;
		pcbk->dblBUF_codevectors = (double *)malloc(nobj*sizeof(double));
		if( pcbk->dblBUF_codevectors == NULL )
		{
	#ifndef REALTIME
			perror("read_cbk_xplatform:cannot allocate space for codebook vectors:");
	#endif
			return -1;
		}

	//read codevectors
	if( gread_xplatform(fd,(byte*)pcbk->dblBUF_codevectors,pcbk->hdr.dt,DBL,nobj,NO) != nobj )
		return -1;
	else
		return nobj;

}





////------------------------------------------------------------------------------------
////
////------------------------------------------------------------------------------------
int read_header_xplatform	(
					ifstream& fd,							//file descriptor
					unsigned char *hdr,                     //header location
					enum header_types hdr_type              //header type flag
				)
{
	

	//---------------
	//INITIALIZATIONS
	//---------------
		enum	header_types file_hdr_type;       //header type in file
		int		numBytesRead;

	//----------
	//OPERATIONS
	//----------
		//read 512 bytes of header into header buffer
		numBytesRead  = gread_xplatform(fd,hdr,UCH,UCH,HDR_SIZ,NO);

															//err checking
															if( numBytesRead != HDR_SIZ ) 
															{
																perror("less bytes read than should have been");
																return -1;
															}


									//err checking: determine header type read into hdr buffer
										file_hdr_type = *((enum header_types *)hdr);
										switch( hdr_type )
										{
											case IMG:
												if( file_hdr_type != IMG )
													return -1;
												else 
													return 0;
		
											case TSH:
												if( file_hdr_type != TSH )
													return -1;
												else 
													return 0;

											case MCBK :
												if( file_hdr_type != MCBK )
													return -1;
												else 
													return 0;

											case CBK:
												if( file_hdr_type != CBK )
													return -1;
												else 
													return 0;

											default:
												return -1;
										}

}






//------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------
int read_node(
		structCodebookParameters *structCodebook,
		struct structClassTreeNode **node,
		FILE *node_fp,
		unsigned int *node_cnt
		)
	{
	int cnt_codevectorsPerStage_Mp_or_Mp1;


	/*Allocate memory for node.*/
	*node = (struct structClassTreeNode *)malloc(sizeof(struct structClassTreeNode));
	if( *node == NULL )
		return NOT_OK;
	

	if( fread(*node,sizeof(struct structClassTreeNode),1,node_fp) != 1)
		return NOT_OK;

	*node_cnt += 1;

	for(cnt_codevectorsPerStage_Mp_or_Mp1=0; cnt_codevectorsPerStage_Mp_or_Mp1<(int)structCodebook->Mp1; cnt_codevectorsPerStage_Mp_or_Mp1++)
	{
		if( (*node)->child[cnt_codevectorsPerStage_Mp_or_Mp1] != NULL )
		{
			read_node(structCodebook,&((*node)->child[cnt_codevectorsPerStage_Mp_or_Mp1]),node_fp,node_cnt);
		}
	}

	return OK;

}//read_node




//------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------
void get_bnds(
	int last_stage,
	unsigned char *ptr_uchrBUF_Ttuple,
	int *stage,
	struct structClassTreeNode *node,
	enum yin_yang *valid_flag)
	{
	if( node == NULL ){
		*valid_flag = dsFALSE;
		return;
	}

	if( *stage == last_stage ){
		return;
	}

	*stage += 1;
	if( *stage <= last_stage-1 ){
		byte *ptr_uchrBUF_soc= new byte; ptr_uchrBUF_soc = ptr_uchrBUF_Ttuple + *stage;
		get_bnds(last_stage,ptr_uchrBUF_Ttuple,stage,node->child[*ptr_uchrBUF_soc],valid_flag);
	}

	return;

}//get_bnds




//------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------
int gwrite_xplatform	(
						ofstream& fd,					//file descriptor
						byte *buf,                      //bufer to write data from
						enum data_types buf_dt,         //type of data buffer
						enum data_types disk_dt,        //type of data to write to disk
						unsigned nobj,                  //number of objects
						enum yin_yang swap              //swap flag
						)
{
	unsigned char	*uch_ptr,		//pointer to unisgned character
					*tmp_buf;		//temporary bufer
	char			*chr_ptr,		//pointer to char
					*aflt_ptr;		//pointer to ascii float
	byte			tmp_char;
	unsigned short	*usrt_ptr;		//pointer to integer
	short			*srt_ptr;		//pointer to integer
	int				*int_ptr;		//pointer to integer
	unsigned		i,n1,n2,		//looping varables
					buf_size,		//num of bytes in buf_dt
					disk_size,		//num of bytes in disk_dt
					tot_num_writ,	//total number written
					num_writ;		//number written
	long			*lng_ptr;		//pointer to long
	unsigned long	*ulng_ptr;		//pointer to unsigned long
	float			*flt_ptr;		//pointer to float
	double			*dbl_ptr;		//pointer to double
	double			dbl_tmp;


	//Set parameters for different buf data types
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
	}//switch


	//Set parameters for different disk_buf data types
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
	}//switch


	if( buf_size != disk_size ){
	  //Allocate memory for temporary buffer to write data from
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
	   //Cast data before writing to disk
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
		 }//switch
		 break;
		case SRT:
		 srt_ptr = (short *)tmp_buf;
		 switch( buf_dt ){
		  case FLT:
		   for(i=0; i<n2; i++) *srt_ptr++ = (short)*flt_ptr++;
		   break;
		 }//switch
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
		 }//switch
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
		 }//switch
		 break;
		default:
	#ifndef REALTIME
		 printf("gwrite: disk data type unknown\n");
	#endif
		 return -1;
	   }//switch


	   //SWAP data is requested
	   if( swap == YES ){
		if( disk_dt == SRT ){
		 for(i=0; i<n2; i++)
		  SWAP( *(tmp_buf + i*2), *(tmp_buf + i*2 + 1), tmp_char);
		}
	   }


														   //#ifdef SRC_UNIX
														   //if( (num_writ = write(fd,tmp_buf,n2*disk_size)) != n2*disk_size ){
														   //#endif
														   //#ifdef SRC_NT
														   //if( (num_writ = _write(fd,tmp_buf,n2*disk_size)) != n2*disk_size ){
														   //#endif
	   fd.write((char*)tmp_buf,n2*disk_size);
	   
															//#ifndef REALTIME
															//	perror("gwrite: err writing data");
															//#endif
															//	return -1;
															//   }//if
	   tot_num_writ += num_writ;


	   n1 -= n2;
	  }//while


	  //Free dynamic memory
	  free(tmp_buf);


	}//if
	else{
	  n1 = nobj;
	  tot_num_writ = 0;
	  while( (n2 = MIN(n1,BUFSIZ)) > 0 ){


	   //SWAP HERE


														   //#ifdef SRC_UNIX
														   //if((num_writ=write(fd,buf+tot_num_writ,n2*buf_size)) != n2*buf_size){
														   //#endif
														   //#ifdef SRC_NT
														   //if((num_writ=_write(fd,buf+tot_num_writ,n2*buf_size)) != n2*buf_size){
														   //#endif
		fd.write((char*)(buf+tot_num_writ),n2*buf_size);
															//#ifndef REALTIME
															//	perror("gwrite: err writing data");
															//#endif
															//	return -1;
															//   }
	   tot_num_writ += num_writ;


	   n1 -= n2;
	  }//while
	}//else


	return tot_num_writ/disk_size;


}//gwrite
