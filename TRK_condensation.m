%> @file TRK_condensation.m
%> @brief This function implements the particle filter (condensation algorithm).
%> 
%> I                    :   input image, 0t1 means that the min value is 0, max value is 1
%> f                        :   frame number
%> cand_snps_shxswxNp       :   Np candidate snippets, pixel intensity range is [0 1]
%>
%> ALGO                     :   structure holding learning algorithm parameters and data, like MEAN, IPCA, RVQ, TSVQ
%>      mdl_3_U__DxQ        :   basis, normally, I would write U_DxN, but
%>                              here I use mdl_3_U__DxQ because B is the number of
%>                              training examples in one batch
%>
%> TRK                      :   structure that holds information about the condensation algorithm.  has following members:
%>      name                :   name of tracker, trkaIPCA, trkaBPCA, trkaRVQx, trkaTSVQ, etc
%>
%>      DM2                 :   design (data) matrix, contains all best snippets for all frames, pixel intensity range is [0 1]
%>
%>      PRF_1_tsrpxy_6xNp   :   particle filter, density x-axis (affine 6-tuple parameters)
%>      PRF_2_densty_Npx1   :      "       "   , density y-axis (one weight for each of the Np 6-tuples above)
%>      numF         :      "       "   , number of frames this particle filter has run
%>
%>      snp_0_pixls_shxsw   :   snippet stats, best snippet in image, i.e.it's best explained by my model, pixel intensity range is [0 1]
%>      snp_1_tsrpxy_1x6    :      "       " , best affine parameters  
%>      snp_2_error_shxsw   :      "       " , besr error
%>      snp_3_recon_shxsw   :      "       " , best recond (my model's reconstruction of this best snippet)
%>      snp_4_SNRdB_Fx1(f)  :      "       " , SNR of best snippet, comparison between observation-snippet and model-generated-snippet
%>      snp_5_rmse__Fx1(f)  :      "       " , rmse of best snippet
%>      snp_6_armse_Fx1(f)  :      "       "
%>
%>      fpt_1_truth_2xG     :   feature points, ground truth
%>      fpt_2_estim_2xG     :       "      "  , estimate
%>      fpt_3_error_2xG     :       "      "  , error
%>
%>      trk_1_SNRdB_Fx1     :   tracking results 
%>      trk_2_rmse__Fx1     :       "       "
%>      trk_3_armse_Fx1     :       "       "
%>
%>      trg_1_SNRdB_Fx1     :   training results 
%>      trg_2_rmse__Fx1     :       "       "
%>      trg_3_armse_Fx1     :       "       "
%>
%>      tst_1_SNRdB_Fx1     :   testing results
%>      tst_2_rmse__Fx1  	:       "       "
%>      tst_3_armse_Fx1  	:       "       "
%>
%> GT                       :   structure holding ground truth data
%>      fpt_1_truth_2xGxF   :   feature points, all of them   
%>      fpt_2_G             :        "      " , number of feature points in an image     
%>      fpt_3_refzc_2xG     :        "      " , reference for a zero centered target
%>
%> for every algo, compute
%>      ALGO.tst_3_error_DxN       :   errors for all particle filter candidates
%>
%> Copyright (c) Salman Aslam.  All rights reserved.  (IPCA part and computing weights comes from Jongwoo Lim and David Ross with permission)
%> Date created             :   April 25, 2011
%> Date last modified       :   September 18, 2011


function TRK = TRK_condensation(f, I, GT, RAND, PARAM, ALGO, TRK)
    
%----------------------------
%INITIALIZATIONS
%----------------------------
    tic
    
%----------------------------
%PRE-PROCESSING
%----------------------------
    Np                      =   PARAM.pf_Np;                    %particle filter: # of particles (samples) from density)    
    sw                      =   PARAM.tgt_sw;                    %snippet width
    sh                      =   PARAM.tgt_sh;                    %snippet height
    Nw                      =   PARAM.trg_Nw;                    %number of training images in training window
    bWeighting              =   PARAM.DM2_bWeighting;
 
    RN1_1xNp                =   RAND.unif_cdf_maxFxNp(f,:);     %pre-stored uniform random numbers to ensure repeatability    
    RN2_6xNp(:,:)           =   RAND.gaus_maxFx6xNp(f,:,:);     %     "     gaussian  "       "    "      "        "
    stddev                  =   PARAM.ds_6_PF_normalizer;
	
    D                       =   sw*sh;                              %dimensionality of input data    
    DM2                     =   TRK.DM2;
    
    

%----------------------------
%PROCESSING
%   compute 
%   1. cand_snps_shxswxNp
%   2. ALGO.tst_3_error_DxN (candidate errors)
%   3. weights, maxidx
%----------------------------
%1. get cand_snps_shxswxNp (candidate snippets, using resampling)   %although here it's done at the beginning, it's really being done at the end.
                                                %the reason is that in the first run, initialization is done, but not resampling.
                                                %then motion model is applied after resampling.  so after the initialization)

    %a. candidate affine tllpxy parameters
    if (TRK.numF==1)  %first time? initialize affine geometric (tllpxy) parameters, one for each of the Np candidate snippets
        TRK.PRF_1_tsrpxy_6xNp=   repmat(PARAM.ds_7_tsrpxy_1x6'  , [1,Np]  );         %initialized candidates with hand labeled parameters (one time)
                                    
    else                         %not first time? resample distribution in tsrpxy space (read details of these steps in my article on resampling)       
        prior_cdf           =   cumsum(TRK.PRF_2_densty_Npx1);
        idx                 =   floor(sum(  repmat(RN1_1xNp,[Np,1]) > repmat(prior_cdf,[1,Np])  ))+1; 
        TRK.PRF_1_tsrpxy_6xNp=  TRK.PRF_1_tsrpxy_6xNp(:,idx);  %overwrite 1st particle filter variable (keep only good candidates (resample))
    end

    %b. apply uniform random motion on tsrpxy (theta, s, r, phi, tx, ty)
    rand_motion_tsrpxy_6xNp =   RN2_6xNp.*repmat(PARAM.ds_8_tsrpxy_1x6_stddev(:),[1,Np]);       
    
    %c. get candidate parameters after motion
    TRK.PRF_1_tsrpxy_6xNp   =   TRK.PRF_1_tsrpxy_6xNp + rand_motion_tsrpxy_6xNp;                        
    
    
    %d. get candidate snippets
    for np=1:Np
        Ha_2x3              =   UTIL_2D_affine_tsrpxy_to_Ha_2x3(TRK.PRF_1_tsrpxy_6xNp(:,np));
        [X_hxw, Y_hxw, cand_snps_shxswxNp(:,:,np)]   ...
                            =   UTIL_2D_affine_extractROI_using_Ha_2x3(I, Ha_2x3, sw, sh);
    end
    cand_snps_DxNp          =   reshape(cand_snps_shxswxNp,[D,Np]);
   
%2. compute candidate errors, i.e., find how well the algorithm model explains each snippet)

    %IPCA, BPCA
    if     (strcmp(TRK.name, 'trkaMEAN'))                                 ALGO = MEAN_2_test          (cand_snps_DxNp, ALGO);
    elseif (strcmp(TRK.name, 'trkaIPCA') || strcmp(TRK.name, 'trkaBPCA')) ALGO = PCA__2_encode_decode (cand_snps_DxNp, ALGO);
    elseif (strcmp(TRK.name, 'trkaRVQx'))                                 ALGO = RVQ__2_encode_decode (cand_snps_DxNp, ALGO);
    elseif (strcmp(TRK.name, 'trkaTSVQ'))                                 ALGO = TSVQ_2_encode_decode (cand_snps_DxNp, ALGO);
    end
    DFFS                    =   abs(ALGO.tst_3_error_DxN/256);              %scale and make positive, PCA terminology from Moghaddam and Pentland terminology to keep things uniform
        
    %if (strcmp(TRK.name, 'trkaRVQx'))
    %    DIFS                =   repmat(ALGO.in_11_lmbd*(ALGO.in_3__maxQ-ALGO.tst_6_partQ_1xN), D, 1);
    %    DFFS                =   DFFS + DIFS;
    %end

       
%3. weights, maxidx (posterior)
    %%compute DIFS for use with PPCA, if not using PPCA, not required
    %if (isfield(TRK,'candErrs_featr_QxNp'))
    %    DIFS               =   (abs(candErrs_featr_QxNp)-abs(TRK.candErrs_featr_QxNp))*PARAM.pf_reseig./repmat(S_Bx1,[1,Np]);
    %else
    %    DIFS               =   candErrs_featr_QxNp                               .*PARAM.pf_reseig./repmat(S_Bx1,[1,Np]);
    %end
    %TRK.candErrs_featr_QxNp=   candErrs_featr_QxNp;
    
    
    switch (PARAM.pf_errfunc)
        case 'robust'; temp_weights  =   exp(-  sum(DFFS.^2./(DFFS.^2 + PARAM.rsig.^2))./stddev)';%PARAM.rsig never defined
        case 'ppca';   temp_weights  =   exp(-( sum(DFFS.^2)+ sum(DIFS.^2)            )./stddev)';
        otherwise;     temp_weights  =   exp(-  sum(DFFS.^2                           )./stddev)';
    end
    weights                 =   temp_weights ./ sum(temp_weights);          %normalize weights
    [maxprob,maxidx]        =   max(weights);                               %MAP estimate: pick best index
    
%----------------------------
%POST-PROCESSING
%----------------------------
%seven best-snippet (this frame only) stats
	TRK.snp_0_pixls_shxsw   =   cand_snps_shxswxNp          (:,:,maxidx);               %0. best snippet 
    TRK.snp_1_tsrpxy_1x6    =   TRK.PRF_1_tsrpxy_6xNp       (:  ,maxidx);               %1. best affine parameters
    TRK.snp_2_error_shxsw   =   reshape(ALGO.tst_3_error_DxN(:  ,maxidx), [sh sw]);     %2. best error                                             
    TRK.snp_3_recon_shxsw   =   TRK.snp_0_pixls_shxsw - TRK.snp_2_error_shxsw;          %3. best recon        
    TRK.snp_4_SNRdB_Fx1(f)  =   UTIL_METRICS_compute_SNRdB  (TRK.snp_0_pixls_shxsw(:), TRK.snp_2_error_shxsw(:));  %4.
    TRK.snp_5_rmse__Fx1(f)  =   UTIL_METRICS_compute_rms    (                          TRK.snp_2_error_shxsw(:));  %5.
    TRK.snp_6_armse_Fx1(f)  =   UTIL_compute_avg            (TRK.snp_5_rmse__Fx1(1:f));                                                %6.
    
    
%save all snippets
    TRK.DM2                 =   [DM2      TRK.snp_0_pixls_shxsw(:)];          %update snippet library
    if 	   (strcmp(TRK.name, 'trkaBPCA') || strcmp(TRK.name, 'trkaRVQx') || strcmp(TRK.name, 'trkaTSVQ')) %not needed for IPCA since it has its own forgetting factor
        TRK.DM2             =   DM2_window_and_repeat(TRK.DM2, Nw, bWeighting); 
    end
    
%two particle filter variables (state and density)
    TRK.PRF_2_densty_Npx1   =   weights;                        %overwrite 2nd particle filter variable
    TRK.numF                =   TRK.numF + 1;                   %overwrite 3rd particle filter variable
    
%three feature point metrics
    TRK.fpt_1_truth_2xG     =   GT.fpt_1_truth_2xGxF(:,:,f);

    Ha_2x3                  =   UTIL_2D_affine_tsrpxy_to_Ha_2x3(TRK.snp_1_tsrpxy_1x6);
    x                       =   GT.fpt_3_refzc_2xG(1,:);         %x coordinates, ground-truth reference zero-centered feature points in first frame
    y                       =   GT.fpt_3_refzc_2xG(2,:);         %y      "          "     "      "           "            "       "   "   "    "   
    TRK.fpt_2_estim_2xG     =   UTIL_2D_affine_apply_transform(Ha_2x3, [x;y]);
    clear x y
    
    TRK.fpt_3_error_2xG     =   TRK.fpt_1_truth_2xG - TRK.fpt_2_estim_2xG;
    
%three (3) tracking metrics
    TRK.trk_1_SNRdB_Fx1(f)  =   UTIL_METRICS_compute_SNRdB2     (TRK.fpt_1_truth_2xG,   TRK.fpt_3_error_2xG);  
    TRK.trk_2_rmse__Fx1(f)  =   UTIL_METRICS_compute_rms2       (                       TRK.fpt_3_error_2xG);  
    TRK.trk_3_armse_Fx1(f)  =   UTIL_compute_avg                (TRK.trk_2_rmse__Fx1(1:f));              
   
%three (3) training metrics
    TRK.trg_1_SNRdB_Fx1(f)  =   ALGO.trg_4_SNRdB_1x1;
    TRK.trg_2_rmse__Fx1(f)  =   ALGO.trg_5_rmse__1x1;
    TRK.trg_3_armse_Fx1(f)  =   UTIL_compute_avg                (TRK.trg_2_rmse__Fx1(1:f));

%three (3) testing metrics
    TRK.tst_1_SNRdB_Fx1(f)  =   ALGO.tst_4_SNRdB_1x1;
    TRK.tst_2_rmse__Fx1(f)  =   ALGO.tst_5_rmse__1x1;
    TRK.tst_3_armse_Fx1(f)  =   UTIL_compute_avg                (TRK.tst_2_rmse__Fx1(1:f));

%three (3) timing metrics
    TRK.tim_t_sec(f)        =   toc;                                        %time for this run
    TRK.tim_T_sec           =   TRK.tim_T_sec + TRK.tim_t_sec(f);           %total time for all runs
    TRK.tim_fps             =   f/TRK.tim_T_sec;                            %frames per sec for this run
    
%WRITE STATS TO STRING
    if     (strcmp(TRK.name, 'trkaMEAN'))           %no need to write for trkaMEAN, reason is that name cannot be differentiated between configurations, and running on the cluster then causes problems.
        return;
    end
    
    fid                     =   fopen(TRK.cfn, 'a');
                                UTIL_FILE_checkFileOpen(fid, TRK.cfn); 
    %time and errors
                                         %1,2,3,        4,5,6            7,8,9            10,11,12         13,14,15         
    str_1_time_errors       =   sprintf('%4d%8.2f%8.2f  %8.2f%8.2f%8.2f  %8.2f%8.2f%8.2f  %8.2f%8.2f%8.2f  %8.2f%8.2f%8.2f ',...
                                f                       , ALGO.tim_t_sec          , TRK.tim_t_sec(f)      , ... %1,2,3                                  
                                TRK.trk_1_SNRdB_Fx1(f)  , TRK.trk_2_rmse__Fx1(f)  , TRK.trk_3_armse_Fx1(f), ... %4,5,6
                                TRK.snp_4_SNRdB_Fx1(f)  , TRK.snp_5_rmse__Fx1(f)  , TRK.snp_6_armse_Fx1(f), ... %7,8,9
                                TRK.trg_1_SNRdB_Fx1(f)  , TRK.trg_2_rmse__Fx1(f)  , TRK.trg_3_armse_Fx1(f), ... %10,11,12
                                TRK.tst_1_SNRdB_Fx1(f)  , TRK.tst_2_rmse__Fx1(f)  , TRK.tst_3_armse_Fx1(f) ...  %13,14,15
                                );
    %affine parameters
                                         %16  17      18   19     20   21 
    str_2_aff               =   sprintf('%8.2f%8.2f  %8.2f%8.2f  %8.2f%8.2f ',...
                                TRK.snp_1_tsrpxy_1x6(1), TRK.snp_1_tsrpxy_1x6(2), TRK.snp_1_tsrpxy_1x6(3), TRK.snp_1_tsrpxy_1x6(4), TRK.snp_1_tsrpxy_1x6(5), TRK.snp_1_tsrpxy_1x6(6) ...
                                );
   
    %estimated feature points
    str_3_fp                =   [];
    [temp1, G]              =   size(TRK.fpt_2_estim_2xG);  
    for g=1:G
        temp2               =   sprintf('%8.2f%8.2f ', TRK.fpt_2_estim_2xG(1,g), TRK.fpt_2_estim_2xG(2,g));
        str_3_fp            =   [str_3_fp temp2];
    end
    
    %combine strings    
    str_out                 =   [str_1_time_errors  ' '  str_2_aff ' '  str_3_fp];
  
    %write RVQ stats, if RVQ, to string
    if (strcmp(TRK.name, 'trkaRVQx'))
        ALGO.tst_9_drmse_Qx1=   ALGO.tst_8_drmse_QxN(:, maxidx);
        str_rvq             =   RVQx_stats_str(ALGO,maxidx);
        str_out             =   [str_out ' ' str_rvq];
    end
    
    %write to file           
                                fprintf(fid, [str_out '\n']); 
                                fclose(fid);