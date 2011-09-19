%> @file TRK_condensation.m
%> @brief This function implements the particle filter (condensation algorithm).
%> 
%> I_0t1                    :   input image, 0t1 means that the min value is 0, max value is 1
%> f                        :   frame number
%> aff_tsrpxy_6xNp          :   Np affine candidates in (theta, s, r, phi,
%tx, ty) format
%> cand_snps_0t1_shxswxNp    :   Np candidate snippets
%> TRK.per_                 :   state variable for tracking
%> ALGO.mdl_2_U_DxB         :   basis, normally, I would write U_DxN, but
%>                              here I use mdl_2_U_DxB because B is the number of
%>                              training examples in one batch
%> TRK                      :   structure that holds information about the condensation algorithm.  has following members:
%>
%>      name                :   
%>      err_descr_BxNp      :   used only with IPCA, should change this because i don't want algo specific structures here
%>
%>      per_1_DM2           :   persistent variable 
%>      per_2_mu_shxsw      :       "         "
%>      per_3_weights       :       "         "
%>      per_4_aff_abcdxy_1x6:       "         "
%>
%>      snp_1_best__0t1_shxsw:   snippet stats, best snippet in image, i.e. it's best explained by my model
%>      snp_2_error_shxsw   :      "       "  , the error
%>      snp_3_recon_shxsw   :      "       "  , my model's reconstruction of this best snippet	
%>      snp_4_SNRdB_Fx1(f)  :      "       "
%>      snp_5_rmse__Fx1(f)  :      "       "
%>      snp_6_armse_Fx1(f)  :      "       "
%>
%>      trg_SNRdB_1x1       :   training results 
%>      trg_rmse__Fx1       :       "       "
%>      trg_armse_Fx1       :       "       "
%>
%>      tst_SNRdB_Fx1(f)    :   testing results
%>      tst_rmse__Fx1(f)  	:       "       "
%>      tst_armse_Fx1(f)  	:       "       "
%>
%>      fp_1_gt             :   feature points, ground truth
%>      fp_2_est            :       "      "  , estimate
%>      fp_3_err            :       "      "  , error
%>
%> for every algo, compute
%>      cand_errs_0t1_DxNp :   errors for all particle filter candidates
%>
%> Copyright (c) Salman Aslam.  All rights reserved.  (IPCA part and computing weights comes from Jongwoo Lim and David Ross with permission)
%> Date created              :   April 25, 2011
%> Date last modified        :   September 18, 2011


function TRK = TRK_condensation(f, I_0t1, GT, RAND, PARAM, ALGO, TRK)
%----------------------------
%INITIALIZATIONS
%----------------------------
    cand_errs_0t1_DxNp     = 	[];
    
%----------------------------
%PRE-PROCESSING
%----------------------------
    Np                      =   PARAM.in_Np;                        %particle filter: # of particles (samples) from density)    
    sw                      =   PARAM.in_sw;                       %snippet width
    sh                      =   PARAM.in_sh;                       %snippet height
    Nw                      =   PARAM.in_Nw;
    bWeighting              =   PARAM.in_bWeighting;
 
    RN1_1xNp                =   RAND.unif_cdf_maxFxNp(f,:);     %pre-stored uniform random numbers to ensure repeatability    
    RN2_6xNp(:,:)           =   RAND.gaus_maxFx6xNp(f,:,:);     %     "     gaussian  "       "    "      "        "
    stddev                  =   PARAM.ds_6_con_stddev;
	
    D                       =   sw*sh;                              %dimensionality of input data
    
%state variables (use and then update) 
    per_1_DM2               =   TRK.per_1_DM2;
    per_2_mu_shxsw          =   TRK.per_2_mu_shxsw;
    per_3_weights           =   TRK.per_3_weights;
    per_4_aff_abcdxy_1x6    =   TRK.per_4_aff_abcdxy_1x6(:);
    
    
    

%----------------------------
%PROCESSING
%   compute 
%   1. cand_snps_0t1_shxswxNp
%   2. cand_errs_0t1_DxNp
%   3. weights, maxidx
%----------------------------
%1. get cand_snps_0t1_shxswxNp (candidate snippets, using resampling)   %although here it's done at the beginning, it's really being done at the end.
                                                %the reason is that in the first run, initialization is done, but not resampling.
                                                %then motion model is applied after resampling.  so after the initialization)

    %a. candidate affine tllpxy parameters
    if ~isfield(TRK,'aff_tsrpxy_6xNp')
        %first time? initialize affine geometric (tllpxy) parameters, one for each of the Np candidate snippets
        aff_tsrpxy_1x6      =   UTIL_2D_affine_abcdxy_to_tsrpxy(per_4_aff_abcdxy_1x6);
        aff_tsrpxy_6xNp     =   repmat(aff_tsrpxy_1x6'  , [1,Np]  );         %initialized candidates with hand labeled parameters (one time)
                                    
    else
        %not first time? resample distribution in aff_tsrpxy_6xNp space (read details of these steps in my article on resampling)
        prior_cdf           =   cumsum(per_3_weights);
        idx                 =   floor(sum(  repmat(RN1_1xNp,[Np,1]) > repmat(prior_cdf,[1,Np])  ))+1; 
        aff_tsrpxy_6xNp     =   aff_tsrpxy_6xNp(:,idx);  %keep only good candidates (resample)
    end

    %b. apply uniform random motion on tsrpxy (theta, s, r, phi, tx, ty)
    rand_motion_tsrpxy_6xNp =   RN2_6xNp.*repmat(PARAM.ds_aff_tsrpxy_stddev_1x6(:),[1,Np]);       
    
    %c. get candidate parameters after motion
    aff_tsrpxy_6xNp      	=   aff_tsrpxy_6xNp + rand_motion_tsrpxy_6xNp;                        
    
    
    %d. get candidate snippets
    for np=1:Np
        aff_abcdxy_1x6      =   (UTIL_2D_affine_tsrpxy_to_abcdxy(aff_tsrpxy_6xNp(:,np)))'; 
        Ha_2x3              =   UTIL_2D_affine_abcdxy_to_Ha_2x3(aff_abcdxy_1x6);
        [X_hxw, Y_hxw, cand_snps_0t1_shxswxNp(:,:,np)]   ...
                            =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_0t1, Ha_2x3, sw, sh);
    end
    
   
%2. compute cand_errs_0t1_DxNp (candidate errors, i.e., find how well the algorithm model explains each snippet, find distances)

    %generic algo
    if (strcmp(TRK.name, 'genericPF')) 
        cand_errs_0t1_DxNp =   repmat(per_2_mu_shxsw(:),[1,Np]) - reshape(cand_snps_0t1_shxswxNp,[D,Np]); 
        DIFS                =   0;
        
        
    %iPCA    
    elseif (strcmp(TRK.name, 'trkIPCA'))
        U_DxB               =   ALGO.mdl_2_U_DxB;   
        S_Bx1               =   ALGO.mdl_4_S_Bx1;
             
        %part 1: error, distance from mean (err vector points to mean)
        cand_errs_0t1_DxNp =   repmat(mu_Dx1(:),[1,Np]) - reshape(cand_snps_0t1_shxswxNp,[D,Np]); %DFFS
        DIFS                =   0;
        
        %part 2: error, reduce the part that can be explained by the basis
        err_descr_BxNp      =   U_DxB'*cand_errs_0t1_DxNp;             %error projection on basis: scalars
        err_recon_DxNp      =   U_DxB*err_descr_BxNp;                   %error projection on basis: vectors
        cand_errs_0t1_DxNp =   cand_errs_0t1_DxNp - err_recon_DxNp;   %this is DFFS
                                                            
        %compute DIFS for use with PPCA, if not using PPCA, not required
        if (isfield(TRK,'err_descr_BxNp'))
            DIFS            =   (abs(err_descr_BxNp)-abs(TRK.err_descr_BxNp))*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
        else
            DIFS            =   err_descr_BxNp                               .*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
        end
        TRK.err_descr_BxNp  =   err_descr_BxNp;
        
        
	
        
    %bPCA    
    elseif (strcmp(TRK.name, 'trkBPCA'))
        for i = 1:Np
            Itst            =   255*cand_snps_0t1_shxswxNp(:,:,i);
            ALGO            =   bPCA_3_test(Itst(:), ALGO);
            cand_errs_0t1_DxNp(:,i) ...
                            =   ALGO.tst_3_error_DxN/255;                                
        end

        
        
        
    %RVQ    
    elseif (strcmp(TRK.name, 'trkRVQ')) 
        cand_errs_0t1_DxNp  ...
                            = 	[];
        for i = 1:Np
            Itst            =   255*cand_snps_0t1_shxswxNp(:,:,i);
            ALGO            =   RVQ__testing_grayscale(Itst(:), ALGO);
            cand_errs_0t1_DxNp(:,i) ...
                            =   (abs(ALGO.tst_3_error_DxN) + RVQ.in_10_lambda*(ALGO.maxP-ALGO.P))/255;
        end
        
        
    %TSVQ
    elseif (strcmp(TRK.name, 'trkTSVQ'))
        cand_errs_0t1_DxNp  ...
                            = 	[];
        for i = 1:Np
            Itst            =   255*cand_snps_0t1_shxswxNp(:,:,i);
            ALGO            =   TSVQ_3_test(Itst(:), ALGO);
            cand_errs_0t1_DxNp(:,i) ....
                            =   ALGO.tst_3_error_DxN/255;                                
        end
    end

%3. weights, maxidx (posterior)
    DFFS                    =   cand_errs_0t1_DxNp;
    switch (PARAM.con_errfunc)
        case 'robust'; temp_weights  =   exp(- sum(DFFS.^2./(DFFS.^2 + PARAM.rsig.^2))./stddev)';%PARAM.rsig never defined
        case 'ppca';   temp_weights  =   exp(-(     sum(DFFS.^2)+ sum(DIFS.^2)        )./stddev)';
        otherwise;     temp_weights  =   exp(-      sum(DFFS.^2                       )./stddev)';
    end
    weights                 =   temp_weights ./ sum(temp_weights);          %normalize weights
    [maxprob,maxidx]        =   max(weights);                               %MAP estimate: pick best index
    
%----------------------------
%POST-PROCESSING
%----------------------------
%six best snippet stats
	TRK.snp_1_best__0t1_shxsw=   cand_snps_0t1_shxswxNp(:,:,maxidx);        %best 2. best snippet 
    TRK.snp_2_error_shxsw    =   reshape(cand_errs_0t1_DxNp(:,maxidx), [sh sw]);    %best 3. best error     
    if 	   (PARAM.ds_1_code==0 || 1) 
        TRK.snp_2_error_shxsw=   -TRK.snp_2_error_shxsw;                           
    end
    TRK.snp_3_recon_shxsw   =   TRK.snp_1_best__0t1_shxsw - TRK.snp_2_error_shxsw;                           %my model's reconstruction of this best snippet
    TRK.snp_4_SNRdB_Fx1(f)  =   UTIL_METRICS_compute_SNRdB       (TRK.snp_1_best__0t1_shxsw(:), TRK.snp_2_error_shxsw(:)    );
    TRK.snp_5_rmse__Fx1(f)  =   UTIL_METRICS_compute_rms_value   (                              TRK.snp_2_error_shxsw(:)*255);
    TRK.snp_6_armse_Fx1(f)  =   UTIL_compute_avg(TRK.snp_5_rmse__Fx1(1:f));
    
    
%four persistent variables
    TRK.per_1_DM2           =   [per_1_DM2 TRK.snp_1_best__0t1_shxsw(:)];%update snippet library
    if 	   (strcmp(TRK.name, 'BPVQ') || strcmp(TRK.name, 'RVQ') || strcmp(TRK.name, 'TSVQ')) %not needed for IPCA since it has its own forgetting factor
        TRK.per_1_DM2       =   DATAMATRIX_pick_last_Nw_values_in_DM2(TRK.per_1_DM2, Nw, bWeighting); 
    end      
    TRK.per_2_mu_Dx1;                           %not updating at this time
    TRK.per_3_weights       =   weights;
    TRK.per_4_aff_abcdxy_1x6=   UTIL_2D_affine_tllpxy_to_abcdxy(aff_tsrpxy_6xNp(:,maxidx));  %best 1. affine ROI 
    

%three (3) training metrics
    TRK.trg_SNRdB_1x1(f)    =   ALGO.trg_4_SNRdB_1x1;
    TRK.trg_rmse__Fx1(f)  	=   ALGO.trg_5_rmse__1x1;
    TRK.trg_armse_Fx1(f)  	=   UTIL_compute_avg(TRK.trg_rmse__Fx1(1:f));

%three (3) testing metrics
    TRK.tst_SNRdB_Fx1(f)    =   ALGO.tst_4_SNRdB_1x1;
    TRK.tst_rmse__Fx1(f)  	=   ALGO.tst_5_rmse__1x1
    TRK.tst_armse_Fx1(f)  	=   UTIL_compute_avg(TRK.tst_rmse__Fx1(1:f));
    
%three (3) feature points metrics
    TRK.fp_2_est            =   TRK.per_4_aff_abcdxy_1x6([3,4,1;5,6,2]) ...
                                        * ...
                                       [GT.fp_3_ref_upright_zc; ones(1,GT.fp_2_G)];
    TRK.fp_1_gt                     =   cat(3, ...
                                        GT.fp_3_ref_upright_zc+repmat(PARAM.tgt_sz'/2,[1,GT.fp_2_G]), ...
                                        GT.fp_1_all_2xGxF(:,:,f), ...
                                        TRK.fp_2_est);
    idx                             =   find(TRK.fp_1_gt(1,:,2) > 0);
    if (length(idx) > 0)
        TRK.fp_3_err(f)             =   sqrt(mean(sum((TRK.fp_1_gt(:,idx,2)-TRK.fp_1_gt(:,idx,3)).^2,1)));
    else
        TRK.fp_3_err(f)             =   nan;
    end
        
