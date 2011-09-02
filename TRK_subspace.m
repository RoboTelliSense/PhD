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
%CONST 
    %save passed parameters and clear them to reduce clutter
    CONST.in_Np            =   Np;  %number of particles
    CONST.in_Nw            =   Nw;  %number of images for training, (training window)
    CONST.in_bWeighting    =   bWeighting;
    CONST.in_pca_Q         =   pca_Q;
    CONST.in_rvq_maxP      =   rvq_maxP;
    CONST.in_rvq_M         =   rvq_M;
    CONST.in_rvq_targetSNR =   rvq_targetSNR;
    CONST.in_tsvq_P        =   tsvq_P;
    CONST.in_tsvq_M        =   tsvq_M;
    CONST.in_bUseIPCA      =   bUseIPCA;
    CONST.in_bUseBPCA      =   bUseBPCA;
    CONST.in_bUseRVQ       =   bUseRVQ;
    CONST.in_bUseTSVQ      =   bUseTSVQ;
    INP.ds_1_code   =   datasetCode;
    clear Np Nw bWeighting pca_Q rvq_maxP rvq_M rvq_targetSNR tsvq_P tsvq_M bUseIPCA bUseBPCA bUseRVQ bUseTSVQ datasetCode
    
    [INP.ds_8_I_HxWxF, RandomData_sample, RandomData_cdf, CONST] =   TRK_set_constants_and_load_data(CONST);

%2. structure #2: ALGO (algorithm parameters), template for IPCA, BPCA, RVQ, TSVQ

    %data 
    ALGO.DM2               	=   [];     			%1. data 		:	design matrix, one observation per column  
	ALGO.sw                	=   33;     			%2. dimensions	: 	snippet (target) width 
    ALGO.sh                	=   33;     			%  					snippet (target) height
    ALGO.sz                 =   [ALGO.sh ALGO.sw];  % 					combine two above
    ALGO.max_signal_val     =   255;  				%3. amplitude	:	max
    temp_I_0t1              =   double(INP.ds_8_I_HxWxF(:,:,1))/256; %0t1 means the image intensities are between 0 and 1       
    ALGO.mdl_1_mu_Dx1     	=   warpimg(temp_I_0t1, INP.ds_4_affineROI_1x6, ALGO.sz); clear temp_I_0t1; %data mean
    
	%particle filter
	ALGO.Np                	=   0;
    ALGO.reseig            	=   0;
	
	
	
%3. structure #3: tracking, template for trkIPCA, trkBPCA, trkRVQ, trkTSVQ
	%feature points
    TRK.FP_1_gt   			=   cat(3, CONST.FP_gt_initial + repmat(ALGO.sz'/2,[1,CONST.FP_num]), FP_gt(:,:,1)); %1. ground truth
    TRK.FP_2_est      		=   zeros(size(FP_gt));  			%1b. estimated
	TRK.FP_3_err  			=   zeros(1,CONST.FP_num);    	%1c. feature points: error
    TRK.FP_err_avg 			=   zeros(1,CONST.FP_num);          	%1d. feature points: average error
    
    TRK.best_affineROI_1x6 	=   INP.ds_4_affineROI_1x6; rmfield(CONST,'affineROI_1x6');              %2.  bounding region: affine parameters
    
	TRK.trg_RMSE_Tx1 		=   zeros(CONST.const_T,1);                  %3.  training
	TRK.trg_RMSEavg_Tx1 	=   zeros(CONST.const_T,1);
	TRK.trg_SNRdB_Tx1 		=   zeros(CONST.const_T,1);

    TRK.tst_bestSnippet_0t1 =   ALGO.mdl_1_mu_Dx1;							%4.  testing
	TRK.tst_RMSE_Fx1 		=   zeros(CONST.const_F,1);
	TRK.tst_RMSEavg_Fx1 	=   zeros(CONST.const_F,1);
	TRK.tst_SNRdB_Fx1   	=   zeros(CONST.const_F,1);

%4. %timing   
    duration                =   0; 
    tic;



%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%training phase
    for f = 1:CONST.trg_B
        %strings
        f
        CONST.str_f        =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [CONST.dir_out 'out_' CONST.str_f '.png'];
        
        %input
        I_0t1               =   double(INP.ds_8_I_HxWxF(:,:,f))/256;
        
        %operation
        algo_code           =   0; %i.e. just distance from mean of data
        [ALGO TRK]          =   TRK_condensation(I_0t1, f, ALGO, FP_gt, TRK, CONST, RandomData_sample, RandomData_cdf, algo_code); %estwarp_grad    (I_0t1, ALGO, TRK, CONST);		
	end	   
	
    
%save algorithm structures	
	IPCA 					=	ALGO;
    BPCA                   	=   ALGO;rmfield(BPCA,'mdl_1_mu_Dx1');rmfield(BPCA,'mdl_2_U_DxB');rmfield(BPCA,'mdl_3_S_Bx1');
    RVQ                   	=   ALGO;rmfield(RVQ, 'mdl_1_mu_Dx1');rmfield(RVQ, 'mdl_2_U_DxB');rmfield(RVQ, 'mdl_3_S_Bx1');
    TSVQ                   	=   ALGO;rmfield(TSVQ,'mdl_1_mu_Dx1');rmfield(TSVQ,'mdl_2_U_DxB');rmfield(TSVQ,'mdl_3_S_Bx1');
    
    %IPCA
    IPCA.Q                  =   CONST.in_pca_Q;     
    IPCA.ff                 =   INP.ds_6_ff;              rmfield(CONST,'ds_3_ff');       %forgetting factor
    IPCA.code               =   1;
    
    %BPCA
    BPCA.in_1_Q                  =   CONST.in_pca_Q;        rmfield(CONST,'in_pca_Q'); %number of eigenvectors to retain  
    BPCA.code               =   2;
    
    %RVQ
    RVQ.in_6_dir_out           	=   CONST.dir_out;
    RVQ.in_2_M                 	=   CONST.in_rvq_M;         rmfield(CONST,'in_rvq_M');
    RVQ.in_1_maxP              	=   CONST.in_rvq_maxP;      rmfield(CONST,'in_rvq_maxP');
    RVQ.in_3_targetSNR         	=   CONST.in_rvq_targetSNR; rmfield(CONST,'in_rvq_targetSNR');
    RVQ.tst_6_partialP      	=   -1;
    RVQ.code                =   3;
    
    %TSVQ
    TSVQ.in_1_maxP                 	=   CONST.in_tsvq_P;       rmfield(CONST,'in_tsvq_P');
    TSVQ.in_2_M                 	=   CONST.in_tsvq_M;       rmfield(CONST,'in_tsvq_M');
    TSVQ.code               =   4;
    
%save tracking structures	
	trkIPCA					=	TRK;
	trkBPCA					=	TRK;
	trkRVQ					=	TRK;
	trkTSVQ					=	TRK;
 
%train once
    CONST.trg_frame_idxs           =   [CONST.trg_frame_idxs, f];
    if (CONST.in_bUseIPCA) IPCA  =   ipca_1_train  (IPCA.DM2,                            IPCA);	 IPCA.DM2 =   [];	end		
    if (CONST.in_bUseBPCA) BPCA  =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,  BPCA);  end
    if (CONST.in_bUseRVQ)  RVQ   =   RVQ__training (RVQ.DM2_weighted  * max_signal_val,  RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' CONST.str_f '.txt']); end
    if (CONST.in_bUseTSVQ) TSVQ  =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,  TSVQ);  end  

    disp('initialization complete');
    
    %CONST.minopt         =   optimset;  %pre-defined in Matlab for optimization functions
    %CONST.minopt.MaxIter =   25; 
    %CONST.minopt.Display =   'off';                            
%-----------------------------------------
%PROCESSING
%-----------------------------------------5
    duration=0;    
    for f = CONST.trg_B+1 : CONST.const_F
        tic
        f
        CONST.str_f        =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [CONST.dir_out 'out_' CONST.str_f '.png'];
        I_0t1               =   double(INP.ds_8_I_HxWxF(:,:,f))/256;
        
		%testing: condensation
		if (CONST.in_bUseIPCA) trkIPCA = TRK_condensation(I_0t1, f, IPCA, GT, trkIPCA, CONST, RandomData_sample, RandomData_cdf, 1); end %estwarp_grad    (I_0t1, IPCA, trkIPCA, CONST);
		if (CONST.in_bUseBPCA) trkBPCA = TRK_condensation(I_0t1, f, BPCA, GT, trkBPCA, CONST, RandomData_sample, RandomData_cdf, 2); end
		if (CONST.in_bUseRVQ)  trkRVQ 	= TRK_condensation(I_0t1, f, RVQ,  GT, trkRVQ,  CONST, RandomData_sample, RandomData_cdf, 3); end
		if (CONST.in_bUseTSVQ) trkTSVQ = TRK_condensation(I_0t1, f, TSVQ, GT, trkTSVQ, CONST, RandomData_sample, RandomData_cdf, 4); end
	
		%training (update model) every few frames
        if (mod(f,CONST.trg_B)==0) %i.e.train every batchsize images
			CONST.trg_frame_idxs = [CONST.trg_frame_idxs, f];
			if (CONST.in_bUseIPCA)	 [IPCA, trkIPCA] =   ipca_1_train  (IPCA.DM2, IPCA, trkIPCA, CONST);	 IPCA.DM2 =   [];	end		
            if (CONST.in_bUseBPCA)   BPCA           =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,   BPCA);   end
            if (CONST.in_bUseRVQ)    RVQ            =   RVQ__training (RVQ.DM2_weighted * max_signal_val,   RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' CONST.str_f '.txt']); end
            if (CONST.in_bUseTSVQ)   TSVQ           =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,   TSVQ);   end  
        end
        
        TRK_draw_results(f, INP.ds_8_I_HxWxF, CONST, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQ.FP_1_gt, trkTSVQ.FP_1_gt);
        TRK_save_allResults;
        %[f trkIPCA.FPerr_avg(f) RVQ.FPerr_avg(f) TSVQ.FPerr_avg(f)]
        toc
        duration            =   duration + toc;
        fprintf('This frame: %d sec, all frames: %f seconds, frame rate: %.2f\n',f, toc, duration, f/duration);
    end

%>-----------------------------------------
%POST-PROCESSING
%>-----------------------------------------







