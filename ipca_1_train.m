%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function IPCA = ipca_1_train(DM2, IPCA)

    
    if (isfield(IPCA,'projScalars'))
        num_projScalars     =   size(IPCA.projScalars,2);
        recon               =   repmat(IPCA.mdl_mu_Dx1(:),[1,num_projScalars]) + IPCA.U_DxB * IPCA.projScalars;
        [IPCA.U_DxB, IPCA.S_Bx1, IPCA.mdl_mu_Dx1, IPCA.Np] ...
                            =   sklm2(DM2, IPCA.U_DxB, IPCA.S_Bx1, IPCA.mdl_mu_Dx1, IPCA.Np, IPCA.ff);
        
        %update projection scalars (only place where an assignment to projScalars takes place)
        IPCA.projScalars =   IPCA.U_DxB'*(recon - repmat(IPCA.mdl_mu_Dx1(:),[1,num_projScalars]));
    else
        [IPCA.U_DxB, IPCA.S_Bx1, IPCA.mdl_mu_Dx1, IPCA.Np] ...
                            =   sklm2(DM2, IPCA.U_DxB, IPCA.S_Bx1, IPCA.mdl_mu_Dx1, IPCA.Np, IPCA.ff);
    end

%------------------------------------------------------
% POST-PROCESSING
%------------------------------------------------------
%limit to Q
    if (size(IPCA.U_DxB,2) > IPCA.Q)
        %IPCA.reseig         = IPCA.ff^2 *IPCA.reseig + sum(IPCA.S_Bx1(IPCA.maxbasis+1:end).^2);
        IPCA.reseig         =   IPCA.ff * IPCA.reseig + sum(IPCA.S_Bx1(IPCA.Q+1:end));
        IPCA.U_DxB          =   IPCA.U_DxB(:,1:IPCA.Q);
        IPCA.S_Bx1              =   IPCA.S_Bx1(1:IPCA.Q);
        if (isfield(IPCA,'projScalars'))
            IPCA.projScalars    =   IPCA.projScalars(1:IPCA.Q,:);
        end
    end

    %find training error
    IPCA                    =   UTIL_METRICS_compute_training_error_RVQ_style(DM2, IPCA, 1);   %2 is the algo code
    