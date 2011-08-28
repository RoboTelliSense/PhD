%% This function computes training error, i.e., loss
% 
% The training error computed is for DM2, i.e., all the training data.
%
% For computing SNRdB, the following approach is taken:
% (a) for each training vector, compute the error vector algo_struct.tst_err_Dx1
% (b) concatenate all training vectors into S_NDx1 to make one giant signal
% (c) concatenate all error vectors into E_NDx1 to make one giant error signal
% (d) compute SNRdB using these giant signals
%
% The reason for this approach is that it's similar to the approach taken
% in Explorer, Dr Barnes' software.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 20, 2011
% Date last modified : July 7, 2011
%%

function algo_struct = UTIL_METRICS_compute_training_error_RVQ_style(DM2, algo_struct, algo_code)

%---------------
%INITIALIZATIONS
%---------------
    [D, N]                  =   size(DM2);
    S_NDx1                  =   [];             %all N D-dimensional training vectors are concatentated to form a large signal
    E_NDx1                  =   [];             %all N D-dimensional error vectors are concatentated to form a large signal
    algo_struct.mdl_XDRs_PxN = [];        %the above step is carried out to be compatible with the way Explorer computes training error

%-------------------
%PRE-PROCESSING
%-------------------   
%!!caution, this needs checking
    if      (algo_code==1)  str='algo_struct              =   bPCA_3_test	(tst_vec_Dx1, algo_struct);';  %probabilistic PCA  
%!!end caution
    elseif  (algo_code==2)  str='algo_struct              =   bPCA_3_test	(tst_vec_Dx1, algo_struct);';  %batch PCA
    elseif  (algo_code==3)  str='algo_struct              =   RVQ__testing_grayscale	(tst_vec_Dx1, algo_struct);';  %RVQ 
    elseif  (algo_code==4)  str='algo_struct              =   TSVQ_3_test	(tst_vec_Dx1, algo_struct);';  %TSVQ
    end

%-------------------
%PROCESSING
%-------------------    
	for i=1:N
        
        %pick out a single vector from DM2, this is one training example
        tst_vec_Dx1         =   DM2(:,i);        
        
        %evaluate error against model
                                eval(str);       %so for RVQ, test against the RVQ codebook
                                
        %concatenate signals (training vectors) and errors
        S_NDx1              =   [S_NDx1; tst_vec_Dx1];                %save the SNR
        E_NDx1              =   [E_NDx1; algo_struct.tst_err_Dx1]; %save the error
    end
    
    %compute SNR for the large signal
    SNRdB                   =   UTIL_METRICS_compute_SNRdB       (S_NDx1, E_NDx1); %S_NDx1 is now one big signal
    rmse                    =   UTIL_METRICS_compute_rms_value   (E_NDx1);
    
%-------------------
%POST-PROCESSING
%-------------------
%save results
    algo_struct.trg_SNRdB   =   SNRdB;
    algo_struct.trg_rmse    =   rmse;