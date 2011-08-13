function ImageFilePrefix = UTIL_GetZeroPrefixedFileNumber_2(t)

	if (t<10)														
		ImageFilePrefix							=	'0';
    elseif (t>9 && t<100)
        ImageFilePrefix							=	'';
	end

	ImageFilePrefix = [ImageFilePrefix int2str(t)];