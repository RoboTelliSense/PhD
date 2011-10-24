clear;
clc;
close all;

load test;
iptsetpref('ImshowAxesVisible', 'off');

out = warpimg(I_0t1, affparam2mat(a(:,1)), sz);  %now create actual snippet candidates
   
colormap('gray');
for i=1:25
    UTIL_PLOT_tightsubplot(5, 5, i, out(:,:,i))
end
UTIL_FILE_save2pdf('out.pdf', gcf, 300);
