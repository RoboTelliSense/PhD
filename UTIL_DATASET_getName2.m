function [PARAM.ds_2_name, PARAM.ds_3_name2, F] = UTIL_DATASET_getName2(datasetCode)

if      (datasetCode==1) PARAM.ds_2_name = 'Dudek';         PARAM.ds_3_name2='1___Dudek__________';  F=573;
elseif  (datasetCode==2) PARAM.ds_2_name = 'davidin300';    PARAM.ds_3_name2='2___davidin300_____';  F=462;
elseif  (datasetCode==3) PARAM.ds_2_name = 'sylv';          PARAM.ds_3_name2='3___sylv___________';  F=379;%using instead of 620 just for RVQ_16x..
elseif  (datasetCode==4) PARAM.ds_2_name = 'trellis70';     PARAM.ds_3_name2='4___trellis70______';  F=434;%same reason as above, should be 501;
elseif  (datasetCode==5) PARAM.ds_2_name = 'fish';          PARAM.ds_3_name2='5___fish__________';   F=476;
elseif  (datasetCode==6) PARAM.ds_2_name = 'car4';          PARAM.ds_3_name2='6___car4___________';  F=589;%same reason as above, should be 657;
elseif  (datasetCode==7) PARAM.ds_2_name = 'car11';         PARAM.ds_3_name2='7___car11__________';  F=306;
elseif  (datasetCode==8) PARAM.ds_2_name = 'PETS2001rcf';   PARAM.ds_3_name2='8___PETS2001rcf____';  F=-1;
elseif  (datasetCode==9) PARAM.ds_2_name = 'PETS2009';      PARAM.ds_3_name2='9___PETS2009_______';  F=-1;
elseif  (datasetCode==10) PARAM.ds_2_name = 'AVSS2007_1';   PARAM.ds_3_name2='10__AVSS2007_1_____';  F=-1;
elseif  (datasetCode==11) PARAM.ds_2_name = 'AVSS2007_2';   PARAM.ds_3_name2='11__AVSS2007_2_____';  F=-1;
elseif  (datasetCode==12) PARAM.ds_2_name = 'AVSS2007_3';   PARAM.ds_3_name2='12__AVSS2007_3_____';  F=-1;
elseif  (datasetCode==13) PARAM.ds_2_name = 'motinasFast';  PARAM.ds_3_name2='13__motinasFast____';  F=-1;
end
