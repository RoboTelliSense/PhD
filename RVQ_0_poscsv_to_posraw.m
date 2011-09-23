clear;
clc;
close all;

odir = 'results_1_maxT_8_M_4_Np_600_Nict_-1_PCA_16_Dudek\';
dir_img = 'img\Dudek\720x480\';
ext_I   =   '.png';
cfn_poscsv = [odir 'positiveExamples2.csv'];
cfn_posraw = [odir 'positiveExamples2.raw'];
[cfn_I, SX, SY, SW, SH]   = textread(cfn_poscsv, '%s   %d %d %d %d', 'delimiter', ',');

Ntrgsnp = length(cfn_I);

for f=1:Ntrgsnp
    f
    str_f       =   UTIL_GetZeroPrefixedFileNumber(f);
    cfn_I       =   [dir_img str_f ext_I];
    I           =   imread(cfn_I);
    b           =   SY(f):SY(f)+SH(f)-1;
    a           =   SX(f):SX(f)+SW(f)-1;
    Is3d(:,:,f) =   I(b, a);  
end

save test.mat

RVQ_0_create_posraw(Is3d, cfn_posraw);