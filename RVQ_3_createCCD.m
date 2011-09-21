%A is matrix of training SoC feature vectors, previously called trg_mat_SoC


function [pX1, CCD] = RVQ_3_createCCD(A, M, lambda) %A has one SoC per row, pX1 is the probability of stage 1, CCD has the rest of the probabilities

        [Ntrg, T] = size(A);
    %====================
    %COUNTS
    %====================
        %t=1 (first stage, there are no transitions here, for reusability, I'mt using the this complex code, otherwise I could have used simple counts)
        %---
            Nt1=[]; %at t=1, get counts
            t=1;
            for Xt  = 1:M  %possible values at stage 1, i.e. t=1
                cnt             =   getStageTransitionCounts(A, t, t, Xt, Xt);
                Nt1              =   [Nt1      cnt]; 
            end



        %t, t-1, get joint counts, same as conditional counts
        %------
            %start at second stage, compare it with 1st stage,
            %then go to 3rd stage and compare it with 2nd, and so on
            %finally get to stage T and compare it with T-1 th stage
            N_tm1_to_t=[];
            for t = 2:T
                for Xtm1 = 1:M               %the value of X at t-1
                    for Xt  = 1:M            %the value of X at t     
                        cnt = getStageTransitionCounts(A, t-1, t, Xtm1, Xt);   %Xtp1 is X_{t+1}

                        N_tm1_to_t = [N_tm1_to_t cnt]; %an is pnext
                        %sprintf('STAGE %d to %d (VALUE %d to %d), FREQUENCY: %d', t, t+1, Xt, Xtp1, cnt);
                    end
                end
            end
            N_tm1_to_t  = reshape(N_tm1_to_t,  M,  M,  T-1); %there are T-1 state transitions

    %====================
    %PROBABILITIES
    %====================

        %pX1 = Nt1/sum(Nt1);
        pX1 = (Nt1 + lambda)./(Ntrg + M*lambda);  %Jeffrey Perks Law, i.e. Lidstone's Law with lambda=0.5
        
%         for t=1:T-1
%              CCD(:,:,t)    =  N_tm1_to_t(:,:,t) / sum(sum(N_tm1_to_t(:,:,t)));
%              %CCD(:,:,t)    = (N_tm1_to_t(:,:,t) + 0.5)./(Ntrg + M*M*0.5); %here there are M*M different possible values in distribution
%         end
        
        for t=1:T-1
            for m=1:M
                sss         =   sum(N_tm1_to_t(:,:,t));
                %CCD(:,m,t)  =   N_tm1_to_t(:,m,t) / sss(m);
                CCD(:,m,t)  =   (N_tm1_to_t(:,m,t) + lambda) / (sss(m) + lambda*M);
            end
        end
        

                                                %check
                                                sum(sum(CCD));
                                                


                                                
                                                
                                                
                                                
%-------------------------------------------------------------------------
%get stage transition counts at every stage boundary, so if there are T 
%stages, there are T-1 transitions
%-------------------------------------------------------------------------
function len = getStageTransitionCounts(matrix_SoC, t, tp1, Xt, Xtp1) %one SoC per row
    exists = find   (   matrix_SoC(:,t)==Xt &  matrix_SoC(:,tp1)==Xtp1 );
    len = length(exists);