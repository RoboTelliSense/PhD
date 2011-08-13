clear;
clc;
clf;


bar([1 2 3 4;4 5 6 7;8 9 10 11;4 5 6 7])
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'16, 8x2, 3';   ...
                      '32, 8x4, 4';   ...
                      '64, 8x8, 5';   ...
                      '128, 8x16, 6';})
                  colormap jet
xlabel('bPCA, iPCA, RVQ, TSVQ configurations');
ylabel('Tracking error');
legend('iPCA', 'bPCA', 'RVQ', 'TSVQ')
grid
