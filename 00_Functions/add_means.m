% Add participants' mean CR to vectors
switch study
    case 'dim'
        % Acquisition
        DASS_A_ACQ_CSp_high = ACQ_CSp_all(DASS_A_high_indices);
        DASS_A_ACQ_CSm_high = ACQ_CSm_all(DASS_A_high_indices);
        DASS_A_ACQ_CSd_high = ACQ_CSd_all(DASS_A_high_indices);
        DASS_A_ACQ_CSp_low = ACQ_CSp_all(DASS_A_low_indices);
        DASS_A_ACQ_CSm_low = ACQ_CSm_all(DASS_A_low_indices);
        DASS_A_ACQ_CSd_low = ACQ_CSd_all(DASS_A_low_indices);
        % Extinction
        DASS_A_EXT_CSp_high = EXT_CSp_all(DASS_A_high_indices);
        DASS_A_EXT_CSm_high = EXT_CSm_all(DASS_A_high_indices);
        DASS_A_EXT_CSd_high = EXT_CSd_all(DASS_A_high_indices);
        DASS_A_EXT_CSp_low = EXT_CSp_all(DASS_A_low_indices);
        DASS_A_EXT_CSm_low = EXT_CSm_all(DASS_A_low_indices);
        DASS_A_EXT_CSd_low = EXT_CSd_all(DASS_A_low_indices);
        % Retention
        DASS_A_RET_CSp_high = RET_CSp_all(DASS_A_high_indices);
        DASS_A_RET_CSm_high = RET_CSm_all(DASS_A_high_indices);
        DASS_A_RET_CSd_high = RET_CSd_all(DASS_A_high_indices);
        DASS_A_RET_CSp_low = RET_CSp_all(DASS_A_low_indices);
        DASS_A_RET_CSm_low = RET_CSm_all(DASS_A_low_indices);
        DASS_A_RET_CSd_low = RET_CSd_all(DASS_A_low_indices);
        % Extinction retention indices
        % High DASS-A
        DASS_A_A_high = A(DASS_A_high_indices);
        DASS_A_B_high = B(DASS_A_high_indices);
        DASS_A_C_high = C(DASS_A_high_indices);
        DASS_A_D_high = D(DASS_A_high_indices);
        DASS_A_E_high = E(DASS_A_high_indices);
        DASS_A_F_high = F(DASS_A_high_indices);
        DASS_A_G_high = G(DASS_A_high_indices);
        DASS_A_H_high = H(DASS_A_high_indices);
        DASS_A_I_high = I(DASS_A_high_indices);
        DASS_A_J_high = J(DASS_A_high_indices);
        DASS_A_K_high = K(DASS_A_high_indices);
        DASS_A_L_high = L(DASS_A_high_indices);
        DASS_A_M_high = M(DASS_A_high_indices);
        % Low DASS-A
        DASS_A_A_low = A(DASS_A_low_indices);
        DASS_A_B_low = B(DASS_A_low_indices);
        DASS_A_C_low = C(DASS_A_low_indices);
        DASS_A_D_low = D(DASS_A_low_indices);
        DASS_A_E_low = E(DASS_A_low_indices);
        DASS_A_F_low = F(DASS_A_low_indices);
        DASS_A_G_low = G(DASS_A_low_indices);
        DASS_A_H_low = H(DASS_A_low_indices);
        DASS_A_I_low = I(DASS_A_low_indices);
        DASS_A_J_low = J(DASS_A_low_indices);
        DASS_A_K_low = K(DASS_A_low_indices);
        DASS_A_L_low = L(DASS_A_low_indices);
        DASS_A_M_low = M(DASS_A_low_indices);
%         % Models (BIC/logBF)
%         % High DASS_A
%         RW_DASS_A_high = RW_all(DASS_A_high_indices);
%         PH_DASS_A_high = PH_all(DASS_A_high_indices);
%         LCM_DASS_A_high = LCM_all(DASS_A_high_indices);
%         LS_DASS_A_high = LS_all(DASS_A_high_indices);
%         % Low DASS_A
%         RW_DASS_A_low = RW_all(DASS_A_low_indices);
%         PH_DASS_A_low = PH_all(DASS_A_low_indices);
%         LCM_DASS_A_low = LCM_all(DASS_A_low_indices);
%         LS_DASS_A_low = LS_all(DASS_A_low_indices);
        
    case 'cat'
        % Add participants' mean CR to vectors
        % Acquisition
        SP_ACQ_CSp = ACQ_CSp_all(SP_group_indices);
        SP_ACQ_CSm = ACQ_CSm_all(SP_group_indices);
        SP_ACQ_CSd = ACQ_CSd_all(SP_group_indices);
        HC_ACQ_CSp = ACQ_CSp_all(HC_group_indices);
        HC_ACQ_CSm = ACQ_CSm_all(HC_group_indices);
        HC_ACQ_CSd = ACQ_CSd_all(HC_group_indices);
        DASS_A_ACQ_CSp_high = ACQ_CSp_all(DASS_A_high_indices);
        DASS_A_ACQ_CSm_high = ACQ_CSm_all(DASS_A_high_indices);
        DASS_A_ACQ_CSd_high = ACQ_CSd_all(DASS_A_high_indices);
        DASS_A_ACQ_CSp_low = ACQ_CSp_all(DASS_A_low_indices);
        DASS_A_ACQ_CSm_low = ACQ_CSm_all(DASS_A_low_indices);
        DASS_A_ACQ_CSd_low = ACQ_CSd_all(DASS_A_low_indices);
        STAI_ACQ_CSp_high = ACQ_CSp_all(STAI_high_indices);
        STAI_ACQ_CSm_high = ACQ_CSm_all(STAI_high_indices);
        STAI_ACQ_CSd_high = ACQ_CSd_all(STAI_high_indices);
        STAI_ACQ_CSp_low = ACQ_CSp_all(STAI_low_indices);
        STAI_ACQ_CSm_low = ACQ_CSm_all(STAI_low_indices);
        STAI_ACQ_CSd_low = ACQ_CSd_all(STAI_low_indices);
        % Extinction
        SP_EXT_CSp = EXT_CSp_all(SP_group_indices);
        SP_EXT_CSm = EXT_CSm_all(SP_group_indices);
        SP_EXT_CSd = EXT_CSd_all(SP_group_indices);
        HC_EXT_CSp = EXT_CSp_all(HC_group_indices);
        HC_EXT_CSm = EXT_CSm_all(HC_group_indices);
        HC_EXT_CSd = EXT_CSd_all(HC_group_indices);
        DASS_A_EXT_CSp_high = EXT_CSp_all(DASS_A_high_indices);
        DASS_A_EXT_CSm_high = EXT_CSm_all(DASS_A_high_indices);
        DASS_A_EXT_CSd_high = EXT_CSd_all(DASS_A_high_indices);
        DASS_A_EXT_CSp_low = EXT_CSp_all(DASS_A_low_indices);
        DASS_A_EXT_CSm_low = EXT_CSm_all(DASS_A_low_indices);
        DASS_A_EXT_CSd_low = EXT_CSd_all(DASS_A_low_indices);
        STAI_EXT_CSp_high = EXT_CSp_all(STAI_high_indices);
        STAI_EXT_CSm_high = EXT_CSm_all(STAI_high_indices);
        STAI_EXT_CSd_high = EXT_CSd_all(STAI_high_indices);
        STAI_EXT_CSp_low = EXT_CSp_all(STAI_low_indices);
        STAI_EXT_CSm_low = EXT_CSm_all(STAI_low_indices);
        STAI_EXT_CSd_low = EXT_CSd_all(STAI_low_indices);
        % Retention
        SP_RET_CSp = RET_CSp_all(SP_group_indices);
        SP_RET_CSm = RET_CSm_all(SP_group_indices);
        SP_RET_CSd = RET_CSd_all(SP_group_indices);
        HC_RET_CSp = RET_CSp_all(HC_group_indices);
        HC_RET_CSm = RET_CSm_all(HC_group_indices);
        HC_RET_CSd = RET_CSd_all(HC_group_indices);
        DASS_A_RET_CSp_high = RET_CSp_all(DASS_A_high_indices);
        DASS_A_RET_CSm_high = RET_CSm_all(DASS_A_high_indices);
        DASS_A_RET_CSd_high = RET_CSd_all(DASS_A_high_indices);
        DASS_A_RET_CSp_low = RET_CSp_all(DASS_A_low_indices);
        DASS_A_RET_CSm_low = RET_CSm_all(DASS_A_low_indices);
        DASS_A_RET_CSd_low = RET_CSd_all(DASS_A_low_indices);
        STAI_RET_CSp_high = RET_CSp_all(STAI_high_indices);
        STAI_RET_CSm_high = RET_CSm_all(STAI_high_indices);
        STAI_RET_CSd_high = RET_CSd_all(STAI_high_indices);
        STAI_RET_CSp_low = RET_CSp_all(STAI_low_indices);
        STAI_RET_CSm_low = RET_CSm_all(STAI_low_indices);
        STAI_RET_CSd_low = RET_CSd_all(STAI_low_indices);
        % Extinction retention indices
        % SP
        SP_A = A(SP_group_indices);
        SP_B = B(SP_group_indices);
        SP_C = C(SP_group_indices);
        SP_D = D(SP_group_indices);
        SP_E = E(SP_group_indices);
        SP_F = F(SP_group_indices);
        SP_G = G(SP_group_indices);
        SP_H = H(SP_group_indices);
        SP_I = I(SP_group_indices);
        SP_J = J(SP_group_indices);
        SP_K = K(SP_group_indices);
        SP_L = L(SP_group_indices);
        SP_M = M(SP_group_indices);
        % HC
        HC_A = A(HC_group_indices);
        HC_B = B(HC_group_indices);
        HC_C = C(HC_group_indices);
        HC_D = D(HC_group_indices);
        HC_E = E(HC_group_indices);
        HC_F = F(HC_group_indices);
        HC_G = G(HC_group_indices);
        HC_H = H(HC_group_indices);
        HC_I = I(HC_group_indices);
        HC_J = J(HC_group_indices);
        HC_K = K(HC_group_indices);
        HC_L = L(HC_group_indices);
        HC_M = M(HC_group_indices);
        % High DASS-A
        DASS_A_A_high = A(DASS_A_high_indices);
        DASS_A_B_high = B(DASS_A_high_indices);
        DASS_A_C_high = C(DASS_A_high_indices);
        DASS_A_D_high = D(DASS_A_high_indices);
        DASS_A_E_high = E(DASS_A_high_indices);
        DASS_A_F_high = F(DASS_A_high_indices);
        DASS_A_G_high = G(DASS_A_high_indices);
        DASS_A_H_high = H(DASS_A_high_indices);
        DASS_A_I_high = I(DASS_A_high_indices);
        DASS_A_J_high = J(DASS_A_high_indices);
        DASS_A_K_high = K(DASS_A_high_indices);
        DASS_A_L_high = L(DASS_A_high_indices);
        DASS_A_M_high = M(DASS_A_high_indices);
        % Low DASS-A
        DASS_A_A_low = A(DASS_A_low_indices);
        DASS_A_B_low = B(DASS_A_low_indices);
        DASS_A_C_low = C(DASS_A_low_indices);
        DASS_A_D_low = D(DASS_A_low_indices);
        DASS_A_E_low = E(DASS_A_low_indices);
        DASS_A_F_low = F(DASS_A_low_indices);
        DASS_A_G_low = G(DASS_A_low_indices);
        DASS_A_H_low = H(DASS_A_low_indices);
        DASS_A_I_low = I(DASS_A_low_indices);
        DASS_A_J_low = J(DASS_A_low_indices);
        DASS_A_K_low = K(DASS_A_low_indices);
        DASS_A_L_low = L(DASS_A_low_indices);
        DASS_A_M_low = M(DASS_A_low_indices);
        % High STAI
        STAI_A_high = A(STAI_high_indices);
        STAI_B_high = B(STAI_high_indices);
        STAI_C_high = C(STAI_high_indices);
        STAI_D_high = D(STAI_high_indices);
        STAI_E_high = E(STAI_high_indices);
        STAI_F_high = F(STAI_high_indices);
        STAI_G_high = G(STAI_high_indices);
        STAI_H_high = H(STAI_high_indices);
        STAI_I_high = I(STAI_high_indices);
        STAI_J_high = J(STAI_high_indices);
        STAI_K_high = K(STAI_high_indices);
        STAI_L_high = L(STAI_high_indices);
        STAI_M_high = M(STAI_high_indices);
        % Low STAI
        STAI_A_low = A(STAI_low_indices);
        STAI_B_low = B(STAI_low_indices);
        STAI_C_low = C(STAI_low_indices);
        STAI_D_low = D(STAI_low_indices);
        STAI_E_low = E(STAI_low_indices);
        STAI_F_low = F(STAI_low_indices);
        STAI_G_low = G(STAI_low_indices);
        STAI_H_low = H(STAI_low_indices);
        STAI_I_low = I(STAI_low_indices);
        STAI_J_low = J(STAI_low_indices);
        STAI_K_low = K(STAI_low_indices);
        STAI_L_low = L(STAI_low_indices);
        STAI_M_low = M(STAI_low_indices);
        % Models (BIC/logBF)
%         % SP
%         RW_SP = RW_all(SP_group_indices);
%         PH_SP = PH_all(SP_group_indices);
%         LCM_SP = LCM_all(SP_group_indices);
%         LS_SP = LS_all(SP_group_indices);
%         % HC
%         RW_HC = RW_all(HC_group_indices);
%         PH_HC = PH_all(HC_group_indices);
%         LCM_HC = LCM_all(HC_group_indices);
%         LS_HC = LS_all(HC_group_indices);
%         % High DASS_A
%         RW_DASS_A_high = RW_all(DASS_A_high_indices);
%         PH_DASS_A_high = PH_all(DASS_A_high_indices);
%         LCM_DASS_A_high = LCM_all(DASS_A_high_indices);
%         LS_DASS_A_high = LS_all(DASS_A_high_indices);
%         % Low DASS_A
%         RW_DASS_A_low = RW_all(DASS_A_low_indices);
%         PH_DASS_A_low = PH_all(DASS_A_low_indices);
%         LCM_DASS_A_low = LCM_all(DASS_A_low_indices);
%         LS_DASS_A_low = LS_all(DASS_A_low_indices);
%         % High STAI
%         RW_STAI_high = RW_all(STAI_high_indices);
%         PH_STAI_high = PH_all(STAI_high_indices);
%         LCM_STAI_high = LCM_all(STAI_high_indices);
%         LS_STAI_high = LS_all(STAI_high_indices);
%         % Low STAI
%         RW_STAI_low = RW_all(STAI_low_indices);
%         PH_STAI_low = PH_all(STAI_low_indices);
%         LCM_STAI_low = LCM_all(STAI_low_indices);
%         LS_STAI_low = LS_all(STAI_low_indices);
        
end
