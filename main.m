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
pca__Q                      =   16;
rvq__maxQ                   =   8;
rvq__M                      =   2;
rvq__targetSNRdB            =   1000;
rvq__tstI                   =   3; %testing index, 4 options are, 1: maxQ, 2: RofE, 3: nulE , 4: monE
tsvq_maxQ                   =   3;
tsvq_M                      =   2;
bUseIPCA                    =   1;
bUseBPCA                    =   1;   
bUseRVQx                    =   1;
bUseTSVQ                    =   1;
ds_code                     =   1;

%#######################################################################
% function main(   pca__Q,                                          ...
%                  rvq__maxQ, rvq__M, rvq__targetSNRdB, rvq__tstI,  ...
%                  tsvq_maxQ, tsvq_M,                               ...
%                  PARAM.in_bUseIPCA , PARAM.in_bUseBPCA , PARAM.in_bUseRVQx, PARAM.in_bUseTSVQ,        ...
%                  ds_code)

%-----------------------------------------
%INITIALIZATION
%-----------------------------------------
%1. PARAMETERS    
    PARAM.ds_1_code         =   ds_code;
    PARAM.in_bUseIPCA       =   bUseIPCA;
    PARAM.in_bUseBPCA       =   bUseBPCA;   
    PARAM.in_bUseRVQx       =   bUseRVQx;
    PARAM.in_bUseTSVQ       =   bUseTSVQ;
    PARAM.DM2_bWeighting    =   false;              %data: weighting of input data points 
    PARAM.trg_Nw            =   10000;              %training: number of images (training window size)
    PARAM.trg_freq          =   5;                  %training: frequency
    PARAM.tgt_scale         =   32;                 %target: affine scaling, note 1 less than sw and sh which I had to increase by 1 for aRVQx
    PARAM.tgt_sw            =   33;                 %target: width
    PARAM.tgt_sh            =   33;                 %target: size
    PARAM.tgt_sz            =   [PARAM.tgt_sh PARAM.tgt_sw];  %combine two above	
    PARAM.pf_Np             =   600;                %particle filter, number of particles
    PARAM.pf_errfunc        =   'L2';               %    "       "  , options: PPCA, robust, L2
    PARAM.pf_reseig         =   0;    
	PARAM.plot_row2       	=   2;                  %plotting related
	PARAM.plot_row3   		=   3;                  %    "       "
	PARAM.plot_row4   		=   4;                  %    "       "
	PARAM.plot_num_rows  	=   5;                  %    "       "
	PARAM.plot_num_cols  	=   4;                  %    "       "
	PARAM.plot_title_fontsz =   8;                  %    "       "     fontsize,
	colormap(gray)
                   
    


%-----------------------------------------
%PRE-PROCESSING (run mean tracker for a few frames
%-----------------------------------------
%1. READ IMAGES
    [PARAM,I_HxWxF,GT,RAND] =   TRK_read_input(PARAM);  
    firstI                  =   double(I_HxWxF(:,:,1));  %initialize first target for bootstrapping
    [a b first_mean_shxsw]  =   UTIL_2D_affine_extractROI_using_Ha_2x3(firstI, UTIL_2D_affine_tsrpxy_to_Ha_2x3(PARAM.ds_7_tsrpxy_1x6), PARAM.tgt_sw, PARAM.tgt_sh);
    
%2. CONFIGURE TRACKER
    [aMEAN, trkMEAN]        =   MEAN_config(PARAM, first_mean_shxsw); %give it first image

%3. run for few frames
    for f = 1:PARAM.trg_freq
        I                   =   double(I_HxWxF(:,:,f)); %input
        trkMEAN             =   TRK_condensation(f, I, GT, RAND, PARAM, aMEAN, trkMEAN); %%tracking: frame num, image, ground truth, random data, parameters, learning algo, tracking structure                          

        %display
        str_console         =   num2str(f);
        str_plot            =   num2str(f);
        str_plot            =   [str_plot     ' ' num2str(trkMEAN.trk_2_rmse__Fx1(f))];
        str_console         =   [str_console  ' ' num2str(trkMEAN.trk_3_armse_Fx1(f))]
        
        %4. plot
        imagesc(uint8(I));
        hold on;
        UTIL_PLOT_display(f, GT.fpt_1_truth_2xGxF(:,:,f), trkMEAN.fpt_2_estim_2xG, trkMEAN.snp_1_tsrpxy_1x6, PARAM.tgt_sh, PARAM.tgt_sw, 'k');
        title(str_plot); 
        hold off;   
        drawnow
    end	   

%============================================
%PROCESSING
%============================================

%1. configure learning algos
    if (PARAM.in_bUseIPCA) [aIPCA, trkIPCA]=  IPCA_config     (PARAM, trkMEAN, pca__Q, first_mean_shxsw);    end
    if (PARAM.in_bUseBPCA) [aBPCA, trkBPCA]=  BPCA_config     (PARAM, trkMEAN, pca__Q);                      end
    if (PARAM.in_bUseRVQx) [aRVQx, trkRVQx]=  RVQx_config     (PARAM, trkMEAN, rvq__maxQ, rvq__M, rvq__targetSNRdB, rvq__tstI); end
    if (PARAM.in_bUseTSVQ) [aTSVQ, trkTSVQ]=  TSVQ_config     (PARAM, trkMEAN, tsvq_maxQ, tsvq_M);           end
      
    %clean up clutter
    clear bUseIPCA bUseBPCA bUseRVQx bUseTSVQ
    clear pca__Q 
    clear rvq__maxQ rvq__M rvq__targetSNRdB rvq__tstI 
    clear tsvq_maxQ tsvq_M 
    clear ds_code
    clear a b firstI first_mean_shxsw

    
%2. run learning algorithms once
    if (PARAM.in_bUseIPCA) aIPCA     =   IPCA_1_learn    (trkIPCA.DM2(:,f-PARAM.trg_freq+1:f), aIPCA);  end		
    if (PARAM.in_bUseBPCA) aBPCA     =   PCA__1_learn    (trkBPCA.DM2                        , aBPCA);  end
    if (PARAM.in_bUseRVQx) aRVQx     =   RVQ__1_learn    (trkRVQx.DM2                        , aRVQx);  end
    if (PARAM.in_bUseTSVQ) aTSVQ     =   TSVQ_1_learn    (trkTSVQ.DM2                        , aTSVQ);  end  

    disp('initialization complete');
    

%============================================
%PROCESSING
%============================================
for f = PARAM.trg_freq+1 : PARAM.ds_4_F
    %1. input
    I                       =   double(I_HxWxF(:,:,f));

    %2. tracking (condensation)
    if (PARAM.in_bUseIPCA) trkIPCA   =   TRK_condensation(f, I, GT, RAND, PARAM, aIPCA, trkIPCA); end %estwarp_grad(I, aIPCA, trkIPCA, PARAM);
    if (PARAM.in_bUseBPCA) trkBPCA   =   TRK_condensation(f, I, GT, RAND, PARAM, aBPCA, trkBPCA); end
    if (PARAM.in_bUseRVQx) trkRVQx   =   TRK_condensation(f, I, GT, RAND, PARAM, aRVQx, trkRVQx); end
    if (PARAM.in_bUseTSVQ) trkTSVQ   =   TRK_condensation(f, I, GT, RAND, PARAM, aTSVQ, trkTSVQ); end

    %3. training (update model) 
    if (mod(f,PARAM.trg_freq)==0)                                               %every PARAM.trg_freq frames
        if (PARAM.in_bUseIPCA) aIPCA = IPCA_1_learn  (trkIPCA.DM2(:,f-PARAM.trg_freq+1:f), aIPCA); end		
        if (PARAM.in_bUseBPCA) aBPCA = PCA__1_learn  (trkBPCA.DM2,                         aBPCA); end
        if (PARAM.in_bUseRVQx) aRVQx = RVQ__1_learn  (trkRVQx.DM2 ,                        aRVQx); end
        if (PARAM.in_bUseTSVQ) aTSVQ = TSVQ_1_learn  (trkTSVQ.DM2,                         aTSVQ); end  
    end

    %5. strings
    str_console = num2str(f);
    str_plot    = num2str(f);
    if (PARAM.in_bUseIPCA) str_plot = [str_plot ' ' num2str(trkIPCA.trk_2_rmse__Fx1(f))]; str_console = [str_console ' ' num2str(trkIPCA.trk_3_armse_Fx1(f))]; end
    if (PARAM.in_bUseBPCA) str_plot = [str_plot ' ' num2str(trkBPCA.trk_2_rmse__Fx1(f))]; str_console = [str_console ' ' num2str(trkBPCA.trk_3_armse_Fx1(f))]; end
    if (PARAM.in_bUseRVQx) str_plot = [str_plot ' ' num2str(trkRVQx.trk_2_rmse__Fx1(f))]; str_console = [str_console ' ' num2str(trkRVQx.trk_3_armse_Fx1(f))]; end
    if (PARAM.in_bUseTSVQ) str_plot = [str_plot ' ' num2str(trkTSVQ.trk_2_rmse__Fx1(f))]; str_console = [str_console ' ' num2str(trkTSVQ.trk_3_armse_Fx1(f))]; end

    %output: console
    str_console
        
    %output: plot
    imagesc(uint8(I));hold on;
    if (PARAM.in_bUseIPCA) UTIL_PLOT_display(f, GT.fpt_1_truth_2xGxF(:,:,f), trkIPCA.fpt_2_estim_2xG, trkIPCA.snp_1_tsrpxy_1x6, PARAM.tgt_sh, PARAM.tgt_sw, 'm'); end
    if (PARAM.in_bUseBPCA) UTIL_PLOT_display(f, GT.fpt_1_truth_2xGxF(:,:,f), trkBPCA.fpt_2_estim_2xG, trkBPCA.snp_1_tsrpxy_1x6, PARAM.tgt_sh, PARAM.tgt_sw, 'r'); end
    if (PARAM.in_bUseRVQx) UTIL_PLOT_display(f, GT.fpt_1_truth_2xGxF(:,:,f), trkRVQx.fpt_2_estim_2xG, trkRVQx.snp_1_tsrpxy_1x6, PARAM.tgt_sh, PARAM.tgt_sw, 'g'); end
    if (PARAM.in_bUseTSVQ) UTIL_PLOT_display(f, GT.fpt_1_truth_2xGxF(:,:,f), trkTSVQ.fpt_2_estim_2xG, trkTSVQ.snp_1_tsrpxy_1x6, PARAM.tgt_sh, PARAM.tgt_sw, 'b'); end
    title(str_plot); 
    hold off;
    drawnow
end