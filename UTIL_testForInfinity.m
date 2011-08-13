%the length of the input signal is Nm1 (i.e. N-1)
%the length of the ouput average signal is N
                                        
function [s_1xN, s_avg_1xN, f_1xN] = UTIL_testForInfinity(s_1xNm1, s_avg_1xNm1, f_1xNm1,    s_1x1, f_1x1)

    if (s_1x1==Inf)
        s_1xN       =   s_1xNm1;
        f_1xN       =   f_1xNm1;
        s_avg_1xN   =   s_avg_1xNm1;
        
    else
        s_1xN       =   [s_1xNm1 s_1x1];
        f_1xN       =   [f_1xNm1 f_1x1];
        s_avg_1xN   =   [s_avg_1xNm1 sum(s_1xN)/length(s_1xN)];
    end
    
    

%function [s_avg_N, new_f] = UTIL_createAverageSignal(s_1x1, s_avg_1xNm1, old_f, f_1x1)

%     if (s_1x1 ~= Inf)
%         old_avg         =   s_avg_1xNm1(end);
%         Nm1             =   length(s_avg_1xNm1);
%         old_total       =   old_avg * Nm1;
% 
%         new_total       =   old_total + s_1x1;
%         new_avg         =   sum(new_total)/(Nm1+1);
% 
%         s_avg_N         =   [s_avg_1xNm1 new_avg];
%         new_f           =   [old_f f_1x1];
%     else
%         s_avg_N         =   s_avg_1xNm1;
%         new_f           =   [old_f];
%     end    