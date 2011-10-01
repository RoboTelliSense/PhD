load dudek
[H, W, F] = size(data);
for f=1:F
    I = data(:,:,f);
    imshow(I);
    title(num2str(f));
    drawnow
    UTIL_dbloop
end