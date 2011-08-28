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
%> B                        :   training update interval
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
datasetCode=1;

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
%save passed parameters and clear them to reduce clutter
    CONFIG.in_Np            =   Np;  %number of particles
    CONFIG.in_Nw            =   Nw;  %number of images for training, (training window)
    CONFIG.in_bWeighting    =   bWeighting;
    CONFIG.in_pca_Q         =   pca_Q;
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
    clear Np Nw bWeighting pca_Q rvq_maxP rvq_M rvq_targetSNR tsvq_P tsvq_M bUseIPCA bUseBPCA bUseRVQ bUseTSVQ datasetCode
    
    [I_HxWxF, RandomData_sample, RandomData_cdf, CONFIG, IPCA, BPCA, RVQ, TSVQ, trkIPCA, trkBPCA, trkRVQ, trkTSVQ] ...
                            =   TRK_initialization(CONFIG);

%-----------------------------------------
%PROCESSING
%-----------------------------------------5
    duration=0;    
    for f = CONFIG.trg_B+1 : CONFIG.F
        tic
        f
        CONFIG.str_f        =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [CONFIG.dir_out 'out_' CONFIG.str_f '.png'];
        I_0t1               =   double(I_HxWxF(:,:,f))/256;
        
		%testing: condensation
		if (CONFIG.in_bUseIPCA) trkIPCA = TRK_condensation(I_0t1, f, IPCA, trkIPCA, CONFIG, RandomData_sample, RandomData_cdf, 1); end %estwarp_grad    (I_0t1, IPCA, trkIPCA, CONFIG);
		if (CONFIG.in_bUseBPCA) trkBPCA = TRK_condensation(I_0t1, f, BPCA, trkBPCA, CONFIG, RandomData_sample, RandomData_cdf, 2); end
		if (CONFIG.in_bUseRVQ)  trkRVQ 	= TRK_condensation(I_0t1, f, RVQ,  trkRVQ,  CONFIG, RandomData_sample, RandomData_cdf, 3); end
		if (CONFIG.in_bUseTSVQ) trkTSVQ = TRK_condensation(I_0t1, f, TSVQ, trkTSVQ, CONFIG, RandomData_sample, RandomData_cdf, 4); end
	
		%training (update model) every few frames
        if (mod(f,CONFIG.trg_B)==0) %i.e.train every batchsize images
			CONFIG.trg_frames = [CONFIG.trg_frames, f];
			if (CONFIG.in_bUseIPCA)	 [IPCA, trkIPCA] =   ipca_1_train  (IPCA.DM2, IPCA, trkIPCA, CONFIG);	 IPCA.DM2 =   [];	end		
            if (CONFIG.in_bUseBPCA)   BPCA           =   bpca_1_train  (BPCA.DM2_weighted * max_signal_val,   BPCA);   end
            if (CONFIG.in_bUseRVQ)    RVQ            =   RVQ__training (RVQ.DM2_weighted * max_signal_val,   RVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' CONFIG.str_f '.txt']); end
            if (CONFIG.in_bUseTSVQ)   TSVQ           =   tsvq_1_train  (TSVQ.DM2_weighted * max_signal_val,   TSVQ);   end  
        end
        
        TRK_draw_results(f, I_HxWxF, CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_gt, trkBPCA.FP_gt, trkRVQ.FP_gt, trkTSVQ.FP_gt);
        TRK_save_allResults;
        %[f trkIPCA.FPerr_avg(f) RVQ.FPerr_avg(f) TSVQ.FPerr_avg(f)]
        toc
        duration            =   duration + toc;
        fprintf('This frame: %d sec, all frames: %f seconds, frame rate: %.2f\n',f, toc, duration, f/duration);
    end

%>-----------------------------------------
%POST-PROCESSING
%>-----------------------------------------







