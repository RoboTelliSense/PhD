%% This function computes training error, i.e., loss
% 
% The training error computed is for DM2, i.e., all the training data.
%
% For computing SNRdB, the following approach is taken:
% (a) for each training vector, compute the error vector algo_struct.tst_3_error_DxN
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
	algo.trg_3_error_DxN                 	=   zeros(D,N);
	algo.trg_1_featr_QxN         	=   zeros(algo.mdl_1_Q__1x1,N);
	for n=1:N
		x_Dx1                           =   DM2(:,n);                                %test vector
        if      (strcmp(algo.in_1__name, 'RVQ'))
            algo                        =   RVQ__2_encode_decode(x_Dx1, algo);     %test
        elseif (strcmp(algo.in_1__name, 'TSVQ'))
            algo                        =   TSVQ_2_encode_decode(x_Dx1, algo);     
        end
		algo.trg_1_featr_QxN(:,n)	=   algo.tst_1_featr_QxN;                                         %trg1.
		algo.trg_2_recon_DxN(:,n)     	=   algo.tst_2_recon_DxN;                                              %trg2.
		algo.trg_3_error_DxN(:,n)       =   algo.tst_3_error_DxN;                                                %trg3.
        algo.trg_4_SNRdB_1x1(n,1)       =   UTIL_METRICS_compute_SNRdB       (DM2(:), algo.trg_3_error_DxN(:));  %trg4.
        algo.trg_5_rmse__1x1(n,1)        =   UTIL_METRICS_compute_rms   (algo.trg_3_error_DxN(:));          %trg5.
	end
    
    algo.tst_1_featr_QxN           =   [];