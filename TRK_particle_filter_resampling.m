function [picked_particle_idx, resampled_density_Npx1]=   TRK_particle_filter_resampling(cdf_ref_1xNp, cdf_data_Npx1, pdf_data_Npx1) %data_cdf is Npx1

%------------------------
%INITIALIZATIONS
%------------------------
    Np                      =   length(cdf_data_Npx1); %number of particles 
  
    ref_NpxNp               =   repmat(cdf_ref_1xNp,    [Np, 1]); %repeats each row of Np random numbers Np times giving Np rows
    dat_NpxNp               =   repmat(cdf_data_Npx1,   [1 , Np]); %repeats each col of Np cdf weights Np times giving Np cols

%------------------------
%PROCESSING
%------------------------
%we use 2 programming styles that both produce the same result.
%style 1 (Ross et al, Robust Incremental Learning)
    %in summary, go over each value of ref_NpxNp.  see how many values of
    %cdf_data_Npx1 it is larger than.  pick the particle that is one
    %larger.
    
    %mask has Np columns.  each column corresponds to a single entry in ref_NpxNp.  
    %for example, let's take the 5th value of cdf_ref_1xNp which is 0.55, 
    %the 5th column of mask has 6 ones which means that 0.55 is greater
    %than the first 6 values of cdf_data_Npx1
    mask                    =   ref_NpxNp  > dat_NpxNp;
    num_weaker_particles    =   sum(   mask    );

    %this means that the 7th value of cdf_data_Npx1 must be good, and so we
    %pick it
    picked_particle_idx     =   num_weaker_particles + 1; 
    
    
%style 2 (Neil Gordon's code) 
    i                       =   1;
    j                       =   1;
    picked_particle_idx     =   [];
    for j =1:Np                                         %make sure you are less than threshold Np times
        while cdf_ref_1xNp(j) > cdf_data_Npx1(i)        %take the sample, and keep comparing with particles
            i = i+1;
        end            
        picked_particle_idx=[picked_particle_idx i]; 	%as soon as particle is more, pick it, and now get ready to start comparing with next sample
    end;     

%------------------------
%POST-PROCESSING
%------------------------
    temp                    =   pdf_data_Npx1(picked_particle_idx);
    resampled_density_Npx1  =   temp./sum(temp);