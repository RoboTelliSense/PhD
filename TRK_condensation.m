%> @file TRK_condensation.m
%> @brief This function implements the particle filter (condensation algorithm).
%> 
%> I_0t1                    :   input image, 0t1 means that the min value is 0, max value is 1
%> f                        :   frame number
%> cand_snps_shxswxNp       :   Np candidate snippets, pixel intensity range is [0 1]
%>
%> ALGO                     :   structure holding learning algorithm parameters and data, like MEAN, IPCA, RVQ, TSVQ
%>      mdl_3_U__DxP        :   basis, normally, I would write U_DxN, but
%>                              here I use mdl_3_U__DxP because B is the number of
%>                              training examples in one batch
%>
%> TRK                      :   structure that holds information about the condensation algorithm.  has following members:
%>      name                :   name of tracker, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, etc
%>
%>      DM2                 :   design (data) matrix, contains all best snippets for all frames, pixel intensity range is [0 1]
%>
%>      PRF_1_tsrpxy_6xNp   :   particle filter, density x-axis (affine 6-tuple parameters)
%>      PRF_2_densty_Npx1   :      "       "   , density y-axis (one weight for each of the Np 6-tuples above)
%>      PRF_3_numfr         :      "       "   , number of frames this particle filter has run
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
%>      candErrs_DxNp       :   errors for all particle filter candidates
%>
%> Copyright (c) Salman Aslam.  All rights reserved.  (IPCA part and computing weights comes from Jongwoo Lim and David Ross with permission)
%> Date created             :   April 25, 2011
%> Date last modified       :   September 18, 2011


function TRK = TRK_condensation(f, I_0t1, GT, RAND, PARAM, ALGO, TRK)
%----------------------------
%INITIALIZATIONS
%----------------------------
    candErrs_DxNp     = 	[];
    
%----------------------------
%PRE-PROCESSING
%----------------------------
    Np                      =   PARAM.in_Np;                    %particle filter: # of particles (samples) from density)    
    sw                      =   PARAM.in_sw;                    %snippet width
    sh                      =   PARAM.in_sh;                    %snippet height
    Nw                      =   PARAM.in_Nw;                    %number of training images in training window
    bWeighting              =   PARAM.in_bWeighting;
 
    RN1_1xNp                =   RAND.unif_cdf_maxFxNp(f,:);     %pre-stored uniform random numbers to ensure repeatability    
    RN2_6xNp(:,:)           =   RAND.gaus_maxFx6xNp(f,:,:);     %     "     gaussian  "       "    "      "        "
    stddev                  =   PARAM.ds_6_PF_normalizer;
	
    D                       =   sw*sh;                              %dimensionality of input data    
    DM2                     =   TRK.DM2;
    
    

%----------------------------
%PROCESSING
%   compute 
%   1. cand_snps_shxswxNp
%   2. candErrs_DxNp
%   3. weights, maxidx
%----------------------------
%1. get cand_snps_shxswxNp (candidate snippets, using resampling)   %although here it's done at the beginning, it's really being done at the end.
                                                %the reason is that in the first run, initialization is done, but not resampling.
                                                %then motion model is applied after resampling.  so after the initialization)

    %a. candidate affine tllpxy parameters
    if (TRK.PRF_3_numfr==1)  %first time? initialize affine geometric (tllpxy) parameters, one for each of the Np candidate snippets
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
                            =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_0t1, Ha_2x3, sw, sh);
    end
    cand_snps_DxNp          =   reshape(cand_snps_shxswxNp,[D,Np]);
   
%2. compute candidate errors, i.e., find how well the algorithm model explains each snippet)

    %IPCA, BPCA
    if     (strcmp(TRK.name, 'trkMEAN'))                                ALGO = MEAN_2_test (cand_snps_DxNp    , ALGO);
    elseif (strcmp(TRK.name, 'trkIPCA') || strcmp(TRK.name, 'trkBPCA')) ALGO = PCA__2_test (cand_snps_DxNp    , ALGO);
    elseif (strcmp(TRK.name, 'trkRVQ'))                                 ALGO = RVQ__2_test (cand_snps_DxNp    , ALGO);
    elseif (strcmp(TRK.name, 'trkTSVQ'))                                ALGO = TSVQ_2_test (cand_snps_DxNp    , ALGO);
    end
    candErrs_DxNp           =   ALGO.tst_3_error_DxN;
        
    %if (strcmp(TRK.name, 'trkRVQ'))
    %    candErrs_DxNp(:,i)  =   (abs(candErrs_DxNp) + ALGO.in_11_lambda*(ALGO.in_3_maxP-ALGO.P));
    %end

       
%3. weights, maxidx (posterior)
    %%compute DIFS for use with PPCA, if not using PPCA, not required
    %if (isfield(TRK,'candErrs_featr_PxNp'))
    %    DIFS               =   (abs(candErrs_featr_PxNp)-abs(TRK.candErrs_featr_PxNp))*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
    %else
    %    DIFS               =   candErrs_featr_PxNp                               .*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
    %end
    %TRK.candErrs_featr_PxNp=   candErrs_featr_PxNp;
    DFFS                    =   candErrs_DxNp/256;  %DFFS                    =   reshape(UTIL_scale2(candErrs_DxNp(:), 0, 1), D, Np);
    
    switch (PARAM.con_errfunc)
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
    TRK.snp_2_error_shxsw   =   reshape(candErrs_DxNp       (:  ,maxidx), [sh sw]);     %2. best error                                             
    TRK.snp_3_recon_shxsw   =   TRK.snp_0_pixls_shxsw - TRK.snp_2_error_shxsw;          %3. best recon        
    TRK.snp_4_SNRdB_Fx1(f)  =   UTIL_METRICS_compute_SNRdB  (TRK.snp_0_pixls_shxsw(:), TRK.snp_2_error_shxsw(:)    );  %4.
    TRK.snp_5_rmse__Fx1(f)  =   UTIL_METRICS_compute_rms    (                          TRK.snp_2_error_shxsw(:)*255);  %5.
    TRK.snp_6_armse_Fx1(f)  =   UTIL_compute_avg            (TRK.snp_5_rmse__Fx1(1:f));                                                %6.
    
    
%save all snippets
    TRK.DM2                 =   [DM2      TRK.snp_0_pixls_shxsw(:)];          %update snippet library
    if 	   (strcmp(TRK.name, 'trkBPCA') || strcmp(TRK.name, 'trkRVQ') || strcmp(TRK.name, 'trkTSVQ')) %not needed for IPCA since it has its own forgetting factor
        TRK.DM2             =   DATAMATRIX_pick_last_Nw_values_and_weight_in_DM2(TRK.DM2, Nw, bWeighting); 
    end
    
%two particle filter variables (state and density)
    TRK.PRF_2_densty_Npx1   =   weights;                                %overwrite 2nd particle filter variable
    TRK.PRF_3_numfr         =   TRK.PRF_3_numfr + 1;                %overwrite 3rd particle filter variable
    
%three feature point metrics
    TRK.fpt_1_truth_2xG     =   GT.fpt_1_truth_2xGxF(:,:,f);

    Ha_2x3                  =   UTIL_2D_affine_tsrpxy_to_Ha_2x3(TRK.snp_1_tsrpxy_1x6);
    x                       =   GT.fpt_3_refzc_2xG(1,:);         %x coordinates, ground-truth reference zero-centered feature points in first frame
    y                       =   GT.fpt_3_refzc_2xG(2,:);         %y      "          "     "      "           "            "       "   "   "    "   
    TRK.fpt_2_estim_2xG     =   UTIL_2D_affine_apply_transform(Ha_2x3, [x;y]);
    clear x y
    
    TRK.fpt_3_error_2xG     =   TRK.fpt_1_truth_2xG - TRK.fpt_2_estim_2xG;
    
%three tracking metrics
    TRK.trk_1_SNRdB_Fx1(f)  =   UTIL_METRICS_compute_SNRdB2     (TRK.fpt_1_truth_2xG,   TRK.fpt_3_error_2xG);  
    TRK.trk_2_rmse__Fx1(f)  =   UTIL_METRICS_compute_rms2       (                       TRK.fpt_3_error_2xG);  
    TRK.trk_3_armse_Fx1(f)  =   UTIL_compute_avg                (                       TRK.trk_2_rmse__Fx1(1:f));              
   
%three (3) training metrics
    TRK.trg_1_SNRdB_Fx1(f)  =   ALGO.trg_4_SNRdB_1x1;
    TRK.trg_2_rmse__Fx1(f)  =   ALGO.trg_5_rmse__1x1;
    TRK.trg_3_armse_Fx1(f)  =   UTIL_compute_avg                (TRK.trg_2_rmse__Fx1(1:f));

%three (3) testing metrics
    TRK.tst_1_SNRdB_Fx1(f)  =   ALGO.tst_4_SNRdB_1x1;
    TRK.tst_2_rmse__Fx1(f)  =   ALGO.tst_5_rmse__1x1;
    TRK.tst_3_armse_Fx1(f)  =   UTIL_compute_avg                (TRK.tst_2_rmse__Fx1(1:f));