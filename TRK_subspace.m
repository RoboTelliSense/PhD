% Copyright (C) Jongwoo Lim and David Ross.
% All rights reserved.  Changed with permission by Salman Aslam
%
% The following structures are used for the algorithms used: sIPCA, sBPCA, sRVQ, sTSVQ
% For condensation, we have: sIPCA_cond, sBPCA_cond, sRVQ__cond, sTSVQ_cond
%
%   vecAff_variance_1x6: contains 
% 
% Date created       : June 8, 2011
% Date last modified : July 17, 2011
%-------------------------------------------------------------------------
%INTIALIZATION
%-------------------------------------------------------------------------
%initialize variables
                                rand  ('state',0);  
                                randn ('state',0);
                                
    I_0t1                   =   double(data(:,:,1))/256; %0t1 means the image intensities are between 0 and 1
    sw                      =   33; %snippet width
    sh                      =   33; %snippet height
    f_trg                   =   [];

%sOptions
    if ~exist('sOptions','var')            sOptions                   =   [];                         end
    if ~isfield(sOptions,'tmplsize')       sOptions.tmplsize          =   [sh,sw];                    end %!!caution: only tested for square snippets
    if ~isfield(sOptions,'Np')             sOptions.Np                =   400;                        end
    if ~isfield(sOptions,'vecAff_variance_1x6')         sOptions.vecAff_variance_1x6            =   [4,4,.02,.02,.005,.001];    end
    if ~isfield(sOptions,'condenssig')     sOptions.condenssig        =   0.01;                       end
    if ~isfield(sOptions,'maxbasis')       sOptions.maxbasis          =   ipca_Neig ;                 end %default: 16
    if ~isfield(sOptions,'batchsize')      sOptions.batchsize         =   5;                          end
    if ~isfield(sOptions,'errfunc')        sOptions.errfunc           =   'L2';                       end
    if ~isfield(sOptions,'ff')             sOptions.ff                =   1.0;                        end
    if ~isfield(sOptions,'minopt')
                                           sOptions.minopt            =   optimset; 
                                           sOptions.minopt.MaxIter    =   25; 
                                           sOptions.minopt.Display    =   'off';
    end

%structures: algorithms    
    sIPCA.sw=sw; sBPCA.sw=sw; sRVQ.sw=sw; sTSVQ.sw=sw;
    sIPCA.sh=sh; sBPCA.sh=sh; sRVQ.sh=sh; sTSVQ.sh=sh; 
    
    %sIPCA
    sIPCA.mean              =   warpimg(I_0t1, vecAff_1x6, sOptions.tmplsize);
    sIPCA.basis             =   [];
    sIPCA.eigval            =   [];
    sIPCA.Np                =   0;
    sIPCA.reseig            =   0;

    %sBPCA
    sBPCA.tstprm_Neig_1x1   =   bpca_Neig;

    %sRVQ        
    sRVQ.M                  =   rvq_M;
    sRVQ.maxP               =   rvq_maxP;
    sRVQ.targetSNR          =   rvq_targetSNR; 
    sRVQ.dir_out            =   dir_out;
    sRVQ.tst_partialP=   -1;

    %sTSVQ
    sTSVQ.P                 =   tsvq_P;
    sTSVQ.M                 =   tsvq_M;
    
    %other
    sz                      =   size(sIPCA.mean);  
    N                       =   sz(1)*sz(2);

%structures: condensation
    sIPCA_cond               =   [];
    sIPCA_cond.best_vecAff_1x6 ...
                            =   vecAff_1x6;
    sIPCA_cond.tst_bestPFcandidate_0t1 ...
                            =   sIPCA.mean;

        sBPCA_cond          =   sIPCA_cond;
        sRVQ__cond          =   sIPCA_cond;
        sTSVQ_cond          =   sIPCA_cond;
        
%GT (ground truth) information

    if (exist('truepts','var'))
        npts                =   size(truepts,2);
        aff0                =   affparaminv(sIPCA_cond.best_vecAff_1x6);
        pts0                =   aff0([3,4,1;5,6,2]) * [truepts(:,:,1); ones(1,npts)];

        ipca_pts            =   cat(3, pts0 + repmat(sz'/2,[1,npts]), truepts(:,:,1));
        ipca_trackpts       =   zeros(size(truepts));
        ipca_trackerr       =   zeros(1,npts); 
        ipca_trackerr_mean  =   zeros(1,npts);

        bpca_pts            =   ipca_pts;
        bpca_trackpts       =   ipca_trackpts;
        bpca_trackerr       =   ipca_trackerr; 
        bpca_trackerr_mean  =   ipca_trackerr_mean; 

        rvq__pts            =   ipca_pts;
        rvq__trackpts       =   ipca_trackpts;
        rvq__trackerr       =   ipca_trackerr; 
        rvq__trackerr_mean  =   ipca_trackerr_mean; 

        tsvq_pts            =   ipca_pts;
        tsvq_trackpts       =   ipca_trackpts;
        tsvq_trackerr       =   ipca_trackerr; 
        tsvq_trackerr_mean  =   ipca_trackerr_mean; 

    else
      ipca_pts              =   [];
      bpca_pts              =   [];
      rvq__pts              =   [];
      tsvq_pts              =   [];
    end
                
    %draw initial track window
    %-------------------------
    sIPCADrawOptions               =   drawtrackresult([], 0, I_0t1, sIPCA, sIPCA_cond, ipca_pts);
    sIPCADrawOptions.showcondens   =   0;  
    sIPCADrawOptions.thcondens     =   1/sOptions.Np;
        
    %other
    %-----
    ipca_DM2                =   [];    %design matrix, col wise
    bpca_DM2                =   [];
    rvq__DM2                =   [];
    tsvq_DM2                =   [];
        
    %save 
    %----
        if (isfield(sOptions,'dump') && sOptions.dump > 0)
            imwrite(frame2im(getframe(gcf)),sprintf('dump/%s.0000.png',title));
            save(sprintf('dump/sOptions.%s.mat',title),'sOptions');
        end
        
    %timing
    
    duration                        =   0; 
                                            tic;
        if (exist('dispstr','var'))  
            dispstr                     =   '';  
        end

    %figures
    %-------        
        tsvq_Prg_f                      =   [];
        rvq__trg_f                      =   [];
        
        %iPCA
            ipca_trg_SNRdB             =   [];
            ipca_trg_rmse            =   [];
            ipca_trgout_avgrmse         =   [];

            ipca_tst_snr             =   zeros(1,F);
            ipca_tst_rmse            =   zeros(1,F);
            ipca_tst_avgrmse         =   zeros(1,F);
        
        %bPCA
        if (bUsebPCA)
            
            
            bpca_trg_SNRdB             =   [];
            bpca_trg_rmse            =   [];
            bpca_trgout_avgrmse         =   [];
            
            bpca_tst_snr             =   zeros(1,F);
            bpca_tst_rmse            =   zeros(1,F);
            bpca_tst_avgrmse         =   zeros(1,F);
        end

        %RVQ
        if (bUseRVQ)            
            rvq__trg_SNRdB             =   [];
            rvq__trg_rmse            =   [];
            rvq__trgout_avgrmse         =   [];
            
            rvq__tst_snr             =   zeros(1,F);
            rvq__tst_rmse            =   zeros(1,F);
            rvq__tst_avgrmse         =   zeros(1,F);
        end

        %TSVQ
        if (bUseTSVQ)
            tsvq_trg_SNRdB             =   [];
            tsvq_trg_rmse            =   [];
            tsvq_trgout_avgrmse         =   [];
            
            tsvq_tst_snr             =   zeros(1,F);
            tsvq_tst_rmse            =   zeros(1,F);
            tsvq_tst_avgrmse         =   zeros(1,F);
        end
        
        top_row         =   0;
        second_row      =   1;
        row_recon       =   2;
        row_recon_err   =   3;
        row_particles   =   4;
        out_num_rows    =   5;
        out_num_cols    =   4;
        fs              =   8; %fontsize
        
        
%==========================================================================
%TRACKING
%==========================================================================



for f = 1:F
    f
    %input
        str_f                           =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_Ioverlaid                   =   [dir_out 'out_' str_f '.png'];
        I_0t1                           =   double(data(:,:,f))/256;
    
        %--------------------------------------
        %TRK_condensation (testing)
        %--------------------------------------
                    %sIPCA_cond                                                =   estwarp_grad                            (I_0t1, sIPCA, sIPCA_cond, sOptions);
                    sIPCA_cond                                                 =   TRK_condensation                            (I_0t1, f, sIPCA, sIPCA_cond, sOptions, RandomData_sample, RandomData_cdf, 1);
                    ipca_DM2                                                        =   [ipca_DM2, sIPCA_cond.tst_bestPFcandidate_0t1(:)];
                    ipca_tst_snr(f)                                              =   sIPCA_cond.tst_snr;
                    ipca_tst_rmse(f)                                             =   sIPCA_cond.tst_rmse;
                    ipca_tst_avgrmse(f)                                          =   UTIL_compute_avg                        (ipca_tst_rmse(1:f));

                    if (f<=sOptions.batchsize)
                        if (bUsebPCA)   sBPCA_cond                             =   sIPCA_cond;                                end       
                        if (bUseRVQ)    sRVQ__cond                             =   sIPCA_cond;                                end
                        if (bUseTSVQ)   sTSVQ_cond                             =   sIPCA_cond;                                end
                        
                        %bpca_DM2(:,f)                                              =   UTIL_IP_image_to_colWiseVectorized      (sIPCA_cond.tst_bestPFcandidate_0t1);
                        if (bUsebPCA)   bpca_DM2                                    =   ipca_DM2;                                       end
                        if (bUseRVQ)    rvq__DM2                                    =   ipca_DM2;                                       end
                        if (bUseTSVQ)   tsvq_DM2                                    =   ipca_DM2;                                       end
                        
                        if (bUsebPCA)   bpca_DM2_new                                =   ipca_DM2;                                       end
                        if (bUseRVQ)    rvq__DM2_new                                =   ipca_DM2;                                       end
                        if (bUseTSVQ)   tsvq_DM2_new                                =   ipca_DM2;                                       end
                        
                        if (bUsebPCA)   bpca_tst_snr(f)                          =   ipca_tst_snr              (f);                    end
                        if (bUseRVQ)    rvq__tst_snr(f)                          =   ipca_tst_snr              (f);                    end
                        if (bUseTSVQ)   tsvq_tst_snr(f)                          =   ipca_tst_snr              (f);                    end
                        
                        if (bUsebPCA)   bpca_tst_rmse(f)                         =   ipca_tst_rmse             (f);                    end
                        if (bUseRVQ)    rvq__tst_rmse(f)                         =   ipca_tst_rmse             (f);                    end
                        if (bUseTSVQ)   tsvq_tst_rmse(f)                         =   ipca_tst_rmse             (f);                    end
                        
                        if (bUsebPCA)   bpca_tst_avgrmse(f)                      =   ipca_tst_avgrmse          (f);                    end
                        if (bUseRVQ)    rvq__tst_avgrmse(f)                      =   ipca_tst_avgrmse          (f);                    end
                        if (bUseTSVQ)   tsvq_tst_avgrmse(f)                      =   ipca_tst_avgrmse          (f);                    end
                    else
                        if (bUsebPCA)   sBPCA_cond                             =   TRK_condensation            (I_0t1, f, sBPCA,   sBPCA_cond, sOptions, RandomData_sample, RandomData_cdf, 2);   end
                        if (bUseRVQ)    sRVQ__cond                             =   TRK_condensation            (I_0t1, f, sRVQ,   sRVQ__cond, sOptions, RandomData_sample, RandomData_cdf, 3);   end
                        if (bUseTSVQ)   sTSVQ_cond                             =   TRK_condensation            (I_0t1, f, sTSVQ,   sTSVQ_cond, sOptions, RandomData_sample, RandomData_cdf, 4);   end

                        if (bUsebPCA)   bpca_DM2                                    =                           [bpca_DM2   sBPCA_cond.tst_bestPFcandidate_0t1(:)];  end         
                        if (bUseRVQ)    rvq__DM2                                    =                           [rvq__DM2   sRVQ__cond.tst_bestPFcandidate_0t1(:)];  end
                        if (bUseTSVQ)   tsvq_DM2                                    =                           [tsvq_DM2   sTSVQ_cond.tst_bestPFcandidate_0t1(:)];  end
                        
                        if (bUsebPCA)   bpca_DM2_new                                =   DATAMATRIX_pick_last_Nw_values_in_DM2(bpca_DM2, Nw, bWeighting); end                                                                                                       
                        if (bUseRVQ)    rvq__DM2_new                                =   DATAMATRIX_pick_last_Nw_values_in_DM2(rvq__DM2, Nw, bWeighting); end
                        if (bUseTSVQ)   tsvq_DM2_new                                =   DATAMATRIX_pick_last_Nw_values_in_DM2(tsvq_DM2, Nw, bWeighting); end
                        
                        if (bUsebPCA)   bpca_tst_snr(f)                          =   sBPCA_cond.tst_snr;     end
                        if (bUseRVQ)    rvq__tst_snr(f)                          =   sRVQ__cond.tst_snr;     end  
                        if (bUseTSVQ)   tsvq_tst_snr(f)                          =   sTSVQ_cond.tst_snr;     end

                        if (bUsebPCA)   bpca_tst_rmse(f)                         =   sBPCA_cond.tst_rmse;     end
                        if (bUseRVQ)    rvq__tst_rmse(f)                         =   sRVQ__cond.tst_rmse;     end  
                        if (bUseTSVQ)   tsvq_tst_rmse(f)                         =   sTSVQ_cond.tst_rmse;     end
                        
                        if (bUsebPCA)   bpca_tst_avgrmse(f)                      =   UTIL_compute_avg     (bpca_tst_rmse(1:f));  end
                        if (bUseRVQ)    rvq__tst_avgrmse(f)                      =   UTIL_compute_avg     (rvq__tst_rmse(1:f));  end
                        if (bUseTSVQ)   tsvq_tst_avgrmse(f)                      =   UTIL_compute_avg     (tsvq_tst_rmse(1:f));  end
                    end                            

    %--------------------------------------
    %training: update model
    %--------------------------------------
    Ntrg_snp                 =   size(ipca_DM2,2); 
    if (Ntrg_snp             >=  sOptions.batchsize) %i.e.train every batchsize images
                        f_trg = [f_trg, f];
                        [sIPCA, sIPCA_cond]              =   ipca_1_train  (ipca_DM2, sIPCA, sIPCA_cond, sOptions);   
                        ipca_DM2                                    =   [];   %since this is incremental, the data matrix is flushed
                        ipca_trg_SNRdB                             =   [ipca_trg_SNRdB        sIPCA.trg_SNRdB];
                        ipca_trg_rmse                            =   [ipca_trg_rmse       sIPCA.trg_rmse];
                        temp1 = UTIL_compute_avg (ipca_trg_rmse); ipca_trgout_avgrmse  =   [ipca_trgout_avgrmse  temp1 ]; 
            
        if (bUsebPCA)   sBPCA                                 =   bpca_1_train            (bpca_DM2_new * max_signal_value,   sBPCA);   end
        if (bUseRVQ)    sRVQ                                 =   RVQ__training            (rvq__DM2_new * max_signal_value,   sRVQ);   UTIL_copyFile([dir_out 'rvq__trg_verbose.txt'], [dir_out 'rvq__trg_verbose_' str_f '.txt']); end
        if (bUseTSVQ)   sTSVQ                                 =   tsvq_1_train            (tsvq_DM2_new * max_signal_value,   sTSVQ);   end  

        if (bUsebPCA)   bpca_trg_SNRdB                             =   [bpca_trg_SNRdB        sBPCA.trg_SNRdB];                        end
        if (bUseRVQ)    rvq__trg_SNRdB                             =   [rvq__trg_SNRdB        sRVQ.trg_SNRdB];                        end
        if (bUseTSVQ)   tsvq_trg_SNRdB                             =   [tsvq_trg_SNRdB        sTSVQ.trg_SNRdB];                        end
        
        if (bUsebPCA)   bpca_trg_rmse                            =   [bpca_trg_rmse      sBPCA.trg_rmse];                        end
        if (bUseRVQ)    rvq__trg_rmse                            =   [rvq__trg_rmse      sRVQ.trg_rmse];                        end
        if (bUseTSVQ)   tsvq_trg_rmse                            =   [tsvq_trg_rmse      sTSVQ.trg_rmse];                        end
        
        if (bUsebPCA)   temp2 = UTIL_compute_avg (bpca_trg_rmse); bpca_trgout_avgrmse  =   [bpca_trgout_avgrmse  temp2 ];                    end
        if (bUseRVQ)    temp3 = UTIL_compute_avg (rvq__trg_rmse); rvq__trgout_avgrmse  =   [rvq__trgout_avgrmse  temp3];                    	end
        if (bUseTSVQ)   temp4 = UTIL_compute_avg (tsvq_trg_rmse); tsvq_trgout_avgrmse  =   [tsvq_trgout_avgrmse  temp4];                     end        
        
    end
    %UTIL_dbloop
    
    

%---------------------------------------------------------------    
%view results
%---------------------------------------------------------------   
	duration                =   duration + toc;
    
    
    h1                      =   figure                  (1);
    h1_pos                  =   get                     (h1, 'Position');
                                set                     (h1, 'Position', [10, 702, h1_pos(3), h1_pos(4)]);
    sIPCADrawOptions  =   drawtrackresult        (sIPCADrawOptions, f, I_0t1, sIPCA, sIPCA_cond, ipca_pts);

    
    
    h2                      =   figure                  (2);                                      
    h2_pos                  =   get                     (h2, 'Position');
                                set                     (h2, 'Position', [10, 90, h2_pos(3), h2_pos(4)]); 
                                    
                                TRK_draw_1_I;
                                TRK_draw_2_metrics_trkerr;
                                TRK_draw_3_metrics_trgtst_wrapper;
                                TRK_draw_4_recon_reconerr_wrapper;
                                TRK_draw_5_PFcandidates_wrapper;
                                TRK_draw_6_DM2; 
                                TRK_draw_7_CB; 
                           

                                %[f ipca_trackerr_mean(f) rvq__trackerr_mean(f) tsvq_trackerr_mean(f)]
            
%---------------------------------------------------------------    
%save results
%---------------------------------------------------------------   
        
    %%% UNCOMMENT THIS TO SAVE THE RESULTS (uses a lot of memory)
    %%% saved_params{f} = sIPCA_cond;
    if (isfield(sOptions,'dump') && sOptions.dump > 0)
                                    imwrite(frame2im(getframe(gcf)),sprintf('dump/%s.%04d.png',title,f));
    end
    tic;

    TRK_save_allResults;
    
end

duration = duration + toc;
fprintf('%d frames took %.3f seconds : %.3fps\n',f,duration,f/duration);


%                     if (f>Nict)    
%                         bpca_DM2                        =   bpca_DM2                       (2:Nict, :);  
%                     end
