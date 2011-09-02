clear;
clc;
close all;



avg_trk_err=-1*[];
Np          =   600;
bUseBPCA     =   1;
bUseTSVQ    =   1;
bUseRVQ1    =   1;
bUseRVQ2    =   0;

config=[];
config(1,:)=[16      8  2  1000     3 2];
config(2,:)=[32      8  4  1000     4 2];
config(3,:)=[64      8  8  1000     5 2];
config(4,:)=[128     8  16 1000     6 2];
% config(5,:)=[32      16 2  1000     4 2];
% config(6,:)=[64      16 4  1000     5 2];
% config(7,:)=[128     16 8  1000     6 2];
% config(8,:)=[256     16 16 1000     7 2];
w=0;
Nw=2;
j=0;
for datasetCode = 1:7
    [CONST.ds_2_name, CONST.ds_3_longName, F] = dataset_getName(datasetCode);
    k=0;
    for algo = [{'ipca'} {'bpca'} {'rvq'} {'tsvq'}]
        k=k+1;
        for c=1:size(config, 1)
            ipca_Neig       =   config(c,1);
            bpca_Neig       =   ipca_Neig;
            rvq_maxT        =   config(c,2);
            rvq_S           =   config(c,3);
            rvq_targetSNR   =   config(c,4);
            tsvq_T          =   config(c,5);
            j               =   j+1
            [txt_overall_config dir_out_wo_slash dir_out]         =   UTIL_DATASET_makeName(CONST.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
            myname          =   ['results_'   CONST.ds_3_longName '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np)]
            cfn             =   [dir_out 'FPerr_3_' char(algo) '.csv'];
            if (exist(cfn,'file'))
                a               =   csvread(cfn);
                f               =   size(a,1);  %last frame number
                avg_trk_err(c,k)=   a(f,3);
                %k=k+1;
            end
        end
            %read_output_all_algos_one_config;
    end
        h=figure;
    bar(avg_trk_err)
    title(myname, 'Interpreter','None');
%     axis([0 5 0 30])
%     set(gca,'XTick',[1:4])
%     set(gca,'XTickLabel',{'8x2';   ...
%                                   '8x4';   ...
%                                   '8x8';   ...
%                                   '8x16';})   
%                               xlabel('2,4,8,16,32,64,128,$\infty$', 'Interpreter','Latex');
%     UTIL_FILE_save2pdf  ([myname '.pdf'],      h,     300);  
end

%RVQ
% Nw=2;
% w=0;
% for datasetCode = 1:7
%     [CONST.ds_2_name, CONST.ds_3_longName, F] = dataset_getName(datasetCode);
%     k=0;
%     for Nw = [2 4 8 16 32 64 128 10000]
%         k=k+1;
%         for c=1:size(config, 1)
%             ipca_Neig       =   config(c,1);
%             bpca_Neig       =   ipca_Neig;
%             rvq_maxT        =   config(c,2);
%             rvq_S           =   config(c,3);
%             rvq_targetSNR   =   config(c,4);
%             tsvq_T          =   config(c,5);
%             j               =   j+1;
%             [txt_overall_config dir_out_wo_slash dir_out]         =   UTIL_DATASET_makeName(CONST.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
%             myname          =   ['results_'   CONST.ds_3_longName '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np) '_RVQ'];   
%             cfn             =   [dir_out 'FPerr_3_rvq.csv'];
%             if (exist(cfn,'file'))
%                 a               =   csvread(cfn);
%                 f               =   size(a,1);  %last frame number
%                 avg_trk_err(c,k)=   a(f,3);
%                 %k=k+1;
%             end
%         end
%         
%     end
%     h=figure;
%     bar(avg_trk_err)
%     title(myname, 'Interpreter','None');
%     axis([0 5 0 30])
%     set(gca,'XTick',[1:4])
%     set(gca,'XTickLabel',{'8x2';   ...
%                                   '8x4';   ...
%                                   '8x8';   ...
%                                   '8x16';})   
%                               xlabel('2,4,8,16,32,64,128,$\infty$', 'Interpreter','Latex');
%     UTIL_FILE_save2pdf  ([myname '.pdf'],      h,     300);                               
% end
% 
% 
% 
% 
% 
% 
% %TSVQ
% w=0;
% for datasetCode = 1:7
%     [CONST.ds_2_name, CONST.ds_3_longName, F] = dataset_getName(datasetCode);
%     k=0;
%     for Nw = [2 4 8 16 32 64 128 10000]
%         k=k+1;
%         for c=1:size(config, 1)
%             ipca_Neig       =   config(c,1);
%             bpca_Neig       =   ipca_Neig;
%             rvq_maxT        =   config(c,2);
%             rvq_S           =   config(c,3);
%             rvq_targetSNR   =   config(c,4);
%             tsvq_T          =   config(c,5);
%             j               =   j+1;
%             [txt_overall_config dir_out_wo_slash dir_out]         =   UTIL_DATASET_makeName(CONST.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
%             myname          =   ['results_'   CONST.ds_3_longName '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np) '_TSVQ'];   
%             cfn             =   [dir_out 'FPerr_3_tsvq.csv'];
%             if (exist(cfn,'file'))
%                 a               =   csvread(cfn);
%                 f               =   size(a,1);  %last frame number
%                 avg_trk_err(c,k)=   a(f,3);
%                 %k=k+1;
%             end
%         end
%         
%     end
%     h=figure;
%     bar(avg_trk_err)
%     title(myname, 'Interpreter','None');
%     axis([0 5 0 30])
%     set(gca,'XTick',[1:4])
%     set(gca,'XTickLabel',{'3';   ...
%                                   '4';   ...
%                                   '5';   ...
%                                   '6';})   
%                               xlabel('2,4,8,16,32,64,128,$\infty$', 'Interpreter','Latex');
%                               
%     UTIL_FILE_save2pdf  ([myname '.pdf'],      h,     300);                               
% end
% 
% 
% 
% %bPCA
% w=0;
% for datasetCode = 1:7
%     [CONST.ds_2_name, CONST.ds_3_longName, F] = dataset_getName(datasetCode);
%     k=0;
%     for Nw = [2 4 8 16 32 64 128 10000]
%         k=k+1;
%         for c=1:size(config, 1)
%             ipca_Neig       =   config(c,1);
%             bpca_Neig       =   ipca_Neig;
%             rvq_maxT        =   config(c,2);
%             rvq_S           =   config(c,3);
%             rvq_targetSNR   =   config(c,4);
%             tsvq_T          =   config(c,5);
%             j               =   j+1;
%             [txt_overall_config dir_out_wo_slash dir_out]         =   UTIL_DATASET_makeName(CONST.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
%             myname          =   ['results_'   CONST.ds_3_longName '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np) '_bPCA'];   
%             cfn             =   [dir_out 'FPerr_3_bpca.csv'];
%             if (exist(cfn,'file'))
%                 a               =   csvread(cfn);
%                 f               =   size(a,1);  %last frame number
%                 avg_trk_err(c,k)=   a(f,3);
%                 %k=k+1;
%             end
%         end
%         
%     end
%     h=figure;
%     bar(avg_trk_err)
%     title(myname, 'Interpreter','None');
%     axis([0 5 0 30])
%     set(gca,'XTick',[1:4])
%     set(gca,'XTickLabel',{'16';   ...
%                                   '32';   ...
%                                   '64';   ...
%                                   '128';})   
%                               xlabel('2,4,8,16,32,64,128,$\infty$', 'Interpreter','Latex');
%                               
%     UTIL_FILE_save2pdf  ([myname '.pdf'],      h,     300);                               
% end
% 
% 
% %iPCA
% w=0;
% for datasetCode = 1:7
%     [CONST.ds_2_name, CONST.ds_3_longName, F] = dataset_getName(datasetCode);
%     k=0;
%     for Nw = [2 4 8 16 32 64 128 10000]
%         k=k+1;
%         for c=1:size(config, 1)
%             ipca_Neig       =   config(c,1);
%             bpca_Neig       =   ipca_Neig;
%             rvq_maxT        =   config(c,2);
%             rvq_S           =   config(c,3);
%             rvq_targetSNR   =   config(c,4);
%             tsvq_T          =   config(c,5);
%             j               =   j+1;
%             [txt_overall_config dir_out_wo_slash dir_out]         =   UTIL_DATASET_makeName(CONST.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
%             myname          =   ['results_'   CONST.ds_3_longName '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np) '_iPCA'];   
%             cfn             =   [dir_out 'FPerr_3_ipca.csv'];
%             if (exist(cfn,'file'))
%                 a               =   csvread(cfn);
%                 f               =   size(a,1);  %last frame number
%                 avg_trk_err(c,k)=   a(f,3);
%                 %k=k+1;
%             end
%         end
%         
%     end
%     h=figure;
%     bar(avg_trk_err)
%     title(myname, 'Interpreter','None');
%     axis([0 5 0 30])
%     set(gca,'XTick',[1:4])
%     set(gca,'XTickLabel',{'16';   ...
%                                   '32';   ...
%                                   '64';   ...
%                                   '128';})   
%                               xlabel('2,4,8,16,32,64,128,$\infty$', 'Interpreter','Latex');
%                               
%     UTIL_FILE_save2pdf  ([myname '.pdf'],      h,     300);                               
% end
