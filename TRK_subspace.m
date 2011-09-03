%> @file TRK_subspace.m
%> @brief Main function for subspace tracking
%>
%> Description of options
%> ----------------------
%> affineROI_1x6            :   [px, py, sx, sy, theta]; The location of the target in the first frame.
%> px, py                   :   Coordinates of the centre of the box.
%> sx, sy                   :   Size of the box in the x (width) and y (height) dimensions, before rotation.
%> theta                    :   Rotation angle of the box
%> Np                       :   Number of samples used in the condensation, I normally use 600.
%>                              Increasing this will likely improve the results, but make the tracker slower.
%> condenssig               :   The standard deviation of the observation likelihood, e.g. 0.01
%> ff                       :   Forgetting factor, as described in the paper.  When doing the incremental update, 
%>                              1 means remember all past INP.ds_8_I_HxWxF, and 0 means remeber none of it.
%> batchsize                :   How often to update the eigenbasis.  We've used this value (update every 5th frame) 
%>                              fairly consistently, so it most likely won't need to be changed.  A smaller batchsize 
%>                              means more frequent updates, making it quicker to model changes in appearance, but also 
%>                              a little more prone to drift, and require more computation.
%> affineROIvar_1x6     	:   Standard deviations of the dynamics distribution, that is how much we expect the target
%>                              object might move from one frame to the next.  The meaning of each number is as follows:
%>                              affineROIvar_1x6(1) = x translation (pixels, mean is 0)
%>                              affineROIvar_1x6(2) = y translation (pixels, mean is 0)
%>                              affineROIvar_1x6(3) = rotation angle (radians, mean is 0)
%>                              affineROIvar_1x6(4) = x scaling (pixels, mean is 1)
%>                              affineROIvar_1x6(5) = y scaling (pixels, mean is 1)
%>                              affineROIvar_1x6(6) = scaling angle (radians, mean is 0)
%> sw, sh                   :   snippet width, height
%> tmplsize                 :   snippet size, the resolution at which the tracking window is sampled, in this case 
%>                              sw pixels by sh pixels.  If your initial window (given by affineROI_1x6) is very large you may need to increase this.
%> maxbasis                 :   The number of basis vectors to keep in the learned apperance model.
%> I_0t1                    :   Input image scaled between 0 and 1
%> B                        :   training update interval
%>
%> abbreviations
%> -------------
%> FP_2_est 						: 	Feature points
%> gt 						: 	Ground truth
%> DM2 						:	Data matrix, one observation per column.  If DM, then one observation per row.
%> structures
%> ----------
%> IPCA, BPCA, RVQ, TSVQ
%> trkIPCA, trkBPCA, trkRVQ, trkTSVQ
%>
%> dependencies
%> ------------
%> Dudek.mat, RandomData.mat, RVQ__training_gen8.exe
%> on Linux, make sure you do chmod +x RVQ__training_gen8.linux
%>
%> Copyright (c) Jongwoo Lim and David Ross.  All rights reserved.  Changed with permission by Salman Aslam.
%> Date created             :   around Feb, 2011
%> Date last modified       :   Aug 22, 2011


clear;
clc;
close all;
Np=600;
Nw=4;
bWeighting=0;
pca_Q=16;
rvq_maxP=8;
rvq_M=2;
rvq_targetSNR=1000;
tsvq_P=3;
tsvq_M=2;
bUseIPCA=1;
bUseBPCA=1;   
bUseRVQ=1;
bUseTSVQ=1;
datasetCode=0;

%#######################################################################
% function TRK_subspace(  Np, Nw, bWeighting,                     ...
%                         pca_Q,                               ...
%                         rvq_maxP, rvq_M, rvq_targetSNR,         ...
%                         tsvq_P, tsvq_M,                         ...
%                         bUseIPCA , bUseBPCA , bUseRVQ, bUseTSVQ,  ...
%                         datasetCode)

%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%PARAM 
    %variable parameters (from command line)
    PARAM.in_Np            =   Np;  %number of particles
    PARAM.in_Nw            =   Nw;  %number of images for training, (training window)
    PARAM.in_bWeighting    =   bWeighting;
    PARAM.in_pca_Q         =   pca_Q;
    PARAM.in_rvq_maxP      =   rvq_maxP;
    PARAM.in_rvq_M         =   rvq_M;
    PARAM.in_rvq_targetSNR =   rvq_targetSNR;
    PARAM.in_tsvq_P        =   tsvq_P;
    PARAM.in_tsvq_M        =   tsvq_M;
    PARAM.in_bUseIPCA      =   bUseIPCA;
    PARAM.in_bUseBPCA      =   bUseBPCA;
    PARAM.in_bUseRVQ       =   bUseRVQ;
    PARAM.in_bUseTSVQ      =   bUseTSVQ;
    PARAM.in_datasetCode   =   datasetCode;
    clear Np Nw bWeighting pca_Q rvq_maxP rvq_M rvq_targetSNR tsvq_P tsvq_M bUseIPCA bUseBPCA bUseRVQ bUseTSVQ datasetCode  
    
    %fixed parameters    
    PARAM.con_errfunc       =   'L2';               %condensation related              
    PARAM.con_reseig            =   0;
	PARAM.tgt_warped_sw_sh  =   32;                 %target related, note 1 less than sw and sh which I had to increase by 1 for RVQ
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    PARAM.tgt_sz            =   [PARAM.tgt_sh PARAM.tgt_sw];  % 					combine two above
    PARAM.tgt_max_signal_val=   255;
	PARAM.trg_B             =   5;                  %training related, batch size for how many images to use for training
	PARAM.trg_frame_idxs    =   [];                 %"
	PARAM.plot_row2       	=   2;                  %plotting related
	PARAM.plot_row3   		=   3;                  %"
	PARAM.plot_row4   		=   4;                  %"
	PARAM.plot_num_rows  	=   5;                  %"
	PARAM.plot_num_cols  	=   4;                  %"
	PARAM.plot_title_fontsz =   8;                  %", fontsize
   
%2. INP
    INP                    =    TRK_read_input(PARAM.in_datasetCode, PARAM.tgt_warped_sw_sh); 

    
    %back to PARAM based on input
    PARAM                   =   TRK_fileManagement(PARAM, INP);  %filenames
    PARAM.trg_T             =	round(INP.ds_9_F/PARAM.trg_B); %number of times training occurs
    
    
%2. ALGO
    %data 
    ALGO.in_0_name          =   'genericPF';
    ALGO.DM2               	=   [];                                 %1. data 		:	design matrix, one observation per column  
    temp_I_0t1              =   double(INP.ds_8_I_HxWxF(:,:,1))/256; %0t1 means the image intensities are between 0 and 1       
    ALGO.mdl_1_mu_Dx1     	=   warpimg(temp_I_0t1, INP.ds_4_affineROI_1x6, PARAM.tgt_sz); %data mean
    clear temp_I_0t1; 
    
	
%3. structure #3: tracking, template for trkIPCA, trkBPCA, trkRVQ, trkTSVQ
	%feature points
    TRK.fp_1_gt   			=   cat(3, INP.gt_3_initial_fp + repmat(PARAM.tgt_sz'/2,[1,INP.gt_2_num_fp]), INP.gt_1_fp(:,:,1)); %1. ground truth
    TRK.fp_2_est      		=   zeros(size(INP.gt_1_fp));  			%1b. estimated
	TRK.fp_3_err  			=   zeros(1,INP.gt_2_num_fp);    	%1c. feature points: error
    TRK.fp_4_err_avg        =   zeros(1,INP.gt_2_num_fp);       %1d. feature points: average error
    
    TRK.tgt_best_affineROI_1x6 	=   INP.ds_4_affineROI_1x6; 
   
	TRK.trg_RMSE_Tx1 		=   zeros(PARAM.trg_T,1);                  %3.  training
	TRK.trg_RMSEavg_Tx1 	=   zeros(PARAM.trg_T,1);
	TRK.trg_SNRdB_Tx1 		=   zeros(PARAM.trg_T,1);

    TRK.tst_bestSnippet_0t1 =   ALGO.mdl_1_mu_Dx1;							%4.  testing
	TRK.tst_RMSE_Fx1 		=   zeros(INP.ds_9_F,1);
	TRK.tst_RMSEavg_Fx1 	=   zeros(INP.ds_9_F,1);
	TRK.tst_SNRdB_Fx1   	=   zeros(INP.ds_9_F,1);

%4. %timing   
    duration                =   0; 
    tic;



%>-----------------------------------------
%PRE-PROCESSING: bootstrapping
%>-----------------------------------------
%step 1. B frames of tracking (generic particle filter)
    for f = 1:PARAM.trg_B
        %strings
       
        %PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [PARAM.dir_out 'out_' PARAM.str_f '.png'];
        
        %input
        I_0t1               =   double(INP.ds_8_I_HxWxF(:,:,f))/256;
        
        %operation
        [ALGO TRK]          =   TRK_condensation(f, INP, PARAM, I_0t1, ALGO, TRK);		
    end	   

%step 2. save tracking structures	
	trkIPCA					=	TRK;
	trkBPCA					=	TRK;
	trkRVQ					=	TRK;
	trkTSVQ					=	TRK;

    
%step 2. save algorithm structures	
	IPCA 					=	ALGO;
    BPCA                   	=   ALGO;
    RVQ                   	=   ALGO;rmfield(RVQ, 'mdl_1_mu_Dx1');rmfield(RVQ, 'mdl_2_U_DxB');rmfield(RVQ, 'mdl_3_S_Bx1');
    TSVQ                   	=   ALGO;rmfield(TSVQ,'mdl_1_mu_Dx1');rmfield(TSVQ,'mdl_2_U_DxB');rmfield(TSVQ,'mdl_3_S_Bx1');

%step 3. extra stuff for algorithms
    %IPCA
    IPCA.in_0_name          =   'IPCA';
    IPCA.in_1_Q             =   PARAM.in_pca_Q;     
   
    %BPCA
    BPCA.in_0_name          =   'BPCA';
    BPCA.in_1_Q             =   PARAM.in_pca_Q;         rmfield(PARAM,'in_pca_Q'); %number of eigenvectors to retain  
     
    %RVQ
    RVQ.in_0_name           =   'RVQ';
    RVQ.in_1_maxP           =   PARAM.in_rvq_maxP;      rmfield(PARAM,'in_rvq_maxP');
    RVQ.in_2_M              =   PARAM.in_rvq_M;         rmfield(PARAM,'in_rvq_M');
    RVQ.in_3_targetSNR      =   PARAM.in_rvq_targetSNR; rmfield(PARAM,'in_rvq_targetSNR');
    RVQ.in_6_dir_out        =   PARAM.dir_out;
    RVQ.tst_6_partialP      =   -1;
    
    %TSVQ
    TSVQ.in_0_name          =   'TSVQ';
    TSVQ.in_1_maxP          =   PARAM.in_tsvq_P;       rmfield(PARAM,'in_tsvq_P');
    TSVQ.in_2_M             =   PARAM.in_tsvq_M;       rmfield(PARAM,'in_tsvq_M');
    
    
 
%step 5. 1 training
    PARAM.trg_frame_idxs           =   [PARAM.trg_frame_idxs, f];
    if (PARAM.in_bUseIPCA) IPCA  =   ipca_1_train  (IPCA.DM2(:,f-PARAM.trg_B+1:f),       IPCA);	 end		
    if (PARAM.in_bUseBPCA) BPCA  =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,  BPCA);  end
    if (PARAM.in_bUseRVQ)  RVQ   =   RVQ__training (RVQ.DM2_weighted  * max_signal_val,  RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' PARAM.str_f '.txt']); end
    if (PARAM.in_bUseTSVQ) TSVQ  =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,  TSVQ);  end  

    disp('initialization complete');
    
    %PARAM.minopt         =   optimset;  %pre-defined in Matlab for optimization functions
    %PARAM.minopt.MaxIter =   25; 
    %PARAM.minopt.Display =   'off';                            
%-----------------------------------------
%PROCESSING
%-----------------------------------------5
    duration=0;    
    for f = PARAM.trg_B+1 : INP.ds_9_F
        tic
        f
        PARAM.str_f        =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [PARAM.dir_out 'out_' PARAM.str_f '.png'];
        I_0t1               =   double(INP.ds_8_I_HxWxF(:,:,f))/256;
        
		%testing: condensation
		if (PARAM.in_bUseIPCA) trkIPCA = TRK_condensation(I_0t1, f, IPCA, GT, trkIPCA, PARAM, INP.rn_1_samples, INP.rn_2_cdf, 1); end %estwarp_grad    (I_0t1, IPCA, trkIPCA, PARAM);
		if (PARAM.in_bUseBPCA) trkBPCA = TRK_condensation(I_0t1, f, BPCA, GT, trkBPCA, PARAM, INP.rn_1_samples, INP.rn_2_cdf, 2); end
		if (PARAM.in_bUseRVQ)  trkRVQ  = TRK_condensation(I_0t1, f, RVQ,  GT, trkRVQ,  PARAM, INP.rn_1_samples, INP.rn_2_cdf, 3); end
		if (PARAM.in_bUseTSVQ) trkTSVQ = TRK_condensation(I_0t1, f, TSVQ, GT, trkTSVQ, PARAM, INP.rn_1_samples, INP.rn_2_cdf, 4); end
	
		%training (update model) every few frames
        if (mod(f,PARAM.trg_B)==0) %i.e.train every batchsize images
			PARAM.trg_frame_idxs = [PARAM.trg_frame_idxs, f];
			if (PARAM.in_bUseIPCA)	 [IPCA, trkIPCA] =   ipca_1_train  (IPCA.DM2, IPCA, trkIPCA, PARAM);	 IPCA.DM2 =   [];	end		
            if (PARAM.in_bUseBPCA)   BPCA           =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,   BPCA);   end
            if (PARAM.in_bUseRVQ)    RVQ            =   RVQ__training (RVQ.DM2_weighted * max_signal_val,   RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' PARAM.str_f '.txt']); end
            if (PARAM.in_bUseTSVQ)   TSVQ           =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,   TSVQ);   end  
        end
        
        TRK_draw_results(f, INP.ds_8_I_HxWxF, PARAM, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQ.FP_1_gt, trkTSVQ.FP_1_gt);
        TRK_save_allResults;
        %[f trkIPCA.FPerr_avg(f) RVQ.FPerr_avg(f) TSVQ.FPerr_avg(f)]
        toc
        duration            =   duration + toc;
        fprintf('This frame: %d sec, all frames: %f seconds, frame rate: %.2f\n',f, toc, duration, f/duration);
    end

%>-----------------------------------------
%POST-PROCESSING
%>-----------------------------------------







