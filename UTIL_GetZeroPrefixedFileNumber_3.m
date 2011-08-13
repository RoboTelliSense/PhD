function ImageFilePrefix = UTIL_GetZeroPrefixedFileNumber_3(t)

	if (t<10)														
		ImageFilePrefix							=	'00';			%2 zeros
	elseif ((t>9) & (t<100))										
		ImageFilePrefix							=	'0';			%1 zeros
	elseif ((t>99) & (t<1000))										
		ImageFilePrefix							=	'';             %no zeros
    end

	ImageFilePrefix = [ImageFilePrefix int2str(t)];