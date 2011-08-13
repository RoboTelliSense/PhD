function ImageFilePrefix = UTIL_GetZeroPrefixedFileNumber(t);

	if (t<10)														
		ImageFilePrefix							=	'0000';			%4 zeros
	elseif ((t>9) & (t<100))										
		ImageFilePrefix							=	'000';			%3 zeros
	elseif ((t>99) & (t<1000))										
		ImageFilePrefix							=	'00';			%2 zeros
    else ((t>999) & (t<10000))									
		ImageFilePrefix							=	'0';			%1 zeros
	end

	ImageFilePrefix = [ImageFilePrefix int2str(t)];