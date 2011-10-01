load dudek
[H, W, F] = size(data);
for f=490:490
    I = data(:,:,f);
    imshow(I);
    title(num2str(f));
    drawnow
    UTIL_dbloop
end