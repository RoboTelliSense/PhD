function [CONFIG.datasetName, CONFIG.fullDatasetName, F] = UTIL_DATASET_getName2(datasetCode)

if      (datasetCode==1) CONFIG.datasetName = 'Dudek';         CONFIG.fullDatasetName='1___Dudek__________';  F=573;
elseif  (datasetCode==2) CONFIG.datasetName = 'davidin300';    CONFIG.fullDatasetName='2___davidin300_____';  F=462;
elseif  (datasetCode==3) CONFIG.datasetName = 'sylv';          CONFIG.fullDatasetName='3___sylv___________';  F=620;
elseif  (datasetCode==4) CONFIG.datasetName = 'trellis70';     CONFIG.fullDatasetName='4___trellis70______';  F=501;
elseif  (datasetCode==5) CONFIG.datasetName = 'fish';          CONFIG.fullDatasetName='5___fish__________';   F=476;
elseif  (datasetCode==6) CONFIG.datasetName = 'car4';          CONFIG.fullDatasetName='6___car4___________';  F=659;
elseif  (datasetCode==7) CONFIG.datasetName = 'car11';         CONFIG.fullDatasetName='7___car11__________';  F=393;
elseif  (datasetCode==8) CONFIG.datasetName = 'PETS2001rcf';   CONFIG.fullDatasetName='8___PETS2001rcf____';  F=-1;
elseif  (datasetCode==9) CONFIG.datasetName = 'PETS2009';      CONFIG.fullDatasetName='9___PETS2009_______';  F=-1;
elseif  (datasetCode==10) CONFIG.datasetName = 'AVSS2007_1';   CONFIG.fullDatasetName='10__AVSS2007_1_____';  F=-1;
elseif  (datasetCode==11) CONFIG.datasetName = 'AVSS2007_2';   CONFIG.fullDatasetName='11__AVSS2007_2_____';  F=-1;
elseif  (datasetCode==12) CONFIG.datasetName = 'AVSS2007_3';   CONFIG.fullDatasetName='12__AVSS2007_3_____';  F=-1;
elseif  (datasetCode==13) CONFIG.datasetName = 'motinasFast';  CONFIG.fullDatasetName='13__motinasFast____';  F=-1;
end
