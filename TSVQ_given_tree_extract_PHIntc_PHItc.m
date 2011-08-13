function [CBntc, CBtc] = TSVQ_given_tree_extract_CBntc_CBtc(CB, M, T)
    
    [Nntc, Ntc] = TSVQ_find_Nntc_Ntc(M, T);
    
    for i=1:Nntc
        CBntc(i,:) =     CB(i,:)
    end
    
    for i=Nntc+1:Nntc+Ntc
        CBtc(i,:) =     CB(i,:)
    end
    