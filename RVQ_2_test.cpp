//generating output from reference inputs for comparison
//put this in Property Pages -> Configuration Properties -> Debugging -> Command Arguments
//referenceRVQ/reference_0_00472_640x480.raw referenceRVQ/reference_4_codebooks.ecbk referenceRVQ/reference_4_codebooks.dcbk  referenceRVQ/reference_5_codebooks.nodes 2 640 480 11 41 test_out/00472 1
//img/Dudek/120x80/00001_120x80.raw test_out/codebook.ecbk test_out/codebook.dcbk  test_out/codebook.nodes 2 120 80 17 17 test_out/00001 1

#include "RVQ_xplatform_cleaner.h"

void Vectorize	(
				structTrgParameters*	structTrg,
				int						strip_height,
				float**					pptr_fltBUF_img_row,
				int						iw,
				int						ih,
				int						iiw,
				int						sw,
				int						sh,
				int						x_stride,
				int						y_stride,
				int						ic
				);

int		detect_encode_single_stage		(
										structTrgParameters*,
										structCodebookParameters*,
										structControlParameters*,
										int,float*,
										double*,
										unsigned int*,
										double*,
										double*
										);

bool	ClassifyImage					(
										structTrgParameters*,
										structCodebookParameters*,
										structControlParameters*,
										int,
										int,
										int,
										int,
										int,
										int,
										int,
										int,
										int,
										double,
										double,
										std::string strPixelType,
										std::string cfn_Iraw,
										std::string cfn_NSR,
										std::string cfn_STG,
										std::string cfn_SoC,
										int bVerbose
										);



//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//old: g++ RVQ_test.cpp VQlib_noMFC.cpp IOlib_noMFC.cpp my_miner_DSSAlib.cpp -IRVQ_common -IRVQ_common/include 
//now: g++ RVQ_test.cpp (since I've moved everything inside this file and one include file which is also in this directory)
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
int main(int argc, char** argv)
{
	//----------------------------------------------------
	//INITIALIZATION
	//----------------------------------------------------

		//parameters (passed through command line)
			structTrgParameters						structTrg;
			structControlParameters					structControl;
			structCodebookParameters				structCodebook;

			structTrg.cfn							=	argv[1];
			std::string cfn_Iraw(structTrg.cfn);				//image filename
			std::string cfn_ecbk					=	argv[2];	//encoder codebook filename
			std::string cfn_dcbk					=	argv[3];	//decoder codebook filename
			std::string cfn_nodes					=	argv[4];	//nodes filename

			int M									=	atoi(argv[5]);	//number of templates per stage

			int iw									=	atoi(argv[6]);	//image width
			int ih									=	atoi(argv[7]);	//image height
			int sw									=	atoi(argv[8]);	//snippet width
			int sh									=	atoi(argv[9]);	//snippet height
	
			std::string cfn_STG						=	argv[10];		//SNR filename
			std::string cfn_NSR						=	argv[10];		//stages filename
			std::string cfn_SoC						=	argv[10];		//SoC's filename (previously saved as .idx)
			int bVerbose							=	atoi(argv[11]);

		//constant
			int ic									=	6;  //we use 6 channels in the raw image: R, G, B, invR, invG, invB
			structControl.bpp						=	4;
			structControl.encode_only				=	0;
			structControl.threshold					=	0.0;
			structControl.markov_stage				=	(int)MAXNUMSTAGES - 1;
			structControl.mean						=	0;
			structControl.stop_snr					=	1000;

			double floorScaleFactor					=	1.0;
			double ceilingScaleFactor				=	1.0;
			std::string strPixelType				=	"unsigned int8";


		//dependent
			cfn_NSR									+=	"_9.nsr";
			cfn_STG									+=	"_10.stg";
			cfn_SoC									+=	"_11.soc";


			
			structCodebook.cfn_ecbk					=	(char*)cfn_ecbk.c_str();
			structCodebook.cfn_dcbk					=	(char*)cfn_dcbk.c_str();
			structCodebook.Mp1						=	M+1; //notice that this is M + 1


			structTrg.tsh.sw						=	sw;				//width in pixels
			structTrg.tsh.shc						=	sh * ic;		//height in bytes of planar (non-interleaved) channels, $s_{hc} =s_h * s_c$
			structCodebook.N_posnegPixelsInSnippet	=	sw * sh * ic;	//number of positive and negative pixels in snippet

														strcpy(structControl.node_file, cfn_nodes.c_str());


			int crop_left							=	0;
			int crop_top							=	0;
			int crop_right							=	iw;
			int crop_bottom							=	ih;


	//----------------------------------------------------
	//OPERATIONS
	//----------------------------------------------------

		bool status = ClassifyImage		(
											&structTrg,
											&structCodebook,
											&structControl,
											iw,
											ih,
											crop_top,
											crop_left, 
											crop_bottom, 
											crop_right, 
											sw, 
											sh, 
											ic, 
											floorScaleFactor, 
											ceilingScaleFactor, 
											strPixelType,
											cfn_Iraw,
											cfn_NSR,
											cfn_STG,
											cfn_SoC,
											bVerbose
										);

	return status;

}




//-------------------------------------------------------------------------------
//
//-------------------------------------------------------------------------------
bool ClassifyImage		(
						structTrgParameters				*structTrg,
						structCodebookParameters		*structCodebook,
						structControlParameters			*structControl,
						int								iw,
						int								ih,
						int								crop_top,
						int								crop_left,
						int								crop_bottom,
						int								crop_right,
						int								sw,
						int								sh,
						int								ic,
						double							floorScaleFactor,
						double							ceilingScaleFactor,
						std::string						strPixelType,
						std::string						cfn_Iraw,
						std::string						cfn_NSR,
						std::string						cfn_STG,
						std::string						cfn_SoC,
						int								bVerbose
						)
{
    //------------------------------------------------------
    //INITIALIZATIONS
    //------------------------------------------------------
        //declarations
            //cout<<"start classifying image"<<endl;
            

            int					x_stride;
            int					y_stride;
            int					strip_cnt               =   0;
            int					rows_processed          =   0;

            
			ifstream			ifs_Iraw;
			FILE*				fil_nodes;

			ofstream			ofs_nsr;
            ofstream			ofs_stg;
            ofstream			ofs_soc;

			unsigned int		num_read				=	0;
			unsigned int		node_cnt = 0;
			unsigned int		Nimg_bytes;
            float*				fltBUF_img;
			unsigned char*		chrBUF_img;
            int					strip_height;
            double*				dblBUF_Esignal;
            float*				fltBUF_nsr;
			double				detect_floor, detect_ceiling;

            if ( sw % 2 == 0 && sh % 2 == 0 )
            {
                        x_stride                =   sw;
                        y_stride                =   sh;
            }
            else
            {
                        x_stride                =   1;
                        y_stride                =   1;
            }

            int         Iit				=   crop_top + sh/2;	//correct			(inner image, top)
            int         Iil				=   crop_left + sw/2;	//correct			(inner image, left)
            int         Iib				=   crop_bottom - sh/2;	//incorrect: there should be a -1 here, but that's ok since this is only used to compute inner image height, and that ignores a +1, in the end, the height is needed and that is correct
            int         Iir				=   crop_right - sw/2;	//incorrect: same argument as above
            int         iiw				=   Iir - Iil;			//incorrectly computed but answer is correct because of incorrection above
            int         iih				=   Iib - Iit;			//same argument as above

                                                    if ( iiw < 0 || iih < 0 )
                                                    {
														cout<<"inner image width or height < 0";
                                                        return false;
                                                    }

            strip_height                        =   MIN(iih, STRIP_HEIGHT);
            structTrg->Nstrippixels				=   (strip_height / y_stride) * (iiw / x_stride);			//number of pixels in a horizontal image strip which is iiw x 8, x_stride and y_stride are 1
            structTrg->Nstripbytes              =   structTrg->Nstrippixels * structCodebook->N_posnegPixelsInSnippet;	//one ROI (snippet) is placed on every strip pixel

        //memory allocations
            structTrg->dblBUF_trgStrip				=   (double*)   malloc(sizeof(double)   *structTrg->Nstripbytes);
            dblBUF_Esignal						=   (double *)  malloc (sizeof(double)  *structTrg->Nstrippixels);
            structControl->uchrBUF_stages		=   (byte *)    malloc (sizeof(byte)    *structTrg->Nstrippixels);
            fltBUF_nsr							=   (float *)   malloc (sizeof(float)   *structTrg->Nstrippixels);

                                                    if ( structTrg->dblBUF_trgStrip == NULL )
													{
														cout<<"could not allocate memory for training data buffer";
                                                        return FALSE;
													}

                                                    if (dblBUF_Esignal == NULL)
													{
														cout<<"could not allocate memory for training energies";
                                                        return FALSE;
													}

                                                    if (structControl->uchrBUF_stages == NULL)
													{
														cout<<"could not allocate memory for stages buffer";
                                                        return FALSE;
													}

                                                    if (fltBUF_nsr == NULL)
													{
														cout<<"could not allocate memory for nsr buffer"; //nsr = 1/snr
                                                        return FALSE;
													}

	//------------------------------------------------------
    //READ FILES
    //------------------------------------------------------
        //.nsr, .stg, .soc
		//----------------
            ofs_nsr.open		(cfn_NSR.c_str(), ios::binary);
            ofs_stg.open		(cfn_STG.c_str(), ios::binary);
            ofs_soc.open		(cfn_SoC.c_str(), ios::binary);

																		//err checking
																		if (!ofs_nsr.is_open())
																		{
																			cout<<"FILE OPEN ERROR: SNR file not opened"<<endl;
																			return FALSE;
																		}

																		if (!ofs_stg.is_open())
																		{
																			cout<<"FILE OPEN ERROR: stage file not opened"<<endl;
																			return FALSE;
																		}

																		if (!ofs_soc.is_open())
																		{
																			cout<<"FILE OPEN ERROR: SoC descriptor file not opened"<<endl;
																			return FALSE;
																		}



		//files: .ecbk, .dcbk (get existing codebooks)
		//-------------------
			int status = get_cbks (structTrg, structCodebook, structControl);

																		//err checking
																		if ( status == NOT_OK )
																		{
																			cout<<"FILE OPEN ERROR: Codebook files could not be opened.  Check to make sure that SRC_NT or UNIX preprocessor flags are correctly set.  Then make sure that .ecbk and .dcbk files exist"<<endl;
																			return FALSE;
																		}



		//files: .nodes (open tree-node file. Read decision tree nodes)
		//-------------
            fil_nodes = fopen (structControl->node_file, "rb");  //i had wanted to make this ifstream, but it's later read recursively, which i thought would be difficult to do with ifstream.  moreover, this file is opened using regular fopen and read using fread, which are ok, as opposed to the open and _open and read and _read which were the initial motivation for removal

																		//err checking
																		if (fil_nodes == NULL)
																		{
																			cout<<"FILE OPEN ERROR: NodeFile not opened"<<endl;
																			return FALSE;
																		}

																		if (fread (&detect_floor, sizeof(double), 1, fil_nodes) != 1)
																		{
																			cout<<"detect_floor problem";
																			return FALSE;
																		}
			
																		if (fread (&detect_ceiling, sizeof(double), 1, fil_nodes) != 1)
																		{
																			cout<<"detect_ceiling problem";
																			return FALSE;
																		}

			//read floor and ceiling from nodes file
            detect_floor		*=	floorScaleFactor;
            detect_ceiling		*=	ceilingScaleFactor;

			//recursively read nodes
            status				=	read_node (structCodebook, &(structCodebook->root_node), fil_nodes, &node_cnt);

																		//err checking
																		if ( status == NOT_OK )
																		{
																			cout<<"FILE READ ERROR: recursively not read nodes"<<endl;
																			return FALSE;
																		}

									fclose (fil_nodes);





		//file: image
		//-----------
            Nimg_bytes			=	iw * ih * ic;

            fltBUF_img			=	new float			[Nimg_bytes];
			chrBUF_img			=	new unsigned char	[Nimg_bytes];

									ifs_Iraw.open(cfn_Iraw.c_str(), ios::binary);

																		//err checking
																		if (!ifs_Iraw.is_open())
																		{
																			cout<<"FILE OPEN ERROR: .raw image file not opened"<<endl;
																			return FALSE;
																		}

									ifs_Iraw.read(   (char *)chrBUF_img,   (Nimg_bytes * sizeof(byte))  );
			num_read			=	ifs_Iraw.gcount();

																//err checking
																if( num_read != Nimg_bytes * sizeof(byte) )
																{
																	cout<<"not enough bytes read from image"<<endl;
																	return -1;
																}


			//copy char image to float image
            byte* ptr_chrBUF_img_temp=	chrBUF_img;
            float* ptr_fltBUF_img_temp=	fltBUF_img;

            for ( unsigned int i = 0; i < Nimg_bytes; i++ )
            {
                *ptr_fltBUF_img_temp++	=	(float)*ptr_chrBUF_img_temp++;
            }

									delete chrBUF_img;
									ifs_Iraw.close();

            //initialize image data pointers
            float* ptr_fltBUF_img		=	fltBUF_img;
            float* pptr_fltBUF_img_row	=	ptr_fltBUF_img;

            pptr_fltBUF_img_row			+=	(crop_top * iw + crop_left);

    //------------------------------------------------------
    //OPERATIONS
    //------------------------------------------------------
        //Process image in strips
			int numTimesOutermostWhileExecuted=0;
            while (strip_height)
            {
				numTimesOutermostWhileExecuted++;
                //a. vectorize input image
				//------------------------
                    Vectorize(structTrg, strip_height, &pptr_fltBUF_img_row, iw, ih, iiw, sw, sh, x_stride, y_stride, ic);

                //b. compute Esignal (go over all the pixels, one snippet per pixel, and store the energy of every single snippet 
				//------------------
						//old comment: compute mean-removed vector energies
                    int		cnt_stripPixels;
                    int		N_posnegPixelsInSnippet;
                    double* ptr_dblBUF_trgStrip	=	structTrg->dblBUF_trgStrip;  //contains training data from one strip
                    double* ptr_dblBUF_Esignal	=	dblBUF_Esignal;
                    cnt_stripPixels				=	structTrg->Nstrippixels;

					//goes over each pixel (i.e. snippet) in strip 
                    while ( cnt_stripPixels-- )  //iiw * STRIP_HEIGHT
                    {
						if (bVerbose)
						{
							//cout<<numTimesOutermostWhileExecuted<<". computed Esignal of "<<structTrg->Nstrippixels - cnt_stripPixels<< " of "<< structTrg->Nstrippixels<<" pixels in iiw x STRIP_HEIGHT ("<<iiw<< " x "<<STRIP_HEIGHT<<") strip"<<endl;
						}
															//code doesn't seem to stop here
															if (structControl->mean)
															{
																double vec_mean		=	0.0;
																double* vec_ptr		=	ptr_dblBUF_trgStrip;
																N_posnegPixelsInSnippet					=	structCodebook->N_posnegPixelsInSnippet;
																while (N_posnegPixelsInSnippet--)
																{
																	vec_mean += *vec_ptr++;
																}
																vec_mean /= (float) structCodebook->N_posnegPixelsInSnippet;

																vec_ptr = ptr_dblBUF_trgStrip;
																N_posnegPixelsInSnippet = structCodebook->N_posnegPixelsInSnippet;
																while (N_posnegPixelsInSnippet--)
																{
																	*vec_ptr++ -= vec_mean;
																}
															}

                        N_posnegPixelsInSnippet	=	structCodebook->N_posnegPixelsInSnippet;
                        *ptr_dblBUF_Esignal	=	0.0;

						////goes over single snippet, (compute energy of one snippet, but include positive and negative pixels in the computation)
                        while (N_posnegPixelsInSnippet--) //remember that ptr_dblBUF_trgStrip contains the first snippet (R channel, then G channel, and so on, cnt_stripPixels.e. planar) and then the second snippet, and so on
                        {
                            *ptr_dblBUF_Esignal += (float)(*ptr_dblBUF_trgStrip * *ptr_dblBUF_trgStrip);  //total energy of a snippet: take every pixel, square it, and sum all these numbers (also, remember that this includes negative pixel values as well)
                            ++ptr_dblBUF_trgStrip;
                        }
						
						//one location of ptr_dblBUF_Esignal stores energy of one snippet, here we're saying advance to the next location so the next snippet's energy can be stored
                        ++ptr_dblBUF_Esignal; 
                    }

                //c. do detection/classification processing
				//-----------------------------------------
                    byte* ptr_uchrBUF_stages = structControl->uchrBUF_stages;
                    int vec_cnt = structTrg->Nstrippixels;
                    while (vec_cnt--)
                    {
                        *ptr_uchrBUF_stages++ = 0;          /*SET to ZERO or ONE?*/
                    }

					//called once per strip
                    unsigned int nustages_used = 0;
                    for (int stage=0; stage<(int) structControl->num_primed_stages; stage++)
                    {
                        status = detect_encode_single_stage (structTrg, structCodebook, structControl, stage, fltBUF_nsr,
                                                dblBUF_Esignal, &nustages_used, &detect_floor,
                                                &detect_ceiling);  //notice that you pass in Esignal to compute fltBUF_nsr

                        if (status == NOT_OK)
                        {
                            return FALSE;
                        }
                    }


                //d. save
				//-------
                    if ( BSaveOutputState == TRUE )
                    {
						//NSR
                        nTotalProcessedPixels	+=	structTrg->Nstrippixels;
													ofs_nsr.write((char *)fltBUF_nsr,				( structTrg->Nstrippixels * sizeof(float) ) );

						
                        byte *ptr_uchrBUF_soc			=	structControl->uchrBUF_soc;  

						//stages
													ofs_stg.write((char *)structControl->uchrBUF_stages, ( structTrg->Nstrippixels * sizeof(byte) ) );
                        int nNumStagesWrite		=	(int)structControl->num_primed_stages;


                        byte* uchrBUF_soc = (byte*)malloc(sizeof(byte) * structTrg->Nstrippixels * nNumStagesWrite);
                        if ( uchrBUF_soc == NULL )
                        {
                            cout<<"memory not allocated to uchrBUF_soc"<<endl;
                            return FALSE;
                        }

                        ptr_uchrBUF_soc = structControl->uchrBUF_soc;
                        byte* idx_ptrOut = uchrBUF_soc;
                        int stage;
                        for ( cnt_stripPixels = 0; cnt_stripPixels < (int)structTrg->Nstrippixels; cnt_stripPixels++ )
                        {
                            for ( stage = 0; stage < nNumStagesWrite; stage++ )
                            {
                                *idx_ptrOut++ = *(ptr_uchrBUF_soc + cnt_stripPixels + stage * (int)structTrg->Nstrippixels);
                            }
                        }

                        ofs_soc.write((char *)uchrBUF_soc, ( structTrg->Nstrippixels * nNumStagesWrite * sizeof(byte) ) );
                    }//end save

//!!caution!! salman: although I want iih to be a constant, here, iih is being reduced!  not quite consistent with my notation, but it works, so I'll let it go
                //e. update parameters
				//--------------------
                    iih -= strip_height;  
                    strip_height     = MIN (iih, STRIP_HEIGHT);
                    strip_height     = MAX (0, strip_height);
                    rows_processed  += strip_height;
                    
					//cout<<rows_processed<<endl;

                    structTrg->Nstrippixels    = (strip_height / y_stride) * (iiw / x_stride);
                    structTrg->Nstripbytes = structTrg->Nstrippixels * structCodebook->N_posnegPixelsInSnippet;

                    ++strip_cnt;

            } //end while (strip_height)


    //------------------------------------------------------
    //WRAP UP
    //------------------------------------------------------

            if ( BSaveOutputState == TRUE )
            {
    //            int nNumStages = structControl->num_primed_stages;
    //            OutParameterFile.write((char *)&nNumStages, ( sizeof(int) ) );
    //
    //            int nNumTemplatesPerStage = atoi(strNumTemplatesPerStage);
    //            OutParameterFile.write((char *)&nNumTemplatesPerStage, ( sizeof(int) ) );
    //
    //            int nSnippetWidth = atoi(strSnippetWidth);
    //            OutParameterFile.write((char *)&nSnippetWidth, ( sizeof(int) ) );
    //
    //            int nSnippetHeight = atoi(strSnippetHeight);
    //            OutParameterFile.write((char *)&nSnippetHeight, ( sizeof(int) ) );
    //
    //            float sglDataPakFidelity = (float)atof(strDataPakFidelity);
    //            OutParameterFile.write((char *)&sglDataPakFidelity, ( sizeof(float) ) );
    //
    //            int nCropStartX = ptCropStart.x;
    //            OutParameterFile.write((char *)&nCropStartX, ( sizeof(int) ) );
    //
    //            int nCropEndX = ptCropEnd.x;
    //            OutParameterFile.write((char *)&nCropEndX, ( sizeof(int) ) );
    //
    //            int nCropStartY = ptCropStart.y;
    //            OutParameterFile.write((char *)&nCropStartY, ( sizeof(int) ) );
    //
    //            int nCropEndY = ptCropEnd.y;
    //            OutParameterFile.write((char *)&nCropEndY, ( sizeof(int) ) );
    //
    //            int nTotalProcessedPixels = nTotalProcessedPixels;
    //            OutParameterFile.write((char *)&nTotalProcessedPixels, ( sizeof(int) ) );
    //
    //            nTotalProcessedPixels = 0;
    //            nTotalProcessedPixels = 0;

                ofs_nsr.close();
                ofs_stg.close();
                ofs_soc.close();
                
            }

            delete fltBUF_img;

			
			structCodebook->ifs_ecbk.close();
            structCodebook->ifs_dcbk.close();

            return TRUE;
}


//--------------------------------------------------------------------------------------------------------
//
//--------------------------------------------------------------------------------------------------------
int detect_encode_single_stage	(
					structTrgParameters			*structTrg,
					structCodebookParameters	*structCodebook,
					structControlParameters		*structControl,
					int							stage,
					float						*fltBUF_nsr,
					double						*dblBUF_Esignal,
					unsigned int				*nustages_used,
					double						*detect_floor,
					double						*detect_ceiling
					)
{
	enum	yin_yang valid_flag;
	
	byte	*ptr_uchrBUF_Ttuple;
	byte	*ptr_uchrBUF_soc;
	float	*ptr_fltBUF_nsr;
	double	*ptr_dblBUF_codevectors;
	double	*ptr_dblBUF_trgStrip;
	double	*ptr_dblBUF_trg2;
	double	*ptr_dblBUF_Esignal;
	byte	*ptr_to_prior_null_encoding_flag;

	byte	P_tuple_buf[MAXNUMSTAGES];
	byte	idx_codevector;
	byte	idx_best_codevector;
	byte	*ptr_uchrBUF_stages;
	
	byte	P_value_to_keep_encoding_at_this_stage;
	byte	P_value_to_not_encode_at_next_stage;
	byte	P_value_to_keep_encoding_at_next_stage;
	int		i;
	int		start_stage;
	int		Nstrippixels;
	int		cnt_codevectorsPerStage_Mp_or_Mp1;
	int		N_posnegPixelsInSnippet;
	int		curr_cbk_size_Mp_or_Mp1;
	int		markov_stage;
	int		stage_p1;
	int		stage_p2;
	int		curr_cbk_size_M;
	int		prior_cbk_size_M;
	double	err;
	double	Enoise;
	double	min_Enoise;
	double	tmp_dbl;
	double	nsr; //nsr = 1/snr
	double	stop_dist;

	// Determine variable rate encoder stopping threshold factor.
		tmp_dbl				=	-(structControl->stop_snr / 10.0);
		stop_dist			=	pow(10.0,tmp_dbl);

	/*Determine markov stage.*/
		markov_stage		=	stage - structControl->markov_stage;

	// for variable start RVQ, initialize "active" training vector pointer to P-tuple buffer
	if( stage )
	{
		ptr_to_prior_null_encoding_flag = structControl->uchrBUF_soc + (stage - 1) * structTrg->Nstrippixels;
	}

	P_value_to_keep_encoding_at_this_stage		=	(byte)(stage + 1);
	P_value_to_not_encode_at_next_stage			=	(byte)(stage + 1);
	P_value_to_keep_encoding_at_next_stage		=	(byte)(stage + 2);

	stage_p1									=	stage + 1;
	stage_p2									=	stage + 2;	

	ptr_dblBUF_Esignal							=	dblBUF_Esignal;
	ptr_fltBUF_nsr								=	fltBUF_nsr;

	curr_cbk_size_M								=	structCodebook->Mp1 - 1;
	prior_cbk_size_M							=	structCodebook->Mp1 - 1;
	
	ptr_dblBUF_trgStrip								=	structTrg->dblBUF_trgStrip;
	ptr_uchrBUF_Ttuple							=	structControl->uchrBUF_soc;
	ptr_uchrBUF_stages							=	structControl->uchrBUF_stages;

	ptr_uchrBUF_soc								=	structControl->uchrBUF_soc + stage * structTrg->Nstrippixels;

	Nstrippixels								=	structTrg->Nstrippixels;

	while( Nstrippixels-- )
	{

		if( stage == 0 )
		{
			*ptr_fltBUF_nsr = (const float)INFINITY_DIST;
		}

		// Does input vector have same energy as realm of experience?
		if( 1 || (*detect_floor <= *ptr_dblBUF_Esignal && *ptr_dblBUF_Esignal <= *detect_ceiling ) )
		{
			/***********************************************************************************************************/
			// Encode the training vector if it is still active at the current stage for variable stop RVQ
			if( ( (int)*ptr_uchrBUF_stages >= P_value_to_keep_encoding_at_this_stage ) || ( (int)*ptr_uchrBUF_stages == 0 ) )
			{
				// If not the first stage, set codebook size to allow or dissalow null encoding based on previous encoding result
				if( stage && (int)*ptr_to_prior_null_encoding_flag++ < prior_cbk_size_M )  // previously non-null encoded
				{
					curr_cbk_size_Mp_or_Mp1			=	curr_cbk_size_M; //structCodebook->enc_cbks[stage].nuvectors - 1;
				}
				else
				{
 					curr_cbk_size_Mp_or_Mp1			=	structCodebook->Mp1;  // null encoding is still an option
				}

				*nustages_used += 1;

				//find closest codevector
				min_Enoise							=	myINFINITY;
				idx_codevector						=	0;
				ptr_dblBUF_codevectors				=	structCodebook->enc_cbks[stage].dblBUF_codevectors;
				cnt_codevectorsPerStage_Mp_or_Mp1	=	curr_cbk_size_Mp_or_Mp1;

				while( cnt_codevectorsPerStage_Mp_or_Mp1-- )
				{
					Enoise							=	0.0;
					ptr_dblBUF_trg2					=	ptr_dblBUF_trgStrip;
					N_posnegPixelsInSnippet			=	structCodebook->N_posnegPixelsInSnippet;
					while( N_posnegPixelsInSnippet-- )
					{
						err							=	*ptr_dblBUF_trg2++ - *ptr_dblBUF_codevectors++;
						Enoise						+=	err * err;  //Enoise is sse (sum of squared errors)
					}

					if( Enoise < min_Enoise )
					{
						min_Enoise					=	Enoise;
						idx_best_codevector			=	idx_codevector;
					}
					++idx_codevector;

				}
				*ptr_uchrBUF_soc++					=	idx_best_codevector;
						
				//See if path is valid.
				for(i=0; i<markov_stage; i++)
				{
					P_tuple_buf[i]					=	(byte)curr_cbk_size_M;
				}
				byte* pbytP_tuple = ptr_uchrBUF_Ttuple;
				for(i=MAX(markov_stage,0); i<=stage; i++)
				{
					P_tuple_buf[i]					=	*pbytP_tuple;

					pbytP_tuple						+=	structTrg->Nstrippixels;
				}

				valid_flag							=	dsTRUE;
				start_stage							=	-1;
														get_bnds(stage,P_tuple_buf,&start_stage,structCodebook->root_node,&valid_flag);

				//Break if not a valid path.
				if( valid_flag == dsFALSE )
				{
					//(ptr_uchrBUF_soc - 1)			= cbk_size_m1;   // this would point to null vector
					*(ptr_uchrBUF_soc - 1)			=	(byte)structCodebook->Mp1;   // offset from pointer increment above
															 // don't add this codevector referenced by this
															 // index value in a DSSA reconstruction

					*ptr_uchrBUF_stages				=	(byte)stage; // set to stop variable rate coding

					ptr_dblBUF_trgStrip					+=	structCodebook->N_posnegPixelsInSnippet;
				}
				//Do valid path processing.
				else
				{
					//Do processing if non-null encoded.
					if( idx_best_codevector < curr_cbk_size_M ) // non-null encoded
					{
						//Update causal residual in all cases.
						ptr_dblBUF_codevectors				=	structCodebook->enc_cbks[stage].dblBUF_codevectors + idx_best_codevector * structCodebook->N_posnegPixelsInSnippet;
						N_posnegPixelsInSnippet		=	structCodebook->N_posnegPixelsInSnippet;
						
						//notice that a residual is being written in place here
						while( N_posnegPixelsInSnippet-- )
						{
							*ptr_dblBUF_trgStrip++	-=	*ptr_dblBUF_codevectors++;
						}

						//determine current noise-to-signal ratio (salman: actually this is 1/SNR)
						//since this subroutine detect_encode_single_stage is called once per stage, and the fact that
						//the residual is written in place, nsr is overwritten at every stage, or every time this subroutine is called
						nsr						=	min_Enoise / *ptr_dblBUF_Esignal; //nsr = 1/snr

						*ptr_fltBUF_nsr			=	(float)nsr;
						*ptr_uchrBUF_stages		=	(byte)stage_p2;         //targ_grow // continue signal
					}
					//Else null-encoded and continue to latter stages.
					else
					{
						*ptr_uchrBUF_stages		=	(byte)stage_p2;
						ptr_dblBUF_trgStrip			+=	structCodebook->N_posnegPixelsInSnippet;
					}

				}//if valid
			}
			//Encoding previously completed.
			else
			{
				ptr_dblBUF_trgStrip					+=	structCodebook->N_posnegPixelsInSnippet;
				*ptr_uchrBUF_soc++				=	(byte)structCodebook->Mp1;
			}
		}
		//Not enough input energy path.
		else
		{
			ptr_dblBUF_trgStrip						+=	structCodebook->N_posnegPixelsInSnippet;
			*ptr_uchrBUF_soc++					=	(byte)structCodebook->Mp1;
		}

		if ( stage )
		{
												++ptr_to_prior_null_encoding_flag;
		}

												++ptr_uchrBUF_stages;
												++ptr_uchrBUF_Ttuple;
												++ptr_fltBUF_nsr;
												++ptr_dblBUF_Esignal;

	}//Nstrippixels

	return OK;

}//detect_encode_single_stage




//-------------------------------------------------------------------------------
//this function takes strip_height x iiw pixels, and for each pixel, extracts a sw x sh x ic snippet (channels are planar)
//all these planar channeled snippets are concatenated one after the other
//-------------------------------------------------------------------------------
void Vectorize		(
					structTrgParameters		*structTrg,
					int						strip_height,
					float					** pptr_fltBUF_img_row,
					int						iw,
					int						ih,
					int						iiw,
					int						sw,
					int						sh,
					int						x_stride,
					int						y_stride,
					int						ic
					)
{
	int i;
	int j;
	int k;
	int l;
	int m;


	double*	ptr_dblBUF_trgStrip = structTrg->dblBUF_trgStrip;
	i = strip_height;
	while ( i > 0 )
	{
		//moves horizontally.  when j=0, the lines below create ic planar channels of one sw x sh snippet
		for ( j = 0; j < iiw; j += x_stride )
		{

			//causes planar channels for sw x sh snippet
			for ( m = 0; m < ic; m++ )
			{
				float* vec_row_ptr = *pptr_fltBUF_img_row + m * iw * ih + j;

				//extracts one channel of sw x sh snippet from the iw x ih image
				k = sh;
				while ( k-- )
				{
					float* vec_col_ptr = vec_row_ptr;

					l = sw;
					while ( l-- )
					{
						*ptr_dblBUF_trgStrip = *vec_col_ptr;

						++ptr_dblBUF_trgStrip;
						++vec_col_ptr;
					}

					vec_row_ptr += iw;
				}
			}
		}

		*pptr_fltBUF_img_row += (iw * y_stride);

		i -= y_stride;
	}
}
