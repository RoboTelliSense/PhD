%> @file TRK_subspace.m
%> @brief Main function for subspace tracking
%>
%> Description of options
%> ----------------------
%> affine2_1x6            :   [px, py, sx, sy, theta]; The location of the target in the first frame.
%> px, py                   :   Coordinates of the centre of the box.
%> sx, sy                   :   Size of the box in the x (width) and y (height) dimensions, before rotation.
%> theta                    :   Rotation angle of the box
%> Np                       :   Number of samples used in the condensation, I normally use 600.
%>                              Increasing this will likely improve the results, but make the tracker slower.
%> con_normalizer               :   The standard deviation of the observation likelihood, e.g. 0.01
%> ff                       :   Forgetting factor, as described in the paper.  When doing the incremental update, 
%>                              1 means remember all past INP.ds_8_I_HxWxF, and 0 means remeber none of it.
%> batchsize                :   How often to update the eigenbasis.  We've used this value (update every 5th frame) 
%>                              fairly consistently, so it most likely won't need to be changed.  A smaller batchsize 
%>                              means more frequent updates, making it quicker to model changes in appearance, but also 
%>                              a little more prone to drift, and require more computation.
%> affROIvar_1x6     	:   Standard deviations of the dynamics distribution, that is how much we expect the target
%>                              object might move from one frame to the next.  The meaning of each number is as follows:
%>                              affROIvar_1x6(1) = x translation (pixels, mean is 0)
%>                              affROIvar_1x6(2) = y translation (pixels, mean is 0)
%>                              affROIvar_1x6(3) = rotation angle (radians, mean is 0)
%>                              affROIvar_1x6(4) = x scaling (pixels, mean is 1)
%>                              affROIvar_1x6(5) = y scaling (pixels, mean is 1)
%>                              affROIvar_1x6(6) = scaling angle (radians, mean is 0)
%> sw, sh                   :   snippet width, height
%> tmplsize                 :   snippet size, the resolution at which the tracking window is sampled, in this case 
%>                              sw pixels by sh pixels.  If your initial window (given by affine2_1x6) is very large you may need to increase this.
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
pca_P=16;
rvq_maxP=8;
rvq_M=2;
rvq_targetSNR=1000;
tsvq_P=3;
tsvq_M=2;
bUseIPCA=1;
bUseBPCA=1;   
bUseRVQ=1;
bUseTSVQ=1;
datasetCode=1;

%#######################################################################
% function TRK_subspace(  Np, Nw, bWeighting,                     ...
%                         pca_P,                               ...
%                         rvq_maxP, rvq_M, rvq_targetSNR,         ...
%                         tsvq_P, tsvq_M,                         ...
%                         bUseIPCA , bUseBPCA , bUseRVQ, bUseTSVQ,  ...
%                         datasetCode)

%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%1. PARAMETERS
    %variable parameters (from command line)
    PARAM.in_Np             =   Np;             %1. number of particles
    PARAM.in_Nw             =   Nw;             %2. number of images for training, (training window)
    PARAM.in_bWeighting     =   bWeighting;     %3. weighting of input data points 
    PARAM.in_pca_P          =   pca_P;          %4. PCA: number of eigenvectors to retain for PCA
    PARAM.in_rvq_maxP       =   rvq_maxP;       %5. RVQ: max stages
    PARAM.in_rvq_M          =   rvq_M;          %6. RVQ: templates per stage
    PARAM.in_rvq_targetSNR  =   rvq_targetSNR;  %7. RVQ: target SNR
    PARAM.in_tsvq_P         =   tsvq_P;         %8. TSVQ: max stages
    PARAM.in_tsvq_M         =   tsvq_M;         %9. TSVQ: templates per stage, 2 for binary TSVQ
    PARAM.in_bUseIPCA       =   bUseIPCA;       %10. flag    
    PARAM.in_bUseBPCA       =   bUseBPCA;       %11. flag
    PARAM.in_bUseRVQ        =   bUseRVQ;        %12. flag
    PARAM.in_bUseTSVQ       =   bUseTSVQ;       %13. flag
    PARAM.in_datasetCode    =   datasetCode;    %14. dataset code
  
    %clear all 14 parameters passed in to reduce clutter
    clear Np Nw bWeighting pca_P rvq_maxP rvq_M rvq_targetSNR tsvq_P tsvq_M bUseIPCA bUseBPCA bUseRVQ bUseTSVQ datasetCode    
    
    %fixed parameters    
    PARAM.con_errfunc       =   'L2';               %condensation related              
    PARAM.con_reseig        =   0;
	PARAM.tgt_warped_sw_sh  =   32;                 %target related, note 1 less than sw and sh which I had to increase by 1 for RVQ
    PARAM.in_sw            =   33;
    PARAM.in_sh            =   33;    
    PARAM.tgt_sz            =   [PARAM.in_sh PARAM.in_sw];  %combine two above
    PARAM.tgt_max_signal_val=   255;
	PARAM.trg_B             =   5;                  %training related, batch size for how many images to use for training
	PARAM.trg_frame_idxs    =   [];                 %"
	PARAM.plot_row2       	=   2;                  %plotting related
	PARAM.plot_row3   		=   3;                  %"
	PARAM.plot_row4   		=   4;                  %"
	PARAM.plot_num_rows  	=   5;                  %"
	PARAM.plot_num_cols  	=   4;                  %"
	PARAM.plot_title_fontsz =   8;                  %", fontsize

%2. INPUT
    INP                     =   TRK_read_input(PARAM.in_datasetCode, PARAM.tgt_warped_sw_sh); 
    first_I_0t1             =   double(INP.ds_8_I_HxWxF(:,:,1))/256; %read first image, 0t1 means the image intensities are between 0 and 1       

    %back to PARAM based on input
    PARAM                   =   TRK_fileManagement(PARAM, INP);  %filenames
    PARAM.trg_T             =	round(INP.ds_9_F/PARAM.trg_B); %number of times training occurs
    
%3. LEARNING ALGORITHMS
    %NONE
    NONE.in_1_name          =   'NONE';
    NONE.trg_4_SNRdB_1x1    =   0;  
    NONE.trg_5_rmse__1x1    =   0; 
    NONE.tst_4_SNRdB_1x1    =   0;  
    NONE.tst_5_rmse__1x1    =   0; 

    %IPCA
    IPCA.in_1_name          =   'IPCA';
    IPCA.in_2_mode          =   'tst';
    IPCA.mdl_1_P__1x1       =   PARAM.in_pca_P;      %number of eigenvectors to retain    
   
    %BPCA
    BPCA.in_1_name          =   'BPCA';
    BPCA.in_2_mode          =   'tst';
    BPCA.mdl_1_P__1x1       =   PARAM.in_pca_P;    
     
    %RVQ
    RVQ.in_1_name           =   'RVQ';
    RVQ.in_2_mode           =   'tst';
    RVQ.in_3_maxP           =   PARAM.in_rvq_maxP;
    RVQ.in_4_M              =   PARAM.in_rvq_M;         
    RVQ.in_5_targetSNR      =   PARAM.in_rvq_targetSNR;
    RVQ.in_6_sw             =   PARAM.in_sw;
    RVQ.in_7_sh             =   PARAM.in_sh;
    RVQ.in_8_dir_out        =   PARAM.dir_out;
    RVQ.in_9_rule_stop_decoding =   'monSNR';
    RVQ.in_10_lambda        =   0.5;

    %TSVQ
    TSVQ.in_1_name          =   'TSVQ';
    TSVQ.in_2_mode          =   'tst';
    TSVQ.in_3_maxP          =   PARAM.in_tsvq_P;
    TSVQ.in_4_M             =   PARAM.in_tsvq_M;

%4. TRACKERS    
    %generic particle filter
    trkPF.name              =   'genericPF';                        %generic particle filter    
    
    trkPF.state_1_DM2       =   [];                                 %1. data:	design matrix, one observation per column 
    trkPF.state_2_mu_Dx1    =   UTIL_2D_warp_image(first_I_0t1, INP.ds_4_affine2_1x6, PARAM.tgt_sz); %data mean
    trkPF.state_3_weights   =   [];
    trkPF.state_4_best_affine2_1x6=   INP.ds_4_affine2_1x6; 
    
    trkPF.fp_1_gt           =   cat(3, INP.gt_3_initial_fp + repmat(PARAM.tgt_sz'/2,[1,INP.gt_2_num_fp]), INP.gt_1_fp(:,:,1)); %1. ground truth
    trkPF.fp_2_est          =   zeros(size(INP.gt_1_fp));  			%1b. estimated
	trkPF.fp_3_err          =   zeros(1,INP.gt_2_num_fp);           %1c. feature points: error
    trkPF.fp_4_err_avg      =   zeros(1,INP.gt_2_num_fp);           %1d. feature points: average error
     
	trkPF.trg_rmse__Tx1     =   zeros(PARAM.trg_T,1);               %3.  training
	trkPF.trg_armse_Tx1 	=   zeros(PARAM.trg_T,1);
	trkPF.trg_SNRdB_Tx1     =   zeros(PARAM.trg_T,1);
    
	trkPF.trk_rmse__Fx1     =   zeros(INP.ds_9_F,1);
	trkPF.trk_armse_Fx1 	=   zeros(INP.ds_9_F,1);
    
	trkPF.tst_SNRdB_Fx1   	=   zeros(INP.ds_9_F,1);

    trkPF.bestCandidate_0t1_shxsw =   trkPF.state_2_mu_Dx1;							%4.  testing
    
%4. %timing   
    duration                =   0; 
    tic;


    clear first_I_0t1; 

%>-----------------------------------------
%PRE-PROCESSING: generic particle filter for B frames for bootstrapping
%>-----------------------------------------
%step 1.
    for f = 1:PARAM.trg_B
        %strings  
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [PARAM.dir_out 'out_' PARAM.str_f '.png'];
        I_0t1               =   double(INP.ds_8_I_HxWxF(:,:,f))/256; %input
        trkPF               =   TRK_condensation(f, INP, PARAM, I_0t1, NONE, trkPF);		
    end	   

%step 2. save structures	
	trkIPCA					=	trkPF;  trkIPCA.name = 'trkIPCA';
	trkBPCA					=	trkPF;  trkBPCA.name = 'trkBPCA';
	trkRVQ					=	trkPF;  trkRVQ.name  = 'trkRVQ';
	trkTSVQ					=	trkPF;  trkTSVQ.name = 'trkTSVQ';
    
 
%step 5. 1 training
    PARAM.trg_frame_idxs         =   [PARAM.trg_frame_idxs, f];
    if (PARAM.in_bUseIPCA) IPCA  =   ipca_1_train  (IPCA.DM2(:,f-PARAM.trg_B+1:f),       IPCA);	 end		
    if (PARAM.in_bUseBPCA) BPCA  =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,  BPCA);  end
    if (PARAM.in_bUseRVQ)  RVQ   =   RVQ__training (RVQ.DM2_weighted  * max_signal_val,  RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' PARAM.str_f '.txt']); end
    if (PARAM.in_bUseTSVQ) TSVQ  =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,  TSVQ);  end  

    disp('initialization complete');
    
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
		if (PARAM.in_bUseIPCA) trkIPCA = TRK_condensation(I_0t1, f, IPCA, GT, trkIPCA, PARAM, INP.rand_unitvar_maxFx6xNp, INP.rand_cdf_maxFxNp, 1); end %estwarp_grad    (I_0t1, IPCA, trkIPCA, PARAM);
		if (PARAM.in_bUseBPCA) trkBPCA = TRK_condensation(I_0t1, f, BPCA, GT, trkBPCA, PARAM, INP.rand_unitvar_maxFx6xNp, INP.rand_cdf_maxFxNp, 2); end
		if (PARAM.in_bUseRVQ)  trkRVQ  = TRK_condensation(I_0t1, f, RVQ,  GT, trkRVQ,  PARAM, INP.rand_unitvar_maxFx6xNp, INP.rand_cdf_maxFxNp, 3); end
		if (PARAM.in_bUseTSVQ) trkTSVQ = TRK_condensation(I_0t1, f, TSVQ, GT, trkTSVQ, PARAM, INP.rand_unitvar_maxFx6xNp, INP.rand_cdf_maxFxNp, 4); end
	
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







