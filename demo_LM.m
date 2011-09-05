clear;
clc;
%close all;
%---------------------------------------
%INITIALIZATION
%---------------------------------------
N=10;
X = 3 + 0.1*randn(N,1);


%---------------------------------------
%PRE-PROCESSING
%---------------------------------------
%parameter
    lambda                      =   200;

idx                             =   1;
theta_guess(idx)                =   10;
g                               =   theta_guess(idx)+0.1*randn(length(X),1);

e(idx)                          =   (g-X)'*(g-X);
delta1(idx)                      =   0.3;%have to make this guess so i have 2 points to compute gradient

%gradient descent
for idx=2:10000    
    theta_guess(idx)            =   theta_guess(idx-1) + delta1(idx-1);     %step 1: guess  
    g                           =   theta_guess(idx)+0.1*randn(length(X),1);                       %step 2: model output based on guess
                                                                            
    e(idx)                      =   (g-X)'*(g-X);                           %step 3: error norm, f, the objective function to be minimized   
    J(idx)                      =   e(idx)-e(idx-1);                        %step 4: compute gradient
    grad                        =   J(idx)'*e(idx);
    delta1(idx)                 =   -(1/lambda)*grad;                        %step 5: find delta
    %delta2(idx)                 =   inv(J(idx)'*J(idx))*J(idx)';
    
    [idx e(idx) theta_guess(idx)+delta1(idx)]
    if (abs(e(idx))<50)
        break
    end
end
stem(theta_guess)



%---------------------------------------
%PROCESSING
%---------------------------------------
idx=1;


%g(theta1) where theta1 is your first guess
%stem(X)
%hold on;
%stem(g, 'g')
%stem(theta_i:1:theta_f, f, 'r')
%xlabel('\theta')
%ylabel('e^Te')
%grid on;