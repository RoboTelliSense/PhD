function [ds_2_name, ds_3_name] =    UTIL_DATASET_getName3(ds_1_code)

    if      (ds_1_code==0)  ds_2_name = 'test';          ds_3_name='0_test___'; %ds is for dataset
    elseif  (ds_1_code==1)  ds_2_name = 'Dudek';         ds_3_name='1_Dudek__';
    elseif  (ds_1_code==2)  ds_2_name = 'davidin300';    ds_3_name='2_David__';
    elseif  (ds_1_code==3)  ds_2_name = 'sylv';          ds_3_name='3_Sylvs__';
    elseif  (ds_1_code==4)  ds_2_name = 'trellis70';     ds_3_name='4_Trels__';
    elseif  (ds_1_code==5)  ds_2_name = 'fish';          ds_3_name='5_Fish___';
    elseif  (ds_1_code==6)  ds_2_name = 'car4';          ds_3_name='6_Dodge__';
    elseif  (ds_1_code==7)  ds_2_name = 'car11';         ds_3_name='7_CarNgt_';
    elseif  (ds_1_code==8)  ds_2_name = 'PETS2001rcf';   ds_3_name='8_PETS2001rcf____';
    elseif  (ds_1_code==9)  ds_2_name = 'PETS2009';      ds_3_name='9_PETS2009_______';
    elseif  (ds_1_code==10) ds_2_name = 'AVSS2007_1';    ds_3_name='10_AVSS2007_1_____';
    elseif  (ds_1_code==11) ds_2_name = 'AVSS2007_2';    ds_3_name='11_AVSS2007_2_____'; 
    elseif  (ds_1_code==12) ds_2_name = 'AVSS2007_3';    ds_3_name='12_AVSS2007_3_____'; 
    elseif  (ds_1_code==13) ds_2_name = 'motinasFast';   ds_3_name='13_motinasFast____';  
    end