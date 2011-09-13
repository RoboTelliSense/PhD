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
%> aff_tllpxy_var_1x6         :   variance on affine parameters
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created : Aug 17, 2011
%> Date modified: Aug 17, 2011


function INP = TRK_read_input(code, scale)

	INP.ds_1_code = code;
%-----------------------------------------------
%PRE-PROCESSING
%-----------------------------------------------
	
%fn: filename (convert datasetCode to datasetName)
    if      (INP.ds_1_code==0)  INP.ds_2_name = 'test';          INP.ds_3_longName='0___test___________';
    elseif  (INP.ds_1_code==1)  INP.ds_2_name = 'Dudek';         INP.ds_3_longName='1___Dudek__________';
    elseif  (INP.ds_1_code==2)  INP.ds_2_name = 'davidin300';    INP.ds_3_longName='2___davidin300_____';
    elseif  (INP.ds_1_code==3)  INP.ds_2_name = 'sylv';          INP.ds_3_longName='3___sylv___________';
    elseif  (INP.ds_1_code==4)  INP.ds_2_name = 'trellis70';     INP.ds_3_longName='4___trellis70______';
    elseif  (INP.ds_1_code==5)  INP.ds_2_name = 'fish';          INP.ds_3_longName='5___fish___________';
    elseif  (INP.ds_1_code==6)  INP.ds_2_name = 'car4';          INP.ds_3_longName='6___car4___________';
    elseif  (INP.ds_1_code==7)  INP.ds_2_name = 'car11';         INP.ds_3_longName='7___car11__________';
    elseif  (INP.ds_1_code==8)  INP.ds_2_name = 'PETS2001rcf';   INP.ds_3_longName='8___PETS2001rcf____';
    elseif  (INP.ds_1_code==9)  INP.ds_2_name = 'PETS2009';      INP.ds_3_longName='9___PETS2009_______';
    elseif  (INP.ds_1_code==10) INP.ds_2_name = 'AVSS2007_1';    INP.ds_3_longName='10__AVSS2007_1_____';
    elseif  (INP.ds_1_code==11) INP.ds_2_name = 'AVSS2007_2';    INP.ds_3_longName='11__AVSS2007_2_____'; 
    elseif  (INP.ds_1_code==12) INP.ds_2_name = 'AVSS2007_3';    INP.ds_3_longName='12__AVSS2007_3_____'; 
    elseif  (INP.ds_1_code==13) INP.ds_2_name = 'motinasFast';   INP.ds_3_longName='13__motinasFast____';  
    end
    
    %get dataset affine ROI parameters, 
    switch (INP.ds_2_name)
        case 'test';        xywht=[133 127 110 130 -0.08]; con_normalizer=0.25; ff=1.00; aff_tllpxy_var_1x6=[9  9  .05  .05  .005  .001]; 
        case 'Dudek';       xywht=[133 127 110 130 -0.08]; con_normalizer=0.25; ff=1.00; aff_tllpxy_var_1x6=[9  9  .05  .05  .005  .001]; 
        case 'davidin300';  xywht=[129 67  62  78  -0.02]; con_normalizer=0.75; ff=0.99; aff_tllpxy_var_1x6=[5  5  .01  .02  .002  .001]; 
        case 'sylv';        xywht=[118 54  53  53  -0.20]; con_normalizer=0.75; ff=0.95; aff_tllpxy_var_1x6=[7  7  .01  .02  .002  .001]; 
        case 'trellis70';   xywht=[178 76  45  49   0   ]; con_normalizer=0.20; ff=0.95; aff_tllpxy_var_1x6=[4  4  .01  .01  .002  .001]; 
        case 'fish';        xywht=[134 62  62  80   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[7  7  .01  .01  .002  .001]; 
        case 'car4';        xywht=[145 105 200 150  0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[5  5  .025 .01  .002  .001];
        case 'car11';       xywht=[74  128 30  25   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[5  5  .01  .01  .001  .001]; 
        case 'PETS2001rcf'; xywht=[414 341 13  37   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[1  1  .01  .01  .001  .001]; 
        case 'PETS2009';    xywht=[333 217 9   40   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[3  3  .05  .05  .002  .002]; 
        case 'AVSS2007_1';  xywht=[69  232 43  40   0.07]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[3  3  .05  .05  .002  .002]; 
        case 'AVSS2007_2';  xywht=[60  234 37  37   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[3  3  .05  .05  .002  .002]; 
        case 'AVSS2007_3';  xywht=[213 67  14  14   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[2  2  .05  .05  .002  .002]; 
        case 'motinas_fast';xywht=[474 60  43  67   0   ]; con_normalizer=0.20; ff=1.00; aff_tllpxy_var_1x6=[15 15 .05  .05  .005  .002]; 
        otherwise;  error(['unknown INP.ds_2_name ' INP.ds_2_name]);
    end    
    
    %initial geometric parameters (easy to get from an image)
    top_left_x              =   xywht(1);
    top_left_y              =   xywht(2);
    w                       =   xywht(3);       
    h                       =   xywht(4);
    theta                   =   xywht(5);
    
    %convert to affine geometric parameters (tllpxy)
    theta                   =   theta;                      %1.
    lambda1                 =   w/scale;                    %2.
    lambda2                 =   h/scale;                    %3.
    phi                     =   0;                          %4. 
    tx                      =   top_left_x + round(w/2);    %5. x coordinate, central pixel of bounding box
    ty                      =   top_left_y + round(h/2);    %6. y coordinate, central pixel of bounding box       
    aff_tllpxy_1x6          =   [theta, lambda1, lambda2, phi, tx ty];
    
    %convert to affine parameters (abcdxy)
    aff_abcdxy_1x6          =   UTIL_2D_affine_tllpxy_to_abcdxy(aff_tllpxy_1x6);

%-----------------------------------------------
%PROCESSING
%-----------------------------------------------	
%load data
	disp(['loading dataset ' INP.ds_2_name ' and its ground truth ...']);
	load([INP.ds_2_name '.mat'],'data','datatitle','truepts');

    disp(['loading pre-stored random data for repeatability ...']);
    load RandomData 
%-----------------------------------------------
%POST-PROCESSING
%-----------------------------------------------
%save 
	%dataset
    INP.ds_4_aff_abcdxy_1x6     =   aff_abcdxy_1x6;                 %affine ROI parameters
    INP.ds_5_aff_tllpxy_var_1x6  =   aff_tllpxy_var_1x6;              %" 					  , variance of
    INP.ds_6_ff            	=   ff;                 		%forgetting factor
    INP.ds_7_con_stddev   	=   con_normalizer;             %condensation algorithm, normalizer
    INP.ds_8_I_HxWxF      	=   data;                       %read all images, height x width x number of frames 
	INP.ds_9_F          	=   size(INP.ds_8_I_HxWxF,3);   %total number of frames

	%ground truth
    INP.gt_1_fp      		=   truepts;                    %ground truth for the feature points
    INP.gt_2_num_fp        	=   size(INP.gt_1_fp,2);        %number of feature points
    INP.gt_3_initial_fp    	=   INP.ds_4_aff_abcdxy_1x6([3,4,1;5,6,2]) * [INP.gt_1_fp(:,:,1); ones(1,INP.gt_2_num_fp)];
    
    %random input
    INP.rand_unitvar_maxFx6xNp=   RandomData_sample; %pre-stored random numbers to ensure repeatability, maxF=1000 since we do not anticipate more than 1000 frames  
    INP.rand_cdf_maxFxNp    =   RandomData_cdf;
    
    clear data truepts RandomData_sample RandomData_cdf;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%> Use the following set of parameters for the ground truth experiment.
%> It's much slower, but more accuracte.
%case 'dudek';  aff_abcdxy_1x6 = [188,192,110,130,-0.08];
%>     PARAM = struct('Np',4000, 'con_normalizer=0.25, 'ff',0.99, ...
%>                 'batchsize',5, 'aff_tllpxy_var_1x6',[11,9,.05,.05,0,0], ...
%>                 'errfunc','');


%case 'dudekgt';  aff_abcdxy_1x6 = [188,192,110,130,-0.08]; 
%>   PARAM = struct('Np',4000, 'con_normalizer=1, 'ff',1, ...
%>                 'batchsize',5, 'aff_tllpxy_var_1x6',[6,5,.05,.05,0,0], ...
%>                'errfunc','');

%case 'toycan';    aff_abcdxy_1x6=[137 113 30 62 0];      PARAM.in_Np',Np,'con_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tllpxy_var_1x6',[7,7,.01,.01,.002,.001]);  INP.ds_3_longName='1';txt2='Dudek';
%case 'mushiake';  aff_abcdxy_1x6=[172 145 60 60 0];      PARAM.in_Np',Np,'con_normalizer=0.2, 'ff',1,  'batchsize',5,'aff_tllpxy_var_1x6',[10,10,.01,.01,.002,.001]);INP.ds_3_longName='1';txt2='Dudek';
    
    