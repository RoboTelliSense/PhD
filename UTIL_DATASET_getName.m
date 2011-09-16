function [PARAM.ds_2_name, PARAM.ds_3_longName, F] = UTIL_DATASET_getName2(datasetCode)

if      (datasetCode==1) PARAM.ds_2_name = 'Dudek';         PARAM.ds_3_longName='1___Dudek__________';  F=573;
elseif  (datasetCode==2) PARAM.ds_2_name = 'davidin300';    PARAM.ds_3_longName='2___davidin300_____';  F=462;
elseif  (datasetCode==3) PARAM.ds_2_name = 'sylv';          PARAM.ds_3_longName='3___sylv___________';  F=620;
elseif  (datasetCode==4) PARAM.ds_2_name = 'trellis70';     PARAM.ds_3_longName='4___trellis70______';  F=501;
elseif  (datasetCode==5) PARAM.ds_2_name = 'fish';          PARAM.ds_3_longName='5___fish__________';   F=476;
elseif  (datasetCode==6) PARAM.ds_2_name = 'car4';          PARAM.ds_3_longName='6___car4___________';  F=659;
elseif  (datasetCode==7) PARAM.ds_2_name = 'car11';         PARAM.ds_3_longName='7___car11__________';  F=393;
elseif  (datasetCode==8) PARAM.ds_2_name = 'PETS2001rcf';   PARAM.ds_3_longName='8___PETS2001rcf____';  F=-1;
elseif  (datasetCode==9) PARAM.ds_2_name = 'PETS2009';      PARAM.ds_3_longName='9___PETS2009_______';  F=-1;
elseif  (datasetCode==10) PARAM.ds_2_name = 'AVSS2007_1';   PARAM.ds_3_longName='10__AVSS2007_1_____';  F=-1;
elseif  (datasetCode==11) PARAM.ds_2_name = 'AVSS2007_2';   PARAM.ds_3_longName='11__AVSS2007_2_____';  F=-1;
elseif  (datasetCode==12) PARAM.ds_2_name = 'AVSS2007_3';   PARAM.ds_3_longName='12__AVSS2007_3_____';  F=-1;
elseif  (datasetCode==13) PARAM.ds_2_name = 'motinasFast';  PARAM.ds_3_longName='13__motinasFast____';  F=-1;
end
