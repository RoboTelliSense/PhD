%% This function implements the particle filter (condensation algorithm).
%
% 0t1 means that the min value is 0, max value is 1.
%
% I_0t1 is the input image.
% f is the frame number.
%
% sCondensation is the structure that holds information about the
% condensation algorithm.  It has the following members:
%    (a) best_vecAff_1x6: MAP estimate of best affine parameters that describe target bounding region
%    (b) affineCandidates_6xNp: possible affine candidates that describe target bounding region
%    weights
%    coef
%    tst_bestPFcandidate_0t1
%    err_0to1_DxNp
%    recon
%    tst_snr
%    tst_rmse
%
% sOptions.vecAff_variance_1x6
%
% Copyright (C) Jongwoo Lim and David Ross (modified by Salman Aslam with permission)
% Date created      : April 25, 2011
% Date last modified: July 14, 2011
%%

function sCondensation = TRK_condensation(I_0t1, f, sAlgo, sCondensation, sOptions, RandomData_sample, RandomData_cdf, algo_code)
%----------------------------
%INITIALIZATIONS
%----------------------------
    sw                      =   sAlgo.sw;          %snippet width
    sh                      =   sAlgo.sh;          %snippet height
    sz                      =   [sh sw];    
    D                       =   sw*sh;                   %dimensionality of input data
    
    Np                      =   sOptions.Np;       %particle filter: # of particles (samples) from density)
    rn1                     =   RandomData_cdf(f,:);     %pre-stored random numbers to ensure repeatability    
    rn2(:,:)                =   RandomData_sample(f,:,:);%same as above
    
%----------------------------
%PRE-PROCESSING
%----------------------------
%1. resample (although here it's done at the beginning, it's really being done at the end.
%the reason is that in the first run, initialization is done, but not resampling.
%then motion model is applied after resampling.  so after the initialization)

    if ~isfield(sCondensation,'affineCandidates_6xNp')
        %one time: initialize 6 affine parameters, one for each of the Np candidate snippets
        sCondensation.affineCandidates_6xNp       ...  %initialized with hand labeled parameters
                            =   repmat(  affparam2geom(sCondensation.best_vecAff_1x6(:)), [1,Np]  );        %initialize candidates (one time)
    else
        %recurring: resample distribution in 3 lines (read details of this in my article on resampling)
        cumconf             =   cumsum(sCondensation.weights);
        idx                 =   floor(sum(  repmat(rn1,[Np,1]) > repmat(cumconf,[1,Np])  ))+1; 
        sCondensation.affineCandidates_6xNp       ...
                            =   sCondensation.affineCandidates_6xNp(:,idx);  %keep only good candidates (resample)
    end

%2. apply motion model (brownian, so just add randomness)
    delta_affineCandidates_6xNp=   rn2.*repmat(sOptions.vecAff_variance_1x6(:),[1,Np]); %rn2 is 
    sCondensation.affineCandidates_6xNp           ...
                            =   sCondensation.affineCandidates_6xNp + delta_affineCandidates_6xNp;

    %extract the candidate snippets from the image based on motion model above
    PFcandidateSnippets_0t1 =   warpimg(I_0t1, affparam2mat(sCondensation.affineCandidates_6xNp), sz);  %now create actual snippet candidates
    
%----------------------------
%PROCESSING
%----------------------------
%3a. weighting (find how well the algorithm model explains each snippet, find distances)
    if (algo_code==1) %i.e. iPCA    
        
        err_0to1_DxNp            =   repmat(sAlgo.mean(:),[1,Np]) - reshape(PFcandidateSnippets_0t1,[D,Np]); %err_0to1_DxNp: (sw)(sh) x Np
        coefdiff            =   0;
        
        if (size(sAlgo.basis,2) > 0)
            coef            =   sAlgo.basis'*err_0to1_DxNp;
            err_0to1_DxNp        	=   err_0to1_DxNp - sAlgo.basis*coef;
            if (isfield(sCondensation,'coef'))
                coefdiff    =   (abs(coef)-abs(sCondensation.coef))*sAlgo.reseig./repmat(sAlgo.eigval,[1,Np]);
            else
                coefdiff    =   coef .* sAlgo.reseig ./ repmat(sAlgo.eigval,[1,Np]);
            end
            sCondensation.coef=   coef;
        end
        
	
        
        
    elseif(algo_code==2) %i.e. bPCA
        err_0to1_DxNp       = 	[];
        for i = 1:Np
            Itst            =   255*PFcandidateSnippets_0t1(:,:,i);
            sAlgo     		=   bPCA_3_test(Itst(:), sAlgo);
            err_0to1_DxNp(:,i)   	=   sAlgo.tst_err_Dx1/255;                                
        end

        
        
    elseif(algo_code==3) %i.e. RVQ
        err_0to1_DxNp     	= 	[];
        sAlgo.rule_stop_decoding = 'monotonic_PSNR';
        sAlgo.rule_stop_decoding = 'realm_of_experience';
        for i = 1:Np
            Itst          	=   255*PFcandidateSnippets_0t1(:,:,i);
            sAlgo           =   RVQ__testing_grayscale(Itst(:), sAlgo);
            %err_0to1_DxNp(:,i)   =   sAlgo.tst_err_Dx1/255;                                
			err_0to1_DxNp(:,i)   	=   sAlgo.tst_err_Dx1/sAlgo.P;                                
        end
        
        

    elseif(algo_code==4) %i.e. TSVQ
        err_0to1_DxNp      	= 	[];
        for i = 1:Np
            Itst        	=   255*PFcandidateSnippets_0t1(:,:,i);
            sAlgo     		=   TSVQ_3_test(Itst(:), sAlgo);
            err_0to1_DxNp(:,i)   	=   sAlgo.tst_err_Dx1/255;                                
        end
    end

%3b. raise distances to exponentials
    if (~isfield(sOptions,'errfunc'))  
        sOptions.errfunc ...
                            =   [];  
    end

    switch (sOptions.errfunc)
        case 'robust';
            sCondensation.weights ...
                            =   exp(-sum(err_0to1_DxNp.^2./(err_0to1_DxNp.^2+sOptions.rsig.^2))./sOptions.condenssig)';
        case 'ppca';
            sCondensation.weights ...
                            =   exp(-(sum(err_0to1_DxNp.^2) + sum(coefdiff.^2))./sOptions.condenssig)';
        otherwise;
            sCondensation.weights ...
                            =   exp(-sum(err_0to1_DxNp.^2)./sOptions.condenssig)';
    end

%4. pick MAP estimate
    sCondensation.weights     =   sCondensation.weights ./ sum(sCondensation.weights);            %normalize weights
    [maxprob,maxidx]        =   max(sCondensation.weights);                                   %MAP estimate: pick best index
    sCondensation.best_vecAff_1x6 ...
                            =   affparam2mat(sCondensation.affineCandidates_6xNp(:,maxidx));  %MAP estimate: pick best affine parameters based on best index          
    sCondensation.tst_bestPFcandidate_0t1 ...
                            =   PFcandidateSnippets_0t1(:,:,maxidx);                        %MAP estimate: pick best candidate snippet based on best index                
        

%----------------------------
%POST-PROCESSING
%----------------------------
%error and reconstruction
    sCondensation.err_0to1_sw_x_sh     =   reshape(err_0to1_DxNp(:,maxidx), sz);                            %get reconstruction error
    if 	   (algo_code==1) 
        sCondensation.err_0to1_sw_x_sh =   -sCondensation.err_0to1_sw_x_sh; 
    end
    sCondensation.recon       =   sCondensation.tst_bestPFcandidate_0t1 - sCondensation.err_0to1_sw_x_sh; %get reconstructed image

%metrics    
    sCondensation.tst_snr  =   UTIL_METRICS_compute_SNR       (sCondensation.tst_bestPFcandidate_0t1, sCondensation.err_0to1_sw_x_sh);
    sCondensation.tst_rmse =   UTIL_METRICS_compute_rms_value (sCondensation.err_0to1_sw_x_sh(:)*255);
                                                                                         