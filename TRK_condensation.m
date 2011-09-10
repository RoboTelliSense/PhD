%> @file TRK_condensation.m
%> @brief This function implements the particle filter (condensation algorithm).
% 
% 0t1 means that the min value is 0, max value is 1.
%
% I_0t1 is the input image.
% f is the frame number.
%
%> ALGO.mdl_2_U_DxB               :   basis, normally, I would write U_DxN,
%but
%>                              here I use mdl_2_U_DxB because B is the number of
%>                              training examples in one batch
% TRK is the structure that holds information about the
% condensation algorithm.  It has the following members:
%    (a) tgt_best_affine2_1x6: MAP estimate of best affine parameters that describe target bounding region
%    (b) affineCandidates_6xNp: possible affine candidates that describe target bounding region
%    weights
%    err_projScalars_BxNp
%    out_1_snp_0t1_shxsw
%    all_candidate_errors_0to1_DxNp
%    recon
%    trk_SNRdB_1x1
%    out_5_rmse__1x1
%
% INP.ds_5_affROIvar_1x6
%
% requirement
% TRK.state_4_best_affine2_1x6
% Copyright (C) Jongwoo Lim and David Ross (modified by Salman Aslam with permission)
% Date created      : April 25, 2011
% Date last modified: July 18, 2011
%%

function TRK = TRK_condensation(f, INP, PARAM, I_0t1, ALGO, TRK)
%----------------------------
%INITIALIZATIONS
%----------------------------
    Np                              =   PARAM.in_Np;                        %particle filter: # of particles (samples) from density)    
    sw                              =   PARAM.in_sw;                       %snippet width
    sh                              =   PARAM.in_sh;                       %snippet height
    Nw                              =   PARAM.in_Nw;
    bWeighting                      =   PARAM.in_bWeighting;
 
    rn1                             =   INP.rand_cdf_maxFxNp(f,:);          %pre-stored random numbers to ensure repeatability    
    rn2(:,:)                        =   INP.rand_unitvar_maxFx6xNp(f,:,:);  %same as above
    stddev                          =   INP.ds_7_con_stddev;
	
    D                               =   sw*sh;                              %dimensionality of input data
    
%state variables (use and then update) 
    state_1_DM2                     =   TRK.state_1_DM2;
    state_2_mu_Dx1                  =   TRK.state_2_mu_Dx1;
    state_3_weights                 =   TRK.state_3_weights;
    state_4_best_affine2_1x6         =   TRK.state_4_best_affine2_1x6(:);
    

%----------------------------
%PRE-PROCESSING
%----------------------------
%1. resample candidate parameters           %although here it's done at the beginning, it's really being done at the end.
                                            %the reason is that in the first run, initialization is done, but not resampling.
                                            %then motion model is applied after resampling.  so after the initialization)

    if ~isfield(TRK,'affineCandidates_6xNp')
        %one time: initialize 6 affine parameters, one for each of the Np candidate snippets
        candidate_affineROIs_6xNp      =   repmat(  UTIL_2D_affine_abcdtxty_to_tllptxty(state_4_best_affine2_1x6(:)), [1,Np]  );         %initialized candidates with hand labeled parameters (one time)
                                    
    else
        %recurring: resample distribution in 3 lines (read details of this in my article on resampling)
        cumconf             =   cumsum(state_3_weights);
        idx                 =   floor(sum(  repmat(rn1,[Np,1]) > repmat(cumconf,[1,Np])  ))+1; 
        candidate_affineROIs_6xNp      =   candidate_affineROIs_6xNp(:,idx);  %keep only good candidates (resample)
    end

%2. apply motion        candidate parameters -> (a). motion model -> (b). new candidate parameters -> (c). new candidate images
    delta_motion_6xNp       =   rn2.*repmat(INP.ds_5_affROIvar_1x6(:),[1,Np]);       %a. motion model
    candidate_affineROIs_6xNp      	=   candidate_affineROIs_6xNp + delta_motion_6xNp;                     %b. candidate parameters
    candidate_snippets_0t1_shxswxNp =   UTIL_2D_warp_image(I_0t1, UTIL_2D_affine_tllptxty_to_abcdtxty(candidate_affineROIs_6xNp), [sh sw]);  %c. candidate images
    
%----------------------------
%PROCESSING
%----------------------------
%3. weighting (find how well the algorithm model explains each snippet, find distances)

    %generic algo
    if (strcmp(TRK.name, 'genericPF')) 
        all_candidate_errors_0to1_DxNp             =   repmat(state_2_mu_Dx1(:),[1,Np]) - reshape(candidate_snippets_0t1_shxswxNp,[D,Np]); %all_candidate_errors_0to1_DxNp: (sw)(sh) x Np
        DIFS                        =   0;
        
        
    %iPCA    
    elseif (strcmp(TRK.name, 'trkIPCA'))
        U_DxB                       =   ALGO.mdl_2_U_DxB;   
        S_Bx1                       =   ALGO.mdl_4_S_Bx1;
             
        %part 1: error, distance from mean (err vector points to mean)
        all_candidate_errors_0to1_DxNp       =   repmat(mu_Dx1(:),[1,Np]) - reshape(candidate_snippets_0t1_shxswxNp,[D,Np]); %all_candidate_errors_0to1_DxNp: (sw)(sh) x Np
        DIFS                =   0;
        
        %part 2: error, reduce the part that can be explained by the basis
            err_projScalars_BxNp    =   U_DxB'*all_candidate_errors_0to1_DxNp;              %error projection on basis: scalars
            err_projVectors_DxNp    =   U_DxB*err_projScalars_BxNp;        %error projection on basis: vectors
            all_candidate_errors_0to1_DxNp         =   all_candidate_errors_0to1_DxNp - err_projVectors_DxNp;   %this is DFFS
                                                        
            
            %compute DIFS for use with PPCA, if not using PPCA, not required
            if (isfield(TRK,'err_projScalars_BxNp'))
                DIFS            				=   (abs(err_projScalars_BxNp)-abs(TRK.err_projScalars_BxNp))*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
            else
                DIFS            				=   err_projScalars_BxNp                               .*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
            end
            TRK.err_projScalars_BxNp 			=   err_projScalars_BxNp;
        
        
	
        
    %bPCA    
    elseif (strcmp(TRK.name, 'trkBPCA'))
        all_candidate_errors_0to1_DxNp         	= 	[];
        for i = 1:Np
            Itst                    			=   255*candidate_snippets_0t1_shxswxNp(:,:,i);
            ALGO                    			=   bPCA_3_test(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i) =   ALGO.tst_3_error_DxN/255;                                
        end

        
        temp_DxNp = zeros(D,Np);
        
        
    %RVQ    
    elseif (strcmp(TRK.name, 'trkRVQ')) 
        all_candidate_errors_0to1_DxNp        	= 	[];
        for i = 1:Np
            Itst                    			=   255*candidate_snippets_0t1_shxswxNp(:,:,i);
            ALGO                    			=   RVQ__testing_grayscale(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i) =   (abs(ALGO.tst_3_error_DxN) + RVQ.in_10_lambda*(ALGO.maxP-ALGO.P))/255;
        end
        
        
    %TSVQ
    elseif (strcmp(TRK.name, 'trkTSVQ'))
        all_candidate_errors_0to1_DxNp         	= 	[];
        for i = 1:Np
            Itst                    			=   255*candidate_snippets_0t1_shxswxNp(:,:,i);
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
    best_affine2_1x6         =   UTIL_2D_affine_tllptxty_to_abcdtxty(candidate_affineROIs_6xNp(:,maxidx));  %best 1. affine ROI 
    
	%three instantaneous variables
	best_snippet_0t1_shxsw  =   candidate_snippets_0t1_shxswxNp(:,:,maxidx);        %best 2. best snippet 
    best_error_0to1_Dx1     =   all_candidate_errors_0to1_DxNp(:,maxidx);           %best 3. best error 
    best_error_0to1_shxsw   =   reshape(best_error_0to1_Dx1, [sh sw]);
    if 	   (INP.ds_1_code==0 || 1) 
        best_error_0to1_shxsw =   -best_error_0to1_shxsw;                           
    end
    best_recon_shxsw        =   best_snippet_0t1_shxsw - best_error_0to1_shxsw;     %best 4. best recon
	
%----------------------------
%POST-PROCESSING
%----------------------------
%save
    %three (3) instantaneous variables
    TRK.insta_1_snp_0t1_shxsw =   best_snippet_0t1_shxsw;                     %best snippet in image, i.e. it's best explained by my model
    TRK.insta_2_recon_shxsw   =   best_recon_shxsw;                           %my model's reconstruction of this best snippet
    TRK.insta_3_error_shxsw   =   best_error_0to1_shxsw;                      %the error
	
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
    TRK.state_1_DM2         =   [state_1_DM2 TRK.insta_1_snp_0t1_shxsw(:)];%update snippet library
    if 	   (strcmp(TRK.name, 'BPVQ') || strcmp(TRK.name, 'RVQ') || strcmp(TRK.name, 'TSVQ')) %not needed for IPCA since it has its own forgetting factor
        TRK.state_1_DM2     =   DATAMATRIX_pick_last_Nw_values_in_DM2(TRK.state_1_DM2, Nw, bWeighting); 
    end                                                                                                       
    TRK.state_3_weights     =   weights;
    TRK.state_4_best_affine2_1x6 = best_affine2_1x6;
    
%tracking error        
    TRK.fp_2_est                    =   TRK.state_4_best_affine2_1x6([3,4,1;5,6,2]) ...
                                        * ...
                                       [INP.gt_3_initial_fp; ones(1,INP.gt_2_num_fp)];
    TRK.fp_1_gt                     =   cat(3, ...
                                        INP.gt_3_initial_fp+repmat(PARAM.tgt_sz'/2,[1,INP.gt_2_num_fp]), ...
                                        INP.gt_1_fp(:,:,f), ...
                                        TRK.fp_2_est);
    idx                             =   find(TRK.fp_1_gt(1,:,2) > 0);
    if (length(idx) > 0)
        TRK.fp_3_err(f)             =   sqrt(mean(sum((TRK.fp_1_gt(:,idx,2)-TRK.fp_1_gt(:,idx,3)).^2,1)));
    else
        TRK.fp_3_err(f)             =   nan;
    end
        
