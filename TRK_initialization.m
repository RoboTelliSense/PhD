function [INP.ds_8_I_HxWxF, INP.rand_unitvar_maxFx6xNp, INP.rand_cdf_maxFxNp, CONFIG, IPCA, BPCA, RVQ, TSVQ, trkIPCA, trkBPCA, trkRVQ, trkTSVQ] = TRK_initialization(CONFIG)

    
%1. structure #1: PARAM (algorithm parameters)
    PARAM.con_errfunc      =   'L2';               %condensation related              
    INP.ds_7_con_stddev     =   0.01;               %check!!
	PARAM.scale =   32;                 %target related
	PARAM.trg_B          =   5;                  %training related, batch size for how many images to use for training
	PARAM.trg_frame_idxs   =   [];                 %"
	PARAM.plot_row2       	=   2;                  %plotting related
	PARAM.plot_row3   		=   3;                  %"
	PARAM.plot_row4   		=   4;                  %"
	PARAM.plot_num_rows  	=   5;                  %"
	PARAM.plot_num_cols  	=   4;                  %"
	PARAM.plot_title_fontsz=   8;                  %", fontsize

    
    %load .mat file: (a) dataset images, (b) dataset parameters, (c) dataset ground truth
    [CONFIG, INP.ds_8_I_HxWxF]   =   UTIL_DATASET_getName4(CONFIG, data, datatitle, truepts);  %check since sw and sh are 33
    
    %random data for particle filter (pre-stored for repeatability)
	load RandomData 

    %directories and files    
    CONFIG                  =   TRK_fileManagement(CONFIG);
    
    %ground truth related
    INP.gt_2_num_fp            =   size(INP.gt_1_fp,2);                         %number of feature points
    INP.ds_4_aff_abcdxy_1x6=   affparaminv(INP.ds_4_aff_abcdxy_1x6);
    INP.gt_3_initial_fp     =   INP.ds_4_aff_abcdxy_1x6([3,4,1;5,6,2]) * [INP.gt_1_fp(:,:,1); ones(1,INP.gt_2_num_fp)];

%2. structure #2: ALGO (algorithm parameters), template for IPCA, BPCA, RVQ, TSVQ

    %data 
    ALGO.DM2               	=   [];     			%1. data 		:	design matrix, one observation per column  
	PARAM.in_sw                	=   33;     			%2. dimensions	: 	snippet (target) width 
    PARAM.in_sh                	=   33;     			%  					snippet (target) height
    PARAM.tgt_sz                 =   [PARAM.in_sh PARAM.in_sw];  % 					combine two above
    ALGO.max_signal_val     =   255;  				%3. amplitude	:	max
    temp_I_0t1              =   double(INP.ds_8_I_HxWxF(:,:,1))/256; %0t1 means the image intensities are between 0 and 1       
    ALGO.mdl_2_mu_Dx1     	=   UTIL_2D_warp_image(temp_I_0t1, INP.ds_4_aff_abcdxy_1x6, PARAM.tgt_sz); clear temp_I_0t1; %data mean
    
	%particle filter
	PARAM.con_1_Np                	=   0;
    PARAM.con_reseig            	=   0;
	
	
	
%3. structure #3: tracking, template for trkIPCA, trkBPCA, trkRVQ, trkTSVQ
	%feature points
    TRK.fp_1_gt   			=   cat(3, INP.gt_3_initial_fp + repmat(PARAM.tgt_sz'/2,[1,INP.gt_2_num_fp]), INP.gt_1_fp(:,:,1)); %1. ground truth
    TRK.fp_2_est      		=   zeros(size(INP.gt_1_fp));  			%1b. estimated
	TRK.fp_3_err  			=   zeros(1,INP.gt_2_num_fp);    	%1c. feature points: error
    TRK.fp_4_err_avg 			=   zeros(1,INP.gt_2_num_fp);          	%1d. feature points: average error
    
    TRK.aff_abcdxy_1x6 	=   INP.ds_4_aff_abcdxy_1x6; rmfield(CONFIG,'aff_abcdxy_1x6');              %2.  bounding region: affine parameters
    
	TRK.trg_rmse__Tx1 		=   zeros(PARAM.trg_T,1);                  %3.  training
	TRK.trg_armse_Tx1 	=   zeros(PARAM.trg_T,1);
	TRK.trg_SNRdB_Tx1 		=   zeros(PARAM.trg_T,1);

    TRK.bestCandidate_0t1_shxsw =   ALGO.mdl_2_mu_Dx1;							%4.  testing
	TRK.trk_rmse__Fx1 		=   zeros(INP.ds_9_F,1);
	TRK.trk_armse_Fx1 	=   zeros(INP.ds_9_F,1);
	TRK.tst_SNRdB_Fx1   	=   zeros(INP.ds_9_F,1);

%4. %timing   
    duration                =   0; 
    tic;



%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%training phase
    for f = 1:PARAM.trg_B
        %strings
        f
        PARAM.str_f        =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [PARAM.dir_out 'out_' PARAM.str_f '.png'];
        
        %input
        I_0t1               =   double(INP.ds_8_I_HxWxF(:,:,f))/256;
        
        %operation
        algo_code           =   0; %i.e. just distance from mean of data
        [ALGO TRK]          =   TRK_condensation(I_0t1, f, ALGO, INP.gt_1_fp, TRK, CONFIG, INP.rand_unitvar_maxFx6xNp, INP.rand_cdf_maxFxNp, algo_code); %estwarp_grad    (I_0t1, ALGO, TRK, CONFIG);		
	end	   
	
    
%save algorithm structures	
	IPCA 					=	ALGO;
    BPCA                   	=   ALGO;rmfield(BPCA,'mdl_2_mu_Dx1');rmfield(BPCA,'mdl_2_U_DxB');rmfield(BPCA,'mdl_4_S_Bx1');
    RVQ                   	=   ALGO;rmfield(RVQ, 'mdl_2_mu_Dx1');rmfield(RVQ, 'mdl_2_U_DxB');rmfield(RVQ, 'mdl_4_S_Bx1');
    TSVQ                   	=   ALGO;rmfield(TSVQ,'mdl_2_mu_Dx1');rmfield(TSVQ,'mdl_2_U_DxB');rmfield(TSVQ,'mdl_4_S_Bx1');
    
    %IPCA
    IPCA.mdl_1_P__1x1                  =   PARAM.in_pca_P;     
    IPCA.ff                 =   INP.ds_6_ff;              rmfield(CONFIG,'ds_3_ff');       %forgetting factor
    IPCA.code               =   1;
    
    %BPCA
    BPCA.mdl_1_P__1x1                  =   PARAM.in_pca_P;        rmfield(CONFIG,'in_pca_P'); %number of eigenvectors to retain  
    BPCA.code               =   2;
    
    %RVQ
    RVQ.in_8_dir_out           	=   PARAM.dir_out;
    RVQ.in_4_M                 	=   PARAM.in_rvq_M;         rmfield(CONFIG,'in_rvq_M');
    RVQ.in_3_maxP              	=   PARAM.in_rvq_maxP;      rmfield(CONFIG,'in_rvq_maxP');
    RVQ.in_5_targetSNR         	=   PARAM.in_rvq_targetSNR; rmfield(CONFIG,'in_rvq_targetSNR');
    RVQ.tst_6_partP_Nx1      	=   -1;
    RVQ.code                =   3;
    
    %TSVQ
    TSVQ.P                 	=   PARAM.in_tsvq_P;       rmfield(CONFIG,'in_tsvq_P');
    TSVQ.M                 	=   PARAM.in_tsvq_M;       rmfield(CONFIG,'in_tsvq_M');
    TSVQ.code               =   4;
    
%save tracking structures	
	trkIPCA					=	TRK;
	trkBPCA					=	TRK;
	trkRVQ					=	TRK;
	trkTSVQ					=	TRK;
 
%train once
    PARAM.trg_frame_idxs           =   [PARAM.trg_frame_idxs, f];
    if (PARAM.in_bUseIPCA) IPCA  =   ipca_1_train  (IPCA.DM2,                            IPCA);	 IPCA.DM2 =   [];	end		
    if (PARAM.in_bUseBPCA) BPCA  =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,  BPCA);  end
    if (PARAM.in_bUseRVQ)  RVQ   =   RVQ__training (RVQ.DM2_weighted  * max_signal_val,  RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' PARAM.str_f '.txt']); end
    if (PARAM.in_bUseTSVQ) TSVQ  =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,  TSVQ);  end  

    disp('initialization complete');
    
    %PARAM.minopt         =   optimset;  %pre-defined in Matlab for optimization functions
    %PARAM.minopt.MaxIter =   25; 
    %PARAM.minopt.Display =   'off';    