GT=[];
dir_out_prefix          =   ['test_out' num2str(Nict)];
%GT{1}               =   csvread('GTBB_AVSS2007_360x288_redCar.txt'); %ground truth data
%GT{2}               =   csvread('GTBB_AVSS2007_360x288_blueCar.txt'); %ground truth data
%bGTisComplete       =   false;      %there is complete ground truth information

%frame numbers    
    
    fF                  =   543;            %last testing frame

%image
    dir_I               =   'img/Dudek/';                            %image directory
    ext_I               =   '.png';
    iw                  =   240;
    ih                  =   160;  
    
%snippets
    sw                  =   33;  %RVQ parameters
    sh                  =   33;      
    Nsx                 =   1;
    Nsy                 =   1;

   
%RVQ    
    M                   =   2;
    T                   =   8;
    gamma_STG           =   T;              %gammaolds
    gamma_SNR           =   0.8*255;            
    
%target    
    tgtID               =   1;              %target ID
    vx(tgtID)           =   3;              %target velocity
    vy(tgtID)           =   1;              %"
    riw                  =   33;             %search window width
    rih                  =   33;             %"
    
      
    lambda              =   0.5;