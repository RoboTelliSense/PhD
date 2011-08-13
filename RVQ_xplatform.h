#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include <math.h>


#include "RVQ_xplatform_const_params.h"
#include "RVQ_xplatform_dssa.h"
#include "RVQ_xplatform_dssa_params.h"

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
	unsigned char *P_tuple_ptr,
	int *stage,
	struct class_tree_node *node,
	enum yin_yang *valid_flag);
int		read_node				(dssa_params *dssa, struct class_tree_node **node,FILE *node_fp,unsigned int *node_cnt);
void	set_up_cbk				(structCodebook*, char*,int,int,int,enum data_types, enum complex_flag);
int		get_cbks				(ts_params*, dssa_params*, cntrl_params*);




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
																			//error checking
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
				ts_params *ts,
				dssa_params *dssa,
				cntrl_params *cntrl
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
			byte		*sig_map_ptr;
#endif
#if CLASSIFY
			byte		*sig_map_ptr;
#endif
			unsigned	stage;
			unsigned	setup_start;
			int			vec_cnt;


		//open codebook files.
			dssa->enc_cbk_fd.open(dssa->ecbk_filename, ios::binary);
			dssa->dec_cbk_fd.open(dssa->ecbk_filename, ios::binary);

							if (!dssa->enc_cbk_fd.is_open())
								cout<<"could not open encoder codebook";
							if (!dssa->dec_cbk_fd.is_open())
								cout<<"could not open decoder codebook";


	//---------------------------
	//OPERATIONS
	//---------------------------
		//1. read codebook headers if they exist
			if( read_header_xplatform(dssa->enc_cbk_fd,(byte*)&(dssa->enc_cbk_mhdr),MCBK) < 0 ||
				read_header_xplatform(dssa->dec_cbk_fd,(byte*)&(dssa->dec_cbk_mhdr),MCBK) < 0 )
			{
											//error checking: code books do not exist, so prepare to generate new codebooks
											cntrl->prev_cbks = dsFALSE;    /*unset so new codebooks will be primed*/
											cntrl->num_primed_stages = 0;
											cntrl->switch_stage = 0;
											setup_start = 0;


											#if TYPE2
											//Initialize significance map to enable first-stage seeding operation.
											sig_map_ptr = cntrl->sig_map; vec_cnt = ts->num_vecs;
											while( vec_cnt-- ) *sig_map_ptr++ = ONE;
											#endif
											#if CLASSIFY
											//Initialize significance map to enable first-stage seeding operation.
											sig_map_ptr = cntrl->sig_map; vec_cnt = ts->num_vecs;
											while( vec_cnt-- ) *sig_map_ptr++ = ONE;
											#endif
			}
			else
			{
											//error checking: check to see if number of stages is sufficient to read exiting codebooks.
											if( dssa->enc_cbk_mhdr.num_cbks > MAXNUMSTAGES ||
												dssa->dec_cbk_mhdr.num_cbks > MAXNUMSTAGES )
											{

												return NOT_OK;
											}

				cntrl->prev_cbks = dsTRUE;     //set so new codebooks will not be primed
				cntrl->num_primed_stages = dssa->enc_cbk_mhdr.num_cbks;
				cntrl->switch_stage = dssa->enc_cbk_mhdr.switch_stage;
				setup_start = cntrl->num_primed_stages;

		//2. read actual existing codebooks
				for(stage=0; stage<cntrl->num_primed_stages; stage++)
				{
					num_enc = read_cbk_xplatform(dssa->enc_cbk_fd,   &(dssa->enc_cbks[stage]),  DBL,   dssa->cbk_size);
					num_dec = read_cbk_xplatform(dssa->dec_cbk_fd,   &(dssa->dec_cbks[stage]),  DBL,   dssa->cbk_size);
						
						
												//error checking: 
													if (num_enc < 0)
														return NOT_OK;

													if (num_dec < 0)
														return NOT_OK;

													//check parameters to see if codebook and training set are compatable.
													if( dssa->enc_cbks[stage].num_vectors > MAXCBKSIZE ||
														dssa->dec_cbks[stage].num_vectors > MAXCBKSIZE )
														return NOT_OK;

													if( dssa->enc_cbks[stage].num_vectors > (int)dssa->cbk_size ||
														dssa->enc_cbks[stage].num_vectors > (int)dssa->cbk_size )
														return NOT_OK;

													if( dssa->enc_cbks[stage].sw != ts->tsh.sw ||
														dssa->dec_cbks[stage].sw != ts->tsh.sw ||
														dssa->enc_cbks[stage].shc != ts->tsh.shc ||
														dssa->dec_cbks[stage].shc != ts->tsh.shc )
														return NOT_OK;

				}//stage
			}//else

	// Miner specific patch
	dssa->num_stages = dssa->enc_cbk_mhdr.num_cbks;

	//Set up structures for new codebooks.
	for(stage=setup_start; stage<dssa->num_stages; stage++)
	{
		sprintf(enc_name,"RVQ Encoder Code Book #%d",stage);
		sprintf(dec_name,"RVQ Decoder Code Book #%d",stage);
		set_up_cbk(
			&(dssa->enc_cbks[stage]),   //pointer to codebook
			enc_name,                   //codebook name
			dssa->cbk_size,             //number of vectors
			ts->tsh.sw,          //vector width
			ts->tsh.shc,         //vector height
			DBL,                        //codevectors are floats
			REAL);                      //codevectors are real
		set_up_cbk(
			&(dssa->dec_cbks[stage]),   //pointer to codebook
			dec_name,                   //codebook name
			dssa->cbk_size,             //number of vectors
			ts->tsh.sw,          //vector width
			ts->tsh.shc,         //vector height
			DBL,                        //codevectors are floats
			REAL);                      /*codevectors are real*/

		dssa->enc_cbks[stage].num_vectors = 0;  //number of current codevectors
		dssa->dec_cbks[stage].num_vectors = 0;  //number of current codevectors
	}

	//Allocate memory.
	cntrl->P_tuple = (byte *)malloc(sizeof(byte)*dssa->num_stages*ts->num_vecs);
											if( cntrl->P_tuple == NULL )
											{
												return NOT_OK;
											}


	cntrl->tr_buf = (double *)malloc(sizeof(double)*ts->num_samples);
											if( cntrl->tr_buf == NULL )
											{
												return NOT_OK;
											}


	cntrl->cent_buf = (double *)malloc(sizeof(double)*dssa->cbk_size*dssa->vec_size);
											if( cntrl->cent_buf == NULL )
											{
											  return NOT_OK;
											}

	#if( ESFR || ESVR )
	cntrl->equiv_idx = (unsigned *)malloc(sizeof(unsigned)*ts->num_vecs);
	if( cntrl->equiv_idx == NULL ){
	  return NOT_OK;
	}

	//Determine number of direct sum codevectors.
	cntrl->num_ds_cells = dssa->enc_cbks[0].num_vectors;
	for(stage=1; stage<cntrl->num_primed_stages; stage++){
	  cntrl->num_ds_cells *= dssa->enc_cbks[stage].num_vectors;
	  if( cntrl->num_ds_cells > MAXNUMDSCELLS )
	  {
	   return NOT_OK;
	  }
	}

	cntrl->equiv_cbk = (double *)malloc(sizeof(double)*cntrl->num_ds_cells);
	if( cntrl->equiv_cbk == NULL ){
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
	int num_vecs,              /*number of vectors to allocate memory for*/
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
	sprintf(pcbk->hdr.num_vecs,"%d",num_vecs);
	sprintf(pcbk->hdr.sw,"%d",sw);
	sprintf(pcbk->hdr.shc,"%d",shc);
	pcbk->hdr.dt = dt;
	pcbk->hdr.cf = cf;
	pcbk->sw = sw;
	pcbk->shc = shc;
	pcbk->vec_buf_siz = num_vecs;
	pcbk->dblBUF_codevectors = (double *)malloc(num_vecs*sw*shc*sizeof(double));
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


	pcbk->dblBUF_codevectors = (byte *)malloc(num_vecs*sw*shc*dt_size);
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
				int					num_vecs	//number of vectors in codebook
				)
{
	

	// int dt_size;		//data type size in bytes
	int nobj;			//number of objects to read


	//get header first
	if( read_header_xplatform(fd,(byte*)&(pcbk->hdr),CBK) < 0)
	{
		#ifndef REALTIME
		printf("read_cbk_xplatform: error reading header: ");
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
	num_vecs = MAX(num_vecs,atoi(pcbk->hdr.num_vecs));
	nobj = num_vecs * pcbk->sw * pcbk->shc;
	pcbk->dblBUF_codevectors = (byte *)calloc(nobj,dt_size);
	if( pcbk->dblBUF_codevectors == 0 ){
	  #ifndef REALTIME
	  perror("read_cbk_xplatform: cannot allocate space for codebook vectors: ");
	  #endif
	  return -1;
	}
	*/


	//allocate buffer for codevectors
		nobj = num_vecs * pcbk->sw * pcbk->shc;
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

															//error checking
															if( numBytesRead != HDR_SIZ ) 
															{
																perror("less bytes read than should have been");
																return -1;
															}


									//error checking: determine header type read into hdr buffer
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
		dssa_params *dssa,
		struct class_tree_node **node,
		FILE *node_fp,
		unsigned int *node_cnt
		)
	{
	int cv_cnt;


	/*Allocate memory for node.*/
	*node = (struct class_tree_node *)malloc(sizeof(struct class_tree_node));
	if( *node == NULL )
		return NOT_OK;
	

	if( fread(*node,sizeof(struct class_tree_node),1,node_fp) != 1)
		return NOT_OK;

	*node_cnt += 1;

	for(cv_cnt=0; cv_cnt<(int)dssa->cbk_size; cv_cnt++)
	{
		if( (*node)->child[cv_cnt] != NULL )
		{
			read_node(dssa,&((*node)->child[cv_cnt]),node_fp,node_cnt);
		}
	}

	return OK;

}//read_node




//------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------
void get_bnds(
	int last_stage,
	unsigned char *P_tuple_ptr,
	int *stage,
	struct class_tree_node *node,
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
		byte *idx_ptr= new byte; idx_ptr = P_tuple_ptr + *stage;
		get_bnds(last_stage,P_tuple_ptr,stage,node->child[*idx_ptr],valid_flag);
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
															//	perror("gwrite: error writing data");
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
															//	perror("gwrite: error writing data");
															//#endif
															//	return -1;
															//   }
	   tot_num_writ += num_writ;


	   n1 -= n2;
	  }//while
	}//else


	return tot_num_writ/disk_size;


}//gwrite
