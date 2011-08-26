%% This function implements the particle filter (condensation algorithm).
%
% 0t1 means that the min value is 0, max value is 1.
%
% I_0t1 is the input image.
% f is the frame number.
%
% TRK is the structure that holds information about the
% condensation algorithm.  It has the following members:
%    (a) best_affineROI_1x6: MAP estimate of best affine parameters that describe target bounding region
%    (b) affineCandidates_6xNp: possible affine candidates that describe target bounding region
%    weights
%    coef
%    tst_best_0t1
%    err_0to1_DxNp
%    recon
%    tst_SNRdB
%    tst_rmse
%
% CONFIG.var_affineROI_1x6
%
% Copyright (C) Jongwoo Lim and David Ross (modified by Salman Aslam with permission)
% Date created      : April 25, 2011
% Date last modified: July 14, 2011
%%

function TRK = TRK_condensation(I_0t1, f, ALGO, TRK, CONFIG, RandomData_sample, RandomData_cdf, algo_code)
%----------------------------
%INITIALIZATIONS
%----------------------------
    sw                      =   ALGO.sw;          %snippet width
    sh                      =   ALGO.sh;          %snippet height
    sz                      =   [sh sw];    
    D                       =   sw*sh;                   %dimensionality of input data
    
    Np                      =   CONFIG.in_Np;       %particle filter: # of particles (samples) from density)
    rn1                     =   RandomData_cdf(f,:);     %pre-stored random numbers to ensure repeatability    
    rn2(:,:)                =   RandomData_sample(f,:,:);%same as above
    
%----------------------------
%PRE-PROCESSING
%----------------------------
%1. resample (although here it's done at the beginning, it's really being done at the end.
%the reason is that in the first run, initialization is done, but not resampling.
%then motion model is applied after resampling.  so after the initialization)

    if ~isfield(TRK,'affineCandidates_6xNp')
        %one time: initialize 6 affine parameters, one for each of the Np candidate snippets
        TRK.affineCandidates_6xNp       ...  %initialized with hand labeled parameters
                            =   repmat(  affparam2geom(TRK.best_affineROI_1x6(:)), [1,Np]  );        %initialize candidates (one time)
    else
        %recurring: resample distribution in 3 lines (read details of this in my article on resampling)
        cumconf             =   cumsum(TRK.weights);
        idx                 =   floor(sum(  repmat(rn1,[Np,1]) > repmat(cumconf,[1,Np])  ))+1; 
        TRK.affineCandidates_6xNp       ...
                            =   TRK.affineCandidates_6xNp(:,idx);  %keep only good candidates (resample)
    end

%2. apply motion model (brownian, so just add randomness)
    delta_affineCandidates_6xNp=   rn2.*repmat(CONFIG.var_affineROI_1x6(:),[1,Np]); %rn2 is 
    TRK.affineCandidates_6xNp           ...
                            =   TRK.affineCandidates_6xNp + delta_affineCandidates_6xNp;

    %extract the candidate snippets from the image based on motion model above
    PFcandidateSnippets_0t1 =   warpimg(I_0t1, affparam2mat(TRK.affineCandidates_6xNp), sz);  %now create actual snippet candidates
    
%----------------------------
%PROCESSING
%----------------------------
%3a. weighting (find how well the algorithm model explains each snippet, find distances)
    if (algo_code==1) %i.e. iPCA    
        
        err_0to1_DxNp            =   repmat(ALGO.mean(:),[1,Np]) - reshape(PFcandidateSnippets_0t1,[D,Np]); %err_0to1_DxNp: (sw)(sh) x Np
        coefdiff            =   0;
        
        if (size(ALGO.basis,2) > 0)
            coef            =   ALGO.basis'*err_0to1_DxNp;
            err_0to1_DxNp        	=   err_0to1_DxNp - ALGO.basis*coef;
            if (isfield(TRK,'coef'))
                coefdiff    =   (abs(coef)-abs(TRK.coef))*ALGO.reseig./repmat(ALGO.eigval,[1,Np]);
            else
                coefdiff    =   coef .* ALGO.reseig ./ repmat(ALGO.eigval,[1,Np]);
            end
            TRK.coef=   coef;
        end
        
	
        
        
    elseif(algo_code==2) %i.e. bPCA
        err_0to1_DxNp       = 	[];
        for i = 1:Np
            Itst            =   255*PFcandidateSnippets_0t1(:,:,i);
            ALGO     		=   bPCA_3_test(Itst(:), ALGO);
            err_0to1_DxNp(:,i)   	=   ALGO.tst_err_Dx1/255;                                
        end

        
        temp_DxNp = zeros(D,Np);
    elseif(algo_code==3) %i.e. RVQ
        err_0to1_DxNp     	= 	[];
        %ALGO.rule_stop_decoding = 'monotonic_PSNR';
        ALGO.rule_stop_decoding = 'realm_of_experience';
        for i = 1:Np
            Itst          	=   255*PFcandidateSnippets_0t1(:,:,i);
            ALGO           =   RVQ__testing_grayscale(Itst(:), ALGO);
            %err_0to1_DxNp(:,i)  ...
            %                =   ALGO.tst_err_Dx1/255;                                
            err_0to1_DxNp(:,i)  ...
                            =   (abs(ALGO.tst_err_Dx1) + 0.5*(ALGO.maxP-ALGO.P))/255;
        end
        
        

    elseif(algo_code==4) %i.e. TSVQ
        err_0to1_DxNp      	= 	[];
        for i = 1:Np
            Itst        	=   255*PFcandidateSnippets_0t1(:,:,i);
            ALGO     		=   TSVQ_3_test(Itst(:), ALGO);
            err_0to1_DxNp(:,i)   	=   ALGO.tst_err_Dx1/255;                                
        end
    end

%3b. raise distances to exponentials
    stddev                  =   CONFIG.con_stddev;
    err                     =   err_0to1_DxNp;
    switch (CONFIG.con_errfunc)
        case 'robust'; TRK.weights =   exp(- sum(err.^2./(err.^2 + CONFIG.rsig.^2))                   ./stddev)';%CONFIG.rsig never defined
        case 'ppca';   TRK.weights =   exp(-(sum(err.^2                           )+ sum(coefdiff.^2))./stddev)';
        otherwise;     TRK.weights =   exp(- sum(err.^2                           )                   ./stddev)';
    end

%4. pick MAP estimate
    TRK.weights     =   TRK.weights ./ sum(TRK.weights);            %normalize weights
    [maxprob,maxidx]        =   max(TRK.weights);                                   %MAP estimate: pick best index
    TRK.best_affineROI_1x6 ...
                            =   affparam2mat(TRK.affineCandidates_6xNp(:,maxidx));  %MAP estimate: pick best affine parameters based on best index          
    TRK.tst_best_0t1 ...
                            =   PFcandidateSnippets_0t1(:,:,maxidx);                        %MAP estimate: pick best candidate snippet based on best index                
        

%----------------------------
%POST-PROCESSING
%----------------------------
%error and reconstruction
    TRK.err_0to1_sw_x_sh    =   reshape(err_0to1_DxNp(:,maxidx), sz);                            %get reconstruction error
    if 	   (algo_code==1) 
        TRK.err_0to1_sw_x_sh=   -TRK.err_0to1_sw_x_sh; 
    end
    TRK.recon               =   TRK.tst_best_0t1 - TRK.err_0to1_sw_x_sh; %get reconstructed image

%metrics    
    TRK.tst_SNRdB           =   UTIL_METRICS_compute_SNR       (TRK.tst_best_0t1, TRK.err_0to1_sw_x_sh);
    TRK.tst_rmse            =   UTIL_METRICS_compute_rms_value (TRK.err_0to1_sw_x_sh(:)*255);
    
%DM2
    %update
    ALGO.DM2                =   [ALGO.DM2 TRK.tst_best_0t1(:)];%update snippet library
    
    %incorporate weighting and forgetting factor
    if 	   (algo_code==2 || algo_code==3 || algo_code==4) %not needed for IPCA since it has its own forgetting factor
		ALGO.DM2_weighted =   DATAMATRIX_pick_last_Nw_values_in_DM2(ALGO.DM2, CONFIG.Nw, CONFIG.bWeighting); 
    end                                                                                                       
    
