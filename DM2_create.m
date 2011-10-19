function [DM2, sw, sh] = DM2_create(ds)

    if     (ds==1) DM2          =   1:7;                        sw=1; sh=1;
    elseif (ds==2) DM2          =   [4 6 8 10 20 22 24 26];     sw=1; sh=1;   %deterministic, scalar, simplest possible, i've worked this out by hand in a pdf
    elseif (ds==3) DM2          =   1:256;                      sw=1; sh=1;   %deterministic, scalar, example mentioned in IDDM
    elseif (ds==4)                  load testS_DM2_small;       sw=41;sh=27;  %deterministic, vector, i created this movie in Blender3D.  it has an S written on a moving box          
    elseif (ds==5) DM2          =   [1:7;22:2:34];              sw=2; sh=1;   %deterministic, scalar, example mentioned in IDDM
    
    elseif (ds==6) DM2          =   rand (1089,100);            sw=33;sh=33;
    elseif (ds==7) DM2          =   randn(1089,100);            sw=33;sh=33;
    elseif (ds==8) DM2          =   DM2_create_gaussMarkov(1089,100,0.9); sw=33;sh=33;%last 0 means no randomness
    elseif (ds==9) [DM2,sw,sh]  =   DM2_extract_roi_from_Dudek(1,100,0);   %last 0 means no randomness
    end

    [D, N]                  =   size(DM2);                                  %dimensions of DM2

    %elseif (ds==4) [DM2,sw,sh] =   DM2_create_random;     %random,        ?     , RVQ error is large because apparently codebooks are clamped to 255            
    %elseif (ds==5) a = rand(1089,2); DM2 =[a a a a];   sw=33;sh=33;  %random data  (complex) this is a bizarre example, i.e., has repeated data points  
    %elseif (ds==12) DM2 =   DM2_create_densityWithHole(1089, 1000, 0.5, 'Gaussian');sw=33;sh=33;  
    %elseif (ds==13) DM2 =   DM2_create_densityWithHole(1089, 1000, 0.1, 'uniform');sw=33;sh=33;          
