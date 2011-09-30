function [aMEAN, trkMEAN] = MEAN_config(PARAM, first_mean_shxsw)


    aMEAN.in_1__name        =   'aMEAN';
    aMEAN.mdl_2_mu_Dx1      =   first_mean_shxsw(:); 
    aMEAN.in____cnfg        =   [aMEAN.in_1__name '__'];
    aMEAN.tim_t_sec         =   0;                                  %only for this algo, set total running time in sec to 0
    
    trkMEAN.name            =   'trkaMEAN';                          %learning algo only uses mean of data (simplest learning algo)    
    trkMEAN.DM2             =   [];                                 %1. all "best" snippets picked by tracker (one snippet per column)
    trkMEAN.numF     		=   1;                                  %number of frames the particle filter runs
    trkMEAN.cfn             =   [PARAM.ds_3_name aMEAN.in____cnfg '.txt'];
                                UTIL_FILE_delete(trkMEAN.cfn);
    trkMEAN.tim_T_sec       =   0;                                  %stats: total running time in sec
    