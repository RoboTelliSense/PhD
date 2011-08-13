function [DM2, w, h] = UTIL_create_image_designMatrix2()

load dudek
[h, w, F] = size(data)
DM2 = [];
for f=1:10
    I = data(:,:,f);
    DM2(:,f) = I(:);
end

save('dudek_DM2_short', 'DM2', 'w', 'h');


