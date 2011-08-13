// VQlib.cpp: implementation of the CVQlib class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "v2miner.h"
#include "VQlib.h"
#include "IOlib.h"

#pragma warning(disable : 4996)

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CVQlib::CVQlib()
{

}

CVQlib::~CVQlib()
{

}

int CVQlib::get_cbks(
	ts_params *ts,
	dssa_params *dssa,
	cntrl_params *cntrl
){
	CIOlib IOlib;
	char enc_name[STRLEN];   
	char dec_name[STRLEN];   
	#if TYPE2
	byte *sig_map_ptr;
	#endif
	#if CLASSIFY
	byte *sig_map_ptr;
	#endif
	unsigned stage;
	unsigned setup_start;
//	int vec_cnt;

	/*Open codebook files.*/
	if( (dssa->enc_cbk_fd = IOlib.gopen(dssa->ecbk_filename,RW)) < 3 )
	{
		#ifndef REALTIME
		perror("get_cbks:error opening encoder codebook:");
		#endif
		return NOT_OK;
	}
	if( (dssa->dec_cbk_fd = IOlib.gopen(dssa->dcbk_filename,RW)) < 3 )
	{
		#ifndef REALTIME
		perror("get_cbks:error opening encoder codebook:");
		#endif
		return NOT_OK;
	}

	/*Read codebooks if they exit.*/
	if( read_header(dssa->enc_cbk_fd,(byte*)&(dssa->enc_cbk_mhdr),MCBK) < 0 ||
		read_header(dssa->dec_cbk_fd,(byte*)&(dssa->dec_cbk_mhdr),MCBK) < 0 )
	{
		/*Code books do not exist, so prepare to generate new codebooks.*/
		cntrl->prev_cbks = dsFALSE;    /*unset so new codebooks will be primed*/
		cntrl->num_primed_stages = 0;
		cntrl->switch_stage = 0;
		setup_start = 0;


		#if TYPE2
		/*Initialize significance map to enable first-stage seeding operation.*/
		sig_map_ptr = cntrl->sig_map; vec_cnt = ts->num_vecs;
		while( vec_cnt-- ) *sig_map_ptr++ = ONE;
		#endif
		#if CLASSIFY
		/*Initialize significance map to enable first-stage seeding operation.*/
		sig_map_ptr = cntrl->sig_map; vec_cnt = ts->num_vecs;
		while( vec_cnt-- ) *sig_map_ptr++ = ONE;
		#endif
	}
	else
	{
		/*Check to see if number of stages is sufficient to read exiting codebooks.*/
		if( dssa->enc_cbk_mhdr.num_cbks > MAXNUMSTAGES ||
			dssa->dec_cbk_mhdr.num_cbks > MAXNUMSTAGES )
		{
			#ifndef REALTIME
			printf("get_cbks:existing number of stages exceeds MAXNUMSTAGES:");
			printf("recompile the software!\n");
			#endif
			return NOT_OK;
		}

		cntrl->prev_cbks = dsTRUE;     /*set so new codebooks will not be primed*/
		cntrl->num_primed_stages = dssa->enc_cbk_mhdr.num_cbks;
		cntrl->switch_stage = dssa->enc_cbk_mhdr.switch_stage;
		setup_start = cntrl->num_primed_stages;

		/*Read exiting codebooks.*/
		for(stage=0; stage<cntrl->num_primed_stages; stage++)
		{
			if( read_cbk(dssa->enc_cbk_fd,&(dssa->enc_cbks[stage]),DBL,dssa->cbk_size) < 0 )
			{
				#ifndef REALTIME
				perror("get_cbks:error reading encoder codebooks:");
				#endif
				return NOT_OK;
			}
			if( read_cbk(dssa->dec_cbk_fd,&(dssa->dec_cbks[stage]),DBL,dssa->cbk_size) < 0 )
			{
				#ifndef REALTIME
				perror("get_cbks:error reading decoder codebooks:");
				#endif
				return NOT_OK;
			}

			/*Check parameters to see if codebook and training set are compatable.*/
			if( dssa->enc_cbks[stage].num_vectors > MAXCBKSIZE ||
				dssa->dec_cbks[stage].num_vectors > MAXCBKSIZE )
			{
				#ifndef REALTIME
				printf("get_cbks:codebooks have more than MAXCBKSIZE codevectors!\n");
				#endif
				return NOT_OK;
			}
			if( dssa->enc_cbks[stage].num_vectors > (int)dssa->cbk_size ||
				dssa->enc_cbks[stage].num_vectors > (int)dssa->cbk_size )
			{
				#ifndef REALTIME
				printf("get_cbks:existing codebooks contain too many codevectors!\n");
				#endif
				return NOT_OK;
			}
			if( dssa->enc_cbks[stage].vec_width != ts->tsh.vec_width ||
				dssa->dec_cbks[stage].vec_width != ts->tsh.vec_width ||
				dssa->enc_cbks[stage].vec_height != ts->tsh.vec_height ||
				dssa->dec_cbks[stage].vec_height != ts->tsh.vec_height )
			{
				#ifndef REALTIME
				printf("get_cbks:codebook/training vectors sizes are not compatable!\n");
				#endif
				return NOT_OK;
			}

		}/*stage*/
	}/*else*/

	// Miner specific patch
	dssa->num_stages = dssa->enc_cbk_mhdr.num_cbks;

	/*Set up structures for new codebooks.*/
	for(stage=setup_start; stage<dssa->num_stages; stage++)
	{
		sprintf(enc_name,"RVQ Encoder Code Book #%d",stage);
		sprintf(dec_name,"RVQ Decoder Code Book #%d",stage);
		set_up_cbk(
			&(dssa->enc_cbks[stage]),   /*pointer to codebook*/
			enc_name,                   /*codebook name*/
			dssa->cbk_size,             /*number of vectors*/
			ts->tsh.vec_width,          /*vector width*/
			ts->tsh.vec_height,         /*vector height*/
			DBL,                        /*codevectors are floats*/
			REAL);                      /*codevectors are real*/
		set_up_cbk(
			&(dssa->dec_cbks[stage]),   /*pointer to codebook*/
			dec_name,                   /*codebook name*/
			dssa->cbk_size,             /*number of vectors*/
			ts->tsh.vec_width,          /*vector width*/
			ts->tsh.vec_height,         /*vector height*/
			DBL,                        /*codevectors are floats*/
			REAL);                      /*codevectors are real*/

		dssa->enc_cbks[stage].num_vectors = 0;  /*number of current codevectors*/
		dssa->dec_cbks[stage].num_vectors = 0;  /*number of current codevectors*/
	}

	/*Allocate memory.*/
	cntrl->P_tuple = (byte *)malloc(sizeof(byte)*dssa->num_stages*ts->num_vecs);
	if( cntrl->P_tuple == NULL ){
	  return NOT_OK;
	}
	cntrl->tr_buf = (double *)malloc(sizeof(double)*ts->num_samples);
	if( cntrl->tr_buf == NULL ){
	  return NOT_OK;
	}
	cntrl->cent_buf = (double *)malloc(sizeof(double)*dssa->cbk_size*dssa->vec_size);
	if( cntrl->cent_buf == NULL ){
	  return NOT_OK;
	}

	#if( ESFR || ESVR )
	cntrl->equiv_idx = (unsigned *)malloc(sizeof(unsigned)*ts->num_vecs);
	if( cntrl->equiv_idx == NULL ){
	  return NOT_OK;
	}

	/*Determine number of direct sum codevectors.*/
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

}/*get_cbks*/

void CVQlib::set_up_cbk(
	code_book *pcbk,           /*pointer to code book*/
	char *cbk_name,            /*code book name*/
	int num_vecs,              /*number of vectors to allocate memory for*/
	int vec_width,             /*vector width*/
	int vec_height,            /*vector height*/
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
	sprintf(pcbk->hdr.vec_width,"%d",vec_width);
	sprintf(pcbk->hdr.vec_height,"%d",vec_height);
	pcbk->hdr.dt = dt;
	pcbk->hdr.cf = cf;
	pcbk->vec_width = vec_width;
	pcbk->vec_height = vec_height;
	pcbk->vec_buf_siz = num_vecs;
	pcbk->vecs = (double *)malloc(num_vecs*vec_width*vec_height*sizeof(double));
	if( pcbk->vecs == NULL ){
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


	pcbk->vecs = (byte *)malloc(num_vecs*vec_width*vec_height*dt_size);
	if( pcbk->vecs == NULL ){
	#ifndef REALTIME
	  perror("set_up_cbk: cannot allocate space for code vectors");
	#endif
	  return;
	}
	*/

}

int CVQlib::read_cbk(
	int fd,              /*file descriptor of input file*/
	code_book *pcbk,     /*pointer to codebook buffer*/
	enum data_types dt,  /*data type*/
	int num_vecs         /*number of vectors in codebook*/
){
	CIOlib IOlib;

	/* int dt_size;*/         /*data type size in bytes*/
	int nobj;            /*number of objects to read*/


	/*Get header first.*/
	if( read_header(fd,(byte*)&(pcbk->hdr),CBK) < 0){
	  #ifndef REALTIME
	  printf("read_cbk: error reading header: ");
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
	   printf("read_cbk: cannont recognize data type\n");
	   #endif
	   return -1;
	   break;
	}
	num_vecs = MAX(num_vecs,atoi(pcbk->hdr.num_vecs));
	nobj = num_vecs * pcbk->vec_width * pcbk->vec_height;
	pcbk->vecs = (byte *)calloc(nobj,dt_size);
	if( pcbk->vecs == 0 ){
	  #ifndef REALTIME
	  perror("read_cbk: cannot allocate space for codebook vectors: ");
	  #endif
	  return -1;
	}
	*/


	/*Allocate buffer for codevectors.*/
	nobj = num_vecs * pcbk->vec_width * pcbk->vec_height;
	pcbk->vecs = (double *)malloc(nobj*sizeof(double));
	if( pcbk->vecs == NULL ){
	  #ifndef REALTIME
	  perror("read_cbk:cannot allocate space for codebook vectors:");
	  #endif
	  return -1;
	}


	/*Read codevectors.*/
	if( IOlib.gread(fd,(byte*)pcbk->vecs,pcbk->hdr.dt,DBL,nobj,NO) != nobj )
	  return -1;
	else
	  return nobj;

}

int CVQlib::read_header(
	int fd,                                 /*file descriptor*/
	unsigned char *hdr,                     /*header location*/
	enum header_types hdr_type              /*header type flag*/
){
	CIOlib IOlib;

	enum header_types file_hdr_type;       /*header type in file*/


	/*Read header into header buffer.*/
	if( IOlib.gread(fd,hdr,UCH,UCH,HDR_SIZ,NO) != HDR_SIZ ) return -1;


	/*Determine header type read into hdr buffer.*/
	file_hdr_type = *((enum header_types *)hdr);
	switch( hdr_type ){
	  case IMG:
	   if( file_hdr_type != IMG ){
	#ifndef REALTIME
		fprintf(stderr,"warning: not an image header\n");
	#endif
		return -1;
	   }
	   else return 0;
	  case TSH:
	   if( file_hdr_type != TSH ){
	#ifndef REALTIME
		fprintf(stderr,"warning: not a training set header\n");
	#endif
		return -1;
	   }
	   else return 0;
	  case MCBK :
	   if( file_hdr_type != MCBK ){
	#ifndef REALTIME
		fprintf(stderr,"warning: not a master code book header\n");
	#endif
		return -1;
	   }
	   else return 0;
	  case CBK:
	   if( file_hdr_type != CBK ){
	#ifndef REALTIME
		fprintf(stderr,"warning: not a code book header\n");
	#endif
		return -1;
	   }
	   else return 0;
	  default:
	#ifndef REALTIME
	   fprintf(stderr,"warning: header type unrecognized\n");
	#endif
	   return -1;
	}

}

int CVQlib::read_node(
	dssa_params *dssa,
	struct class_tree_node **node,
	FILE *fil_nodes,
	unsigned int *node_cnt
){
	int cv_cnt;


	/*Allocate memory for node.*/
	*node = (struct class_tree_node *)malloc(sizeof(struct class_tree_node));
	if( *node == NULL )
	{
		#ifndef REALTIME
		perror("dssa_detect:read_node:error allocating vector buffer");
		#endif
		return NOT_OK;
	}

	if( fread(*node,sizeof(struct class_tree_node),1,fil_nodes) != 1)
	{
		#ifndef REALTIME
		perror("dssa_detect:read_node:error reading node:");
		#endif
		return NOT_OK;
	}

	*node_cnt += 1;

	for(cv_cnt=0; cv_cnt<(int)dssa->cbk_size; cv_cnt++)
	{
		if( (*node)->child[cv_cnt] != NULL )
		{
			read_node(dssa,&((*node)->child[cv_cnt]),fil_nodes,node_cnt);
		}
	}

	return OK;

}/*read_node*/

void CVQlib::get_bnds(
	double *max_in_dist,
	double *min_out_dist,
	int last_stage,
	unsigned char *P_tuple_ptr,
	int *stage,
	struct class_tree_node *node,
	enum yin_yang *valid_flag
){
	if( node == NULL ){ *valid_flag = dsFALSE; return; }

	if( *stage == last_stage ){
//		*max_in_dist  = (double)node->max_in_dist;
//		*min_out_dist = (double)node->min_out_dist;
		return;
	} 

	*stage += 1;
	if( *stage <= last_stage ){
		byte *idx_ptr; idx_ptr = P_tuple_ptr + *stage;
		get_bnds(max_in_dist,min_out_dist,last_stage,P_tuple_ptr,stage,
			   node->child[*idx_ptr],valid_flag);
	}

	return;

}/*get_bnds*/
