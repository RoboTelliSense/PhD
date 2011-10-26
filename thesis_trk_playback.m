rofe = textread('1_Dudek__aRVQ_08_04_1000_0_RofE__.txt');
%load Dudek
idx=0;
[t1, t2, F]=size(data);

for f=6:15
    idx=f-5;
    snp_1_tsrpxy_1x6 = rofe(idx, 16:21);
    fpt_2_estim_2xG = [rofe(idx,22);rofe(idx,23)];
    
    imshow(uint8(data(:,:,f)));
    UTIL_PLOT_display(f, fpt_2_estim_2xG,fpt_2_estim_2xG, snp_1_tsrpxy_1x6, 33, 33, 'r');
    title(num2str(f));
    drawnow
    pause
end
    