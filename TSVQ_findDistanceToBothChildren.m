function [child1_norm, child2_norm] = TSVQ_findDistanceToBothChildren(tst_Dx1, CB_DxKt, parent_idx)

	
	K 				= 	2; 											%because we have a binary tree
	child1_idx 		= 	K*parent_idx;
	child2_idx  	= 	K*parent_idx+1;
	
    child1_norm 	= 	norm(tst_Dx1 - CB_DxKt(:,child1_idx), 2);	%the 2 is for L-2 norm
    child2_norm 	= 	norm(tst_Dx1 - CB_DxKt(:,child2_idx), 2);	%the 2 is for L-2 norm