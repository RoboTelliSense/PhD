function TRK = TRK_derive_from_generic_tracker(PARAM, ALGO, trkMEAN)

	TRK                 =	trkMEAN;    
    
    TRK.name            =   ['trk' ALGO.in_1__name];
    TRK.config_str      =   [PARAM.ds_3_name    ALGO.config_str];
    TRK.cfn             =   [TRK.config_str '.txt'];
    TRK.tim_T_sec       =   0; 
                            UTIL_FILE_delete(TRK.cfn); 