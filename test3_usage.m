clear;
clc;
close all;

batch_size=5;
thresh=20; %tracking error above this is considered track lost

range      =   [1 2 3 5 6 7];
numDatasets = length(range);
iPCAconfigs = 7;
bPCAconfigs = 7;
RVQconfigs = 8;
TSVQconfigs = 7;

%go over datasetCode
for d = range
    errType =   'Trk_3'; ylab = 'Euclidean distance';
    test3
    
     errType =   'Trg_4'; ylab = 'Luminance rmse';
     test3
     
     errType =   'Tst_5'; ylab = 'Luminance rmse';
     test3
end


%averages
%--------
    h=figure;
    iPCA_overall_avg_trk_err    =   mean(iPCA_avg_trk_err);
    bPCA_overall_avg_trk_err    =   mean(bPCA_avg_trk_err);
    RVQ_overall_avg_trk_err     =   mean(RVQ_avg_trk_err);
    TSVQ_overall_avg_trk_err    =   mean(TSVQ_avg_trk_err);
    overall_avg_trk_err         =   [iPCA_overall_avg_trk_err bPCA_overall_avg_trk_err RVQ_overall_avg_trk_err TSVQ_overall_avg_trk_err]
    bar(overall_avg_trk_err);
    set(gca, 'XTickLabel', [{'iPCA', 'bPCA', 'RVQ', 'TSVQ'}]);
    grid;
    UTIL_FILE_save2pdf('results_overall_avg_trk_err', h, 300);

    h=figure;
    iPCA_overall_avg_trg_err    =   mean(iPCA_avg_trg_err);
    bPCA_overall_avg_trg_err    =   mean(bPCA_avg_trg_err);
    RVQ_overall_avg_trg_err     =   mean(RVQ_avg_trg_err);
    TSVQ_overall_avg_trg_err    =   mean(TSVQ_avg_trg_err);
    overall_avg_trg_err         =   [iPCA_overall_avg_trg_err bPCA_overall_avg_trg_err RVQ_overall_avg_trg_err TSVQ_overall_avg_trg_err]
    bar(overall_avg_trg_err);
    set(gca, 'XTickLabel', [{'iPCA', 'bPCA', 'RVQ', 'TSVQ'}]);
    grid;
    UTIL_FILE_save2pdf('results_overall_avg_trg_err', h, 300);

    h=figure;
    iPCA_overall_avg_tst_err    =   mean(iPCA_avg_tst_err);
    bPCA_overall_avg_tst_err    =   mean(bPCA_avg_tst_err);
    RVQ_overall_avg_tst_err     =   mean(RVQ_avg_tst_err);
    TSVQ_overall_avg_tst_err    =   mean(TSVQ_avg_tst_err);
    overall_avg_tst_err         =   [iPCA_overall_avg_tst_err bPCA_overall_avg_tst_err RVQ_overall_avg_tst_err TSVQ_overall_avg_tst_err]
    bar(overall_avg_tst_err);
    set(gca, 'XTickLabel', [{'iPCA', 'bPCA', 'RVQ', 'TSVQ'}]);
    grid;
    UTIL_FILE_save2pdf('results_overall_avg_tst_err', h, 300);

    h=figure;
    iPCA_correct_trk                                            =   (sum(sum(sum(iPCA_correct_Mask)))/392)*100 %total configs: 7 datasets * 7 configs/dataset * 8 params = 392
    bPCA_correct_trk                                            =   (sum(sum(sum(bPCA_correct_Mask)))/392)*100 %total configs: 7 datasets * 7 configs/dataset * 8 params = 392
    RVQ_correct_trk                                             =   (sum(sum(sum(RVQ_correct_Mask)))/448)*100 %total configs: 7 datasets * 8 configs/dataset * 8 params = 448
    TSVQ_correct_trk                                            =   (sum(sum(sum(TSVQ_correct_Mask)))/392)*100 %total configs: 7 datasets * 8 configs/dataset * 8 params = 392
    overall_correct_trk_percent                                 =   [iPCA_correct_trk bPCA_correct_trk RVQ_correct_trk TSVQ_correct_trk]
    bar(overall_correct_trk_percent);
    set(gca, 'XTickLabel', [{'iPCA', 'bPCA', 'RVQ', 'TSVQ'}]);
    grid;
    UTIL_FILE_save2pdf('results_correct_trk_percent', h, 300);



%configs
%-------
    h=figure;
    a=iPCA.*iPCA_correct_Mask;
    b=mean(a,3)
    c=mean(b,2)
    overall_iPCAconfigs_trk_err =   c
    bar(overall_iPCAconfigs_trk_err);
    set(gca, 'XTickLabel', [{'2', '4', '8', '16', '32', '64', '128'}]);
    axis([0 8 0 8])
    grid;
    UTIL_FILE_save2pdf('overall_iPCAconfigs_trk_err', h, 300);



    h=figure;
    a=bPCA.*bPCA_correct_Mask;
    b=mean(a,3)
    c=mean(b,2)
    overall_bPCAconfigs_trk_err =   c
    bar(overall_bPCAconfigs_trk_err);
    set(gca, 'XTickLabel', [{'2', '4', '8', '16', '32', '64', '128'}]);
    axis([0 8 0 8])
    grid;
    UTIL_FILE_save2pdf('overall_bPCAconfigs_trk_err', h, 300);


    h=figure;
    a=RVQ.*RVQ_correct_Mask;
    b=mean(a,3)
    c=mean(b,2)
    overall_RVQconfigs_trk_err =   c
    bar(overall_RVQconfigs_trk_err);
    set(gca, 'XTickLabel', [{'8x2', '16x2', '8x4', '16x4', '8x8', '16x8', '8x16', '16x16'}]);
    axis([0 9 0 20])
    grid;
    UTIL_FILE_save2pdf('overall_RVQconfigs_trk_err', h, 300);


    h=figure;
    a=TSVQ.*TSVQ_correct_Mask;
    b=mean(a,3)
    c=mean(b,2)
    overall_TSVQconfigs_trk_err =   c
    bar(overall_TSVQconfigs_trk_err);
    set(gca, 'XTickLabel', [{'1', '2', '3', '4', '5', '6', '7'}]);
    axis([0 7 0 8])
    grid;
    UTIL_FILE_save2pdf('overall_TSVQconfigs_trk_err', h, 300);


%track hold
%----------
    h=figure;
    a=iPCA_correct_Mask;
    b=sum(a,3)
    c=sum(b,2)
    overall_iPCAconfigs_trk_hold =   (c/(numDatasets*iPCAconfigs))*100
    bar(overall_iPCAconfigs_trk_hold);
    set(gca, 'XTickLabel', [{'2', '4', '8', '16', '32', '64', '128'}]);
    grid;
    axis([0 8 0 100])
    UTIL_FILE_save2pdf('overall_iPCAconfigs_trk_hold', h, 300);


    h=figure;
    a=bPCA_correct_Mask;
    b=sum(a,3)
    c=sum(b,2)
    overall_bPCAconfigs_trk_hold =   (c/numDatasets*bPCAconfigs)*100
    bar(overall_bPCAconfigs_trk_hold);
    set(gca, 'XTickLabel', [{'2', '4', '8', '16', '32', '64', '128'}]);
    grid;
    axis([0 8 0 100])
    UTIL_FILE_save2pdf('overall_bPCAconfigs_trk_hold', h, 300);



    h=figure;
    a=RVQ_correct_Mask;
    b=sum(a,3)
    c=sum(b,2)
    overall_RVQconfigs_trk_hold =   (c/numDatasets*RVQconfigs)*100
    bar(overall_RVQconfigs_trk_hold);
    set(gca, 'XTickLabel', [{'8x2', '16x2', '8x4', '16x4', '8x8', '16x8', '8x16', '16x16'}]);
    grid;
    axis([0 9 0 100])
    UTIL_FILE_save2pdf('overall_RVQconfigs_trk_hold', h, 300);


    h=figure;
    a=TSVQ_correct_Mask;
    b=sum(a,3)
    c=sum(b,2)
    overall_TSVQconfigs_trk_hold =   (c/numDatasets*TSVQconfigs)*100
    bar(overall_TSVQconfigs_trk_hold);
    set(gca, 'XTickLabel', [{'1', '2', '3', '4', '5', '6', '7'}]);
    grid;
    axis([0 7 0 100])
    UTIL_FILE_save2pdf('overall_TSVQconfigs_trk_hold', h, 300);