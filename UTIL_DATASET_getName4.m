%> @file
%> @brief
%>
%> Options for tracking
%> --------------------
%> aff_abcdxy_1x6            :   Initial affine parameters.  The affine ROI is initialized by selecting a bounding box
%>                              around the target in a software like IrfanView.  This captures the top left x and y 
%>                              coordinates of the bounding box.  However, the code is based on the center of the 
%>                              bounding box, called an affine ROI, so convert to center
%> con_normalizer               :   
%> ff                       :   forgetting factor for incremental SVD
%> aff_tllpxy_var_1x6         :   variance on affine parameters
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created : Aug 17, 2011
%> Date modified: Aug 17, 2011


function [CONFIG, INP.ds_8_I_HxWxF] = UTIL_DATASET_getName4(CONFIG)

%fn: filename (convert datasetCode to datasetName)
    if      (INP.ds_1_code==0) INP.ds_2_name = 'test';          INP.ds_3_longName='0___test___________';
    elseif  (INP.ds_1_code==1) INP.ds_2_name = 'Dudek';         INP.ds_3_longName='1___Dudek__________';
    elseif  (INP.ds_1_code==2) INP.ds_2_name = 'davidin300';    INP.ds_3_longName='2___davidin300_____';
    elseif  (INP.ds_1_code==3) INP.ds_2_name = 'sylv';          INP.ds_3_longName='3___sylv___________';
    elseif  (INP.ds_1_code==4) INP.ds_2_name = 'trellis70';     INP.ds_3_longName='4___trellis70______';
    elseif  (INP.ds_1_code==5) INP.ds_2_name = 'fish';          INP.ds_3_longName='5___fish___________';
    elseif  (INP.ds_1_code==6) INP.ds_2_name = 'car4';          INP.ds_3_longName='6___car4___________';
    elseif  (INP.ds_1_code==7) INP.ds_2_name = 'car11';         INP.ds_3_longName='7___car11__________';
    elseif  (INP.ds_1_code==8) INP.ds_2_name = 'PETS2001rcf';   INP.ds_3_longName='8___PETS2001rcf____';
    elseif  (INP.ds_1_code==9) INP.ds_2_name = 'PETS2009';      INP.ds_3_longName='9___PETS2009_______';
    elseif  (INP.ds_1_code==10) INP.ds_2_name = 'AVSS2007_1';   INP.ds_3_longName='10__AVSS2007_1_____';
    elseif  (INP.ds_1_code==11) INP.ds_2_name = 'AVSS2007_2';   INP.ds_3_longName='11__AVSS2007_2_____'; 
    elseif  (INP.ds_1_code==12) INP.ds_2_name = 'AVSS2007_3';   INP.ds_3_longName='12__AVSS2007_3_____'; 
    elseif  (INP.ds_1_code==13) INP.ds_2_name = 'motinasFast';  INP.ds_3_longName='13__motinasFast____';  
    end
    
    %get dataset affine ROI parameters  
    switch (INP.ds_2_name)
        case 'test';        p=[133 127 110 130 -0.08]; con_normalizer=0.25;   ff=1.00;   aff_tllpxy_var_1x6=[9  9  .05  .05  .005  .001]; 
        case 'Dudek';       p=[133 127 110 130 -0.08]; con_normalizer=0.25;   ff=1.00;   aff_tllpxy_var_1x6=[9  9  .05  .05  .005  .001]; 
        case 'davidin300';  p=[129 67  62  78  -0.02]; con_normalizer=0.75;   ff=0.99;   aff_tllpxy_var_1x6=[5  5  .01  .02  .002  .001]; 
        case 'sylv';        p=[118 54  53  53  -0.20]; con_normalizer=0.75;   ff=0.95;   aff_tllpxy_var_1x6=[7  7  .01  .02  .002  .001]; 
        case 'trellis70';   p=[178 76  45  49   0   ]; con_normalizer=0.20;   ff=0.95;   aff_tllpxy_var_1x6=[4  4  .01  .01  .002  .001]; 
        case 'fish';        p=[134 62  62  80   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[7  7  .01  .01  .002  .001]; 
        case 'car4';        p=[145 105 200 150  0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[5  5  .025 .01  .002  .001];
        case 'car11';       p=[74  128 30  25   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[5  5  .01  .01  .001  .001]; 
        case 'PETS2001rcf'; p=[414 341 13  37   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[1  1  .01  .01  .001  .001]; 
        case 'PETS2009';    p=[333 217 9   40   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[3  3  .05  .05  .002  .002]; 
        case 'AVSS2007_1';  p=[69  232 43  40   0.07]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[3  3  .05  .05  .002  .002]; 
        case 'AVSS2007_2';  p=[60  234 37  37   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[3  3  .05  .05  .002  .002]; 
        case 'AVSS2007_3';  p=[213 67  14  14   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[2  2  .05  .05  .002  .002]; 
        case 'motinas_fast';p=[474 60  43  67   0   ]; con_normalizer=0.20;   ff=1.00;   aff_tllpxy_var_1x6=[15 15 .05  .05  .005  .002]; 
        otherwise;  error(['unknown INP.ds_2_name ' INP.ds_2_name]);
    end    
    %convert top left coordinate to center
    p(1)                    =   p(1) + round(p(3)/2);  
    p(2)                    =   p(2) + round(p(4)/2);
    %normalize    
    aff_abcdxy_1x6           =   [p(1), p(2), p(3)/PARAM.scale, p(5), p(4)/p(3), 0]; %x, y, width/PARAM.scale, angle, height/width, 0
    %convert 
    aff_abcdxy_1x6           =   UTIL_2D_affine_tllpxy_to_abcdxy(aff_abcdxy_1x6);
    
%save 4 things per dataset
    INP.ds_4_aff_abcdxy_1x6       =   aff_abcdxy_1x6;      %will be shifted to tracking structure
    INP.ds_5_aff_tllpxy_var_1x6  =   aff_tllpxy_var_1x6;   %variance of affine ROI parameters
    INP.ds_6_ff                 =   ff;                 %forgetting factor
    INP.ds_7_con_stddev             =   con_normalizer;         %unknown
    
%get data
    %load dataset and ground truth from .mat file 
                                disp(['loading ' INP.ds_2_name '...']);
                                load([INP.ds_2_name '.mat'],'data','datatitle','truepts');
                                
    INP.ds_8_I_HxWxF                 =   data;       clear data;     %read all images, height x width x number of frames 
    INP.gt_1_fp      =   truepts;    clear truepts;  %ground truth for the feature points
    
    %get total number of frames
    INP.ds_9_F          =   size(INP.ds_8_I_HxWxF,3); 
    PARAM.trg_T          =	round(INP.ds_9_F/PARAM.trg_B); %number of times training occurs

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%> Use the following set of parameters for the ground truth experiment.
%> It's much slower, but more accuracte.
%case 'dudek';  aff_abcdxy_1x6 = [188,192,110,130,-0.08];
%>     CONFIG = struct('Np',4000, 'con_normalizer=0.25, 'ff',0.99, ...
%>                 'batchsize',5, 'aff_tllpxy_var_1x6',[11,9,.05,.05,0,0], ...
%>                 'errfunc','');


%case 'dudekgt';  aff_abcdxy_1x6 = [188,192,110,130,-0.08]; 
%>   CONFIG = struct('Np',4000, 'con_normalizer=1, 'ff',1, ...
%>                 'batchsize',5, 'aff_tllpxy_var_1x6',[6,5,.05,.05,0,0], ...
%>                'errfunc','');

%case 'toycan';    aff_abcdxy_1x6=[137 113 30 62 0];      PARAM.in_Np',Np,'con_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tllpxy_var_1x6',[7,7,.01,.01,.002,.001]);  INP.ds_3_longName='1';txt2='Dudek';
%case 'mushiake';  aff_abcdxy_1x6=[172 145 60 60 0];      PARAM.in_Np',Np,'con_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tllpxy_var_1x6',[10,10,.01,.01,.002,.001]);INP.ds_3_longName='1';txt2='Dudek';
    
    