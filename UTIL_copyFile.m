function UTIL_copyFile(cfn_old, cfn_new)   %cfn is complete file name

    if      (ispc)      [status, result] = system (['copy ' cfn_old ' ' cfn_new]);
    elseif  (isunix)    [status, result] = unix   (['cp '   cfn_old ' ' cfn_new]);
    end
                 