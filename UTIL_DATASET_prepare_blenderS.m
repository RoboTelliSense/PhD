clear;
close all;
clc;

load img/testS/testS.mat


[h, w, N] = size(Iout);
Iout_small = [];
DM2=[];

for n=1:N
    I = (Iout(142:142+260, 360:360+400, n));
    I = imresize(I, 0.1);
    Iout_small(:,:,n) = I(1:27,:);
    imshow(uint8(Iout_small(:,:, n)));
    DM2(:,n) = I(:);
    drawnow
end
h=27;
w=41;
save('testS_DM2_small', 'DM2', 'w', 'h');
whos testS_small
