%most probably this is the SIR filter (pg 181 of "A tutorial on Particle Filters ... " by Arulampalam et. al. because it has the following 3 steps:
%1. predict
%2. find weights (likelihood) and normalize them
%3. resample

clear;
clc;
close all;

%PARAMETERS  
	T                               =   50;                                         %Number of time steps
    dt                              =   1;                                          %Time step size
    var_PN                			=   10;                                         %Process noise variance 
    var_MN            				=   1;                                          %Measurement noise varmeiance
    bins 							= 	30;	
    Np                              =   500;                                        %Number of Monte Carlo x_post per time step. 
	var_x                           =   5;                                          %Initial variance of the states. 	           
%MEMORY    
    x_post             				=   zeros(Np,T);                                %this is a matrix that contains all x_post indexed with time
    x_pred                          =   zeros(Np,T);                                %this is only a single vector, with no notion of time
	w                               =	zeros(Np,1);
	c                               =	zeros(Np,1);
	MAP_estimate                    =	zeros(1,T);
	MMSE_estimate                   =	zeros(1,T);
    gt                        =   zeros(1,T);                                 %Hidden states
    observation                        =   zeros(1,T);                                 %Observations     	
%INITIALIZATIONS
    k                               =   1:dt:T;  
	noise_proc                      =   sqrt(var_PN)*randn(T,1);                    %Process noise  
    noise_meas                      =   sqrt(var_MN)*randn(T,1);                    %Measurement noise
    x_post(:,1)                			=   sqrt(var_x)*randn(Np,1);                    %this is the initial x_post
    Temperature						=	2*var_MN;                                   %Like the temperature in Simulated Annealing
%ORACLE
	gt(1)                           =   0.1;                                        %independent
	observation(1)                  =   (gt(1)^(2))./20 + noise_meas(1); %dependent, initial output
    for k=2:T,                                                                      %Create actual states.  These are only for plotting, and not used anywhere in the program
        gt(k)                       =  	0.5   *   gt(k-1)                   +  ...
                  						25    *   gt(k-1)/(1+gt(k-1)^(2))	+  ...
                  						8     *   cos(1.2*(k-1))            +  ...
                            	  			      noise_proc(k-1);
        
        observation(k) 				=  (1/20) *   (gt(k).^(2))             	+      ...
                            					  noise_meas(k); 
    end;

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('2. OPERATIONS')
disp('-------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update and prediction
for k=2:T,

    %1. predict states
        x_pred(:,k)                         =   0.5		*	x_post(:,k-1) 								+ ...
                                                25		*	x_post(:,k-1)	./	(1+x_post(:,k-1).^(2))  + ...
                                                8		*	cos(1.2*(k-1))	.*	ones(Np,1) 				+ ...
                                                                sqrt(var_PN)	*	randn(Np,1);
																
	%2	find weights (likelihood) and normalize them
        
        y_pred                              = 	(1/20)	*	x_pred(:,k).^(2);						%scale all x_post
        innov								=  	abs(observation(k)*ones(Np,1)	  -  y_pred);			%create vector out of scalar observation
                                                                                                    %like the innov in simulated annealing
        for s=1:Np
            w(s)                            =   (exp(  (-innov(s)^2) / Temperature  )) ;			%exponential drop                                                                 
        end;
        w                                   =   w./sum(w);
   
        
       
	%3. resample (i.e. get posterior)
        %a. CDF of weights
        c = cumsum(w);    
        
        %b. start at bottom
        i           =   1;
        
        %c. random CDF
        temp1 		=	cumsum(-log(rand(Np+1,1)));	%almost the same as the line observation=x_post with some noise added.
        u           = 	temp1/temp1(Np); %this cdf is just a ramp, but with added noise
        j           =   1;
        
        %d. selection
        for j =1:Np-1                   %make sure you are less than threshold Np times
            while u(j) > c(i)           %take the sample, and keep comparing with particles
                i = i+1;
            end            
            x_post(j,k)=x_pred(i,k); 	%as soon as particle is more, pick it, and now get ready to start comparing with next sample
            
        end;        
end;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('3. ANALYSIS')
disp('-----------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x_post mean (Posterior mean estimate)
MMSE_estimate = mean(x_post);


% x_post mode (Posterior peak estimate)
for k=1:T
  [x_frequency,x_value] =   hist(x_post(:,k),bins);
  IndexOfMostFrequentx  =   find(x_frequency==max(x_frequency));		%find the index at which the histogram has a peak
  MAP_estimate(k)       =   x_value(IndexOfMostFrequentx(1));
end;

% x_post stdev (Posterior standard deviation estimate)
xstd=std(x_post);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('4. RESULTS')
disp('----------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
plot(1:T, gt,    1:T, MMSE_estimate, 'y-+',     1:T, MAP_estimate, 'r-*')
legend('Actual state','Posterior mean estimate','MAP estimate');
grid




% 
%         while s <= Np,                                              %make sure you are less than threshold Np times
%           if u(n) < c(s) 							%ref_CDF(Np) is always close to Np	
%             x_post(n,k)=x_pred(s,k); 	%important: posterior indexed by n
%             n = n+1;
%           else
%             s = s+1;
%           end;
%         end;