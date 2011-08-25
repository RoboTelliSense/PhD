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
%>                              1 means remember all past I_HxWxF, and 0 means remeber none of it.
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
%>
%> abbreviations
%> -------------
%> FP_est 						: 	Feature points
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
pca_Neig=16;
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
%                         pca_Neig,                               ...
%                         rvq_maxP, rvq_M, rvq_targetSNR,         ...
%                         tsvq_P, tsvq_M,                         ...
%                         bUseIPCA , bUseBPCA , bUseRVQ, bUseTSVQ,  ...
%                         datasetCode)

%>-----------------------------------------
%INITIALIZATION
%>-----------------------------------------
%1. CONFIG and INPUT DATA
    %save passed parameters and clear them to reduce clutter
    CONFIG.in_Np            =   Np;  %number of particles
    CONFIG.in_Nw            =   Nw;  %number of images for training, (training window)
    CONFIG.in_bWeighting    =   bWeighting;
    CONFIG.in_pca_Neig      =   pca_Neig;
    CONFIG.in_maxbasis      =   pca_Neig;       %duplicate?
    CONFIG.in_rvq_maxP      =   rvq_maxP;
    CONFIG.in_rvq_M         =   rvq_M;
    CONFIG.in_rvq_targetSNR =   rvq_targetSNR;
    CONFIG.in_tsvq_P        =   tsvq_P;
    CONFIG.in_tsvq_M        =   tsvq_M;
    CONFIG.in_bUseIPCA      =   bUseIPCA;
    CONFIG.in_bUseBPCA      =   bUseBPCA;
    CONFIG.in_bUseRVQ       =   bUseRVQ;
    CONFIG.in_bUseTSVQ      =   bUseTSVQ;
    CONFIG.in_datasetCode   =   datasetCode;
    clear Np Nw bWeighting pca_Neig rvq_maxP rvq_M rvq_targetSNR tsvq_P tsvq_M bUseIPCA bUseBPCA bUseRVQ bUseTSVQ datasetCode
    CONFIG.con_errfunc      =   'L2';                       %condensation related              
    CONFIG.con_stddev       =   0.01;                       %"
	CONFIG.tgt_warped_sw_sh =   32;                         %target related
    CONFIG.tgt_affineROIvar_1x6=   [4,4,.02,.02,.005,.001]; %"                 check this
	CONFIG.trg_updateInterval=   5;                         %training related
	CONFIG.trg_frames      	=   [];                         %"
	CONFIG.plot_row2       	=   2;
	CONFIG.plot_row3   		=   3;
	CONFIG.plot_row4   		=   4;
	CONFIG.plot_num_rows  	=   5;
	CONFIG.plot_num_cols  	=   4;
	CONFIG.plot_title_fontsize=   8; %fontsize
    
    %load .mat file: (a) dataset images, (b) dataset parameters, (c) dataset ground truth
    [CONFIG, I_HxWxF, GT]  =   UTIL_DATASET_getName4(CONFIG);  %check since sw and sh are 33
     
    %random data for particle filter (pre-stored for repeatability)
	load RandomData 

    %directories and files    
    CONFIG                  =   TRK_fileManagement(CONFIG);
    
    %more parameters
    CONFIG.numFP            =   size(GT,2);                         %number of feature points
    CONFIG.aff0            	=   affparaminv(CONFIG.affineROI_1x6);
    CONFIG.pts0            	=   CONFIG.aff0([3,4,1;5,6,2]) * [GT(:,:,1); ones(1,CONFIG.numFP)];

%2. algorithm parameters          
    %read one image to understand sizes, etc.    
    I_0t1                   =   double(I_HxWxF(:,:,1))/256; %0t1 means the image intensities are between 0 and 1       
   
    %overall 
    ALGO.DM2               	=   [];     %1. design matrix, one observation per column
    ALGO.sw                	=   33;     %2. snippet (target) width 
    ALGO.sh                	=   33;     %3. snippet (target) height
    ALGO.sz                 =   [ALGO.sh ALGO.sw];  
    ALGO.max_signal_val     =   255;  
    ALGO.mean              	=   warpimg(I_0t1, CONFIG.affineROI_1x6, ALGO.sz);
    ALGO.basis             	=   [];
    ALGO.eigval            	=   [];
    ALGO.Np                	=   0;
    ALGO.reseig            	=   0;
	
%3. tracking
    TRK.FP_gt   			=   cat(3, CONFIG.pts0 + repmat(ALGO.sz'/2,[1,CONFIG.numFP]), GT(:,:,1)); %1a. feature points: ground truth
    TRK.FP_est      		=   zeros(size(GT));  	%1b. feature points: estimated
	TRK.FP_err  			=   zeros(1,CONFIG.numFP);          	%1c. feature points: error
    TRK.FP_err_avg 			=   zeros(1,CONFIG.numFP);          	%1d. feature points: average error
    
    TRK.tgt_best_affineROI_1x6 	=   CONFIG.affineROI_1x6;           %2.  check, used once only, bounding region: affine parameters
    
	TRK.trg_RMSE_Tx1 		=   zeros(CONFIG.T,1);                  %3.  training
	TRK.trg_RMSEavg_Tx1 	=   zeros(CONFIG.T,1);
	TRK.trg_SNRdB_Tx1 		=   zeros(CONFIG.T,1);

    TRK.tst_best_0t1    	=   ALGO.mean;							%4.  testing
	TRK.tst_RMSE_Fx1 		=   zeros(CONFIG.F,1);
	TRK.tst_RMSEavg_Fx1 	=   zeros(CONFIG.F,1);
	TRK.tst_SNRdB_Fx1   	=   zeros(CONFIG.F,1);

%4. %timing   
    duration                =   0; 
    tic;



%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%training phase
    for f = 1:CONFIG.trg_updateInterval
        f
        CONFIG.str_f        =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [dir_out 'out_' CONFIG.str_f '.png'];
        I_0t1               =   double(I_HxWxF(:,:,f))/256;
        TRK          	=   TRK_condensation(I_0t1, f, ALGO, TRK, CONFIG, RandomData_sample, RandomData_cdf, 1); %estwarp_grad    (I_0t1, ALGO, TRK, CONFIG);		
		ALGO.DM2        	=   [ALGO.DM2, TRK.tst_best_0t1(:)];
        TRK.tst_RMSE_Fx1(f) ...   	
							=	TRK.tst_rmse;
        TRK.tst_RMSEavg_Fx1(f) 	...
							=   UTIL_compute_avg(TRK.tst_RMSE_Fx1(1:f));

	end	   
	
%save algorithm structures	
	IPCA 					=	ALGO
    BPCA                   	=   ALGO;
    RVQ                   	=   ALGO;
    TSVQ                   	=   ALGO;
    
    %BPCA
    BPCA.Neig_1x1   		=   ALGO.in_pca_Neig;
    
    %RVQ
    RVQ.dir_out           	=   CONFIG.dir_out;
    RVQ.M                 	=   ALGO.in_rvq_M;
    RVQ.maxP              	=   ALGO.in_rvq_maxP;
    RVQ.targetSNR         	=   ALGO.in_rvq_targetSNR; 
    RVQ.tst_partialP      	=   -1;
    
    %TSVQ
    TSVQ.P                 	=   ALGO.in_tsvq_P;
    TSVQ.M                 	=   ALGO.in_tsvq_M;

%save tracking structures	
	trkIPCA					=	TRK;
	trkBPCA					=	TRK;
	trkRVQ					=	TRK;
	trkTSVQ					=	TRK;

%>-----------------------------------------
%PROCESSING
%>-----------------------------------------
        
    for f = CONFIG.trg_updateInterval+1:F
		%condensation
		if (CONFIG.in_bUseIPCA) trkIPCA 	=   TRK_condensation(I_0t1, f, IPCA,   trkIPCA, CONFIG, RandomData_sample, RandomData_cdf, 1); end %estwarp_grad    (I_0t1, IPCA, trkIPCA, CONFIG);
		if (CONFIG.in_bUseBPCA) trkBPCA 	=   TRK_condensation(I_0t1, f, BPCA,   trkBPCA, CONFIG, RandomData_sample, RandomData_cdf, 2); end
		if (CONFIG.in_bUseRVQ)  trkRVQ 	=   TRK_condensation(I_0t1, f, RVQ,   trkRVQ, CONFIG, RandomData_sample, RandomData_cdf, 3); end
		if (CONFIG.in_bUseTSVQ) trkTSVQ 	=   TRK_condensation(I_0t1, f, TSVQ,   trkTSVQ, CONFIG, RandomData_sample, RandomData_cdf, 4); end

		%update snippet library
		if (CONFIG.in_bUseBPCA)	IPCA.DM2=   [IPCA.DM2,  trkIPCA.tst_best_0t1(:)];  end
		if (CONFIG.in_bUseBPCA)  BPCA.DM2=   [BPCA.DM2   trkBPCA.tst_best_0t1(:)];  end         
		if (CONFIG.in_bUseRVQ)   RVQ.DM2 =   [RVQ.DM2    trkRVQ.tst_best_0t1(:)];  end
		if (CONFIG.in_bUseTSVQ)  TSVQ.DM2=   [TSVQ.DM2   trkTSVQ.tst_best_0t1(:)];  end
		
		%weight I_HxWxF
		if (CONFIG.in_bUseBPCA)	BPCA.DM2_weighted =   DATAMATRIX_pick_last_Nw_values_in_DM2(BPCA.DM2, Nw, bWeighting); end                                                                                                       
		if (CONFIG.in_bUseRVQ)   RVQ.DM2_weighted  =   DATAMATRIX_pick_last_Nw_values_in_DM2(RVQ.DM2, Nw, bWeighting); end
		if (CONFIG.in_bUseTSVQ)  TSVQ.DM2_weighted =   DATAMATRIX_pick_last_Nw_values_in_DM2(TSVQ.DM2, Nw, bWeighting); end

		%train (update model) every few frames
        if (mod(f,CONFIG.trg_updateInterval)==0) %i.e.train every batchsize images
			CONFIG.trg_frames = [CONFIG.trg_frames, f];
			if (CONFIG.in_bUseIPCA)	 [IPCA, trkIPCA] 	=   ipca_1_train  (IPCA.DM2, IPCA, trkIPCA, CONFIG);	 IPCA.DM2 =   [];	end		
            if (CONFIG.in_bUseBPCA)   BPCA               =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,   BPCA);   end
            if (CONFIG.in_bUseRVQ)    RVQ                =   RVQ__training (RVQ.DM2_weighted * max_signal_val,   RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' CONFIG.str_f '.txt']); end
            if (CONFIG.in_bUseTSVQ)   TSVQ               =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,   TSVQ);   end  
        end

%>-----------------------------------------
%POST-PROCESSING
%>-----------------------------------------
                                colormap('gray');
        duration            =   duration + toc;
                                TRK_draw_results(f, I_HxWxF, CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_gt, trkBPCA.FP_gt, trkRVQ.FP_gt, trkTSVQ.FP_gt);
                                TRK_save_allResults;
                                %[f trkIPCA.FPerr_avg(f) RVQ.FPerr_avg(f) TSVQ.FPerr_avg(f)]
                                tic;


    end

duration = duration + toc;
fprintf('%d frames took %>.3f seconds : %>.3fps\n',f,duration,f/duration);



    %CONFIG.minopt         =   optimset;  %pre-defined in Matlab for optimization functions
    %CONFIG.minopt.MaxIter =   25; 
    %CONFIG.minopt.Display =   'off';


