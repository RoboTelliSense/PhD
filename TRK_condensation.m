%> @file TRK_condensation.m
%> @brief This function implements the particle filter (condensation algorithm).
% 
% 0t1 means that the min value is 0, max value is 1.
%
% I_0t1 is the input image.
% f is the frame number.
%
%> ALGO.mdl_2_U_DxB               :   basis, normally, I would write U_DxN, but
%>                              here I use mdl_2_U_DxB because B is the number of
%>                              training examples in one batch
% TRK is the structure that holds information about the
% condensation algorithm.  It has the following members:
%    (a) tgt_best_affineROI_1x6: MAP estimate of best affine parameters that describe target bounding region
%    (b) affineCandidates_6xNp: possible affine candidates that describe target bounding region
%    weights
%    err_projScalars_BxNp
%    bestCandidate_0t1_shxsw
%    PFerr_0to1_DxNp
%    recon
%    tst_4_SNRdB_1x1
%    tst_5_rmse__1x1
%
% INP.ds_5_affineROIvar_1x6
%
% Copyright (C) Jongwoo Lim and David Ross (modified by Salman Aslam with permission)
% Date created      : April 25, 2011
% Date last modified: July 18, 2011
%%

function [ALGO, TRK] = TRK_condensation(f, INP, PARAM, I_0t1, ALGO, TRK)
%----------------------------
%INITIALIZATIONS
%----------------------------
    sw                              =   PARAM.tgt_sw;                    %snippet width
    sh                              =   PARAM.tgt_sh;                    %snippet height
    D                               =   sw*sh;                      %dimensionality of input data
    
    Np                              =   PARAM.in_Np;               %particle filter: # of particles (samples) from density)
    rn1                             =   INP.rn_2_cdf_maxFxNp(f,:);        %pre-stored random numbers to ensure repeatability    
    rn2(:,:)                        =   INP.random_affine_maxFx6xNp(f,:,:);   %same as above
    
%----------------------------
%PRE-PROCESSING
%----------------------------
%1. resample on candidate parameters        %although here it's done at the beginning, it's really being done at the end.
                                            %the reason is that in the first run, initialization is done, but not resampling.
                                            %then motion model is applied after resampling.  so after the initialization)

    if ~isfield(TRK,'affineCandidates_6xNp')
        %one time: initialize 6 affine parameters, one for each of the Np candidate snippets
        PF_cndPrm_6xNp      =   repmat(  affparam2geom(TRK.affineROI_1x6(:)), [1,Np]  );         %initialized candidates with hand labeled parameters (one time)
                                    
    else
        %recurring: resample distribution in 3 lines (read details of this in my article on resampling)
        cumconf             =   cumsum(TRK.weights);
        idx                 =   floor(sum(  repmat(rn1,[Np,1]) > repmat(cumconf,[1,Np])  ))+1; 
        PF_cndPrm_6xNp      =   PF_cndPrm_6xNp(:,idx);  %keep only good candidates (resample)
    end

%2. apply motion        candidate parameters -> (a). motion model -> (b). new candidate parameters -> (c). new candidate images
    delta_motion_6xNp       =   rn2.*repmat(INP.ds_5_affineROIvar_1x6(:),[1,Np]);       %a. motion model
    PF_cndPrm_6xNp      	=   PF_cndPrm_6xNp + delta_motion_6xNp;                     %b. candidate parameters
    PF_cndImg_0t1_shxswxNp  =   warpimg(I_0t1, affparam2mat(PF_cndPrm_6xNp), [sh sw]);  %c. candidate images
    
%----------------------------
%PROCESSING
%----------------------------
%3a. weighting (find how well the algorithm model explains each snippet, find distances)

    %generic algo
    if (strcmp(ALGO.in_1_name, 'genericPF')) 
        PFerr_0to1_DxNp             =   repmat(ALGO.mdl_2_mu_Dx1(:),[1,Np]) - reshape(PF_cndImg_0t1_shxswxNp,[D,Np]); %PFerr_0to1_DxNp: (sw)(sh) x Np
        DIFS                        =   0;
    
        
    %iPCA    
    elseif (strcmp(ALGO.in_1_name, 'IPCA'))
        
        U = ALGO.mdl_2_U_DxB;
        
        %part 1: error, distance from mean (err vector points to mean)
        PFerr_0to1_DxNp       =   repmat(ALGO.mdl_2_mu_Dx1(:),[1,Np]) - reshape(PF_cndImg_0t1_shxswxNp,[D,Np]); %PFerr_0to1_DxNp: (sw)(sh) x Np
        DIFS                =   0;
        
        %part 2: error, reduce the part that can be explained by the basis
            err_projScalars_BxNp    =   U'*PFerr_0to1_DxNp;              %error projection on basis: scalars
            err_projVectors_DxNp    =   U*err_projScalars_BxNp;        %error projection on basis: vectors
            PFerr_0to1_DxNp         =   PFerr_0to1_DxNp - err_projVectors_DxNp;   %this is DFFS
                                                        
            
            %compute DIFS for use with PPCA, if not using PPCA, not required
            if (isfield(TRK,'err_projScalars_BxNp'))
                DIFS            =   (abs(err_projScalars_BxNp)-abs(TRK.err_projScalars_BxNp))*PARAM.con_reseig./repmat(ALGO.mdl_4_S_Bx1,[1,Np]);
            else
                DIFS            =   err_projScalars_BxNp                               .*PARAM.con_reseig./repmat(ALGO.mdl_4_S_Bx1,[1,Np]);
            end
            TRK.err_projScalars_BxNp=   err_projScalars_BxNp;
        
        
	
        
    %bPCA    
    elseif (strcmp(ALGO.in_1_name, 'BPCA'))
        PFerr_0to1_DxNp               = 	[];
        for i = 1:Np
            Itst                    =   255*PF_cndImg_0t1_shxswxNp(:,:,i);
            ALGO                    =   bPCA_3_test(Itst(:), ALGO);
            PFerr_0to1_DxNp(:,i)   	=   ALGO.tst_3_error_DxN/255;                                
        end

        
        temp_DxNp = zeros(D,Np);
        
        
    %RVQ    
    elseif (strcmp(ALGO.in_1_name, 'RVQ')) 
        PFerr_0to1_DxNp               = 	[];
        for i = 1:Np
            Itst                    =   255*PF_cndImg_0t1_shxswxNp(:,:,i);
            ALGO                    =   RVQ__testing_grayscale(Itst(:), ALGO);
            %PFerr_0to1_DxNp(:,i)     =   ALGO.tst_3_error_DxN/255;                                
            PFerr_0to1_DxNp(:,i)      =   (abs(ALGO.tst_3_error_DxN) + 0.5*(ALGO.maxP-ALGO.P))/255;
        end
        
        
    %TSVQ
    elseif (strcmp(ALGO.in_1_name, 'TSVQ'))
        PFerr_0to1_DxNp               = 	[];
        for i = 1:Np
            Itst                    =   255*PF_cndImg_0t1_shxswxNp(:,:,i);
            ALGO                    =   TSVQ_3_test(Itst(:), ALGO);
            PFerr_0to1_DxNp(:,i)   	=   ALGO.tst_3_error_DxN/255;                                
        end
    end

%3b. raise distances to exponentials
    stddev                          =   INP.ds_7_con_stddev;
    DFFS                            =   PFerr_0to1_DxNp;
    switch (PARAM.con_errfunc)
        case 'robust'; TRK.weights  =   exp(- sum(DFFS.^2./(DFFS.^2 + PARAM.rsig.^2))./stddev)';%PARAM.rsig never defined
        case 'ppca';   TRK.weights  =   exp(-(     sum(DFFS.^2)+ sum(DIFS.^2)        )./stddev)';
        otherwise;     TRK.weights  =   exp(-      sum(DFFS.^2                       )./stddev)';
    end

%4. pick MAP estimate
    TRK.weights                     =   TRK.weights ./ sum(TRK.weights);                    %normalize weights
    [maxprob,maxidx]                =   max(TRK.weights);                                   %MAP estimate: pick best index
    TRK.affineROI_1x6          =   affparam2mat(PF_cndPrm_6xNp(:,maxidx));  %MAP estimate: pick best affine parameters based on best index          
    TRK.bestCandidate_0t1_shxsw         =   PF_cndImg_0t1_shxswxNp(:,:,maxidx);                %MAP estimate: pick best candidate snippet based on best index                
        

%----------------------------
%POST-PROCESSING
%----------------------------
%error and reconstruction
    TRK.err_0to1_shxsw            =   reshape(PFerr_0to1_DxNp(:,maxidx), [sh sw]);                            %get reconstruction error
    if 	   (INP.ds_1_code==0 || 1) 
        TRK.err_0to1_shxsw        =   -TRK.err_0to1_shxsw; 
    end
    TRK.recon                       =   TRK.bestCandidate_0t1_shxsw - TRK.err_0to1_shxsw; %get reconstructed image

%metrics    
    TRK.tst_4_SNRdB_1x1                   =   UTIL_METRICS_compute_SNRdB       (TRK.bestCandidate_0t1_shxsw(:), TRK.err_0to1_shxsw(:));
    TRK.tst_5_rmse__1x1                    =   UTIL_METRICS_compute_rms_value (TRK.err_0to1_shxsw(:)*255);
    
%DM2
    %update
    ALGO.DM2                        =   [ALGO.DM2 TRK.bestCandidate_0t1_shxsw(:)];%update snippet library
    
    %incorporate weighting and forgetting factor
    if 	   (INP.ds_1_code==2 || INP.ds_1_code==3 || INP.ds_1_code==4) %not needed for IPCA since it has its own forgetting factor
		ALGO.DM2_weighted           =   DATAMATRIX_pick_last_Nw_values_in_DM2(ALGO.DM2, PARAM.Nw, PARAM.bWeighting); 
    end                                                                                                       
    
        TRK.tst_RMSE_Fx1(f)         =	TRK.tst_5_rmse__1x1;
        TRK.tst_RMSEavg_Fx1(f)      =   UTIL_compute_avg(TRK.tst_RMSE_Fx1(1:f));
    
%tracking error        
    TRK.fp_2_est                    =   TRK.affineROI_1x6([3,4,1;5,6,2]) ...
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
        
