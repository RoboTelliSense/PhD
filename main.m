%> @file TRK_subspace.m
%> @brief Main function for subspace tracking
%>
%> Description of options
%> ----------------------
%> aff_abcdxy_1x6           :   [px, py, sx, sy, theta]; The location of the target in the first frame.
%> px, py                   :   Coordinates of the centre of the box.
%> sx, sy                   :   Size of the box in the x (width) and y (height) dimensions, before rotation.
%> theta                    :   Rotation angle of the box
%> Np                       :   Number of samples used in the condensation, I normally use 600.
%>                              Increasing this will likely improve the results, but make the tracker slower.
%> PF_normalizer            :   The standard deviation of the observation likelihood, e.g. 0.01
%> ff                       :   Forgetting factor, as described in the paper.  When doing the incremental update, 
%>                              1 means remember all past I_HxWxF, and 0 means remeber none of it.
%> batchsize                :   How often to update the eigenbasis.  We've used this value (update every 5th frame) 
%>                              fairly consistently, so it most likely won't need to be changed.  A smaller batchsize 
%>                              means more frequent updates, making it quicker to model changes in appearance, but also 
%>                              a little more prone to drift, and require more computation.
%> aff_tsrpxy_stddev_1x6    :   Standard deviations of the dynamics distribution, that is how much we expect the target
%>                              object might move from one frame to the next.  The meaning of each number is as follows:
%>                              aff_tsrpxy_stddev_1x6(1) = x translation (pixels, mean is 0)
%>                              aff_tsrpxy_stddev_1x6(2) = y translation (pixels, mean is 0)
%>                              aff_tsrpxy_stddev_1x6(3) = rotation angle (radians, mean is 0)
%>                              aff_tsrpxy_stddev_1x6(4) = x scaling (pixels, mean is 1)
%>                              aff_tsrpxy_stddev_1x6(5) = y scaling (pixels, mean is 1)
%>                              aff_tsrpxy_stddev_1x6(6) = scaling angle (radians, mean is 0)
%> sw, sh                   :   snippet width, height
%> tmplsize                 :   snippet size, the resolution at which the tracking window is sampled, in this case 
%>                              sw pixels by sh pixels.  If your initial window (given by aff_abcdxy_1x6) is very large you may need to increase this.
%> maxbasis                 :   The number of basis vectors to keep in the learned apperance model.
%> I_0t1                    :   Input image scaled between 0 and 1
%> B                        :   training update interval
%>
%> abbreviations
%> -------------
%> FPT                      : 	feature points
%> GT, TRUTH                : 	Ground truth
%> DM2 						:	Data matrix, one observation per column.  If DM, then one observation per row.
%> structures
%> ----------
%> aIPCA, aBPCA, aRVQ, aTSVQ
%> trkMEAN, trkIPCA, trkBPCA, trkRVQ, trkTSVQ
%>
%> dependencies
%> ------------
%> Dudek.mat, RandomData.mat, RVQ__training_gen8.exe
%> on Linux, make sure you do chmod +x RVQ__training_gen8.linux
%>
%> Copyright (c) Salman Aslam.  All rights reserved. (used parts of Jongwoo Lim and David Ross with permission)
%> Date created             :   around Feb, 2011
%> Date last modified       :   Sep 19, 2011


clear;
clc;
close all;
Np                          =   600;
Nw                          =   4;
bWeighting                  =   0;
pca_P                       =   16;
rvq_maxP                    =   8;
rvq_M                       =   2;
rvq_targetSNR               =   1000;
tsvq_P                      =   3;
tsvq_M                      =   2;
bUseIPCA                    =   1;
bUseBPCA                    =   1;   
bUseRVQ                     =   1;
bUseTSVQ                    =   1;
datasetCode                 =   1;

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
    PARAM.in_rvq_maxP       =   rvq_maxP;       %5. aRVQ: max stages
    PARAM.in_rvq_M          =   rvq_M;          %6. aRVQ: templates per stage
    PARAM.in_rvq_targetSNR  =   rvq_targetSNR;  %7. aRVQ: target SNR
    PARAM.in_tsvq_P         =   tsvq_P;         %8. aTSVQ: max stages
    PARAM.in_tsvq_M         =   tsvq_M;         %9. aTSVQ: templates per stage, 2 for binary aTSVQ
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
	PARAM.aff_scale         =   32;                 %target affine scaling, note 1 less than sw and sh which I had to increase by 1 for aRVQ
    PARAM.in_sw             =   33;
    PARAM.in_sh             =   33;    
    PARAM.tgt_sz            =   [PARAM.in_sh PARAM.in_sw];  %combine two above
	PARAM.trg_B             =   5;                  %training related, batch size for how many images to use for training
	PARAM.trg_frame_idxs    =   [];                 %"
	PARAM.plot_row2       	=   2;                  %plotting related
	PARAM.plot_row3   		=   3;                  %"
	PARAM.plot_row4   		=   4;                  %"
	PARAM.plot_num_rows  	=   5;                  %"
	PARAM.plot_num_cols  	=   4;                  %"
	PARAM.plot_title_fontsz =   8;                  %", fontsize

%2. INPUT
    [PARAM,I_HxWxF,GT,RAND] =   TRK_read_input(PARAM); 
    first_I_0t1             =   double(I_HxWxF(:,:,1));     %read first image, 0t1 means the image intensities are between 0 and 1       
    [a b first_mean_shxsw]  =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(first_I_0t1, UTIL_2D_affine_tsrpxy_to_Ha_2x3(PARAM.ds_7_tsrpxy_1x6), PARAM.in_sw, PARAM.in_sh);
    clear a b first_I_0t1;
    
    %back to PARAM based on input
    PARAM                   =   TRK_fileManagement(PARAM);  %filenames
    PARAM.trg_T             =	round(PARAM.ds_4_F/PARAM.trg_B); %number of times training occurs
    
%3. LEARNING ALGORITHMS
    %aMEAN
    aMEAN.in_1_name         =   'aMEAN';
    aMEAN.mdl_2_mu_Dx1      =   first_mean_shxsw(:); 
    clear a b;
   
    %aIPCA
    aIPCA.in_1_name         =   'aIPCA';
    aIPCA.in_6_sw__         =   PARAM.in_sw;
    aIPCA.in_7_sh__         =   PARAM.in_sh;
    aIPCA.in_Np             =   0;
    aIPCA.in_ff             =   PARAM.ds_5_ff;

    aIPCA.mdl_1_P__1x1      =   PARAM.in_pca_P;      %number of eigenvectors to retain    
    aIPCA.mdl_2_mu_Dx1      =   first_mean_shxsw(:);
    aIPCA.mdl_3_U__DxP      =   [];
    aIPCA.mdl_4_S_Bx1       =   [];

    clear first_mean_shxsw;
    
    %aBPCA
    aBPCA.in_1_name         =   'aBPCA';
    aBPCA.mdl_1_P__1x1      =   PARAM.in_pca_P;    
     
    %aRVQ
    aRVQ.in_1_name          =   'aRVQ';
    aRVQ.in_2_mode          =   'tst';
    aRVQ.in_3_maxP          =   PARAM.in_rvq_maxP;
    aRVQ.in_4_M___          =   PARAM.in_rvq_M;         
    aRVQ.in_5_tSNR          =   PARAM.in_rvq_targetSNR;
    aRVQ.in_6_sw__          =   PARAM.in_sw;            %snippet width
    aRVQ.in_7_sh__          =   PARAM.in_sh;
    aRVQ.in_8_odir          =   PARAM.dir_out;          %output directory
    aRVQ.in_9_trgrule       =   'maxP';
    aRVQ.in_10_tstrule      =   'monRMSE';               %rule to stop decoding in RVQ testing function
    aRVQ.in_11_lgrn         =   0;                    %acts like a lagrange multiplier

    %aTSVQ
    aTSVQ.in_1_name         =   'aTSVQ';
    aTSVQ.in_3_maxP         =   PARAM.in_tsvq_P;
    aTSVQ.in_4_M___         =   PARAM.in_tsvq_M;

%4. TRACKER    
    trkMEAN.name            =   'trkMEAN';                          %learning algo only uses mean of data (simplest learning algo)
    
    trkMEAN.DM2             =   [];                                 %1. all "best" snippets picked by tracker (one snippet per column)
    
    trkMEAN.PRF_1_tsrpxy_6xNp=  [];                                 %1. particle filter, state (affine parameters)
    trkMEAN.PRF_2_densty_Npx1=  [];                                 %2.    "        "  , density (weights)
    trkMEAN.PRF_3_numfr     =   1;                                  %3.    "        "  , number of frames 
    
    trkMEAN.fpt_1_truth_2xG =   [];                                 %1.
    trkMEAN.fpt_2_estim_2xG =   [];                                 %2.
	trkMEAN.fpt_3_error_2xG =   [];                                 %3.
        
%     trkMEAN.trk_1_SNRdB_Fx1 =   zeros(PARAM.ds_4_F,1);              %1.
%     trkMEAN.trk_2_rmse__Fx1 =   zeros(PARAM.ds_4_F,1);              %2.
% 	trkMEAN.trk_3_armse_Fx1 =   zeros(PARAM.ds_4_F,1);              %3.
%     
%     trkMEAN.trg_1_SNRdB_Fx1 =   zeros(PARAM.ds_4_F,1);              %1.
% 	trkMEAN.trg_2_rmse__Fx1 =   zeros(PARAM.ds_4_F,1);              %2.
% 	trkMEAN.trg_3_armse_Fx1 =   zeros(PARAM.ds_4_F,1);              %3.
% 
% 	trkMEAN.tst_1_SNRdB_Fx1 =   zeros(PARAM.ds_4_F,1);              %1.
% 	trkMEAN.tst_2_rmse__Fx1 =   zeros(PARAM.ds_4_F,1);              %2.
% 	trkMEAN.tst_3_armse_Fx1 =   zeros(PARAM.ds_4_F,1);              %3.

    
%4. %timing   
    duration                =   0; 
    tic;


%>-----------------------------------------
%PRE-PROCESSING: generic particle filter for B frames for bootstrapping
%>-----------------------------------------
%step 1.
    for f = 1:PARAM.trg_B
        f 
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [PARAM.dir_out 'out_' PARAM.str_f '.png'];
        I_0t1               =   double(I_HxWxF(:,:,f)); %input
        trkMEAN             =   TRK_condensation(f, I_0t1, GT, RAND, PARAM, aMEAN, trkMEAN); %frame num, image, ground truth, random data, parameters, learning algo, tracking structure
        trkMEAN.trk_2_rmse__Fx1(f)
    end	   

%step 2. save structures	
	trkIPCA					=	trkMEAN;  trkIPCA.name = 'trkIPCA';
	trkBPCA					=	trkMEAN;  trkBPCA.name = 'trkBPCA';
	trkRVQ					=	trkMEAN;  trkRVQ.name  = 'trkRVQ';
	trkTSVQ					=	trkMEAN;  trkTSVQ.name = 'trkTSVQ';
 
%step 5. 1 training
    PARAM.trg_frame_idxs          =   [PARAM.trg_frame_idxs, f];
    if (PARAM.in_bUseIPCA) aIPCA  =   IPCA_1_train  (trkIPCA.DM2(:,f-PARAM.trg_B+1:f), aIPCA);  end		
    if (PARAM.in_bUseBPCA) aBPCA  =   PCA__1_train  (trkBPCA.DM2                     , aBPCA);  end
    if (PARAM.in_bUseRVQ)  aRVQ   =   RVQ__1_train  (trkRVQ.DM2                      , aRVQ);   UTIL_copyFile([aRVQ.in_8_odir 'rvq__trg_verbose.txt'], [aRVQ.in_8_odir 'rvq__trg_verbose_' PARAM.str_f '.txt']); end
    if (PARAM.in_bUseTSVQ) aTSVQ  =   TSVQ_1_train  (trkTSVQ.DM2                     , aTSVQ);  end  

    disp('initialization complete');
    
%-----------------------------------------
%PROCESSING
%-----------------------------------------
% clear;
% clc;
% close all;
% load  

    duration=0;    
    for f = PARAM.trg_B+1 : PARAM.ds_4_F
        tic
        f
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid       =   [PARAM.dir_out 'out_' PARAM.str_f '.png'];
        I_0t1               =   double(I_HxWxF(:,:,f));
        
		%testing: condensation
		if (PARAM.in_bUseIPCA) trkIPCA = TRK_condensation(f, I_0t1, GT, RAND, PARAM, aIPCA, trkIPCA); end %estwarp_grad    (I_0t1, aIPCA, trkIPCA, PARAM);
		if (PARAM.in_bUseBPCA) trkBPCA = TRK_condensation(f, I_0t1, GT, RAND, PARAM, aBPCA, trkBPCA); end
		if (PARAM.in_bUseRVQ)  trkRVQ  = TRK_condensation(f, I_0t1, GT, RAND, PARAM, aRVQ , trkRVQ);  end
		if (PARAM.in_bUseTSVQ) trkTSVQ = TRK_condensation(f, I_0t1, GT, RAND, PARAM, aTSVQ, trkTSVQ); end
	
		%training (update model) every few frames
        if (mod(f,PARAM.trg_B)==0) %i.e.train every batchsize images
			PARAM.trg_frame_idxs = [PARAM.trg_frame_idxs, f];
			if (PARAM.in_bUseIPCA) aIPCA =   IPCA_1_train  (trkIPCA.DM2(:,f-PARAM.trg_B+1:f), aIPCA);	end		
            if (PARAM.in_bUseBPCA) aBPCA =   PCA__1_train  (trkBPCA.DM2,                      aBPCA);   end
            if (PARAM.in_bUseRVQ)  aRVQ  =   RVQ__1_train  (trkRVQ.DM2 ,                      aRVQ );   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' PARAM.str_f '.txt']); end
            if (PARAM.in_bUseTSVQ) aTSVQ =   TSVQ_1_train  (trkTSVQ.DM2,                      aTSVQ);   end  
        end
        [trkIPCA.trk_2_rmse__Fx1(f) trkBPCA.trk_2_rmse__Fx1(f) trkRVQ.trk_2_rmse__Fx1(f) trkTSVQ.trk_2_rmse__Fx1(f)]
        
        
        
        %TRK_draw_results(f, I_HxWxF, PARAM, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQ.FP_1_gt, trkTSVQ.FP_1_gt);
        %TRK_save_allResults;
        %[f trkIPCA.FPerr_avg(f) aRVQ.FPerr_avg(f) aTSVQ.FPerr_avg(f)]
        toc
        duration            =   duration + toc;
        %fprintf('This frame: %d sec, all frames: %f seconds, frame rate: %.2f\n',f, toc, duration, f/duration);
        
    end

%>-----------------------------------------
%POST-PROCESSING
%>-----------------------------------------







