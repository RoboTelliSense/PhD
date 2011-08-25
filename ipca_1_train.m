%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function [IPCA, trkIPCA] = ipca_1_train(DM2, IPCA, trkIPCA, CONFIG)

    
    if (isfield(trkIPCA,'coef'))
        ncoef                                                               =   size(trkIPCA.coef,2);
        recon                                                               =   repmat(IPCA.mean(:),[1,ncoef]) + IPCA.basis * trkIPCA.coef;
        [IPCA.basis, IPCA.eigval, IPCA.mean, IPCA.Np]   =   sklm(DM2, IPCA.basis, IPCA.eigval, IPCA.mean, IPCA.Np, CONFIG.ff);
        trkIPCA.coef                                                  =   IPCA.basis'*(recon - repmat(IPCA.mean(:),[1,ncoef]));
    else
        [IPCA.basis, IPCA.eigval, IPCA.mean, IPCA.Np]   =   sklm(DM2, IPCA.basis, IPCA.eigval, IPCA.mean, IPCA.Np, CONFIG.ff);
    end


    if (size(IPCA.basis,2) > CONFIG.in_maxbasis)
        %IPCA.reseig = CONFIG.ff^2 * IPCA.reseig + sum(IPCA.eigval(IPCA.maxbasis+1:end).^2);
        IPCA.reseig                                                    =   CONFIG.ff * IPCA.reseig + sum(IPCA.eigval(CONFIG.in_maxbasis+1:end));
        IPCA.basis                                                     =   IPCA.basis(:,1:CONFIG.in_maxbasis);
        IPCA.eigval                                                    =   IPCA.eigval(1:CONFIG.in_maxbasis);
        if (isfield(trkIPCA,'coef'))
            trkIPCA.coef                                              =   trkIPCA.coef(1:CONFIG.in_maxbasis,:);
        end
    end

    %find training error
    IPCA.trgout_U_DxD                                                =   IPCA.basis;
    IPCA.trgout_M_Dx1                                                =   IPCA.mean(:);
    IPCA.Neig_1x1                                             =   CONFIG.in_maxbasis; 

    IPCA                                                             =   UTIL_METRICS_compute_training_error_RVQ_style(DM2, IPCA, 1);   %2 is the algo code