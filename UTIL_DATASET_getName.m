function [datasetName, fullDatasetName, F] = UTIL_DATASET_getName2(datasetCode)

if      (datasetCode==1) datasetName = 'Dudek';         fullDatasetName='1___Dudek__________';  F=573;
elseif  (datasetCode==2) datasetName = 'davidin300';    fullDatasetName='2___davidin300_____';  F=462;
elseif  (datasetCode==3) datasetName = 'sylv';          fullDatasetName='3___sylv___________';  F=620;
elseif  (datasetCode==4) datasetName = 'trellis70';     fullDatasetName='4___trellis70______';  F=501;
elseif  (datasetCode==5) datasetName = 'fish';          fullDatasetName='5___fish__________';   F=476;
elseif  (datasetCode==6) datasetName = 'car4';          fullDatasetName='6___car4___________';  F=659;
elseif  (datasetCode==7) datasetName = 'car11';         fullDatasetName='7___car11__________';  F=393;
elseif  (datasetCode==8) datasetName = 'PETS2001rcf';   fullDatasetName='8___PETS2001rcf____';  F=-1;
elseif  (datasetCode==9) datasetName = 'PETS2009';      fullDatasetName='9___PETS2009_______';  F=-1;
elseif  (datasetCode==10) datasetName = 'AVSS2007_1';   fullDatasetName='10__AVSS2007_1_____';  F=-1;
elseif  (datasetCode==11) datasetName = 'AVSS2007_2';   fullDatasetName='11__AVSS2007_2_____';  F=-1;
elseif  (datasetCode==12) datasetName = 'AVSS2007_3';   fullDatasetName='12__AVSS2007_3_____';  F=-1;
elseif  (datasetCode==13) datasetName = 'motinasFast';  fullDatasetName='13__motinasFast____';  F=-1;
end
