function [INP.ds_2_name, INP.ds_3_longName, F] = UTIL_DATASET_getName2(datasetCode)

if      (datasetCode==1) INP.ds_2_name = 'Dudek';         INP.ds_3_longName='1___Dudek__________';  F=573;
elseif  (datasetCode==2) INP.ds_2_name = 'davidin300';    INP.ds_3_longName='2___davidin300_____';  F=462;
elseif  (datasetCode==3) INP.ds_2_name = 'sylv';          INP.ds_3_longName='3___sylv___________';  F=379;%using instead of 620 just for RVQ_16x..
elseif  (datasetCode==4) INP.ds_2_name = 'trellis70';     INP.ds_3_longName='4___trellis70______';  F=434;%same reason as above, should be 501;
elseif  (datasetCode==5) INP.ds_2_name = 'fish';          INP.ds_3_longName='5___fish__________';   F=476;
elseif  (datasetCode==6) INP.ds_2_name = 'car4';          INP.ds_3_longName='6___car4___________';  F=589;%same reason as above, should be 657;
elseif  (datasetCode==7) INP.ds_2_name = 'car11';         INP.ds_3_longName='7___car11__________';  F=306;
elseif  (datasetCode==8) INP.ds_2_name = 'PETS2001rcf';   INP.ds_3_longName='8___PETS2001rcf____';  F=-1;
elseif  (datasetCode==9) INP.ds_2_name = 'PETS2009';      INP.ds_3_longName='9___PETS2009_______';  F=-1;
elseif  (datasetCode==10) INP.ds_2_name = 'AVSS2007_1';   INP.ds_3_longName='10__AVSS2007_1_____';  F=-1;
elseif  (datasetCode==11) INP.ds_2_name = 'AVSS2007_2';   INP.ds_3_longName='11__AVSS2007_2_____';  F=-1;
elseif  (datasetCode==12) INP.ds_2_name = 'AVSS2007_3';   INP.ds_3_longName='12__AVSS2007_3_____';  F=-1;
elseif  (datasetCode==13) INP.ds_2_name = 'motinasFast';  INP.ds_3_longName='13__motinasFast____';  F=-1;
end
