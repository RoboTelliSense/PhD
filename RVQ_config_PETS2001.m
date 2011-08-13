GT=[];
dir_out_prefix      =  ['trkRVQ_PETS2001_' num2str(Nict)];
GT{1}               =   csvread('GTBB_PETS2001_640x480_redCoatFemale.txt'); %ground truth data

bGTisComplete       =   true;      %there is complete ground truth information
[F, temp]           =   size(GT{1});       %F is number of frames you want to track
f1I                 =   GT{1}(1,2);        %initial frame when this target appears
f1F                 =   GT{1}(F,2);        %final frame when this target leaves

dir_img             =   'img/PETS2001_640x480/';                            %image directory
Iw                  =   640;
Ih                  =   480; 
sw                  =   11;  
sh                  =   41;             
Nsx                 =   3;
Nsy                 =   3;
M                   =   2;
T                   =   8;
gamma_STG          =   T;              %thresholds
gamma_SNR          =   0.8*255;           
fI                  =   472;        %current frame, initialize to where you want to train your snippets, next frame is tracking frame
tgtID               =   1;          %target ID
vx(tgtID)           =   3;          %target velocity
vy(tgtID)           =   1;          %"
Ww                  =   9;          %search window
Wh                  =   5;          %"      
cfn_img             =   [dir_img num2str(fI) '.jpg'];     %first image         
lambda              =   0.5;