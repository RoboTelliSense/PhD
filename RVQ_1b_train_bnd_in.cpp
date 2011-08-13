#include "RVQ_xplatform.h"

#define PRECLASS 0

void						in_class_bnd		(ts_params*,dssa_params*,cntrl_params*,int,double*);
void						write_node			(dssa_params*,struct class_tree_node*,FILE*,unsigned int*);
struct class_tree_node		*grow_tree			(double*,double*,dssa_params*,int,byte*,int*,struct class_tree_node*, unsigned int*);
void						parse_command_line	(int,char**,ts_params*,dssa_params*,cntrl_params*);
void						get_ts				(ts_params*,dssa_params*,cntrl_params*);
void						clean_up			(ts_params*,dssa_params*,cntrl_params*);
void						tree_print			(dssa_params*,cntrl_params*,struct class_tree_node*,int);




//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
int main(	int argc,  char *argv[])
{
	
	//==========================
	//INITIALIZATIONS
	//==========================
		//declarations
		//-----------
			byte *sig_map_ptr;
			int i;
			int k;
			int stage;
			int vec_cnt;
			unsigned int node_cnt = 0;
			double *ts_ptr;
			double *vec_eng_buf;
			double *vec_eng_ptr;
			double min_vec_eng;
			double max_vec_eng;
			ts_params structTrg;             //training set parameters
			dssa_params dssa;         //DSSA parameters
			cntrl_params cntrl;       //control parameters
			FILE *fil_nodes;			

		//get command line options
		//------------------------
			parse_command_line(argc,argv,&structTrg,&dssa,&cntrl);

		//read input files
		//----------------

			//get training set/input data, read .sml file which I now call .raw file so that I can easily view it in IrfanView
			get_ts(&structTrg,&dssa,&cntrl);
		 
			//get existing codebooks or generate new codebooks
			get_cbks(&structTrg,&dssa,&cntrl);
			
		//allocate dynamic memory
		//-----------------------
			vec_eng_buf = (double *)calloc(sizeof(double),structTrg.num_vecs);
			if( vec_eng_buf == NULL )
			{
				perror("dssa_detect:cannot allocate memory for the vector energy buffer:");
				exit(-1);
			}

		
		//compute vector energies
		//-----------------------
			{
				int cnt = 1;
				min_vec_eng = myINFINITY;
				max_vec_eng = 0.0;
				ts_ptr = structTrg.buf; vec_eng_ptr = vec_eng_buf; i = structTrg.num_vecs;
				while( i-- )
				{
					k = dssa.vec_size;
					while( k-- )
					{
						*vec_eng_ptr += *ts_ptr * *ts_ptr; 
						++ts_ptr;
					}
					if( min_vec_eng > *vec_eng_ptr ) 
						min_vec_eng = *vec_eng_ptr;
					if( max_vec_eng < *vec_eng_ptr ) 
						max_vec_eng = *vec_eng_ptr;
					++vec_eng_ptr;
				}
				printf("Minimum Training Set Vector Energy = %f\n",min_vec_eng);
				printf("Maximum Training Set Vector Energy = %f\n",max_vec_eng);
			}

				
	//================================
	//OPERATIONS
	//================================
		//grow tree and bound in-class distortions
		//----------------------------------------
			sig_map_ptr = cntrl.sig_map; 
			vec_cnt		= structTrg.num_vecs; 
			while( vec_cnt-- ) 
				*sig_map_ptr++ = ONE;


			dssa.root_node = NULL;
			for(stage=0; stage<(int)cntrl.num_primed_stages; stage++)
			{
				in_class_bnd(&structTrg,&dssa,&cntrl,stage,vec_eng_buf);
			}
	
			
		//write decision tree nodes
		//-------------------------
			//open tree-node file
//#ifdef SRC_UNIX
//				fil_nodes = fopen(cntrl.node_file,"w");
//#endif
//#ifdef SRC_NT
				fil_nodes = fopen(cntrl.node_file,"wb");
//#endif
																		//error checking
																		if( fil_nodes == NULL )
																		{ 
																			perror("bnd_in:error opening tree-node file:"); 
																			exit(-1); 
																		}

		//write maximum and minimum target vector energies
		//------------------------------------------------
			if( fwrite(&min_vec_eng,sizeof(double),1,fil_nodes) != 1)
			{
				perror("BndIn:error writing min energy data:"); 
				exit(-1);
			}
			if( fwrite(&max_vec_eng,sizeof(double),1,fil_nodes) != 1)
			{
				perror("BndIn:error writing max energy data:"); 
				exit(-1);
			}

			
	//===================================
	//WRAP UP
	//===================================
		//recursively write nodes
		//-----------------------
			write_node(&dssa,dssa.root_node,fil_nodes,&node_cnt);
			printf("Number of Nodes in Output File = %u\n",node_cnt);


		//close output file
		//-----------------
			fclose(fil_nodes);
	

		//print tree-useful sometimes
		//---------------------------
			tree_print(&dssa,&cntrl,dssa.root_node,1);

		//tie up loose ends before quiting
		//--------------------------------
			clean_up(&structTrg,&dssa,&cntrl);

		//return 
		//------
			printf("PROGRAM COMPLETED\n");
			return 0;

}//main









//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
void in_class_bnd	(
					ts_params *structTrg,
					dssa_params *dssa,
					cntrl_params *cntrl,
					int stage,
					double *vec_eng_buf
					)
{
	byte *idx_ptr;
	byte *byte_ptr;
	byte *P_tuple_ptr;
	byte cv_idx;
	byte min = 0;  // for jit compilation
	byte *active_ptr;
	byte *sig_map_ptr;
	byte P_tuple_buf[MAXNUMSTAGES];
	unsigned node_cnt = 0;
	static unsigned total_node_cnt = 0;
	int i;
	int i_start;
	int start_stage;
	int cv_cnt;
	int ts_cnt;
	int dim_cnt;
	int curr_cbk_size;
	int cbk_size_m1;
	int markov_stage;
	double *cv_ptr;
	double *cr_ptr;
	double *tr_ptr;
	double *vec_eng_ptr;
	double diff;
	double sse;
	double min_sse;
	double tmp_dbl;
	double dist;
	double stop_dist;


	//Determine TYPE 2 variable rate encoder stopping threshold factor.
	tmp_dbl = -(cntrl->stop_snr / 10.0);
	stop_dist = pow(10.0,tmp_dbl);

	//Determine markov stage
	markov_stage = stage - cntrl->markov_stage;

	cbk_size_m1 = dssa->cbk_size - 1;

	//Always grow null path
	dist = myINFINITY;
	for(i=0; i<=stage; i++)
	{
	  P_tuple_buf[i] = (byte)cbk_size_m1;
	}
	start_stage = -1;
	dssa->root_node = grow_tree(&dist,&stop_dist,dssa,stage,P_tuple_buf,
								 &start_stage,dssa->root_node,&node_cnt);

	//Process each vector
	if( stage )
	{
		active_ptr = cntrl->P_tuple + (stage - 1) * structTrg->num_vecs;
	}
	else
	{
		curr_cbk_size = dssa->cbk_size;
	}

	vec_eng_ptr = vec_eng_buf;
	tr_ptr = structTrg->buf;
	sig_map_ptr = cntrl->sig_map;
	P_tuple_ptr = cntrl->P_tuple;
	idx_ptr = cntrl->P_tuple + stage * structTrg->num_vecs;

	ts_cnt = structTrg->num_vecs;
	while( ts_cnt-- )
	{
	  if( stage < (int)*sig_map_ptr )
	  {
	   if( stage )
	   {
			if( (int)*active_ptr++ < cbk_size_m1 )
			{
				curr_cbk_size = cbk_size_m1;
			}
			else
			{
				curr_cbk_size = dssa->cbk_size;
			}
	   }

	//   if ( cntrl->no_null ) curr_cbk_size = cbk_size_m1;

	   //Find closest codevector
	   min_sse = myINFINITY;
	   cv_idx = 0;
	   cv_ptr = dssa->enc_cbks[stage].dblBUF_codevectors;
	   cv_cnt = curr_cbk_size;
	   while( cv_cnt-- )
	   {
		//L2 and LINF
		sse = 0.0;
		cr_ptr = tr_ptr;
		dim_cnt = dssa->vec_size;
		while( dim_cnt-- )
		{
			diff = *cr_ptr++ - *cv_ptr++;
			sse += diff * diff;
		}
    
		if( sse < min_sse )
		{
			min_sse = sse;
			min = cv_idx;
		}
    
		++cv_idx;
   
	   }
 
	   *idx_ptr = min;
		++idx_ptr;

	   //Grow and bound node
	   for(i=0; i<markov_stage; i++)
	   {
		   P_tuple_buf[i] = (byte)cbk_size_m1;
	   }
	   i_start = MAX(markov_stage,0);
	   byte_ptr = P_tuple_ptr + i_start * structTrg->num_vecs;
	   for(i=i_start; i<=stage; i++)
	   {
		P_tuple_buf[i] = *byte_ptr;

		byte_ptr += structTrg->num_vecs; 
	   }

	   if( min < cbk_size_m1 )
	   {
		//Update causal residual in all cases
		cv_ptr = dssa->enc_cbks[stage].dblBUF_codevectors + min * dssa->vec_size; 
		dim_cnt = dssa->vec_size; 
		while( dim_cnt-- )
		{
			*tr_ptr++ -= *cv_ptr++;
		}

		//Determine current signal-to-noise ratio (linear space)
		dist = *vec_eng_ptr? min_sse / *vec_eng_ptr : myINFINITY;


		//Grow node and bound if new dist is smaller
		start_stage = -1;
		dssa->root_node = grow_tree(&dist,&stop_dist,dssa,stage,P_tuple_buf,
																	&start_stage,dssa->root_node,&node_cnt);

		if( dist <= stop_dist ) *sig_map_ptr = (byte)(stage + 1); 
		else                    *sig_map_ptr = (byte)(stage + 2);


#ifdef PRECLASS
		if( dist <= stop_dist )
		{
		 int factor;
		 int j;
		 int equiv_idx = 0;


		 for(i=0; i<=stage; i++){
		  factor = 1;
		  for(j=stage+1; j<=stage; j++) factor *= dssa->cbk_size;
		  equiv_idx += P_tuple_buf[i] * factor;
		 }
			 
		 //printf("PRECLASS INDEX = %d\n",equiv_idx);
			 
		}
#endif



	   //Else null-encoded and continue to latter stages
	   }else{
		tr_ptr += dssa->vec_size;


		//Determine current signal-to-noise ratio (linear space)
			
		//dist = *vec_eng_ptr? min_sse / *vec_eng_ptr : INFINITY;
			
			dist = 1.0;


		start_stage = -1;
		dssa->root_node = grow_tree(&dist,&stop_dist,dssa,stage,P_tuple_buf,
									&start_stage,dssa->root_node,&node_cnt);


		*sig_map_ptr = (byte)(stage + 2);


	   }//else


	  }
	  //Encoding previously completed
	  else{
	   if ( stage ) ++active_ptr;
	   tr_ptr += dssa->vec_size;
	   *idx_ptr++ = (byte)dssa->cbk_size;
	  }


	  ++sig_map_ptr;
	  ++P_tuple_ptr;
	  ++vec_eng_ptr;


	}//ts_cnt


	total_node_cnt += node_cnt;
	printf("Number of New Nodes = %u at Stage %d::Total=%u\n",node_cnt,
			 stage + 1,total_node_cnt);
	fflush(stdout);


	return;


}//in_class_bnd






//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
struct class_tree_node * grow_tree	(
									double *in_dist,
									double *stop_dist,
									dssa_params *dssa,
									int last_stage,
									byte *P_tuple_ptr,
									int *stage,
									struct class_tree_node *node,
									unsigned int *node_cnt
									)
{
	//Allocate memory if node not previously visited
	if( node == NULL ){
	  node = (struct class_tree_node *)calloc(1,sizeof(struct class_tree_node));
	  if( node == NULL ){
	   perror("grow_tree:cannot allocate memory for decision tree:");
	   exit(-1);
	  }
	  *node_cnt += 1;
	}


	if( *stage == last_stage )
	{
	  return node;
	}


	*stage += 1;
	if( *stage <= last_stage ){
	  byte *idx_ptr; idx_ptr = P_tuple_ptr + *stage;
	  node->child[*idx_ptr] = 
	  grow_tree(in_dist,stop_dist,dssa,last_stage,P_tuple_ptr,stage,
							node->child[*idx_ptr],node_cnt);
	}


	return node;


}//grow_tree





  
  //node->node_state = VALID;
  
  
  //if( *stage > -1 )
  //{
  // int j; for(j=0; j<=*stage; j++) node->tree_path[j] = *(P_tuple_ptr + j);
  //}
  
  //Else, no path is required for root node
  
  //if( *(P_tuple_ptr + *stage) < *cbk_size_m1 )
	//{
	//}
  




									


//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
void write_node		(
					dssa_params *dssa,
					struct class_tree_node *node,
					FILE *fil_nodes,
					unsigned int *node_cnt
					)
{
	int cv_cnt;


	if( fwrite(node,sizeof(struct class_tree_node),1,fil_nodes) != 1){
	  perror("write_node:error writing data:"); exit(-1);
	}


	*node_cnt += 1;


	for(cv_cnt=0; cv_cnt<(int)dssa->cbk_size; cv_cnt++)
	if( node->child[cv_cnt] != NULL ) 
	write_node(dssa,node->child[cv_cnt],fil_nodes,node_cnt);


	return;


}//write_node





//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
void parse_command_line		(
							int argc,
							char **argv,
							ts_params *structTrg,
							dssa_params *dssa,
							cntrl_params *cntrl
							)
{


	int i;             //looping variable


	//Echo the command line
	for(i=0; i<argc; i++) printf("%s ",argv[i]); printf("\n");


	//Do a command line check.

	//if( argc < 6 || *argv[5] == '-' ){

	//if( argc < 5 || *argv[4] == '-' || *argv[5] != '-'){
	if( argc < 5 || *argv[4] == '-' ){
	  if( argc > 1 )                //complain only if more than one argument
	   printf("%s: command line does not have required arguments\n\n",argv[0]);
	  if( argc > 5 && *argv[5] != '-' )
		  printf("%s: command line does not have required arguments\n\n",argv[0]);
	  printf(USAGE,argv[0]);
	  exit(-1);
	}


	//Get required argumets
	structTrg->filename = argv[1];
	dssa->ecbk_filename = argv[2];
	dssa->dcbk_filename = argv[3];

	//dssa->num_stages = (unsigned)atoi(argv[4]);

	dssa->num_stages = (unsigned)MAXNUMSTAGES;
	dssa->cbk_size = (unsigned)atoi(argv[4]);


	if( dssa->num_stages > MAXNUMSTAGES ){
	  printf("parse_command_line:number of stages exceeds MAXNUMSTAGES:");
	  printf("recompile the software!\n");
	  exit(-1);
	}
	if( dssa->cbk_size > MAXCBKSIZE ){
	  printf("parse_command_line:code book exceeds MAXCBKSIZE:");
	  printf("recompile the software!\n");
	  exit(-1);
	}


	//Initialize default values
	cntrl->bpp = 1;                       //initialize bytes per pixel
	cntrl->mean = 0;                      //initialize mean flag off
	cntrl->peak_sqnr = 0;                 //initizalize peak SQNR off
	cntrl->encode_only = 0;               //initizalize encode_only off
	cntrl->epsilon = 0.05;                //initialize optimiation threshold
	cntrl->d_epsilon = 0.05;              //initialize dec optimiation threshold
	cntrl->desired_num_ts_vecs = BIG_INT; //initialize unreasonably large
	cntrl->markov_stage = (int)MAXNUMSTAGES;
	cntrl->no_null = 0;


	//Get command line options
	i = argc - 1;                  //point to last command line argument
	while( *argv[i] == '-'  ){     //check for optional arguments
	  switch( *(argv[i]+1) ){
	   case 'b':                    //bytes per pixel
		cntrl->bpp = atoi(argv[i]+2);
		break;
	   case 'i':                    //joint encoder-decoder epsilon
		cntrl->epsilon = atof(argv[i]+2);
		break;
	   case 'j':                    //decoder epsilon
		cntrl->d_epsilon = atof(argv[i]+2);
		break;
	   case 'l':                    //encode only flag
		cntrl->encode_only = 1;
		break;
	   case 'm':                    /*get num of structTrg dblBUF_codevectors to use*/
		cntrl->desired_num_ts_vecs = (unsigned)atoi(argv[i]+2);
		break;
	   case 'r':                    //set flag
		cntrl->mean = 1;
		break;   
	   case 'p':
		cntrl->peak_sqnr = 1;       //set peak_sqnr on
		break;
	   case 'M':                    //set markov stage count
		cntrl->markov_stage = atoi(argv[i]+2) - 1;
		break;   
	   case 'N':                    //set markov stage count//
    
		//cntrl->node_file = argv[i] + 2;
      
		break;   
	   case 'S':                    //Stop-flag = VRRVQ Type II
		cntrl->stop_snr = atof(argv[i]+2);
		break;   
	   case 'Z':                    //set no null flag
		cntrl->no_null = 1;
		break; 
	   default:
		printf("parse_command_line:%s is a bad optional argument!\n",argv[i]+1);
		exit(-1);
	  }//switch
	  i--;
	}//while


	//Name ouput node file.
	#if ( VARIABLE_START_RVQ )
	i = 0;
	while( *(argv[2]+i) != '.' && i < (STRLEN+1) ){
	  cntrl->node_file[i] = *(argv[2] + i);
	  i++;
	}
	cntrl->node_file[i] = 0;
	strcat(cntrl->node_file,".nodes");
	#endif

	return;

}//parse_command_line



//-------------------------------------------------------------------------------------------
//this reads the .sml file (which I call .raw file).  it contains all training snippets concatenated 
//together.  if you want to read this file in IrfanView, make sure you set a header size of 512 bytes.
//-------------------------------------------------------------------------------------------
void get_ts		(
				ts_params *structTrg,
				dssa_params *dssa,
				cntrl_params *cntrl
				)
{
	//==============================
	//INITIALIZATION
	//==============================
		//declarations
		//------------
			//previous
			char		mean_file[STRLEN];
			int			i;				//looping variable
			int			k;				//looping variable
			double		*mean_ptr;		//mean buffer pointer
			double		*ts_ptr;		//training set pointer
			double		*vec_ptr;		//vector pointer
			double		*mean_buf;		//vector mean buffer
			double		vec_sum;		//vector sum
			double		vec_mean;		//vector mean
			double		abs_pxl;		//absolute pixel value
			double		pxl;			//pixel value

			//salman
			int			numBytesRead = -1;
			int			status = -1;
			ifstream	ts_fd;			//file descriptor
			ofstream	mean_fd;		//file descriptor

		//open the training set file (contains all training snippets in one file)
		//--------------------------
															//if( (ts_fd = gopen(structTrg->filename,R)) < 3 )
															//{
															//	perror("get_ts:error opening training set:");
															//	exit(-1);
															//}

			ts_fd.open(structTrg->filename, ios::binary);
															//error checking
															if (!ts_fd.is_open())
															{
																cout<<"could not open file"<<endl;
																exit(-1);
															}

	


		//read the training set header (this is a 512 byte header)
		//----------------------------
			status = read_header_xplatform(ts_fd,(byte*)&(structTrg->tsh),TSH);

															//error checking
															if( status != 0 )
															{
																perror("get_ts:number of bytes read from the training file (origninally .sml file) header is less than 512 bytes");
																exit(-1);
															}
	

			//get useful information out of training set header//
			structTrg->num_vecs		=	(unsigned)atoi(structTrg->tsh.num_vecs);
			dssa->vec_size		=	(unsigned)structTrg->tsh.shc * (unsigned)structTrg->tsh.sw;

															//error checking
															if( dssa->vec_size > MAXVECSIZE )
															{
																fprintf(stderr,"vector size exceeds MAXVECSIZE:");
																fprintf(stderr,"recompile the software\n");
																exit(-1);
															}

	
			//determine number of training set vectors and samples to process
			if( cntrl->desired_num_ts_vecs < structTrg->num_vecs ) 
				structTrg->num_vecs = cntrl->desired_num_ts_vecs;
	
			structTrg->num_samples = structTrg->num_vecs * dssa->vec_size;


		//allocate memory for training set buffer
		//---------------------------------------
			structTrg->buf			= (double *)malloc(sizeof(double)*structTrg->num_samples);

															//error checking
															if( structTrg->buf == NULL )
															{
																perror("get_ts:cannot allocate memory for the training set buffer:");
																exit(-1);
															}
#if VARIABLE_START_RVQ
			cntrl->sig_map = (byte *)malloc(sizeof(byte)*structTrg->num_vecs);

															//error checking
															if( cntrl->sig_map == NULL )
															{
																perror("get_ts:cannot allocate memory for the significance map:");
																exit(-1);
															}
#endif

	//===========================
	//OPERATIONS
	//===========================

		//read the training set vector into training set buffer
			numBytesRead = gread_xplatform(ts_fd,(byte*)structTrg->buf,structTrg->tsh.dt,DBL,structTrg->num_samples,NO);

															//error checking
															if(  numBytesRead != structTrg->num_samples )
															{
																perror("get_ts: not read enough bytes from the .sml file");
																exit(-1);
															}

	
		//remove mean from training data if required
			if( cntrl->mean )
			{
				printf("Removing vector means ");
				printf("(DOUBLE VERSION)\n");
  
			  //printf("(BYTE VERSION)\n"); 
  
 
			  //Name and open mean output file
				i = 0;
				while( *(structTrg->filename + i) != '.' && i < (STRLEN+1) )
				{
					mean_file[i] = *(structTrg->filename + i);
					i++;
				}
				mean_file[i] = 0;
				strcat(mean_file,".means");
				printf("%s\n",mean_file);
													  //if( (mean_fd = gopen(mean_file,W)) < 3 )
													  //{
													  // perror("get_ts:error opening mean file:");
													  // exit(-1);
													  //}
				mean_fd.open(mean_file,ios::binary);
													  //error checking
													  if (!mean_fd.is_open())
													  {
														  cout<<"get_ts:error opening mean file"<<endl;
														  exit(-1);
													  }

	  
			//allocate memory for mean buffer
				mean_buf = (double *)malloc(sizeof(double)*structTrg->num_vecs);
				if( mean_buf == NULL )
				{
					perror("get_ts:cannot allocate memory for vector means:");
					exit(-1);
				}
			}	

	
		//calculate vector means and training set energy
		//----------------------------------------------
			if( cntrl->mean ) mean_ptr = mean_buf;
				structTrg->energy = 0.0;
			structTrg->max_pxl = 0.0;
			ts_ptr = structTrg->buf;
			i = structTrg->num_vecs;
			while( i-- )
			{
				if( cntrl->mean )
				{
					vec_sum = 0.0;
					vec_ptr = ts_ptr;
					k = dssa->vec_size;
					while( k-- ) 
						vec_sum += *vec_ptr++;


					vec_mean = vec_sum / (double)dssa->vec_size;
					*mean_ptr++ = vec_mean;
					//uch_vec_mean = (byte)(vec_mean + 0.5);
				}


				k = dssa->vec_size;
				while( k-- )
				{
					if( cntrl->mean ) 
						*ts_ptr -= vec_mean; //*ts_ptr -= (double)uch_vec_mean;
	
					pxl = *ts_ptr++;
					
					if( (abs_pxl = fabs(pxl)) > structTrg->max_pxl ) 
						structTrg->max_pxl = abs_pxl;
					
					structTrg->energy += pxl * pxl;
				}
			}

	//===========================
	//WRAP UP
	//===========================
#ifdef VERBOSE
			printf("getts:Initial Training Cummulative Distortion = %6.4e\n",structTrg->energy);
#endif


		//Write mean file if requested
		//----------------------------
			if( cntrl->mean )
			{
				if( gwrite_xplatform(mean_fd,(byte*)mean_buf,DBL,DBL,structTrg->num_vecs,NO) < 0 )
				{
					perror("get_ts:error writing means:");
					exit(-1);
				}
#ifdef SRC_UNIX
				close(mean_fd);
#endif
#ifdef SRC_NT
				_close(mean_fd);
#endif
			}


		//Initialize old cummulative distortion to training set energy
		//------------------------------------------------------------
			cntrl->enc_old_cum_dist = structTrg->energy;


																//close(ts_fd);

			ts_fd.close();
			if( cntrl->mean ) 
				free(mean_buf);

	
			return;


}//get_ts





//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
void tree_print(

				dssa_params *dssa,
				cntrl_params *cntrl,
				struct class_tree_node *node,
				int full_print

				)
{

		int cv_cnt;
		for(cv_cnt=0; cv_cnt<(int)dssa->cbk_size; cv_cnt++)
			if( node->child[cv_cnt] != NULL )
				tree_print(dssa,cntrl,node->child[cv_cnt],full_print);
       return;
}//tree_print



//-------------------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------------------
void clean_up	(
				ts_params *structTrg,
				dssa_params *dssa,
				cntrl_params *cntrl
				)
{

       unsigned int i;

       //free dynamic memory
       free(cntrl->P_tuple);
       free(cntrl->tr_buf);
       free(cntrl->cent_buf);
       free(structTrg->buf);

		for (i=0; i<dssa->num_stages; i++)
		{
			free (dssa->enc_cbks[i].dblBUF_codevectors);
			free (dssa->dec_cbks[i].dblBUF_codevectors);
		}

#if ( ESFR || ESVR )
       //free(cntrl->equiv_idx);
       //free(cntrl->equiv_cbk);
#endif

 

       //Close files
							//       _close(dssa->enc_cbk_fd);
							//       _close(dssa->dec_cbk_fd);

		dssa->enc_cbk_fd.close();
		dssa->dec_cbk_fd.close();
 
       return;

 

}//clean_up