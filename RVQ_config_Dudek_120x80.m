GT=[];
dir_out_prefix          =   ['test_out' num2str(Nict)];
%GT{1}               =   csvread('GTBB_AVSS2007_360x288_redCar.txt'); %ground truth data
%GT{2}               =   csvread('GTBB_AVSS2007_360x288_blueCar.txt'); %ground truth data
%bGTisComplete       =   false;      %there is complete ground truth information

%frame numbers    
    
    fF                  =   543;            %last testing frame

%image
    dir_I               =   'img/Dudek/120x80/';                            %image directory
    ext_I               =   '.png';
    cfn_gt              =   'ground_truth_Dudek_120x80.csv'
    iw                  =   120;
    ih                  =   80;  
    
%snippets
    sw                  =   17;  %RVQ parameters
    sh                  =   17;      
    Nsx                 =   1;
    Nsy                 =   1;
    fI                      =   16; %first testing image
    cx                      =   33;%position at fI-1 
    cy                      =   33;%"
   
%RVQ    
    M                   =   2;
    T                   =   8;
    gamma_STG           =   T;              %gammaolds
    gamma_SNR           =   0.8*255;            
    
%target    
    tgtID               =   1;              %target ID
    vx(tgtID)           =   3;              %target velocity
    vy(tgtID)           =   1;              %"
    riw                  =   25;             %search window width
    rih                  =   25;             %"
    
      
    lambda              =   0.5;