function ImageFilePrefix = UTIL_GetZeroPrefixedFileNumber_4(t)

	if (t<10)														
		ImageFilePrefix							=	'000';			%3 zeros
	elseif ((t>9) & (t<100))										
		ImageFilePrefix							=	'00';			%2 zeros
	elseif ((t>99) & (t<1000))										
		ImageFilePrefix							=	'0';			%1 zeros
	elseif (t>999)										
		ImageFilePrefix							=	'';			   %1 zeros        
	end

	ImageFilePrefix = [ImageFilePrefix int2str(t)];