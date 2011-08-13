function cfn_Iraw = UTIL_createRawFileName(dir_I, f, iw, ih)

    str_f           =   UTIL_GetZeroPrefixedFileNumber(f);
    cfn_Iraw        =   [dir_I  str_f '_' num2str(iw) 'x' num2str(ih) '.raw'];
