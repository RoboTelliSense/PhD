[PARAM.ds_2_name, PARAM.ds_3_name2, actualF] = UTIL_DATASET_getName2(d);
            if (~strcmp(errType, 'Trg_4'))
                F               =   actualF;
            else
                F               =   floor(actualF/batch_size);
            end
            
            if (strcmp(errType, 'Trk_3'))
                ax              =   [0 9 0 30];
            else
                ax              =   [0 9 0 60];
            end
 
%iPCA
%----
        %go over Nw
        nw=0;
        for Nw=[2,4,8,16,32,64,128,10000]
            nw=nw+1;

            %go over configs
            dir_iPCA_2          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__bPCA_002/'];
            dir_iPCA_4          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_004__bPCA_004/'];
            dir_iPCA_8          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_008__bPCA_008/'];            
            dir_iPCA_16         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03/'];
            dir_iPCA_32         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_032__bPCA_032__RVQ__08_04_1000__TSVQ_04/'];
            dir_iPCA_64         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_064__bPCA_064__RVQ__08_08_1000__TSVQ_05/'];
            dir_iPCA_128        =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_128__bPCA_128__RVQ__08_16_1000__TSVQ_06/'];

            cfn_iPCA_2          =   [dir_iPCA_2   'err' errType '_ipca.csv'];
            cfn_iPCA_4          =   [dir_iPCA_4   'err' errType '_ipca.csv'];
            cfn_iPCA_8          =   [dir_iPCA_8   'err' errType '_ipca.csv'];
            cfn_iPCA_16         =   [dir_iPCA_16  'err' errType '_ipca.csv'];
            cfn_iPCA_32         =   [dir_iPCA_32  'err' errType '_ipca.csv'];
            cfn_iPCA_64         =   [dir_iPCA_64  'err' errType '_ipca.csv'];
            cfn_iPCA_128        =   [dir_iPCA_128 'err' errType '_ipca.csv'];

            if (~strcmp(errType, 'Trg_4')) %for iPCA, we don't have training error
            iPCA(1, nw, d)         =   TRK_read_avg_error(cfn_iPCA_2, F);
            iPCA(2, nw, d)         =   TRK_read_avg_error(cfn_iPCA_4, F);
            iPCA(3, nw, d)         =   TRK_read_avg_error(cfn_iPCA_8, F);
            iPCA(4, nw, d)         =   TRK_read_avg_error(cfn_iPCA_16, F);
            iPCA(5, nw, d)         =   TRK_read_avg_error(cfn_iPCA_32, F);
            iPCA(6, nw, d)         =   TRK_read_avg_error(cfn_iPCA_64, F);
            iPCA(7, nw, d)         =   TRK_read_avg_error(cfn_iPCA_128, F);        
            end
        end
 

%bPCA
%----
        %go over Nw
        nw=0;
        for Nw=[2,4,8,16,32,64,128,10000]
            nw=nw+1;

            %go over configs
            dir_bPCA_2          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__bPCA_002/'];
            dir_bPCA_4          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_004__bPCA_004/'];
            dir_bPCA_8          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_008__bPCA_008/'];            
            dir_bPCA_16         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03/'];
            dir_bPCA_32         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_032__bPCA_032__RVQ__08_04_1000__TSVQ_04/'];
            dir_bPCA_64         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_064__bPCA_064__RVQ__08_08_1000__TSVQ_05/'];
            dir_bPCA_128        =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_128__bPCA_128__RVQ__08_16_1000__TSVQ_06/'];

            cfn_bPCA_2          =   [dir_bPCA_2   'err' errType '_bpca.csv'];
            cfn_bPCA_4          =   [dir_bPCA_4   'err' errType '_bpca.csv'];
            cfn_bPCA_8          =   [dir_bPCA_8   'err' errType '_bpca.csv'];
            cfn_bPCA_16         =   [dir_bPCA_16  'err' errType '_bpca.csv'];
            cfn_bPCA_32         =   [dir_bPCA_32  'err' errType '_bpca.csv'];
            cfn_bPCA_64         =   [dir_bPCA_64  'err' errType '_bpca.csv'];
            cfn_bPCA_128        =   [dir_bPCA_128 'err' errType '_bpca.csv'];

            bPCA(1, nw, d)         =   TRK_read_avg_error(cfn_bPCA_2, F);
            bPCA(2, nw, d)         =   TRK_read_avg_error(cfn_bPCA_4, F);
            bPCA(3, nw, d)         =   TRK_read_avg_error(cfn_bPCA_8, F);
            bPCA(4, nw, d)         =   TRK_read_avg_error(cfn_bPCA_16, F);            
            bPCA(5, nw, d)         =   TRK_read_avg_error(cfn_bPCA_32, F);
            bPCA(6, nw, d)         =   TRK_read_avg_error(cfn_bPCA_64, F);
            bPCA(7, nw, d)         =   TRK_read_avg_error(cfn_bPCA_128, F);        
           
        end


%RVQ
%---
        %go over Nw
        nw=0;
        for Nw=[2,4,8,16,32,64,128,10000]
            nw=nw+1;

            %go over configs
            dir_rvq_8x2         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03/'];
            dir_rvq_8x4         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_032__bPCA_032__RVQ__08_04_1000__TSVQ_04/'];
            dir_rvq_8x8         =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_064__bPCA_064__RVQ__08_08_1000__TSVQ_05/'];
            dir_rvq_8x16        =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_128__bPCA_128__RVQ__08_16_1000__TSVQ_06/'];
            dir_rvq_16x2        =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__RVQ__16_02_1000/'];
            dir_rvq_16x4        =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__RVQ__16_04_1000/'];
            dir_rvq_16x8        =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__RVQ__16_08_1000/'];
            dir_rvq_16x16       =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__RVQ__16_16_1000/'];
                                    
            cfn_rvq_8x2         =   [dir_rvq_8x2 'err' errType '_rvq.csv'];
            cfn_rvq_8x4         =   [dir_rvq_8x4 'err' errType '_rvq.csv'];
            cfn_rvq_8x8         =   [dir_rvq_8x8 'err' errType '_rvq.csv'];
            cfn_rvq_8x16        =   [dir_rvq_8x16 'err' errType '_rvq.csv'];
            cfn_rvq_16x2        =   [dir_rvq_16x2 'err' errType '_rvq.csv'];
            cfn_rvq_16x4        =   [dir_rvq_16x4 'err' errType '_rvq.csv'];
            cfn_rvq_16x8        =   [dir_rvq_16x8 'err' errType '_rvq.csv'];
            cfn_rvq_16x16       =   [dir_rvq_16x16 'err' errType '_rvq.csv'];

            RVQ(1, nw, d)          =   TRK_read_avg_error(cfn_rvq_8x2, F);
            RVQ(2, nw, d)          =   TRK_read_avg_error(cfn_rvq_16x2, F); 
            RVQ(3, nw, d)          =   TRK_read_avg_error(cfn_rvq_8x4, F);
            RVQ(4, nw, d)          =   TRK_read_avg_error(cfn_rvq_16x4, F); 
            RVQ(5, nw, d)          =   TRK_read_avg_error(cfn_rvq_8x8, F);
            RVQ(6, nw, d)          =   TRK_read_avg_error(cfn_rvq_16x8, F); 
            RVQ(7, nw, d)          =   TRK_read_avg_error(cfn_rvq_8x16, F);  
            RVQ(8, nw, d)          =   TRK_read_avg_error(cfn_rvq_16x16, F); 
        end
    
    

%TSVQ
%---
        %go over Nw
        nw=0;
        for Nw=[2,4,8,16,32,64,128,10000]
            nw=nw+1;

            %go over configs
            dir_tsvq_1          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__TSVQ_01/'];
            dir_tsvq_2          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_002__TSVQ_02/'];
            dir_tsvq_3          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03/'];
            dir_tsvq_4          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_032__bPCA_032__RVQ__08_04_1000__TSVQ_04/'];
            dir_tsvq_5          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_064__bPCA_064__RVQ__08_08_1000__TSVQ_05/'];
            dir_tsvq_6          =   ['results_thesis\results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_128__bPCA_128__RVQ__08_16_1000__TSVQ_06/'];

            cfn_tsvq_1          =   [dir_tsvq_1 'err' errType '_tsvq.csv'];
            cfn_tsvq_2          =   [dir_tsvq_2 'err' errType '_tsvq.csv'];
            cfn_tsvq_3          =   [dir_tsvq_3 'err' errType '_tsvq.csv'];
            cfn_tsvq_4          =   [dir_tsvq_4 'err' errType '_tsvq.csv'];
            cfn_tsvq_5          =   [dir_tsvq_5 'err' errType '_tsvq.csv'];
            cfn_tsvq_6          =   [dir_tsvq_6 'err' errType '_tsvq.csv'];

            TSVQ(1, nw, d)          =   TRK_read_avg_error(cfn_tsvq_1, F);        
            TSVQ(2, nw, d)          =   TRK_read_avg_error(cfn_tsvq_2, F);        
            TSVQ(3, nw, d)          =   TRK_read_avg_error(cfn_tsvq_3, F);
            TSVQ(4, nw, d)          =   TRK_read_avg_error(cfn_tsvq_4, F);
            TSVQ(5, nw, d)          =   TRK_read_avg_error(cfn_tsvq_5, F);
            TSVQ(6, nw, d)          =   TRK_read_avg_error(cfn_tsvq_6, F);        
            
        end


                                %corrections
                                %-----------
%                                 if (strcmp(errType, 'Trk_3'))
%                                     if (d==1)
%                                         bPCA(7,2)=bPCA(4,2);  %bPCA_128, Nw=4
%                                         bPCA(7,3)=bPCA(4,3);  %bPCA_128, Nw=8
%                                     end
%                                     if (d==3)
%                                         bPCA(5,3)=bPCA(4,3);  %bPCA_32, Nw=8
%                                         bPCA(7,4)=bPCA(4,4);  %bPCA_128, Nw=16
%                                     end
%                                     if (d==4)
%                                         bPCA(6,3)=bPCA(4,3);  %bPCA_64, Nw=8
%                                         bPCA(7,3)=bPCA(4,3);  %bPCA_128, Nw=8
%                                         bPCA(7,4)=bPCA(4,4);  %bPCA_128, Nw=16
%                                         bPCA(7,6)=bPCA(6,6);  %bPCA_128, Nw=64
%                                     end
%                                     if (d==5)
%                                         bPCA(6,3)=bPCA(4,3);  %bPCA_64, Nw=8
%                                         bPCA(7,3)=bPCA(4,3);  %bPCA_128, Nw=8
%                                         bPCA(7,5)=bPCA(6,5);  %bPCA_128, Nw=32
%                                         bPCA(7,6)=bPCA(6,6);  %bPCA_128, Nw=64
%                                     end
%                                     if (d==6)
%                                         iPCA(4,2)=iPCA(4,1);
%                                         iPCA(4,4)=iPCA(4,1);
%                                         iPCA(4,8)=iPCA(4,1);
%                                         iPCA(5,1)=iPCA(5,2);
%                                         iPCA(5,3)=iPCA(5,2);
%                                         iPCA(5,5)=iPCA(5,2);
%                                         iPCA(5,6)=iPCA(5,2);
%                                         iPCA(6,2)=iPCA(6,1);
%                                         iPCA(6,3)=iPCA(6,1);
%                                         iPCA(6,7)=iPCA(6,1);
%                                         iPCA(6,8)=iPCA(6,1);
%                                         iPCA(7,1)=iPCA(7,2);
%                                         iPCA(7,4)=iPCA(7,2);
%                                         iPCA(7,5)=iPCA(7,2);
%                                         iPCA(7,6)=iPCA(7,2);
% 
%                                         bPCA(4,3)=bPCA(6,3);  %bPCA_16, Nw=8
%                                         bPCA(5,3)=bPCA(6,3);  %bPCA_32, Nw=8
%                                         bPCA(6,4)=bPCA(4,4);  %bPCA_64, Nw=16
%                                         bPCA(7,4)=bPCA(4,4);  %bPCA_128, Nw=16
%                                     end
%                                     if (d==7)
%                                         bPCA(4,3)=bPCA(6,3);  %bPCA_16, Nw=8
%                                         bPCA(6,4)=bPCA(4,4);  %bPCA_64, Nw=16
%                                         bPCA(7,4)=bPCA(4,4);  %bPCA_128, Nw=16
%                                         bPCA(7,6)=bPCA(6,6);  %bPCA_128, Nw=64
%                                     end
%                                 end


%averages 
if (strcmp(errType, 'Trk_3'))
    [iPCA_avg_trk_err(d), iPCA_correct_Mask(:,:,d)]         =   test3_avg_trk_err(iPCA(:,:,d), thresh)
    [bPCA_avg_trk_err(d), bPCA_correct_Mask(:,:,d)]         =   test3_avg_trk_err(bPCA(:,:,d), thresh) 
    [RVQ_avg_trk_err(d),  RVQ_correct_Mask(:,:,d) ]         =   test3_avg_trk_err(RVQ(:,:,d),  thresh) 
    [TSVQ_avg_trk_err(d), TSVQ_correct_Mask(:,:,d)]         =   test3_avg_trk_err(TSVQ(:,:,d), thresh) 
end

if (strcmp(errType, 'Trg_4'))
    iPCA_avg_trg_err(d)                                     =   test3_avg_trgtst_err(iPCA(:,:,d), iPCA_correct_Mask(:,:,d));
    bPCA_avg_trg_err(d)                                     =   test3_avg_trgtst_err(bPCA(:,:,d), bPCA_correct_Mask(:,:,d));
    RVQ_avg_trg_err(d)                                      =   test3_avg_trgtst_err(RVQ(:,:,d),  RVQ_correct_Mask(:,:,d));
    TSVQ_avg_trg_err(d)                                     =   test3_avg_trgtst_err(TSVQ(:,:,d), TSVQ_correct_Mask(:,:,d));
end

if (strcmp(errType, 'Tst_5'))
    iPCA_avg_tst_err(d)                                     =   test3_avg_trgtst_err(iPCA(:,:,d), iPCA_correct_Mask(:,:,d));
    bPCA_avg_tst_err(d)                                     =   test3_avg_trgtst_err(bPCA(:,:,d), bPCA_correct_Mask(:,:,d));
    RVQ_avg_tst_err(d)                                      =   test3_avg_trgtst_err(RVQ(:,:,d),  RVQ_correct_Mask(:,:,d));
    TSVQ_avg_tst_err(d)                                     =   test3_avg_trgtst_err(TSVQ(:,:,d), TSVQ_correct_Mask(:,:,d));
end


%-------------------------------------------------
%RESULTS
%-------------------------------------------------
    %iPCA
    if (~strcmp(errType, 'Trg_4')) %for iPCA, we don't have training error
        h=figure(1);
        %disptable(iPCA, '2|4|8|16|32|64|128|10000', 'iPCA_2|iPCA_4|iPCA_8|iPCA_16|iPCA_32|iPCA_64|iPCA_128');
        bar(iPCA(:,:,d)');set(gca, 'XTickLabel', [2,4,8,16,32,64,128,10000]);legend('iPCA 2', 'iPCA 4', 'iPCA 8', 'iPCA 16', 'iPCA 32', 'iPCA 64', 'iPCA 128');xlabel('N_w (number of images in sliding training-window)');ylabel(ylab);%title(PARAM.ds_3_name2, 'Interpreter', 'None');
        axis(ax)
        grid on;
        UTIL_FILE_save2pdf  (['results_err' errType '_____'  PARAM.ds_3_name2 '_iPCA.pdf'],      h,     300); 
    end

    %bPCA
        h=figure(2);
        %disptable(bPCA, '2|4|8|16|32|64|128|10000', 'bPCA_2|bPCA_4|bPCA_8|bPCA_16|bPCA_32|bPCA_64|bPCA_128');
        bar(bPCA(:,:,d)');set(gca, 'XTickLabel', [2,4,8,16,32,64,128,10000]);legend('bPCA 2', 'bPCA 4', 'bPCA 8', 'bPCA 16', 'bPCA 32', 'bPCA 64', 'bPCA 128');xlabel('N_w (number of images in sliding training-window)');ylabel(ylab);%title(PARAM.ds_3_name2, 'Interpreter', 'None');
        axis(ax)
        grid on;
        UTIL_FILE_save2pdf  (['results_err' errType '_____'  PARAM.ds_3_name2 '_bPCA.pdf'],      h,     300); 

    %RVQ
        h=figure(3);
        %disptable(RVQ, '2|4|8|16|32|64|128|10000', 'RVQ_8x2|RVQ_8x4|RVQ_8x8|RVQ_8x16');
        bar(RVQ(:,:,d)');set(gca, 'XTickLabel', [2,4,8,16,32,64,128,10000]);legend('RVQ 8x2', 'RVQ 16x2', 'RVQ 8x4', 'RVQ 16x4', 'RVQ 8x8', 'RVQ 16x8', 'RVQ 8x16', 'RVQ 16x16');xlabel('N_w (number of images in sliding training-window)');ylabel(ylab);%title(PARAM.ds_3_name2, 'Interpreter', 'None');
        axis(ax)
        grid on;
        UTIL_FILE_save2pdf  (['results_err' errType '_____'  PARAM.ds_3_name2 '_RVQ.pdf'],      h,     300); 

    %TSVQ
        h=figure(4);
        %disptable(TSVQ, '2|4|8|16|32|64|128|10000', 'TSVQ_1|TSVQ_2|TSVQ_3|TSVQ_4|TSVQ_5|TSVQ_6');
        bar(TSVQ(:,:,d)');set(gca, 'XTickLabel', [2,4,8,16,32,64,128,10000]);legend('TSVQ 1', 'TSVQ 2', 'TSVQ 3', 'TSVQ 4', 'TSVQ 5', 'TSVQ 6');xlabel('N_w (number of images in sliding training-window)');ylabel(ylab);%title(PARAM.ds_3_name2, 'Interpreter', 'None');
        axis(ax)
        grid on;
        UTIL_FILE_save2pdf  (['results_err' errType '_____'  PARAM.ds_3_name2 '_TSVQ.pdf'],      h,     300); 
        
       