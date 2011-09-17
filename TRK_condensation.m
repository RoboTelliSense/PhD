%> @file TRK_condensation.m
%> @brief This function implements the particle filter (condensation algorithm).
% 
% 0t1 means that the min value is 0, max value is 1.
%
% I_0t1 is the input image.
% f is the frame number.
%
%> aff_tllpxy_6xNp          :   Np affine candidates in (theta, lambda1, lambda2, phi, tx, ty) format
%> snippets_0t1_shxswxNp    :   Np candidate snippets
%>
%> TRK.stt_                   :   state variable for tracking
%>
%> ALGO.mdl_2_U_DxB         :   basis, normally, I would write U_DxN,
%but
%>                              here I use mdl_2_U_DxB because B is the number of
%>                              training examples in one batch
% TRK is the structure that holds information about the
% condensation algorithm.  It has the following members:
%    (a) tgt_best_aff_abcdxy_1x6: MAP estimate of best affine parameters that describe target bounding region
%    (b) affineCandidates_6xNp: possible affine candidates that describe target bounding region
%    weights
%    err_descr_BxNp
%    out_1_snp_0t1_shxsw
%    all_candidate_errors_0to1_DxNp
%    recon
%    trk_SNRdB_1x1
%    out_5_rmse__1x1
%
% PARAM.ds_aff_tllpxy_var_1x6
%
% requirement
% TRK.stt_4_aff_abcdxy_1x6
% Copyright (C) Jongwoo Lim and David Ross (modified by Salman Aslam with permission)
% Date created      : April 25, 2011
% Date last modified: July 18, 2011
%%

function TRK = TRK_condensation(f, I_0t1, GT, RAND, PARAM, ALGO, TRK)
%----------------------------
%INITIALIZATIONS
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
    stt_1_DM2               =   TRK.stt_1_DM2;
    stt_2_mu_shxsw          =   TRK.stt_2_mu_shxsw;
    stt_3_weights           =   TRK.stt_3_weights;
    stt_4_aff_abcdxy_1x6    =   TRK.stt_4_aff_abcdxy_1x6(:);
    

%----------------------------
%PRE-PROCESSING
%----------------------------
%1. get candidate snippets (using resampling)   %although here it's done at the beginning, it's really being done at the end.
                                                %the reason is that in the first run, initialization is done, but not resampling.
                                                %then motion model is applied after resampling.  so after the initialization)

    %a. candidate affine tllpxy parameters
    if ~isfield(TRK,'aff_tllpxy_6xNp')
        %first time? initialize affine geometric (tllpxy) parameters, one for each of the Np candidate snippets
        aff_tllpxy_1x6      =   UTIL_2D_affine_abcdxy_to_tllpxy(stt_4_aff_abcdxy_1x6);
        aff_tllpxy_6xNp     =   repmat(aff_tllpxy_1x6'  , [1,Np]  );         %initialized candidates with hand labeled parameters (one time)
                                    
    else
        %not first time? resample distribution in aff_tllpxy_6xNp space (read details of these steps in my article on resampling)
        prior_cdf           =   cumsum(stt_3_weights);
        idx                 =   floor(sum(  repmat(RN1_1xNp,[Np,1]) > repmat(prior_cdf,[1,Np])  ))+1; 
        aff_tllpxy_6xNp     =   aff_tllpxy_6xNp(:,idx);  %keep only good candidates (resample)
    end

    %b. apply uniform random motion on tllpxy (theta, lambda1, lambda2, phi, tx, ty)
    rand_motion_tllpxy_6xNp =   RN2_6xNp.*repmat(PARAM.ds_aff_tllpxy_var_1x6(:),[1,Np]);       
    
    %c. get candidate parameters after motion
    aff_tllpxy_6xNp      	=   aff_tllpxy_6xNp + rand_motion_tllpxy_6xNp;                        
    
    
    %d. get candidate snippets
    for np=1:Np
        aff_abcdxy_1x6      =   (UTIL_2D_affine_tllpxy_to_abcdxy(aff_tllpxy_6xNp(:,np)))';             
        [X_hxw, Y_hxw, snippets_0t1_shxswxNp(:,:,np)]   ...
                            =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_0t1, aff_abcdxy_1x6, sw, sh);
    end
    %snippets_0t1_shxswxNp   =   UTIL_2D_warp_image(I_0t1, UTIL_2D_affine_tllpxy_to_abcdxy(aff_tllpxy_6xNp), [sh sw]);  %c. candidate images
    
%----------------------------
%PROCESSING
%----------------------------
%3. weighting (find how well the algorithm model explains each snippet, find distances)

    %generic algo
    if (strcmp(TRK.name, 'genericPF')) 
        all_candidate_errors_0to1_DxNp             =   repmat(stt_2_mu_shxsw(:),[1,Np]) - reshape(snippets_0t1_shxswxNp,[D,Np]); %all_candidate_errors_0to1_DxNp: (sw)(sh) x Np
        DIFS                        =   0;
        
        
    %iPCA    
    elseif (strcmp(TRK.name, 'trkIPCA'))
        U_DxB                       =   ALGO.mdl_2_U_DxB;   
        S_Bx1                       =   ALGO.mdl_4_S_Bx1;
             
        %part 1: error, distance from mean (err vector points to mean)
        all_candidate_errors_0to1_DxNp       =   repmat(mu_Dx1(:),[1,Np]) - reshape(snippets_0t1_shxswxNp,[D,Np]); %all_candidate_errors_0to1_DxNp: (sw)(sh) x Np
        DIFS                =   0;
        
        %part 2: error, reduce the part that can be explained by the basis
            err_descr_BxNp    =   U_DxB'*all_candidate_errors_0to1_DxNp;              %error projection on basis: scalars
            err_recon_DxNp    =   U_DxB*err_descr_BxNp;        %error projection on basis: vectors
            all_candidate_errors_0to1_DxNp         =   all_candidate_errors_0to1_DxNp - err_recon_DxNp;   %this is DFFS
                                                        
            
            %compute DIFS for use with PPCA, if not using PPCA, not required
            if (isfield(TRK,'err_descr_BxNp'))
                DIFS            				=   (abs(err_descr_BxNp)-abs(TRK.err_descr_BxNp))*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
            else
                DIFS            				=   err_descr_BxNp                               .*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
            end
            TRK.err_descr_BxNp 			=   err_descr_BxNp;
        
        
	
        
    %bPCA    
    elseif (strcmp(TRK.name, 'trkBPCA'))
        all_candidate_errors_0to1_DxNp         	= 	[];
        for i = 1:Np
            Itst                    			=   255*snippets_0t1_shxswxNp(:,:,i);
            ALGO                    			=   bPCA_3_test(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i) =   ALGO.tst_3_error_DxN/255;                                
        end

        
        temp_DxNp = zeros(D,Np);
        
        
    %RVQ    
    elseif (strcmp(TRK.name, 'trkRVQ')) 
        all_candidate_errors_0to1_DxNp        	= 	[];
        for i = 1:Np
            Itst                    			=   255*snippets_0t1_shxswxNp(:,:,i);
            ALGO                    			=   RVQ__testing_grayscale(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i) =   (abs(ALGO.tst_3_error_DxN) + RVQ.in_10_lambda*(ALGO.maxP-ALGO.P))/255;
        end
        
        
    %TSVQ
    elseif (strcmp(TRK.name, 'trkTSVQ'))
        all_candidate_errors_0to1_DxNp         	= 	[];
        for i = 1:Np
            Itst                    			=   255*snippets_0t1_shxswxNp(:,:,i);
            ALGO                    			=   TSVQ_3_test(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i) =   ALGO.tst_3_error_DxN/255;                                
        end
    end

%4. posterior
    DFFS                           				=   all_candidate_errors_0to1_DxNp;
    switch (PARAM.con_errfunc)
        case 'robust'; temp_weights  			=   exp(- sum(DFFS.^2./(DFFS.^2 + PARAM.rsig.^2))./stddev)';%PARAM.rsig never defined
        case 'ppca';   temp_weights  			=   exp(-(     sum(DFFS.^2)+ sum(DIFS.^2)        )./stddev)';
        otherwise;     temp_weights  			=   exp(-      sum(DFFS.^2                       )./stddev)';
    end
    weights                 					=   temp_weights ./ sum(temp_weights);          %normalize weights
    [maxprob,maxidx]        					=   max(weights);                               %MAP estimate: pick best index
    
    
%5. pick four best (MAP) estimates
	%one state variable
    best_aff_abcdxy_1x6         =   UTIL_2D_affine_tllpxy_to_abcdxy(aff_tllpxy_6xNp(:,maxidx));  %best 1. affine ROI 
    
	%three instantaneous variables
	best_snippet_0t1_shxsw  =   snippets_0t1_shxswxNp(:,:,maxidx);        %best 2. best snippet 
    best_error_0to1_Dx1     =   all_candidate_errors_0to1_DxNp(:,maxidx);           %best 3. best error 
    best_error_0to1_shxsw   =   reshape(best_error_0to1_Dx1, [sh sw]);
    if 	   (PARAM.ds_1_code==0 || 1) 
        best_error_0to1_shxsw =   -best_error_0to1_shxsw;                           
    end
    best_recon_shxsw        =   best_snippet_0t1_shxsw - best_error_0to1_shxsw;     %best 4. best recon
	
%----------------------------
%POST-PROCESSING
%----------------------------
%save
    %three (3) instantaneous variables
    TRK.inst_1_snp_0t1_shxsw =   best_snippet_0t1_shxsw;                     %best snippet in image, i.e. it's best explained by my model
    TRK.inst_2_recon_shxsw   =   best_recon_shxsw;                           %my model's reconstruction of this best snippet
    TRK.inst_3_error_shxsw   =   best_error_0to1_shxsw;                      %the error
	
	%three (3) tracking metrics
    TRK.trk_SNRdB_Fx1(f)    =   UTIL_METRICS_compute_SNRdB       (best_snippet_0t1_shxsw(:), best_error_0to1_shxsw(:)    );
    TRK.trk_rmse__Fx1(f)  	=   UTIL_METRICS_compute_rms_value   (                           best_error_0to1_shxsw(:)*255);
    TRK.trk_armse_Fx1(f)  	=   UTIL_compute_avg(TRK.trk_rmse__Fx1(1:f));
    
    %three (3) training metrics
    TRK.trg_SNRdB_1x1(f)    =   ALGO.trg_4_SNRdB_1x1;
    TRK.trg_rmse__Fx1(f)  	=   ALGO.trg_5_rmse__1x1;
    TRK.trg_armse_Fx1(f)  	=   UTIL_compute_avg(TRK.trg_rmse__Fx1(1:f));

    %three (3) testing metrics
    TRK.tst_SNRdB_Fx1(f)    =   ALGO.tst_4_SNRdB_1x1;
    TRK.tst_rmse__Fx1(f)  	=   ALGO.tst_5_rmse__1x1
    TRK.tst_armse_Fx1(f)  	=   UTIL_compute_avg(TRK.tst_rmse__Fx1(1:f));
    

    %four (4) state variables
    TRK.stt_1_DM2         =   [stt_1_DM2 TRK.inst_1_snp_0t1_shxsw(:)];%update snippet library
    if 	   (strcmp(TRK.name, 'BPVQ') || strcmp(TRK.name, 'RVQ') || strcmp(TRK.name, 'TSVQ')) %not needed for IPCA since it has its own forgetting factor
        TRK.stt_1_DM2     =   DATAMATRIX_pick_last_Nw_values_in_DM2(TRK.stt_1_DM2, Nw, bWeighting); 
    end                                                                                                       
    TRK.stt_3_weights     =   weights;
    TRK.stt_4_aff_abcdxy_1x6 = best_aff_abcdxy_1x6;
    
%tracking error        
    TRK.fp_2_est                    =   TRK.stt_4_aff_abcdxy_1x6([3,4,1;5,6,2]) ...
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
        
