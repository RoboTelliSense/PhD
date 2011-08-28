%% This function computes training error, i.e., loss
% 
% The training error computed is for DM2, i.e., all the training data.
%
% For computing SNRdB, the following approach is taken:
% (a) for each training vector, compute the error vector algo_struct.tst_3_err_Dx1
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

function algo = UTIL_METRICS_compute_training_error_RVQ_style(DM2, algo)

	[D, N]                              =   size(DM2);
	algo.trg_3_err_DxN                 	=   zeros(D,N);
	algo.trg_1_descriptors_PxN         	=   zeros(algo.P,N);
	for n=1:N
		x_Dx1                           =   DM2(:,n);                                %test vector
        if      (strcmp(algo.name, 'RVQ'))
            algo                        =   RVQ__testing_grayscale(x_Dx1, algo);     %test
        elseif (strcmp(algo.name, 'TSVQ'))
            algo                        =   TSVQ_3_test(x_Dx1, algo);     
        end
		algo.trg_1_descriptors_PxN(:,n)	=   algo.tst_1_descriptor_Px1;               %trg1.
		algo.trg_2_recon_DxN(:,n)     	=   algo.tst_2_recon_Dx1;                    %trg2.
		algo.trg_3_err_DxN(:,n)        	=   algo.tst_3_err_Dx1;                      %trg3.
	end
	algo.trg_4_SNRdB                   	=   UTIL_METRICS_compute_SNRdB       (DM2(:), algo.trg_3_err_DxN(:));  %trg4.
	algo.trg_5_rmse                    	=   UTIL_METRICS_compute_rms_value   (algo.trg_3_err_DxN(:));          %trg5.
    
    algo.tst_1_descriptor_Px1           =   [];