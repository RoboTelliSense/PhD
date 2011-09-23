clear;
clc;
close all;


Np          =   600;
bUseBPCA     =   1;
bUseRVQ     =   1;
bUseTSVQ    =   1;

config=[];
config(1,:)=[16      8  2  1000     3 2];
config(2,:)=[32      8  4  1000     4 2];
config(3,:)=[64      8  8  1000     5 2];
config(4,:)=[128     8  16 1000     6 2];
% config(5,:)=[32      16 2  1000     4 2];
% config(6,:)=[64      16 4  1000     5 2];
% config(7,:)=[128     16 8  1000     6 2];
% config(8,:)=[256     16 16 1000     7 2];

j=0;
k=0;
avg_trk_err = -1*zeros(4,4);
for datasetCode=1:1
    [PARAM.ds_2_name, PARAM.ds_3_longName] = dataset_getName(datasetCode);
    
    for Nw = 2;%[2 4 8 16 32 64 128 10000]
        
        for w=0
        
            for c=1:size(config, 1)
                ipca_Neig       =   config(c,1);
                bpca_Neig       =   ipca_Neig;
                rvq_maxT        =   config(c,2);
                rvq_S           =   config(c,3);
                rvq_targetSNR   =   config(c,4);
                tsvq_T          =   config(c,5);
                j               =   j+1
                [config_name odir]         =   UTIL_DATASET_makeName(PARAM.ds_3_longName, bUseBPCA , bUseRVQ, bUseTSVQ, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
                cfn             =   [odir 'FPerr_3_ipca.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,1)=   [avg_trk_err a(f,3)];
                    k=k+1;
                end
                cfn             =   [odir 'FPerr_3_bpca.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,2)=   [avg_trk_err a(f,3)];
                    k=k+1;
                end
                cfn             =   [odir 'FPerr_3_rvq.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,3)=   [avg_trk_err a(f,3)];
                    k=k+1;
                end
                cfn             =   [odir 'FPerr_3_tsvq.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,4)=   [avg_trk_err a(f,3)];
                    k=k+1;
                end
                
            end
        end
    end
end
h=figure;
bar(avg_trk_err);
UTIL_FILE_save2pdf  ('test.pdf',      h,     150) ;
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'16, 8x2, 3';   ...
                      '32, 8x4, 4';   ...
                      '64, 8x8, 5';   ...
                      '128, 8x16, 6';})
                  colormap jet
xlabel('bPCA, iPCA, RVQ, TSVQ configurations');
ylabel('Tracking error');
legend('iPCA', 'bPCA', 'RVQ', 'TSVQ')
grid
