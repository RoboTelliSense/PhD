%> @file
%> @brief
%>
%> Options for tracking
%> --------------------
%> xywht                        :   [top_left_x top_left_y w h theta], it's easier to get target parameters in xywht form 
%>                                  from an image in say Irfanview.  this is converted to affine parameters 
%> aff_abcdxy_1x6               :   i convert from 
%> con_normalizer               :   
%> ff                       :   forgetting factor for incremental SVD
%> aff_tsrpxy_stddev_1x6         :   variance on affine parameters
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created : Aug 17, 2011
%> Date modified: Aug 17, 2011


function [PARAM, I_HxWxF, GT, RAND] = TRK_read_input(PARAM)  %parameters, images, ground truth, random data

	         
%-----------------------------------------------
%PRE-PROCESSING
%-----------------------------------------------
	
%fn: filename (convert datasetCode to datasetName)
    if      (PARAM.in_datasetCode==0)  PARAM.ds_2_name = 'test';          PARAM.ds_3_longName='0___test___________'; %ds is for dataset
    elseif  (PARAM.in_datasetCode==1)  PARAM.ds_2_name = 'Dudek';         PARAM.ds_3_longName='1___Dudek__________';
    elseif  (PARAM.in_datasetCode==2)  PARAM.ds_2_name = 'davidin300';    PARAM.ds_3_longName='2___davidin300_____';
    elseif  (PARAM.in_datasetCode==3)  PARAM.ds_2_name = 'sylv';          PARAM.ds_3_longName='3___sylv___________';
    elseif  (PARAM.in_datasetCode==4)  PARAM.ds_2_name = 'trellis70';     PARAM.ds_3_longName='4___trellis70______';
    elseif  (PARAM.in_datasetCode==5)  PARAM.ds_2_name = 'fish';          PARAM.ds_3_longName='5___fish___________';
    elseif  (PARAM.in_datasetCode==6)  PARAM.ds_2_name = 'car4';          PARAM.ds_3_longName='6___car4___________';
    elseif  (PARAM.in_datasetCode==7)  PARAM.ds_2_name = 'car11';         PARAM.ds_3_longName='7___car11__________';
    elseif  (PARAM.in_datasetCode==8)  PARAM.ds_2_name = 'PETS2001rcf';   PARAM.ds_3_longName='8___PETS2001rcf____';
    elseif  (PARAM.in_datasetCode==9)  PARAM.ds_2_name = 'PETS2009';      PARAM.ds_3_longName='9___PETS2009_______';
    elseif  (PARAM.in_datasetCode==10) PARAM.ds_2_name = 'AVSS2007_1';    PARAM.ds_3_longName='10__AVSS2007_1_____';
    elseif  (PARAM.in_datasetCode==11) PARAM.ds_2_name = 'AVSS2007_2';    PARAM.ds_3_longName='11__AVSS2007_2_____'; 
    elseif  (PARAM.in_datasetCode==12) PARAM.ds_2_name = 'AVSS2007_3';    PARAM.ds_3_longName='12__AVSS2007_3_____'; 
    elseif  (PARAM.in_datasetCode==13) PARAM.ds_2_name = 'motinasFast';   PARAM.ds_3_longName='13__motinasFast____';  
    end
    
    %rigid parameters 
    switch (PARAM.ds_2_name)
        case 'test';        xywht=[133 127 110 130 -0.08]; con_normalizer=0.25; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .005  .001 9  9  ]; 
        case 'Dudek';       xywht=[133 127 110 130 -0.08]; con_normalizer=0.25; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .005  .001 9  9  ]; 
        case 'davidin300';  xywht=[129 67  62  78  -0.02]; con_normalizer=0.75; ff=0.99; aff_tsrpxy_stddev_1x6=[.02  .01  .002  .001 5  5  ]; 
        case 'sylv';        xywht=[118 54  53  53  -0.20]; con_normalizer=0.75; ff=0.95; aff_tsrpxy_stddev_1x6=[.02  .01  .002  .001 7  7  ]; 
        case 'trellis70';   xywht=[178 76  45  49   0   ]; con_normalizer=0.20; ff=0.95; aff_tsrpxy_stddev_1x6=[.01  .01  .002  .001 4  4  ]; 
        case 'fish';        xywht=[134 62  62  80   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .01  .002  .001 7  7  ]; 
        case 'car4';        xywht=[145 105 200 150  0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .025 .002  .001 5  5  ];
        case 'car11';       xywht=[74  128 30  25   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .01  .001  .001 5  5  ]; 
        case 'PETS2001rcf'; xywht=[414 341 13  37   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .01  .001  .001 1  1  ]; 
        case 'PETS2009';    xywht=[333 217 9   40   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 3  3  ]; 
        case 'AVSS2007_1';  xywht=[69  232 43  40   0.07]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 3  3  ]; 
        case 'AVSS2007_2';  xywht=[60  234 37  37   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 3  3  ]; 
        case 'AVSS2007_3';  xywht=[213 67  14  14   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 2  2  ]; 
        case 'motinas_fast';xywht=[474 60  43  67   0   ]; con_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .005  .002 15 15 ]; 
        otherwise;  error(['unknown PARAM.ds_2_name ' PARAM.ds_2_name]);
    end    
    
    aff_tsrpxy_1x6          =   UTIL_2D_affine_xywht_to_tsrpxy(xywht, PARAM.aff_scale);    
    aff_abcdxy_1x6          =   UTIL_2D_affine_tsrpxy_to_abcdxy(aff_tsrpxy_1x6); %convert to affine parameters (abcdxy)

%-----------------------------------------------
%PROCESSING
%-----------------------------------------------	
%load data
	disp(['loading dataset ' PARAM.ds_2_name ' and its ground truth ...']);
	load([PARAM.ds_2_name '.mat'],'data','datatitle','truepts');

    disp(['loading pre-stored random data for repeatability ...']);
    load RandomData 
%-----------------------------------------------
%POST-PROCESSING (return 4 structures)
%-----------------------------------------------
%1. parameters
    PARAM.ds_4_F            =   size(data,3);               %total number of frames
    PARAM.ds_5_ff           =   ff;                         %forgetting factor
    PARAM.ds_6_con_stddev   =   con_normalizer;             %condensation algorithm, normalizer
    PARAM.ds_aff_abcdxy_1x6 =   aff_abcdxy_1x6;             %affine: a, b, c, d, tx, ty
    PARAM.ds_aff_tsrpxy_stddev_1x6  ...
                            =   aff_tsrpxy_stddev_1x6;      %affine: theta, s, r, phi, tx, ty
	
%2. image data
    I_HxWxF                 =   data;                           %read all images, height x width x number of frames 
	
%3. ground truth
    GT.fpt_1_truth_2xGxF    =   truepts;                    %ground truth for the feature points
    GT.fpt_2_G_____1x1      =   size(GT.fp_1_truth_2xGxF,2);  %number of feature points per image, this is 7 for Dudek and I think 2 for others
    GT.fpt_3_refzc_2xG      =   PARAM.ds_aff_abcdxy_1x6([3,4,1;5,6,2]) * [GT.fp_1_truth_2xGxF(:,:,1); ones(1,GT.fp_2_G_____1x1)];
    
%4. random input
    RAND.gaus_maxFx6xNp     =   RandomData_sample; %pre-stored random numbers to ensure repeatability, maxF=1000 since we do not anticipate more than 1000 frames  
    RAND.unif_cdf_maxFxNp   =   RandomData_cdf;
    
    clear data truepts RandomData_sample RandomData_cdf;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%> Use the following set of parameters for the ground truth experiment.
%> It's much slower, but more accuracte.
%case 'dudek';  aff_abcdxy_1x6 = [188,192,110,130,-0.08];
%>     PARAM = struct('Np',4000, 'con_normalizer=0.25, 'ff',0.99, ...
%>                 'batchsize',5, 'aff_tsrpxy_stddev_1x6',[11,9,.05,.05,0,0], ...
%>                 'errfunc','');


%case 'dudekgt';  aff_abcdxy_1x6 = [188,192,110,130,-0.08]; 
%>   PARAM = struct('Np',4000, 'con_normalizer=1, 'ff',1, ...
%>                 'batchsize',5, 'aff_tsrpxy_stddev_1x6',[6,5,.05,.05,0,0], ...
%>                'errfunc','');

%case 'toycan';    aff_abcdxy_1x6=[137 113 30 62 0];      PARAM.in_Np',Np,'con_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tsrpxy_stddev_1x6',[7,7,.01,.01,.002,.001]);  PARAM.ds_3_longName='1';txt2='Dudek';
%case 'mushiake';  aff_abcdxy_1x6=[172 145 60 60 0];      PARAM.in_Np',Np,'con_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tsrpxy_stddev_1x6',[10,10,.01,.01,.002,.001]);PARAM.ds_3_longName='1';txt2='Dudek';
    
    