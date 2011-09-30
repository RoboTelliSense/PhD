%> @file
%> @brief
%>
%> Options for tracking
%> --------------------
%> xywht                        :   [top_left_x top_left_y w h theta], it's easier to get target parameters in xywht form 
%>                                  from an image in say Irfanview.  this is converted to affine parameters 
%> aff_abcdxy_1x6               :   i convert from 
%> PF_normalizer               :   
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
    if      (PARAM.in_ds_code==0)  PARAM.ds_2_name = 'test';          PARAM.ds_3_name2='0_test___'; %ds is for dataset
    elseif  (PARAM.in_ds_code==1)  PARAM.ds_2_name = 'Dudek';         PARAM.ds_3_name2='1_Dudek__';
    elseif  (PARAM.in_ds_code==2)  PARAM.ds_2_name = 'davidin300';    PARAM.ds_3_name2='2_David__';
    elseif  (PARAM.in_ds_code==3)  PARAM.ds_2_name = 'sylv';          PARAM.ds_3_name2='3_Sylvs__';
    elseif  (PARAM.in_ds_code==4)  PARAM.ds_2_name = 'trellis70';     PARAM.ds_3_name2='4_Trels__';
    elseif  (PARAM.in_ds_code==5)  PARAM.ds_2_name = 'fish';          PARAM.ds_3_name2='5_Fish___';
    elseif  (PARAM.in_ds_code==6)  PARAM.ds_2_name = 'car4';          PARAM.ds_3_name2='6_Dodge__';
    elseif  (PARAM.in_ds_code==7)  PARAM.ds_2_name = 'car11';         PARAM.ds_3_name2='7_CarNgt_';
    elseif  (PARAM.in_ds_code==8)  PARAM.ds_2_name = 'PETS2001rcf';   PARAM.ds_3_name2='8_PETS2001rcf____';
    elseif  (PARAM.in_ds_code==9)  PARAM.ds_2_name = 'PETS2009';      PARAM.ds_3_name2='9_PETS2009_______';
    elseif  (PARAM.in_ds_code==10) PARAM.ds_2_name = 'AVSS2007_1';    PARAM.ds_3_name2='10_AVSS2007_1_____';
    elseif  (PARAM.in_ds_code==11) PARAM.ds_2_name = 'AVSS2007_2';    PARAM.ds_3_name2='11_AVSS2007_2_____'; 
    elseif  (PARAM.in_ds_code==12) PARAM.ds_2_name = 'AVSS2007_3';    PARAM.ds_3_name2='12_AVSS2007_3_____'; 
    elseif  (PARAM.in_ds_code==13) PARAM.ds_2_name = 'motinasFast';   PARAM.ds_3_name2='13_motinasFast____';  
    end
    
    %rigid parameters 
    switch (PARAM.ds_2_name)
        case 'test';        xywht=[133 127 110 130 -0.08]; PF_normalizer=0.25; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .005  .001 9  9  ]; 
        case 'Dudek';       xywht=[133 127 110 130 -0.08]; PF_normalizer=0.25; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .005  .001 9  9  ]; 
        case 'davidin300';  xywht=[129 67  62  78  -0.02]; PF_normalizer=0.75; ff=0.99; aff_tsrpxy_stddev_1x6=[.02  .01  .002  .001 5  5  ]; 
        case 'sylv';        xywht=[118 54  53  53  -0.20]; PF_normalizer=0.75; ff=0.95; aff_tsrpxy_stddev_1x6=[.02  .01  .002  .001 7  7  ]; 
        case 'trellis70';   xywht=[178 76  45  49   0   ]; PF_normalizer=0.20; ff=0.95; aff_tsrpxy_stddev_1x6=[.01  .01  .002  .001 4  4  ]; 
        case 'fish';        xywht=[134 62  62  80   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .01  .002  .001 7  7  ]; 
        case 'car4';        xywht=[145 105 200 150  0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .025 .002  .001 5  5  ];
        case 'car11';       xywht=[74  128 30  25   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .01  .001  .001 5  5  ]; 
        case 'PETS2001rcf'; xywht=[414 341 13  37   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.01  .01  .001  .001 1  1  ]; 
        case 'PETS2009';    xywht=[333 217 9   40   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 3  3  ]; 
        case 'AVSS2007_1';  xywht=[69  232 43  40   0.07]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 3  3  ]; 
        case 'AVSS2007_2';  xywht=[60  234 37  37   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 3  3  ]; 
        case 'AVSS2007_3';  xywht=[213 67  14  14   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .002  .002 2  2  ]; 
        case 'motinas_fast';xywht=[474 60  43  67   0   ]; PF_normalizer=0.20; ff=1.00; aff_tsrpxy_stddev_1x6=[.05  .05  .005  .002 15 15 ]; 
        otherwise;  error(['unknown PARAM.ds_2_name ' PARAM.ds_2_name]);
    end    
    
    aff_tsrpxy_1x6          =   UTIL_2D_affine_xywht_to_tsrpxy(xywht, PARAM.tgt_scale);    
    

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
    PARAM.ds_6_PF_normalizer=   PF_normalizer;              %particle filter, normalizer
    PARAM.ds_7_tsrpxy_1x6   =   aff_tsrpxy_1x6;             %affine: theta, s, r, phi, tx, ty
    PARAM.ds_8_tsrpxy_1x6_stddev  ...
                            =   aff_tsrpxy_stddev_1x6;      %affine: theta, s, r, phi, tx, ty
	
%2. image data
    I_HxWxF                 =   data;                           %read all images, height x width x number of frames 
	
%3. ground truth
    GT.fpt_1_truth_2xGxF    =   truepts;                            %ground truth for the feature points
    GT.fpt_2_G              =   size(GT.fpt_1_truth_2xGxF,2);       %number of feature points per image, this is 7 for Dudek and I think 2 for others
    
    Ha_2x3                  =   UTIL_2D_affine_tsrpxy_to_Ha_2x3(PARAM.ds_7_tsrpxy_1x6);
    X                       =   GT.fpt_1_truth_2xGxF(1,:,1);         %x coordinates, ground truth feature points in first frame
    Y                       =   GT.fpt_1_truth_2xGxF(2,:,1);         %y      "          "     "      "      "     "   "     "
    GT.fpt_3_refzc_2xG      =   UTIL_2D_affine_apply_inverse_transform(Ha_2x3, [X;Y]);
    clear X Y;
    
%4. random input
    RAND.gaus_maxFx6xNp     =   RandomData_sample; %pre-stored random numbers to ensure repeatability, maxF=1000 since we do not anticipate more than 1000 frames  
    RAND.unif_cdf_maxFxNp   =   RandomData_cdf;
    
    clear data truepts RandomData_sample RandomData_cdf;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%> Use the following set of parameters for the ground truth experiment.
%> It's much slower, but more accuracte.
%case 'dudek';  aff_abcdxy_1x6 = [188,192,110,130,-0.08];
%>     PARAM = struct('Np',4000, 'PF_normalizer=0.25, 'ff',0.99, ...
%>                 'batchsize',5, 'aff_tsrpxy_stddev_1x6',[11,9,.05,.05,0,0], ...
%>                 'errfunc','');


%case 'dudekgt';  aff_abcdxy_1x6 = [188,192,110,130,-0.08]; 
%>   PARAM = struct('Np',4000, 'PF_normalizer=1, 'ff',1, ...
%>                 'batchsize',5, 'aff_tsrpxy_stddev_1x6',[6,5,.05,.05,0,0], ...
%>                'errfunc','');

%case 'toycan';    aff_abcdxy_1x6=[137 113 30 62 0];      PARAM.pf_Np',Np,'PF_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tsrpxy_stddev_1x6',[7,7,.01,.01,.002,.001]);  PARAM.ds_3_name2='1';txt2='Dudek';
%case 'mushiake';  aff_abcdxy_1x6=[172 145 60 60 0];      PARAM.pf_Np',Np,'PF_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tsrpxy_stddev_1x6',[10,10,.01,.01,.002,.001]);PARAM.ds_3_name2='1';txt2='Dudek';
    
    