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
%> I                        :   Input image scaled between 0 and 1
%> B                        :   training update interval
%>
%> abbreviations
%> -------------
%> FPT                      : 	feature points
%> GT, TRUTH                : 	Ground truth
%> DM2 						:	Data matrix, one observation per column.  If DM, then one observation per row.
%> structures
%> ----------
%> aIPCA, aBPCA, aRVQx, aTSVQ
%> trkMEAN, trkIPCA, trkBPCA, trkRVQx, trkTSVQ
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
pca__Q                      =   16;
rvq__maxQ                   =   8;
rvq__M                      =   2;
rvq__targetSNRdB            =   1000;
rvq__tstI                   =   1; %testing index, 4 options are, 1: maxQ, 2: RofE, 3: monE, 4: nulE 
tsvq_maxQ                   =   3;
tsvq_M                      =   2;
bUseIPCA                    =   1;
bUseBPCA                    =   1;   
bUseRVQx                    =   1;
bUseTSVQ                    =   1;
datasetCode                 =   1;

% %#######################################################################
% function main(   pca__Q,                                          ...
%                  rvq__maxQ, rvq__M, rvq__targetSNRdB, rvq__tstI   ...
%                  tsvq_maxQ, tsvq_M,                               ...
%                  bUseIPCA , bUseBPCA , bUseRVQx, bUseTSVQ,        ...
%                  datasetCode)

%>-----------------------------------------
%PRE-PROCESSING
%>-----------------------------------------
%1. PARAMETERS
    %variable parameters (from command line)
    PARAM.in_pca__Q         =   pca__Q;         %PCA: number of eigenvectors to retain for PCA
    
    PARAM.in_rvq__maxQ      =   rvq__maxQ;      %aRVQx: max stages
    PARAM.in_rvq__M         =   rvq__M;         %aRVQx: templates per stage
    PARAM.in_rvq__targetSNRdB=  rvq__targetSNRdB;%aRVQx: target SNR
    PARAM.in_rvq__tstR      =   RVQ__testing_rule_string(rvq__tstI); %convert test data's decoding rule from index to string
    
    PARAM.in_tsvq_maxQ      =   tsvq_maxQ;      %aTSVQ: max stages
    PARAM.in_tsvq_M         =   tsvq_M;         %aTSVQ: templates per stage, 2 for binary aTSVQ
    
    PARAM.in_bUseIPCA       =   bUseIPCA;       %flag    
    PARAM.in_bUseBPCA       =   bUseBPCA;       %flag
    PARAM.in_bUseRVQx       =   bUseRVQx;       %flag
    PARAM.in_bUseTSVQ       =   bUseTSVQ;       %flag
    
    PARAM.in_datasetCode    =   datasetCode;    %dataset code
      
    %fixed parameters  
    PARAM.DM2_bWeighting    =   false;              %data: weighting of input data points 
	
    PARAM.trg_Nw            =   10000;              %training: number of images (training window size)
    PARAM.trg_freq          =   5;                  %training: frequency
        
    PARAM.tgt_sw            =   33;                 %target: width
    PARAM.tgt_sh            =   33;                 %target: size
    PARAM.tgt_sz            =   [PARAM.tgt_sh PARAM.tgt_sw];  %combine two above
	PARAM.tgt_scale         =   32;                 %target: affine scaling, note 1 less than sw and sh which I had to increase by 1 for aRVQx

    PARAM.pf_Np             =   600;                %particle filter, number of particles
    PARAM.pf_errfunc        =   'L2';               %    "       "  , options: PPCA, robust, L2
    PARAM.pf_reseig         =   0;
    
	PARAM.plot_row2       	=   2;                  %plotting related
	PARAM.plot_row3   		=   3;                  %    "       "
	PARAM.plot_row4   		=   4;                  %    "       "
	PARAM.plot_num_rows  	=   5;                  %    "       "
	PARAM.plot_num_cols  	=   4;                  %    "       "
	PARAM.plot_title_fontsz =   8;                  %    "       "     fontsize,
	PARAM.plot_alpha        =   0.2;                %    "       "     transparency for target bounding regions
    
    PARAM.stats_T_sec       =   0;                  %stats: total running time in sec              

    
%2. INPUT
    [PARAM,I_HxWxF,GT,RAND] =   TRK_read_input(PARAM); 
    first_I                 =   double(I_HxWxF(:,:,1));     %read first image, 0t1 means the image intensities are between 0 and 1       
    [a b first_mean_shxsw]  =   UTIL_2D_affine_extractROI(first_I, UTIL_2D_affine_tsrpxy_to_Ha_2x3(PARAM.ds_7_tsrpxy_1x6), PARAM.tgt_sw, PARAM.tgt_sh);

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
    
    %aIPCA
    aIPCA.in_1__name        =   'aIPCA';
    aIPCA.in_6__sw__        =   PARAM.tgt_sw;
    aIPCA.in_7__sh__        =   PARAM.tgt_sh;
    aIPCA.in_Np             =   0;                      %would like to understand the role of this better
    aIPCA.in_ff             =   PARAM.ds_5_ff; 
    aIPCA.pf_reseig         =   PARAM.pf_reseig;        %would like to understand the role of this better
    aIPCA.mdl_1_Q__1x1      =   PARAM.in_pca__Q;        %number of eigenvectors to retain    
    aIPCA.mdl_2_mu_Dx1      =   first_mean_shxsw(:);
    aIPCA.mdl_3_U__DxP      =   [];
    aIPCA.mdl_4_S_Bx1       =   [];
    aIPCA.in____cnfg        =   BPCA_config_string(aIPCA.mdl_1_Q__1x1);
    
    %aBPCA
    aBPCA.in_1__name        =   'aBPCA';
    aBPCA.mdl_1_Q__1x1      =   PARAM.in_pca__Q;    
    aBPCA.in____cnfg        =   BPCA_config_string(aBPCA.mdl_1_Q__1x1);
     
    %RVQ template
    aRVQx.in_1__name        =   'aRVQx';    
    aRVQx.in_2__data        =   'tst';                      %default mode
    aRVQx.in_3__maxQ        =   PARAM.in_rvq__maxQ;         %max stages
    aRVQx.in_4__M___        =   PARAM.in_rvq__M;            %number of codevectors per stage
    aRVQx.in_5__tSNR        =   PARAM.in_rvq__targetSNRdB;  %targeted SNR for codebook generation
    aRVQx.in_6__sw__        =   PARAM.tgt_sw;               %snippet width
    aRVQx.in_7__sh__        =   PARAM.tgt_sh;               %snippet height
    aRVQx.in_8__odir        =   PARAM.odir;                 %output directory for files that RVQ produces
    aRVQx.in_9__trgD        =   'maxQ';                     %encoding stop rule for training vectors
    aRVQx.in_10_tstD        =   PARAM.in_rvq__tstR;
    aRVQx.in_11_lmbd        =   0;                          %lambda, acts like a lagrange multiplier
    aRVQx.in____cnfg        =   RVQ__config_string(aRVQx.in_3__maxQ, aRVQx.in_4__M___, aRVQx.in_5__tSNR, aRVQx.in_10_tstD);
    
    %aTSVQ
    aTSVQ.in_1__name        =   'aTSVQ';
    aTSVQ.in_3__maxQ        =   PARAM.in_tsvq_maxQ;
    aTSVQ.in_4__M___        =   PARAM.in_tsvq_M;
    aTSVQ.in____cnfg        =   TSVQ_config_string(aTSVQ.in_3__maxQ, aTSVQ.in_4__M___);

%5. TRACKER    
    trkMEAN.name            =   'trkMEAN';                          %learning algo only uses mean of data (simplest learning algo)    
    trkMEAN.DM2             =   [];                                 %1. all "best" snippets picked by tracker (one snippet per column)
    trkMEAN.numF     		=   1;                                  %number of frames the particle filter runs

%general
    %clean up clutter
    clear pca__Q 
    clear rvq__maxQ rvq__M rvq__targetSNRdB rvq__tstI 
    clear tsvq_maxQ tsvq_M 
    clear bUseIPCA bUseBPCA bUseRVQx bUseTSVQ 
    clear datasetCode
    clear a b first_I;
    clear first_mean_shxsw;

%>-----------------------------------------
%PRE-PROCESSING (bootstrapping)
%>-----------------------------------------
%1. run mean tracker for PARAM.trg_freq frames
    for f = 1:PARAM.trg_freq
        %starting stats
        tic
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        
        %input
        I                   =   double(I_HxWxF(:,:,f)); %input
        
        %tracking
        trkMEAN             =   TRK_condensation(f, I, GT, RAND, PARAM, aMEAN, trkMEAN); %frame num, image, ground truth, random data, parameters, learning algo, tracking structure
        
        %stats
        PARAM.stats_t_sec(f)=   toc;                                %time for this frame
        PARAM.stats_T_sec   =   PARAM.stats_T_sec + PARAM.stats_t_sec(f);       %total time for all frames
        PARAM.stats_fps     =   f/PARAM.stats_T_sec;                      %frames per sec
        str_rmse            =   sprintf('%4d  %3.2f %3.2f       %5.2f', f, PARAM.stats_t_sec(f), PARAM.stats_fps, trkMEAN.trk_2_rmse__Fx1(f));       
        str_armse           =   sprintf('%4d  %3.2f %3.2f       %5.2f', f, PARAM.stats_t_sec(f), PARAM.stats_fps, trkMEAN.trk_3_armse_Fx1(f))
        
        %save
                                fprintf(PARAM.log_fid, [str_rmse '\n']);    %write log file
                                
        %display
        if (ispc)
            imshow(uint8(I));
            hold on;
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkMEAN.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, PARAM.plot_alpha, 'y');
            hold off;
            title(str_rmse);
            drawnow;
            UTIL_FILE_save2png([PARAM.config_name '_' PARAM.str_f '.png'], gcf);
        end
    end	   

%step 2. initialize tracking for: learning based trackers (LBTs) based on mean tracker
	trkIPCA	=	trkMEAN;  trkIPCA.name = 'trkIPCA'; 
	trkBPCA	=	trkMEAN;  trkBPCA.name = 'trkBPCA'; 
	trkRVQx	=	trkMEAN;  trkRVQx.name = 'trkRVQx';
	trkTSVQ	=	trkMEAN;  trkTSVQ.name = 'trkTSVQ';
 
%step 3. initialize learning algorithms for: LBTs
    if (PARAM.in_bUseIPCA) aIPCA = IPCA_1_learn (trkIPCA.DM2(:,f-PARAM.trg_freq+1:f), aIPCA);  end		
    if (PARAM.in_bUseBPCA) aBPCA = PCA__1_learn (trkBPCA.DM2                        , aBPCA);  end
    if (PARAM.in_bUseRVQx) aRVQx = RVQ__1_learn (trkRVQx.DM2                        , aRVQx);  end
    if (PARAM.in_bUseTSVQ) aTSVQ = TSVQ_1_learn (trkTSVQ.DM2                        , aTSVQ);  end  

    disp('initialization complete');
    

%============================================
%PROCESSING
%============================================
%clear;clc;close all;load  

    for f = PARAM.trg_freq+1 : PARAM.ds_4_F
        %starting stats
        tic
        UTIL_dbloop
        PARAM.str_f         =   UTIL_GetZeroPrefixedFileNumber(f);
        
        %input
        I                   =   double(I_HxWxF(:,:,f));
        
		%testing: condensation
		if (PARAM.in_bUseIPCA) trkIPCA = TRK_condensation(f, I, GT, RAND, PARAM, aIPCA, trkIPCA); end %estwarp_grad(I, aIPCA, trkIPCA, PARAM);
		if (PARAM.in_bUseBPCA) trkBPCA = TRK_condensation(f, I, GT, RAND, PARAM, aBPCA, trkBPCA); end
		if (PARAM.in_bUseRVQx) trkRVQx = TRK_condensation(f, I, GT, RAND, PARAM, aRVQx, trkRVQx); end
		if (PARAM.in_bUseTSVQ) trkTSVQ = TRK_condensation(f, I, GT, RAND, PARAM, aTSVQ, trkTSVQ); end
	
		%training (update model) every PARAM.trg_freq frames
        if (mod(f,PARAM.trg_freq)==0)
			if (PARAM.in_bUseIPCA) aIPCA = IPCA_1_learn  (trkIPCA.DM2(:,f-PARAM.trg_freq+1:f), aIPCA);	end		
            if (PARAM.in_bUseBPCA) aBPCA = PCA__1_learn  (trkBPCA.DM2,                      aBPCA); end
            if (PARAM.in_bUseRVQx) aRVQx = RVQ__1_learn  (trkRVQx.DM2 ,                     aRVQx); end
            if (PARAM.in_bUseTSVQ) aTSVQ = TSVQ_1_learn  (trkTSVQ.DM2,                      aTSVQ); end  
        end
        
        %stats
        PARAM.stats_t_sec(f)=   toc;                                %time for this frame
        PARAM.stats_T_sec   =   PARAM.stats_T_sec + PARAM.stats_t_sec(f);       %total time for all frames
        PARAM.stats_fps     =   f/PARAM.stats_T_sec;                      %frames per sec
        str_rmse            =   sprintf('%4d  %3.2f %3.2f       %5.2f %5.2f %5.2f %5.2f', f, PARAM.stats_t_sec(f), PARAM.stats_fps, ...
                                trkIPCA.trk_2_rmse__Fx1(f), ...
                                trkBPCA.trk_2_rmse__Fx1(f), ...
                                trkRVQx.trk_2_rmse__Fx1(f), ...
                                trkTSVQ.trk_2_rmse__Fx1(f));
        str_armse           =   sprintf('%4d  %3.2f %3.2f       %5.2f %5.2f %5.2f %5.2f', f, PARAM.stats_t_sec(f), PARAM.stats_fps, ...
                                trkIPCA.trk_3_armse_Fx1(f), ...
                                trkBPCA.trk_3_armse_Fx1(f), ...
                                trkRVQx.trk_3_armse_Fx1(f), ...
                                trkTSVQ.trk_3_armse_Fx1(f))
        
        %save to file
                                fprintf(PARAM.log_fid, [str_rmse '\n']); 
                                UTIL_dbloop
        %display
        if (ispc)
            imshow(uint8(I));
            %colormap(gray)
            hold on;
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkIPCA.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'b');
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkBPCA.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'c');
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkTSVQ.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'g');
            UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkRVQx.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'r');
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
    %TRK_draw_results(f, I_HxWxF, PARAM, trkIPCA, trkBPCA, trkRVQx, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQx.FP_1_gt, trkTSVQ.FP_1_gt);
       