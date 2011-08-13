function ImageFilePrefix = UTIL_GetZeroPrefixedFileNumber_6(t);

	if (t<10)														
		ImageFilePrefix							=	'00000';			%4 zeros
	elseif ((t>9) & (t<100))										
		ImageFilePrefix							=	'0000';			%3 zeros
	elseif ((t>99) & (t<1000))										
		ImageFilePrefix							=	'000';			%2 zeros
    elseif ((t>999) & (t<10000))									
		ImageFilePrefix							=	'00';			%1 zeros
    elseif ((t>9999) & (t<100000))									
		ImageFilePrefix							=	'0';			%1 zeros        
	end

	ImageFilePrefix = [ImageFilePrefix int2str(t)];