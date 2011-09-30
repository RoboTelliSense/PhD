clear;
clc;
close all;

%given Nw, all algos
for datasetCode = 1:7
    [PARAM.ds_2_name, PARAM.ds_3_name, actualF] = UTIL_DATASET_getName2(datasetCode);

    for algo = [{'ipca'} {'bpca'} {'rvq'} {'tsvq'}];
        avg_trk_err = [];
        i=1;
        for Nw=[2 4 8 16 32 64 128 10000]
            odir             =   ['results_' PARAM.ds_3_name '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03/'];
            cfn3                =   [odir 'errTst_5_' char(algo) '.csv'];
            avg_trk_err(1,i)    =   TRK_read_avg_error(cfn3, actualF); %for this configuration, all Nw's are in one row, and therefore grouped together in the bar plot
            i                   =   i+1;
        end

        i=1;
        for Nw=[2 4 8 16 32 64 128 10000]
            odir             =   ['results_' PARAM.ds_3_name '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_032__bPCA_032__RVQ__08_04_1000__TSVQ_04/'];
            cfn3                =   [odir 'errTst_5_' char(algo) '.csv'];
            avg_trk_err(2,i)    =   TRK_read_avg_error(cfn3, actualF);
            i                   =   i+1;
        end

        i=1;
        for Nw=[2 4 8 16 32 64 128 10000]
            odir             =   ['results_' PARAM.ds_3_name '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_064__bPCA_064__RVQ__08_08_1000__TSVQ_05/'];
            cfn3                =   [odir 'errTst_5_' char(algo) '.csv'];
            avg_trk_err(3,i)    =   TRK_read_avg_error(cfn3, actualF);
            i                   =   i+1;
        end


        i=1;
        for Nw=[2 4 8 16 32 64 128 10000]
            odir             =   ['results_' PARAM.ds_3_name '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_0_Np_0600__iPCA_128__bPCA_128__RVQ__08_16_1000__TSVQ_06/'];
            cfn3                =   [odir 'errTst_5_' char(algo) '.csv'];
            avg_trk_err(4,i)    =   TRK_read_avg_error(cfn3, actualF);
            i                   =   i+1;
        end    

        
        h=figure(1);
        bar(avg_trk_err)
        axis([0 5 0 45])
        grid on;
        %set(gca, 'FontSize', 8);   
        set(gca,'XTick',[1:4])
        if      strcmp(char(algo), 'ipca')    set(gca,'XTickLabel',{'16'; '32'; '64'; '128';});     iPCA(:, :, datasetCode)    =   avg_trk_err;
        elseif  strcmp(char(algo), 'bpca')    set(gca,'XTickLabel',{'16'; '32'; '64'; '128';});     bPCA(:, :, datasetCode)    =   avg_trk_err;
        elseif  strcmp(char(algo), 'rvq')     set(gca,'XTickLabel',{'8x2'; '8x4'; '8x8'; '8x16';}); RVQ(:, :, datasetCode)    =   avg_trk_err; 
        elseif  strcmp(char(algo), 'tsvq')    set(gca,'XTickLabel',{'3'; '4'; '5'; '6';});          TSVQ(:, :, datasetCode)    =   avg_trk_err;
        end
        UTIL_FILE_save2pdf  (['results_errTst_' PARAM.ds_3_name '_' char(algo) '.pdf'],      h,     300); 
        
    end
    
end

close all;

    
figure;bar(mean(iPCA,3));axis([0 5 0 45])
figure;bar(mean(bPCA,3));axis([0 5 0 45])
figure;bar(mean(RVQ,3));axis([0 5 0 45])
figure;bar(mean(TSVQ,3));axis([0 5 0 45])
   