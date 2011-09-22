% Tests a test vector using an RVQ codebook.
%
% I used this function for the first draft of my thesis.  However, a few parts
% of it were not intuitive, although it has been tested to be absolutely correct.
% I made a few changes to create RVQ__2_test.m.  Both functions produce
% exactly the same output, but the new function is more intuitive.
% 
% This version is for grayscale images.  In RVQ, I make grayscale images 3
% channel by replicating the grayscale channel to all 3 channels.  RVQ then
% processes the 3 channel image as if it were RGB.  However, the
% codevectors for the red, green and blue channels are exactly the same.
% This is why I use CB_DxMP (i.e., the red channel of the codebook).  I could
% just as well have used mdl_CBg_DxMP or mdl_CBb_DxMP since they are all exactly the same
% as CB_DxMP.
%
% In CB_DxMP, 1st col is the (p,m)=(1,1) codevector, second col is the
% (p,m)=(1,2) codevector, and so on.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created       : April 17, 2011.
% Date last modified : July 7, 2011.
%%

function RVQ = RVQ__2_test_old(x_Dx1, RVQ)

%-------------------------------
%INITIALIZATION
%-------------------------------
    CB_DxMP                 =   RVQ.mdl_3_CB_DxMP;   %1 channel codebook, get it from the red, green or blue channel
    P                       =   RVQ.P;      %actual number of stages in the codebook
    M                       =   RVQ.in_4_M___;      %number of codevectors/stage
    sw                      =   RVQ.in_6_sw__;     %snippet width
    sh                      =   RVQ.in_7_sh__;     %snippet height
    D                       =   sw*sh;       %dimension of data
    
    XDR                     =   P + ones(P,1);      %i initialize with P+1, the code for early termination
    xhat_Dx1                =   zeros(D,1);         %reconstructed signal
    PSNRdB                  =   0;    
    successive_PSNRdB       =   [];
    R_Dx1                   =   x_Dx1;      %initially, the residual is equal to the input
    partialP            =   0;

%-------------------------------
%PROCESSING
%-------------------------------    
%go over all stages
    for p=1:P    
        

        %go over all codevectors at p-th stage
        R_norm_min          =   1E15;
        for m=1:M 
            %get codevector
            %idx            =   UTIL_xy_to_idx(m, p, M); 
            %CV_Dx1			=	CB_DxMP(:,idx);                     
            CV_Dx1			=	RVQ_FILES_getCodevectorFromCodebook(m, p, M, CB_DxMP);    %    get codevector 
            R_norm          =   norm(  R_Dx1-CV_Dx1, 2  ); %if diff is a matrix, this is largest eigenvalue, if it'm a vector, it's L2 norm              
            if (R_norm<R_norm_min)
                R_norm_min  =   R_norm;
                m_best      =   m;
            end
        end
        %best_idx           =   UTIL_xy_to_idx(m_best, p, M);
        %CV_Dx1_best        =	CB_DxMP(:,best_idx);
        CV_Dx1_best         =   RVQ_FILES_getCodevectorFromCodebook(m_best, p, M, CB_DxMP); %  save best codevector for p-th stage

        
        %part 2: for this stage, use best codevector to compute some metrics
        temp_xhat_Dx1		=	xhat_Dx1 + CV_Dx1_best;
        temp_R_Dx1          =   x_Dx1 - temp_xhat_Dx1;
        temp_PSNRdB         =   UTIL_METRICS_compute_PSNRdB (255,     	temp_R_Dx1);
                          

        %for this stage: decide if it will be "retained"
        if (temp_PSNRdB > PSNRdB)
            %keep
            xhat_Dx1		=	temp_xhat_Dx1;                              %(a) reconstruction
            R_Dx1			=	temp_R_Dx1;
            PSNRdB			=   temp_PSNRdB;
            successive_PSNRdB(p)      =   temp_PSNRdB;
            XDR(p)          =   m_best;
            partialP   =   p;
        else
            %discard
            break
        end
    end
    %end: going over stages
        
        
  
%-------------------------------
%POST-PROCESSING
%-------------------------------
%pass out
    RVQ.tst_2_recon_DxN    =   xhat_Dx1;
    RVQ.tst_3_error_DxN     =   R_Dx1;
    RVQ.tst_1_featr_PxN  =   XDR;
        
    RVQ.tst_6_partP_Nx1=   partialP;

    RVQ.tst_4_SNRdB_1x1     =   UTIL_METRICS_compute_SNRdB       (x_Dx1,  R_Dx1);  %for PSNR, you only give error signal
    RVQ.tst_5_rmse__1x1    =   UTIL_METRICS_compute_rms   (        R_Dx1);
    RVQ.tst_PSNRdB    =   max(successive_PSNRdB);
