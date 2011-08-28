function RVQ = RVQ__testing_grayscale(tst_Dx1, RVQ)

    tst_6Dx1                            =   RVQ_FILES_create_posnegImage(tst_Dx1, '', 0, 0);

    mdl_CBr_DxMP                               =   RVQ.mdl_CBr_DxMP;
    mdl_CBg_DxMP                               =   RVQ.mdl_CBg_DxMP;
    mdl_CBb_DxMP                               =   RVQ.mdl_CBb_DxMP;
    CBn_r                              =   RVQ.CBn_r;
    CBn_g                              =   RVQ.CBn_g;
    CBn_b                              =   RVQ.CBn_b;
    T                                   =   RVQ.T;
    S                                   =   RVQ.S;
    sw                                  =   RVQ.sw;
    sh                                  =   RVQ.sh;
    D                                   =   sw*sh;
    
    SoC                                 =   T + ones(T,1);  %i initialize with T+1 because T+1 is the code for early termination
    recon_6Dx1                          =   zeros(6*D,1);
    
    psnr_dB                             =   0;    
    PSNR_dB                             =   [];
    successiveRecon_6DxT                =   zeros(6*D,T); %first column contains first reconstruction, second column contains refined reconstruction, third column still better and so on
    
    err_6Dx1                            =   tst_6Dx1;
    numStagesUsed                       =   0;
    
    %go over all stages
        for t=1:T    
            dmin                        =   1E15;
            
            %for this stage: go over all codevectors
            for s=1:S 
                idx                     =   UTIL_xy_to_idx(s, t, S);
                CB_6Dx1                =   [mdl_CBr_DxMP(:,idx);mdl_CBg_DxMP(:,idx);mdl_CBb_DxMP(:,idx);CBn_r(:,idx);CBn_g(:,idx);CBn_b(:,idx)];
                e                       =   err_6Dx1-CB_6Dx1;                    
                d                       =   norm(  e, 2  ); %if e is a matrix, this is largest eigenvalue, if it's a vector, it's L2 norm              
                if (d<dmin)
                    dmin = d;
                    s_best = s;
                end
            end
            
            %for this stage: temporarily store metrics
            idx                         =   UTIL_xy_to_idx(s_best, t, S);
            temp_recon_6Dx1             =   recon_6Dx1 + CB_6Dx1;    
            temp_err_6Dx1               =   tst_6Dx1 - temp_recon_6Dx1;
            temp_psnr_dB                =   UTIL_METRICS_compute_PSNRdB (255,     err_6Dx1);
            %temp_snr_dB                =   UTIL_METRICS_compute_SNRdB  (tst_6Dx1, err_6Dx1);                        

            %for this stage: decide if it will be "retained"
            if (temp_psnr_dB < psnr_dB)
                %discard
                break
            else
                %keep
                recon_6Dx1                  =   temp_recon_6Dx1; 
                successiveRecon_6DxT(:,t)   =   temp_recon_6Dx1;
                err_6Dx1                    =   temp_err_6Dx1;
                psnr_dB                     =   temp_psnr_dB;
                PSNR_dB(t)                  =   temp_psnr_dB;
                SoC(t)                      =   s_best;
                numStagesUsed               =   t;
            end
        end
        %end: going over stages
        
        
  

        
    %pass out
        RVQ.tst_recon_Dx1    =   recon_6Dx1;
        RVQ.tst_err_Dx1      =   err_6Dx1;
        RVQ.tst_XDR_Px1   =   SoC;
        
        RVQ.tst_partialP =   numStagesUsed;
                
        RVQ.tst_SNRdB      =   UTIL_METRICS_compute_SNRdB       (tst_6Dx1,   err_6Dx1);  %for PSNR, you only give error signal
        RVQ.tst_rmse     =   UTIL_METRICS_compute_rms_value   (           err_6Dx1);
        RVQ.tst_PSNRdB     =   max(PSNR_dB);
