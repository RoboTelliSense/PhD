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
%    (a) tgt_best_affROI_1x6: MAP estimate of best affine parameters that describe target bounding region
%    (b) affineCandidates_6xNp: possible affine candidates that describe target bounding region
%    weights
%    err_projScalars_BxNp
%    out_1_snp_0t1_shxsw
%    all_candidate_errors_0to1_DxNp
%    recon
%    out_4_SNRdB_1x1
%    out_5_rmse__1x1
%
% INP.ds_5_affROIvar_1x6
%
% requirement
% TRK.state_3_best_affROI_1x6
% Copyright (C) Jongwoo Lim and David Ross (modified by Salman Aslam with permission)
% Date created      : April 25, 2011
% Date last modified: July 18, 2011
%%

function [ALGO, TRK] = TRK_condensation(f, INP, PARAM, I_0t1, ALGO, TRK)
%----------------------------
%INITIALIZATIONS
%----------------------------
    sw                              =   PARAM.tgt_sw;                       %snippet width
    sh                              =   PARAM.tgt_sh;                       %snippet height
    D                               =   sw*sh;                              %dimensionality of input data
    
    Np                              =   PARAM.in_Np;                        %particle filter: # of particles (samples) from density)
    rn1                             =   INP.rand_cdf_maxFxNp(f,:);          %pre-stored random numbers to ensure repeatability    
    rn2(:,:)                        =   INP.rand_unitvar_maxFx6xNp(f,:,:);  %same as above
    
%state variables (use and then update) 
    state_1_DM2                     =   TRK.state_1_DM2;
    state_2_weights                 =   TRK.state_2_weights;
    state_3_best_affROI_1x6         =   TRK.state_3_best_affROI_1x6(:);
    
%all data used from ALGO structure, use but do not update
    algo_name                       =   ALGO.in_1_name;
    mu_Dx1                          =   ALGO.mdl_2_mu_Dx1;
    if (strcmp(algo_name, 'IPCA'))    
        U_DxB                       =   ALGO.mdl_2_U_DxB;   
        S_Bx1                       =   ALGO.mdl_4_S_Bx1;
    end
%----------------------------
%PRE-PROCESSING
%----------------------------
%1. resample candidate parameters           %although here it's done at the beginning, it's really being done at the end.
                                            %the reason is that in the first run, initialization is done, but not resampling.
                                            %then motion model is applied after resampling.  so after the initialization)

    if ~isfield(TRK,'affineCandidates_6xNp')
        %one time: initialize 6 affine parameters, one for each of the Np candidate snippets
        candidate_affineROIs_6xNp      =   repmat(  affparam2geom(state_3_best_affROI_1x6(:)), [1,Np]  );         %initialized candidates with hand labeled parameters (one time)
                                    
    else
        %recurring: resample distribution in 3 lines (read details of this in my article on resampling)
        cumconf             =   cumsum(state_2_weights);
        idx                 =   floor(sum(  repmat(rn1,[Np,1]) > repmat(cumconf,[1,Np])  ))+1; 
        candidate_affineROIs_6xNp      =   candidate_affineROIs_6xNp(:,idx);  %keep only good candidates (resample)
    end

%2. apply motion        candidate parameters -> (a). motion model -> (b). new candidate parameters -> (c). new candidate images
    delta_motion_6xNp       =   rn2.*repmat(INP.ds_5_affROIvar_1x6(:),[1,Np]);       %a. motion model
    candidate_affineROIs_6xNp      	=   candidate_affineROIs_6xNp + delta_motion_6xNp;                     %b. candidate parameters
    candidate_snippets_0t1_shxsw  =   warpimg(I_0t1, affparam2mat(candidate_affineROIs_6xNp), [sh sw]);  %c. candidate images
    
%----------------------------
%PROCESSING
%----------------------------
%3a. weighting (find how well the algorithm model explains each snippet, find distances)

    %generic algo
    if (strcmp(algo_name, 'genericPF')) 
        all_candidate_errors_0to1_DxNp             =   repmat(mu_Dx1(:),[1,Np]) - reshape(candidate_snippets_0t1_shxsw,[D,Np]); %all_candidate_errors_0to1_DxNp: (sw)(sh) x Np
        DIFS                        =   0;
    
        
    %iPCA    
    elseif (strcmp(algo_name, 'IPCA'))
             
        %part 1: error, distance from mean (err vector points to mean)
        all_candidate_errors_0to1_DxNp       =   repmat(mu_Dx1(:),[1,Np]) - reshape(candidate_snippets_0t1_shxsw,[D,Np]); %all_candidate_errors_0to1_DxNp: (sw)(sh) x Np
        DIFS                =   0;
        
        %part 2: error, reduce the part that can be explained by the basis
            err_projScalars_BxNp    =   U_DxB'*all_candidate_errors_0to1_DxNp;              %error projection on basis: scalars
            err_projVectors_DxNp    =   U_DxB*err_projScalars_BxNp;        %error projection on basis: vectors
            all_candidate_errors_0to1_DxNp         =   all_candidate_errors_0to1_DxNp - err_projVectors_DxNp;   %this is DFFS
                                                        
            
            %compute DIFS for use with PPCA, if not using PPCA, not required
            if (isfield(TRK,'err_projScalars_BxNp'))
                DIFS            =   (abs(err_projScalars_BxNp)-abs(TRK.err_projScalars_BxNp))*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
            else
                DIFS            =   err_projScalars_BxNp                               .*PARAM.con_reseig./repmat(S_Bx1,[1,Np]);
            end
            TRK.err_projScalars_BxNp=   err_projScalars_BxNp;
        
        
	
        
    %bPCA    
    elseif (strcmp(algo_name, 'BPCA'))
        all_candidate_errors_0to1_DxNp               = 	[];
        for i = 1:Np
            Itst                    =   255*candidate_snippets_0t1_shxsw(:,:,i);
            ALGO                    =   bPCA_3_test(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i)   	=   ALGO.tst_3_error_DxN/255;                                
        end

        
        temp_DxNp = zeros(D,Np);
        
        
    %RVQ    
    elseif (strcmp(algo_name, 'RVQ')) 
        all_candidate_errors_0to1_DxNp               = 	[];
        for i = 1:Np
            Itst                    =   255*candidate_snippets_0t1_shxsw(:,:,i);
            ALGO                    =   RVQ__testing_grayscale(Itst(:), ALGO);
            %all_candidate_errors_0to1_DxNp(:,i)     =   ALGO.tst_3_error_DxN/255;                                
            all_candidate_errors_0to1_DxNp(:,i)      =   (abs(ALGO.tst_3_error_DxN) + 0.5*(ALGO.maxP-ALGO.P))/255;
        end
        
        
    %TSVQ
    elseif (strcmp(algo_name, 'TSVQ'))
        all_candidate_errors_0to1_DxNp               = 	[];
        for i = 1:Np
            Itst                    =   255*candidate_snippets_0t1_shxsw(:,:,i);
            ALGO                    =   TSVQ_3_test(Itst(:), ALGO);
            all_candidate_errors_0to1_DxNp(:,i)   	=   ALGO.tst_3_error_DxN/255;                                
        end
    end

%3b. posterior
    stddev                          =   INP.ds_7_con_stddev;
    DFFS                            =   all_candidate_errors_0to1_DxNp;
    switch (PARAM.con_errfunc)
        case 'robust'; temp_weights  =   exp(- sum(DFFS.^2./(DFFS.^2 + PARAM.rsig.^2))./stddev)';%PARAM.rsig never defined
        case 'ppca';   temp_weights  =   exp(-(     sum(DFFS.^2)+ sum(DIFS.^2)        )./stddev)';
        otherwise;     temp_weights  =   exp(-      sum(DFFS.^2                       )./stddev)';
    end
    weights                 =   temp_weights ./ sum(temp_weights);          %normalize weights
    [maxprob,maxidx]        =   max(weights);                               %MAP estimate: pick best index
    
    
%4. pick MAP estimate
    state_3_best_affROI_1x6         =   affparam2mat(candidate_affineROIs_6xNp(:,maxidx));     %MAP estimate: pick best affine parameters based on best index          

    best_snippet_0t1_shxsw  =   candidate_snippets_0t1_shxsw(:,:,maxidx);                %MAP estimate: pick best candidate snippet based on best index                
    best_error_0to1_Dx1     =   all_candidate_errors_0to1_DxNp(:,maxidx)
    best_error_0to1_shxsw   =   reshape(best_error_0to1_Dx1, [sh sw]);
    if 	   (INP.ds_1_code==0 || 1) 
        best_error_0to1_shxsw =   -best_error_0to1_shxsw; 
    end
    best_recon_shxsw        =   best_snippet_0t1_shxsw - best_error_0to1_shxsw;
%----------------------------
%POST-PROCESSING
%----------------------------
%save
    %decisions taken for this frame
    TRK.out_1_snp_0t1_shxsw =   best_snippet_0t1_shxsw;                     %best snippet in image, i.e. it's best explained by my model
    TRK.out_2_recon_shxsw   =   best_recon_shxsw;                           %my model's reconstruction of this best snippet
    TRK.out_3_error_shxsw   =   best_error_0to1_shxsw;                      %the error
    TRK.out_4_SNRdB_1x1     =   UTIL_METRICS_compute_SNRdB       (best_snippet_0t1_shxsw(:), best_error_0to1_shxsw(:)    );
    TRK.out_5_rmse__Fx1(f)  =   UTIL_METRICS_compute_rms_value   (                           best_error_0to1_shxsw(:)*255);
    TRK.out_6_armse_Fx1(f)  =   UTIL_compute_avg(TRK.out_5_rmse__Fx1(1:f));
    
    %state variables
    TRK.state_1_DM2         =   [state_1_DM2 TRK.out_1_snp_0t1_shxsw(:)];%update snippet library
    if 	   (INP.ds_1_code==2 || INP.ds_1_code==3 || INP.ds_1_code==4) %not needed for IPCA since it has its own forgetting factor
		TRK.state_2_DM2_weighted           =   DATAMATRIX_pick_last_Nw_values_in_DM2(TRK.state_1_DM2, PARAM.Nw, PARAM.bWeighting); 
    end                                                                                                       
    TRK.state_3_weights     =   weights;
    TRK.state_4_best_affROI_1x6 = state_3_best_affROI_1x6;
    
%tracking error        
    TRK.fp_2_est                    =   TRK.state_3_best_affROI_1x6([3,4,1;5,6,2]) ...
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
        
