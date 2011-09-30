clear;
clc;
close all;

%std_experimentalF is the number of frames I have decided I will use.
%the reason is that in the case of datasets 6 and 7, I terminated early after allowing the cluster to run more than a week.  
%if i had known i was this close, i wouldn't have terminated.
%in these 2 datasets, I cannot use actualF, I have to use number of frames
%that were actually tested.


% std_experimentalF(1) = 573; %same as actualF
% std_experimentalF(2) = 462; %same as actualF
% std_experimentalF(3) = 620; %same as actualF
% std_experimentalF(4) = 501; %same as actualF
% std_experimentalF(5) = 476; %same as actualF
% std_experimentalF(6) = 657; %actualF is 659
% std_experimentalF(7) = 306; %actualF is 393

%given Nw, all algos
for datasetCode = 6:6
    [PARAM.ds_2_name, PARAM.ds_3_name2, actualF] = UTIL_DATASET_getName2(datasetCode);
    for Nw=[2,4,8,16,32,64,128,10000]    
        odir             =   ['results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03/'];
        cfn1                =   [odir 'FPerr_3_ipca.csv'];
        cfn2                =   [odir 'FPerr_3_bpca.csv'];
        cfn3                =   [odir 'FPerr_3_rvq.csv'];
        cfn4                =   [odir 'FPerr_3_tsvq.csv'];
        avg_trk_err(1,1)    =   TRK_read_avg_error(cfn1, actualF)
        avg_trk_err(2,1)    =   TRK_read_avg_error(cfn2, actualF)
        avg_trk_err(3,1)    =   TRK_read_avg_error(cfn3, actualF)
        avg_trk_err(4,1)    =   TRK_read_avg_error(cfn4, actualF)

        odir             =   ['results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_032__bPCA_032__RVQ__08_04_1000__TSVQ_04/'];
        cfn1                =   [odir 'FPerr_3_ipca.csv'];
        cfn2                =   [odir 'FPerr_3_bpca.csv'];
        cfn3                =   [odir 'FPerr_3_rvq.csv'];
        cfn4                =   [odir 'FPerr_3_tsvq.csv'];
        avg_trk_err(1,2)    =   TRK_read_avg_error(cfn1, actualF)
        avg_trk_err(2,2)    =   TRK_read_avg_error(cfn2, actualF)
        avg_trk_err(3,2)    =   TRK_read_avg_error(cfn3, actualF)
        avg_trk_err(4,2)    =   TRK_read_avg_error(cfn4, actualF)

        odir             =   ['results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_064__bPCA_064__RVQ__08_08_1000__TSVQ_05/'];
        cfn1                =   [odir 'FPerr_3_ipca.csv'];
        cfn2                =   [odir 'FPerr_3_bpca.csv'];
        cfn3                =   [odir 'FPerr_3_rvq.csv'];
        cfn4                =   [odir 'FPerr_3_tsvq.csv'];
        avg_trk_err(1,3)    =   TRK_read_avg_error(cfn1, actualF)
        avg_trk_err(2,3)    =   TRK_read_avg_error(cfn2, actualF)
        avg_trk_err(3,3)    =   TRK_read_avg_error(cfn3, actualF)
        avg_trk_err(4,3)    =   TRK_read_avg_error(cfn4, actualF)

        odir             =   ['results_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_128__bPCA_128__RVQ__08_16_1000__TSVQ_06/'];
        cfn1                =   [odir 'FPerr_3_ipca.csv'];
        cfn2                =   [odir 'FPerr_3_bpca.csv'];
        cfn3                =   [odir 'FPerr_3_rvq.csv'];
        cfn4                =   [odir 'FPerr_3_tsvq.csv'];
        avg_trk_err(1,4)    =   TRK_read_avg_error(cfn1, actualF)
        avg_trk_err(2,4)    =   TRK_read_avg_error(cfn2, actualF)
        avg_trk_err(3,4)    =   TRK_read_avg_error(cfn3, actualF)
        avg_trk_err(4,4)    =   TRK_read_avg_error(cfn4, actualF)

        %h=figure(1);
        h=figure;
        bar(avg_trk_err)
        axis([0 5 0 20])
        grid on;
        %set(gca, 'FontSize', 8);   
        set(gca,'XTick',[1:4])
        a={'a';'b'};
        xtl = {{'iPCA';'16,32,64,128'} {'bPCA';'16,32,64,128'} {'RVQ';'8x(2,4,8,16)'} {'TSVQ';'3,4,5,6'}};
        my_xticklabels(gca,[1:4],xtl);
        UTIL_FILE_save2pdf  (['resultstrk_rmse_' PARAM.ds_3_name2 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '.pdf'],      h,     300); 
        
        if      (Nw==2) NW2(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==4) NW4(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==8) NW8(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==16) NW16(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==32) NW32(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==64) NW64(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==128) NW128(:,:,datasetCode) = avg_trk_err;
        elseif  (Nw==10000) NW10000(:,:,datasetCode) = avg_trk_err;    
        end
    end
    datasetCode
end
                              
% figure;bar(mean(NW2,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW4,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW8,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW16,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW32,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW64,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW128,3));grid;axis([0 5 0 45])
% figure;bar(mean(NW10000,3));grid;axis([0 5 0 45])
