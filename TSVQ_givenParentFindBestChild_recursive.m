%- this is a recursive function, and the exit condition variable is exit_condition_T.  
%- this variable corresponds to how deep you are in the tree.  this helps you
%exit the recursion once you've hit the bottom, i.e. picked a terminal
%codevector
%- refer to TSVQ_1_train to see how the levels are set

function [t, bVQ] = TSVQ_givenParentFindBestChild_recursive(tst_Dx1, parent_idx, bVQ, CB_DxKt, t, exit_condition_T)

    K=2; %because binary tree
    
    %child indeces (get from parent idx)
        child1_idx = parent_idx*K;
        child2_idx = parent_idx*K+1;
        
    %child distances to test_vec
        [child1_dist, child2_dist] = TSVQ_findDistanceToBothChildren(tst_Dx1, CB_DxKt, parent_idx);

    %find better child
        if ( child1_dist < child2_dist )
            better_child_idx=parent_idx*K;    %better, not best because K=2, i.e. only 2 children 
        else
            better_child_idx=parent_idx*K+1;
        end
        bVQ = [bVQ better_child_idx]; %all better children
    
    %go down one level
        t = t + 1;                      %the better_child_idx you just picked sits in this new incremented level t
                                        %this makes sense because the last child you pick is a terminal codevector and once you've done that, you want to exit
    %exit or recurse?
        if (t==exit_condition_T)        %i don't process TSVQ_givenParentFindBestChild_recursive for exit_condition_T because it has no children
            return
        else
            [t, bVQ] = TSVQ_givenParentFindBestChild_recursive(tst_Dx1, better_child_idx, bVQ, CB_DxKt, t, exit_condition_T);
        end   
        