% script: trackparam.m
%     loads data and initializes variables
%

% Copyright (C) Jongwoo Lim and David Ross (modified with permission)
% Copyright (C) Salman Aslam (modified with permission)
% All rights reserved.

% DESCRIPTION OF OPTIONS:
%
% Following is a description of the options you can adjust for
% tracking, each proceeded by its default value.  For a new sequence
% you will certainly have to change p.  To set the other options,
% first try using the values given for one of the demonstration
% sequences, and change parameters as necessary.
%
% p = [px, py, sx, sy, theta]; The location of the target in the first
% frame.
% px and py are th coordinates of the centre of the box
% sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
% theta is the rotation angle of the box
%
% 'Np',400,   The number of samples used in the condensation
% algorithm/particle filter.  Increasing this will likely improve the
% results, but make the tracker slower.
%
% 'condenssig',0.01,  The standard deviation of the observation likelihood.
%
% 'ff',1, The forgetting factor, as described in the paper.  When
% doing the incremental update, 1 means remember all past data, and 0
% means remeber none of it.
%
% 'batchsize',5, How often to update the eigenbasis.  We've used this
% value (update every 5th frame) fairly consistently, so it most
% likely won't need to be changed.  A smaller batchsize means more
% frequent updates, making it quicker to model changes in appearance,
% but also a little more prone to drift, and require more computation.
%
% 'vecAff_variance_1x6',[4,4,.02,.02,.005,.001]  These are the standard deviations of
% the dynamics distribution, that is how much we expect the target
% object might move from one frame to the next.  The meaning of each
% number is as follows:
%
%    vecAff_variance_1x6(1) = x translation (pixels, mean is 0)
%    vecAff_variance_1x6(2) = y translation (pixels, mean is 0)
%    vecAff_variance_1x6(3) = rotation angle (radians, mean is 0)
%    vecAff_variance_1x6(4) = x scaling (pixels, mean is 1)
%    vecAff_variance_1x6(5) = y scaling (pixels, mean is 1)
%    vecAff_variance_1x6(6) = scaling angle (radians, mean is 0)
%
% OTHER OPTIONS THAT COULD BE SET HERE:
%
% 'tmplsize', [33,33] The resolution at which the tracking window is
% sampled, in this case 33 pixels by 33 pixels.  If your initial
% window (given by p) is very large you may need to increase this.
%
% 'maxbasis', 16 The number of basis vectors to keep in the learned
% apperance model.

% Change 'datasetName' to choose the sequence you wish to run.  If you set
% datasetName to 'dudek', for example, then it expects to find a file called 
% dudek.mat in the current directory.
%
% Setting dump_frames to true will cause all of the tracking results
% to be written out as .png images in the subdirectory ./dump/.  Make
% sure this directory has already been created.

function TRK_subspace_wrapper(Np, Nw, bWeighting,   ipca_Neig,    rvq_maxP, rvq_M, rvq_targetSNR,   tsvq_P, tsvq_M,     bUsebPCA, bUseRVQ, bUseTSVQ, datasetCode)


%-------------------------------------------------
%PRE-PROCESSING
%-------------------------------------------------
%overall settings
    bpca_Neig               =   ipca_Neig;
    dump_frames             =   false;
    max_signal_value        =   255;



    if      (datasetCode==1) datasetName = 'Dudek';         fullDatasetName='1___Dudek__________';
    elseif  (datasetCode==2) datasetName = 'davidin300';    fullDatasetName='2___davidin300_____';
    elseif  (datasetCode==3) datasetName = 'sylv';          fullDatasetName='3___sylv___________';
    elseif  (datasetCode==4) datasetName = 'trellis70';     fullDatasetName='4___trellis70______';
    elseif  (datasetCode==5) datasetName = 'fish';          fullDatasetName='5___fish__________';
    elseif  (datasetCode==6) datasetName = 'car4';          fullDatasetName='6___car4___________';
    elseif  (datasetCode==7) datasetName = 'car11';         fullDatasetName='7___car11__________';
    elseif  (datasetCode==8) datasetName = 'PETS2001rcf';   fullDatasetName='8___PETS2001rcf____';
    elseif  (datasetCode==9) datasetName = 'PETS2009';      fullDatasetName='9___PETS2009_______';
    elseif  (datasetCode==10) datasetName = 'AVSS2007_1';   fullDatasetName='10__AVSS2007_1_____';
    elseif  (datasetCode==11) datasetName = 'AVSS2007_2';   fullDatasetName='11__AVSS2007_2_____'; 
    elseif  (datasetCode==12) datasetName = 'AVSS2007_3';   fullDatasetName='12__AVSS2007_3_____'; 
    elseif  (datasetCode==13) datasetName = 'motinasFast';  fullDatasetName='13__motinasFast____';  
    end
   


    switch (datasetName)
        case 'Dudek';       p=[133,127,110,130,-0.08];sOptions=struct('Np',Np,'condenssig',0.25,'ff',1,  'batchsize',5,'vecAff_variance_1x6',[9,9,.05,.05,.005,.001]); 
        case 'davidin300';  p=[129 67 62 78 -0.02];   sOptions=struct('Np',Np,'condenssig',0.75,'ff',.99,'batchsize',5,'vecAff_variance_1x6',[5,5,.01,.02,.002,.001]); 
        case 'sylv';        p=[118 54 53 53 -0.2];    sOptions=struct('Np',Np,'condenssig',0.75,'ff',.95,'batchsize',5,'vecAff_variance_1x6',[7,7,.01,.02,.002,.001]); 
        case 'trellis70';   p=[178 76 45 49 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',.95,'batchsize',5,'vecAff_variance_1x6',[4,4,.01,.01,.002,.001]); 
        case 'fish';        p=[134 62 62 80 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[7,7,.01,.01,.002,.001]); 
        case 'car4';        p=[145 105 200 150 0];    sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[5,5,.025,.01,.002,.001]);
        case 'car11';       p=[74 128 30 25 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[5,5,.01,.01,.001,.001]); 
        case 'PETS2001rcf'; p=[414 341 13 37 0];      sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[1,1,.01,.01,.001,.001]); 
        case 'PETS2009';    p=[333 217 9 40 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[3,3,.05,.05,.002,.002]); 
        case 'AVSS2007_1';  p=[69 232 43 40 .07];     sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[3,3,.05,.05,.002,.002]); 
        case 'AVSS2007_2';  p=[60 234 37 37 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[3,3,.05,.05,.002,.002]); 
        case 'AVSS2007_3';  p=[213 67 14 14 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[2,2,.05,.05,.002,.002]); 
        %case 'motinas_fast';p=[218 95 48 72 0];      sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[15,15,.05,.05,.005,.002]); 
        %case 'motinas_fast';p=[38 140 41 65 0];      sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[12,12,.03,.03,.005,.001]); 
        case 'motinas_fast';p=[474 60 43 67 0];       sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[15,15,.05,.05,.005,.002]); 
        otherwise;  error(['unknown datasetName ' datasetName]);
    end

    p(1)                    =   p(1) + round(p(3)/2); %i added this because initially 
    p(2)                    =   p(2) + round(p(4)/2);



if (~exist('datatitle') | ~strcmp(datasetName,datatitle))
  if (exist('datatitle') & ~strcmp(datasetName,datatitle))
    disp(['datasetName does not match.. ' datasetName ' : ' datatitle ', continue?']);
    pause;
  end
  disp(['loading ' datasetName '...']);
  clear truepts;
  load([datasetName '.mat'],'data','datatitle','truepts');
end

load RandomData 


%!!caution: should i change 32 to 33? !!
vecAff_1x6 = [p(1), p(2), p(3)/32, p(5), p(4)/p(3), 0]; %x, y, width/32, angle, height/width, 0
vecAff_1x6 = affparam2mat(vecAff_1x6);

sOptions.dump = dump_frames;
if (sOptions.dump & exist('dump') ~= 7)
  error('dump directory does not exist.. turning dump option off..');
  sOptions.dump = 0;
end


%dir_out = 'test_out';
centerText = [];

                centerText = [centerText '__iPCA_'  UTIL_GetZeroPrefixedFileNumber_3(ipca_Neig)];
if  (bUsebPCA)  centerText = [centerText '__bPCA_'  UTIL_GetZeroPrefixedFileNumber_3(bpca_Neig)];                                                                                                   end
if  (bUseRVQ)   centerText = [centerText '__RVQ__'  UTIL_GetZeroPrefixedFileNumber_2(rvq_maxP) '_' UTIL_GetZeroPrefixedFileNumber_2(rvq_M) '_'  UTIL_GetZeroPrefixedFileNumber_4(rvq_targetSNR)];   end
if  (bUseTSVQ)  centerText = [centerText '__TSVQ_'  UTIL_GetZeroPrefixedFileNumber_2(tsvq_P)];                                                                                                      end

dir_out_wo_slash = ['results_'   fullDatasetName '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_' num2str(bWeighting) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np) centerText];
dir_out = UTIL_addSlash(dir_out_wo_slash);
mkdir(dir_out)
            
%complete filenames: images
    cfn_posraw              =   [dir_out 'positiveExamples.raw'];
    cfn_poscsv              =   [dir_out 'positiveExamples.csv'];      %file 1, this is the only file which maintains temporal info     
    cfn_dcbk                =   [dir_out 'codebook.dcbk'];                  %file 4
    cfn_gen_txt             =   [dir_out 'gen.txt'];
    rvq__cfn_6_numStages      =   [dir_out 'rvq__tst_numStages.csv'];
    
%complete filenames: csv files    
    ipca_cfn_1_affineParams =   [dir_out 'affineParams_1_ipca.csv'];
    bpca_cfn_1_affineParams =   [dir_out 'affineParams_1_bpca.csv']; 
    rvq__cfn_1_affineParams =   [dir_out 'affineParams_1_rvq.csv']; 
    tsvq_cfn_1_affineParams =   [dir_out 'affineParams_1_tsvq.csv']; 
    
    gt___cfn_2_featurePts   =   [dir_out 'featurePts_2_ground_truth.csv'];  %ground truth
    ipca_cfn_2_featurePts   =   [dir_out 'featurePts_2_ipca.csv'];
    bpca_cfn_2_featurePts   =   [dir_out 'featurePts_2_bpca.csv'];
    rvq__cfn_2_featurePts   =   [dir_out 'featurePts_2_rvq.csv'];
    tsvq_cfn_2_featurePts   =   [dir_out 'featurePts_2_tsvq.csv'];
        
    ipca_cfn_3_trkerr       =   [dir_out 'errTrk_3_ipca.csv'];
    bpca_cfn_3_trkerr       =   [dir_out 'errTrk_3_bpca.csv'];
    rvq__cfn_3_trkerr       =   [dir_out 'errTrk_3_rvq.csv'];
    tsvq_cfn_3_trkerr       =   [dir_out 'errTrk_3_tsvq.csv'];
    
    ipca_cfn_4_trgerr       =   [dir_out 'errTrg_4_ipca.csv'];
    bpca_cfn_4_trgerr       =   [dir_out 'errTrg_4_bpca.csv'];
    rvq__cfn_4_trgerr       =   [dir_out 'errTrg_4_rvq.csv'];
    tsvq_cfn_4_trgerr       =   [dir_out 'errTrg_4_tsvq.csv'];    
       
    ipca_cfn_5_tsterr       =   [dir_out 'errTst_5_ipca.csv'];
    bpca_cfn_5_tsterr       =   [dir_out 'errTst_5_bpca.csv'];
    rvq__cfn_5_tsterr       =   [dir_out 'errTst_5_rvq.csv'];
    tsvq_cfn_5_tsterr       =   [dir_out 'errTst_5_tsvq.csv'];    
   
      
    
                            UTIL_FILE_deleteFile(cfn_poscsv);  
                              
                            
                            UTIL_FILE_deleteFile(ipca_cfn_1_affineParams);
                            UTIL_FILE_deleteFile(bpca_cfn_1_affineParams);
                            UTIL_FILE_deleteFile(rvq__cfn_1_affineParams);
                            UTIL_FILE_deleteFile(tsvq_cfn_1_affineParams);

                            UTIL_FILE_deleteFile(gt___cfn_2_featurePts);
                            UTIL_FILE_deleteFile(ipca_cfn_2_featurePts);  
                            UTIL_FILE_deleteFile(bpca_cfn_2_featurePts);  
                            UTIL_FILE_deleteFile(rvq__cfn_2_featurePts);  
                            UTIL_FILE_deleteFile(tsvq_cfn_2_featurePts);  

                            UTIL_FILE_deleteFile(ipca_cfn_3_trkerr);      
                            UTIL_FILE_deleteFile(bpca_cfn_3_trkerr);      
                            UTIL_FILE_deleteFile(rvq__cfn_3_trkerr);      
                            UTIL_FILE_deleteFile(tsvq_cfn_3_trkerr);      

                            UTIL_FILE_deleteFile(ipca_cfn_4_trgerr);      
                            UTIL_FILE_deleteFile(bpca_cfn_4_trgerr);      
                            UTIL_FILE_deleteFile(rvq__cfn_4_trgerr);      
                            UTIL_FILE_deleteFile(tsvq_cfn_4_trgerr);      

                            UTIL_FILE_deleteFile(ipca_cfn_5_tsterr);      
                            UTIL_FILE_deleteFile(bpca_cfn_5_tsterr);      
                            UTIL_FILE_deleteFile(rvq__cfn_5_tsterr);      
                            UTIL_FILE_deleteFile(tsvq_cfn_5_tsterr); 
                            
                            UTIL_FILE_deleteFile(rvq__cfn_6_numStages);
                            
F = size(data,3);
colormap('gray');
                            TRK_subspace




% Use the following set of parameters for the ground truth experiment.
% It's much slower, but more accuracte.
%case 'dudek';  p = [188,192,110,130,-0.08];
%     sOptions = struct('Np',4000, 'condenssig',0.25, 'ff',0.99, ...
%                 'batchsize',5, 'vecAff_variance_1x6',[11,9,.05,.05,0,0], ...
%                 'errfunc','');


%case 'dudekgt';  p = [188,192,110,130,-0.08]; 
%   sOptions = struct('Np',4000, 'condenssig',1, 'ff',1, ...
%                 'batchsize',5, 'vecAff_variance_1x6',[6,5,.05,.05,0,0], ...
%                'errfunc','');

%case 'toycan';    p=[137 113 30 62 0];      sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[7,7,.01,.01,.002,.001]);  fullDatasetName='1';txt2='Dudek';
%case 'mushiake';  p=[172 145 60 60 0];      sOptions=struct('Np',Np,'condenssig',0.2, 'ff',1,  'batchsize',5,'vecAff_variance_1x6',[10,10,.01,.01,.002,.001]);fullDatasetName='1';txt2='Dudek';
