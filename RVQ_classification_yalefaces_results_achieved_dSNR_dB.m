clear;
clc;
close all;

h1=figure;
SNR=[10  10  11  11  12  12  12  12  13  13  13  13  13  13  13;...  
  11  11  11  11  13  13  13  13  14  14  14  14  14  14  15;...
  11  12  12  12  13  14  14  15  15  15  15  16  16  16  17;...  
  11  13  13  14  14  14  15  15  16  16  16  17  17  17  18;...  
  12  13  14  14  14  15  16  16  17  17  18  18  18  19  19;...  
  12  13  14  14  15  16  16  17  18  18  19  19  19  20  21;...  
  12  13  15  15  16  17  17  18  18  19  20  20  21  21  22;...  
  13  14  15  16  17  17  18  18  19  20  21  21  22  23  22;]  
imagesc(SNR)
set(gca, 'XTick', [1:15])
set(gca, 'XTickLabel', [2:16])
set(gca, 'XAxisLocation', 'top')
xlabel('s (templates/stage)')
ylabel('t (stages)')
colorbar
%UTIL_FILE_save2pdf('out1.pdf', h1, 150);

h2=figure;
surf(fliplr(SNR))
set(gca, 'XTick', [1:15])
set(gca, 'XTickLabel', [16:-1:2])
set(gca, 'XAxisLocation', 'top')
xlabel('s (templates/stage)')
ylabel('t (stages)')
view(148,54)
colorbar
UTIL_FILE_save2pdf('out2.pdf', h2, 150);