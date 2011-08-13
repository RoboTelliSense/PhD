%clear;
clc;
%close all;

load matlab
clf;
            subplot(3,1,1);plot(structCond.stg_1tT, 'r')
            hold on;
            %subplot(3,1,2);plot(structCond.rmses);title
            subplot(3,1,2);plot(structCond.snrs.*structCond.stg_1tT);title('SNR (dB)');
            subplot(3,1,3);plot(structCond.rmses./structCond.stg_1tT);title('SNR (dB)');
            
%             
%             hold on;
%             diff2 = diff_0t1.^2;
%             a = -sum(diff2);
%             s = structCond.stg_1tT;
%             subplot(2,1,1);plot(     exp(a)     ,  'b'      );
%             hold on;
%             subplot(2,1,1);plot(     exp(a./s)  ,  'r'      );
%             
%             subplot(2,1,2);plot(structCond.stg_1tT/10, 'g');
%             hold off;
            