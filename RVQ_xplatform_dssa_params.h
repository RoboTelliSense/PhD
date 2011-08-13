#ifndef __INCdssa_paramsh
#define __INCdssa_paramsh

#include <fstream>
using namespace std;

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
	Usage: %s ts_file ecbk_file dcbk_file cbk_size [-OPTIONS]\n\
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
	struct class_tree_node
	{
		struct class_tree_node *child[MAXCBKSIZE];
	};
#endif

	typedef struct{
		char* filename;                   /*training set filename*/
		unsigned num_vecs;                /*number of training set vectors*/
		unsigned num_samples;             /*number of training set samples*/
		double *buf;                      /*training set buffer*/
		double energy;                    /*training set energy level*/
		double max_pxl;                   /*training set maximum pixel level*/
		structTrgHeader tsh;                    /*training set header*/
	}ts_params;

	typedef struct{
		char* ecbk_filename;              /*filename*/
		char* dcbk_filename;              /*filename*/
		ifstream enc_cbk_fd;            //encoder codebook file descriptor
		ifstream dec_cbk_fd;            //decoder codebook file descriptor
		unsigned num_stages;              /*number of stages*/
		unsigned cbk_size;                /*number of codevectors per codebook*/
		unsigned vec_size;                /*vector size*/
		structCodebookMasterHeader enc_cbk_mhdr;         /*encoder codebook master header*/
		structCodebookMasterHeader dec_cbk_mhdr;         /*decoder codebook master header*/
		structCodebook enc_cbks[MAXNUMSTAGES]; /*encoder codebooks*/
		structCodebook dec_cbks[MAXNUMSTAGES]; /*decoder codebooks*/
#if ( VARIABLE_START_RVQ )
		struct class_tree_node *root_node;
		unsigned num_active_nodes;
#endif
	}dssa_params;

	typedef struct{
		enum yin_yang prev_cbks;          /*previously existing codebook flag*/
		byte *P_tuple;                    /*codevector index buffer*/
#if ( VARIABLE_START_RVQ )
		char node_file[STRLEN];
		byte *sig_map;                    /*codevector index buffer*/
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
	}cntrl_params;






#endif /* __INCdssa_paramsh */