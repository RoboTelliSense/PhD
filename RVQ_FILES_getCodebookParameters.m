function [M, T, sw, sh] = RVQ_FILES_getCodebookParameters(CB)

    [temp M]        =   size(CB);
    [temp T]        =   size(CB{1});
    [sh, sw, dim]   =   size(CB{1}{1});
    