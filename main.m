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
%> I                    :   Input image scaled between 0 and 1
%> B                        :   training update interval
%>
%> abbreviations
%> -------------
%> FPT                      : 	feature points
%> GT, TRUTH                : 	Ground truth
%> DM2 						:	Data matrix, one observation per column.  If DM, then one observation per row.
%> structures
%> ----------
%> aIPCA, aBPCA, a_RVQ, aTSVQ
%> trkMEAN, trkIPCA, trkBPCA, trk_RVQ, trkTSVQ
%>
%> dependencies
%> ------------
%> Dudek.mat, RandomData.mat, RVQ__training_gen8.exe
%> on Linux, make sure you do chmod +x RVQ__training_gen8.linux
%>
%> Copyright (c) Salman Aslam.  All rights reserved. (used parts of Jongwoo Lim and David Ross with permission)
%> Date created             :   around Feb, 2011
%> Date last modified       :   Sep 19, 2011


% clear;
% clc;
% close all;
% Np                          =   600;
% Nw                          =   4;
% bWeighting                  =   0;
% pca_P                       =   16;
% rvq_maxP                    =   8;
% rvq_M                       =   2;
% rvq_targetSNR               =   1000;
% tsvq_P                      =   3;
% tsvq_M                      =   2;
% bUseIPCA                    =   1;
% bUseBPCA                    =   1;   
% bUseRVQ                     =   1;
% bUseTSVQ                    =   1;
% datasetCode                 =   1;

%#######################################################################
function main(   pca_P,                                     ...
                 rvq_maxP, rvq_M, rvq_targetSNR,            ...
                 tsvq_P, tsvq_M,                            ...
                 bUseIPCA , bUseBPCA , bUseRVQ, bUseTSVQ,   ...
                 datasetCode)

%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%1. PARAMETERS
    %variable parameters (from command line)
    PARAM.in_pca_P          =   pca_P;          %4. PCA: number of eigenvectors to retain for PCA
    PARAM.in_rvq_maxP       =   rvq_maxP;       %5. a_RVQ: max stages
    PARAM.in_rvq_M          =   rvq_M;          %6. a_RVQ: templates per stage
    PARAM.in_rvq_targetSNR  =   rvq_targetSNR;  %7. a_RVQ: target SNR
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
    PARAM.in_Nw             =   10000;              %2. number of images for training, (training window)
    PARAM.in_bWeighting     =   false;              %3. weighting of input data points 

    PARAM.con_Np            =   600;                %condensation, number of particles
    PARAM.con_errfunc       =   'L2';               % 
    PARAM.con_reseig        =   0;
	PARAM.aff_scale         =   32;                 %target affine scaling, note 1 less than sw and sh which I had to increase by 1 for a_RVQ
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
	PARAM.plot_alpha        =   0.2;                %", transparency for target bounding regions
    
    PARAM.T_sec             =   0;                      %total running time in sec              

    
%2. INPUT
    [PARAM,I_HxWxF,GT,RAND] =   TRK_read_input(PARAM); 
    first_I                 =   double(I_HxWxF(:,:,1));     %read first image, 0t1 means the image intensities are between 0 and 1       
    [a b first_mean_shxsw]  =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(first_I, UTIL_2D_affine_tsrpxy_to_Ha_2x3(PARAM.ds_7_tsrpxy_1x6), PARAM.in_sw, PARAM.in_sh);
    clear a b first_I;

%3. strings, directories, files
    PARAM.config_name       =   UTIL_TRK_create_config_string(PARAM);   %in one string, describes the configuration of this experimental run
    PARAM.odir              =   UTIL_addSlash(PARAM.config_name);       %make directory name in case you want to store intermediate files (make from algo parameters, i.e., add slash)
    mkdir(PARAM.odir);                                                  %create directory
    
    PARAM.out_cfn           =   [PARAM.config_name '.txt'];             %make output filename, will be in current directory
    PARAM.log_fid           =   fopen(PARAM.out_cfn, 'w');              %create file
                                UTIL_FILE_checkFileOpen(PARAM.log_fid, PARAM.out_cfn);
    
    
%4. LEARNING ALGORITHMS
    %aMEAN
    aMEAN.in_1__name        =   'aMEAN';
    aMEAN.mdl_2_mu_Dx1      =   first_mean_shxsw(:); 
    clear a b;
   
    %aIPCA
    aIPCA.in_1__name        =   'aIPCA';
    aIPCA.in_6__sw__        =   PARAM.in_sw;
    aIPCA.in_7__sh__        =   PARAM.in_sh;
    aIPCA.in_Np             =   0;
    aIPCA.in_ff             =   PARAM.ds_5_ff; 
    aIPCA.con_reseig        =   PARAM.con_reseig;

    aIPCA.mdl_1_P__1x1      =   PARAM.in_pca_P;      %number of eigenvectors to retain    
    aIPCA.mdl_2_mu_Dx1      =   first_mean_shxsw(:);
    aIPCA.mdl_3_U__DxP      =   [];
    aIPCA.mdl_4_S_Bx1       =   [];

    clear first_mean_shxsw;
    
    %aBPCA
    aBPCA.in_1__name        =   'aBPCA';
    aBPCA.mdl_1_P__1x1      =   PARAM.in_pca_P;    
     
    %a_RVQ
    a_RVQ.in_1__name         =   'a_RVQ';
    a_RVQ.in_2__mode         =   'tst';
    a_RVQ.in_3__maxP         =   PARAM.in_rvq_maxP;
    a_RVQ.in_4__M___         =   PARAM.in_rvq_M;         
    a_RVQ.in_5__tSNR         =   PARAM.in_rvq_targetSNR;
    a_RVQ.in_6__sw__         =   PARAM.in_sw;                %snippet width
    a_RVQ.in_7__sh__         =   PARAM.in_sh;
    a_RVQ.in_8__odir         =   PARAM.odir;              %output directory
    a_RVQ.in_9__trgR         =   'maxP';
    a_RVQ.in_10_tstR         =   'maxP';                  %rule to stop decoding in RVQ testing function
    a_RVQ.in_11_lmbd     	=   0;                          %lambda, acts like a lagrange multiplier

    %aTSVQ
    aTSVQ.in_1__name         =   'aTSVQ';
    aTSVQ.in_3__maxP         =   PARAM.in_tsvq_P;
    aTSVQ.in_4__M___         =   PARAM.in_tsvq_M;

%5. TRACKER    
    trkMEAN.name            =   'trkMEAN';                          %learning algo only uses mean of data (simplest learning algo)    
    trkMEAN.DM2             =   [];                                 %1. all "best" snippets picked by tracker (one snippet per column)
    trkMEAN.numF     		=   1;                                  %number of frames the particle filter runs


%>-----------------------------------------
%PRE-PROCESSING (bootstrapping)
%>-----------------------------------------
%1. run mean tracker for PARAM.trg_B frames
    for f = 1:PARAM.trg_B
        %starting stats
        tic
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        
        %input
        I                   =   double(I_HxWxF(:,:,f)); %input
        
        %tracking
        trkMEAN             =   TRK_condensation(f, I, GT, RAND, PARAM, aMEAN, trkMEAN); %frame num, image, ground truth, random data, parameters, learning algo, tracking structure
        
        %stats
        PARAM.t_sec(f)      =   toc;                                %time for this frame
        PARAM.T_sec         =   PARAM.T_sec + PARAM.t_sec(f);       %total time for all frames
        PARAM.fps           =   f/PARAM.T_sec;                      %frames per sec
        str_rmse            =   sprintf('%4d  %3.2f %3.2f       %5.2f', f, PARAM.t_sec(f), PARAM.fps, trkMEAN.trk_2_rmse__Fx1(f));       
        str_armse           =   sprintf('%4d  %3.2f %3.2f       %5.2f', f, PARAM.t_sec(f), PARAM.fps, trkMEAN.trk_3_armse_Fx1(f))
        
        %save
                                fprintf(PARAM.log_fid, [str_rmse '\n']);    %write log file
                                
        %display
        if (ispc)
            imshow(uint8(I));
            hold on;
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkMEAN.snp_1_tsrpxy_1x6), PARAM.in_sh, PARAM.in_sw, PARAM.plot_alpha, 'y');
            hold off;
            title(str_rmse);
            drawnow;
            UTIL_FILE_save2png([PARAM.config_name '_' PARAM.str_f '.png'], gcf);
        end
    end	   

%step 2. initialize tracking for: learning based trackers (LBTs) based on mean tracker
	trkIPCA					=	trkMEAN;  trkIPCA.name = 'trkIPCA';
	trkBPCA					=	trkMEAN;  trkBPCA.name = 'trkBPCA';
	trk_RVQ					=	trkMEAN;  trk_RVQ.name = 'trk_RVQ';
	trkTSVQ					=	trkMEAN;  trkTSVQ.name = 'trkTSVQ';
 
%step 3. initialize learning algorithms for: LBTs
    if (PARAM.in_bUseIPCA) aIPCA  =   IPCA_1_train  (trkIPCA.DM2(:,f-PARAM.trg_B+1:f), aIPCA);  end		
    if (PARAM.in_bUseBPCA) aBPCA  =   PCA__1_train  (trkBPCA.DM2                     , aBPCA);  end
    if (PARAM.in_bUseRVQ)  a_RVQ  =   RVQ__1_train  (trk_RVQ.DM2                     , a_RVQ);   end
    if (PARAM.in_bUseTSVQ) aTSVQ  =   TSVQ_1_train  (trkTSVQ.DM2                     , aTSVQ);  end  

    disp('initialization complete');
    

%============================================
%PROCESSING
%============================================
%clear;clc;close all;load  

    for f = PARAM.trg_B+1 : PARAM.ds_4_F
        %starting stats
        tic
        UTIL_dbloop
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        
        %input
        I                   =   double(I_HxWxF(:,:,f));
        
		%testing: condensation
		if (PARAM.in_bUseIPCA) trkIPCA = TRK_condensation(f, I, GT, RAND, PARAM, aIPCA, trkIPCA); end %estwarp_grad(I, aIPCA, trkIPCA, PARAM);
		if (PARAM.in_bUseBPCA) trkBPCA = TRK_condensation(f, I, GT, RAND, PARAM, aBPCA, trkBPCA); end
		if (PARAM.in_bUseRVQ)  trk_RVQ = TRK_condensation(f, I, GT, RAND, PARAM, a_RVQ, trk_RVQ); end
		if (PARAM.in_bUseTSVQ) trkTSVQ = TRK_condensation(f, I, GT, RAND, PARAM, aTSVQ, trkTSVQ); end
	
		%training (update model) every PARAM.trg_B frames
        if (mod(f,PARAM.trg_B)==0)
			if (PARAM.in_bUseIPCA) aIPCA = IPCA_1_train  (trkIPCA.DM2(:,f-PARAM.trg_B+1:f), aIPCA);	end		
            if (PARAM.in_bUseBPCA) aBPCA = PCA__1_train  (trkBPCA.DM2,                      aBPCA); end
            if (PARAM.in_bUseRVQ)  a_RVQ = RVQ__1_train  (trk_RVQ.DM2 ,                     a_RVQ); end
            if (PARAM.in_bUseTSVQ) aTSVQ = TSVQ_1_train  (trkTSVQ.DM2,                      aTSVQ); end  
        end
        
        %stats
        PARAM.t_sec(f)      =   toc;                                %time for this frame
        PARAM.T_sec         =   PARAM.T_sec + PARAM.t_sec(f);       %total time for all frames
        PARAM.fps           =   f/PARAM.T_sec;                      %frames per sec
        str_rmse            =   sprintf('%4d  %3.2f %3.2f       %5.2f %5.2f %5.2f %5.2f', f, PARAM.t_sec(f), PARAM.fps, ...
                                trkIPCA.trk_2_rmse__Fx1(f), ...
                                trkBPCA.trk_2_rmse__Fx1(f), ...
                                trk_RVQ.trk_2_rmse__Fx1(f), ...
                                trkTSVQ.trk_2_rmse__Fx1(f));
        str_armse           =   sprintf('%4d  %3.2f %3.2f       %5.2f %5.2f %5.2f %5.2f', f, PARAM.t_sec(f), PARAM.fps, ...
                                trkIPCA.trk_3_armse_Fx1(f), ...
                                trkBPCA.trk_3_armse_Fx1(f), ...
                                trk_RVQ.trk_3_armse_Fx1(f), ...
                                trkTSVQ.trk_3_armse_Fx1(f))
        
        %save to file
                                fprintf(PARAM.log_fid, [str_rmse '\n']); 
                                UTIL_dbloop
        %display
        if (ispc)
            imshow(uint8(I));
            %colormap(gray)
            hold on;
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkIPCA.snp_1_tsrpxy_1x6), PARAM.in_sh, PARAM.in_sw, 0, 'b');
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkBPCA.snp_1_tsrpxy_1x6), PARAM.in_sh, PARAM.in_sw, 0, 'c');
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkTSVQ.snp_1_tsrpxy_1x6), PARAM.in_sh, PARAM.in_sw, 0, 'g');
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trk_RVQ.snp_1_tsrpxy_1x6), PARAM.in_sh, PARAM.in_sw, 0, 'r');
            title(str_rmse);
            drawnow
            hold off;
            UTIL_FILE_save2png([PARAM.config_name '_' PARAM.str_f '.png'], gcf);
        end
    end

%>-----------------------------------------
%POST-PROCESSING
%>-----------------------------------------
    fclose(PARAM.log_fid);
    %TRK_draw_results(f, I_HxWxF, PARAM, trkIPCA, trkBPCA, trk_RVQ, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trk_RVQ.FP_1_gt, trkTSVQ.FP_1_gt);
       