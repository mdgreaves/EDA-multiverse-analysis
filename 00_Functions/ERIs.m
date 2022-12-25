% Calculate ERIs
    % Nondifferential Indices (CS+ Based)
    % ERI 1 x
    % 100 - [100 × first CS+ of retention/max(CS+ acquisition)]
    A(i_sub) = 100-(100*Retention(R_CSp(1),1)/max(Acquisition(A_CSp,1)));
    
    % ERI 2 x
    % 100 - [100 × nanmean(first 2 CS+ retention)/max(CS+ acquisition)]
    B(i_sub) = 100-(100*nanmean(Retention(R_CSp(1:2),1))/max(Acquisition(A_CSp,1)));
    
    % ERI 3 x
    % 100 × [1 - [nanmean(first 2 CS+ retention)/(nanmean(two largest CS+ acquisition)]
    C(i_sub) = 100*(1-nanmean(Retention(R_CSp(1:2),1))/nanmean(A_CSp_sort(1:2)));
    
    % ERI 4 (5 in Lonsdorf et al., 2019) x
    % 100 × nanmean(first 2 CS+ retention)/max(CS+ acquisition)
    D(i_sub) = 100*nanmean(Retention(R_CSp(1:2),1))/max(Acquisition(A_CSp,1));
    
    % ERI_5 (8 in Lonsdorf et al., 2019) x
    % 100 × nanmean(first 4 CS+ retention)/max(CS+ acquisition)
    E(i_sub) = 100*nanmean(Retention(R_CSp(1:4),1))/max(Acquisition(A_CSp,1));
    
    % ERI_6 (9a in Lonsdorf et al., 2019) x
    % (first CS+ retention) - (last CS+ extinction)
    F(i_sub) = Retention(R_CSp(1),1)-Extinction(E_CSp(end),1);
    
    % Nondifferential Indices (CS- Based)
    % ERI_7 (9b in Lonsdorf et al., 2019) x
    % (first CS- retention) - (last CS- extinction)
    G(i_sub) = Retention(R_CSm(1),1)-Extinction(E_CSm(end),1);
    
    % Differential Indices
    % ERI_8 (10 in Lonsdorf et al., 2019) x
    % 100 - (100 × [(nanmean first 2 CS+ retention) -...
    % (nanmean first two CS- retention)]/max pair(CS+) - (CS-) acquisition)
    H(i_sub) = 100-(100*(nanmean(Retention(R_CSp(1:2),1))-nanmean(Retention(R_CSm(1:2),1)))/max(Acquisition_diff_resp));
    
    % ERI_9 (11 in Lonsdorf et al., 2019) x
    % nanmean(first 2 CS+ retention) - nanmean(first 2 CS- trials retention)
    I(i_sub) = nanmean(Retention(R_CSp(1:2),1))-nanmean(Retention(R_CSm(1:2),1));
    
    % ERI_10 (12 in Lonsdorf et al., 2019) x
    % 100 × [(nanmean CS- retention) - (nanmean CS+ retention)]/(nanmean CS- retention)
    J(i_sub) = 100*((nanmean(Retention(R_CSm,1))-nanmean(Retention(R_CSp,1)))/nanmean(Retention(R_CSm,1)));
    
    % ERI_11 (13 in Lonsdorf et al., 2019) x
    % 100 - [100 × nanmean(first 4 CS+ retention) - (nanmean[first 4 CS- retention])/(max pairh(CS+) - (CS-) acquisition)]
    K(i_sub) = 100-(100*nanmean(Retention(R_CSp(1:4),1))-nanmean(Retention(R_CSm(1:4),1))/max(Acquisition_diff_resp));
    
    % ERI_12 (15 in Lonsdorf et al., 2019) x
    % [nanmean(first 5 CS+ retention) - nanmean(first 5 CS- retention)] - [nanmean(trial 2-5 CS+ extinction) - nanmean(trial 2-5 CS- extinction)]
    L(i_sub) = (nanmean(Retention(R_CSp(1:5),1))-nanmean(Retention(R_CSm(1:5),1)))-(nanmean(Extinction(E_CSp(2:5),1))-nanmean(Extinction(E_CSm(2:5),1)));
    
    % ERI_13 (16 in Lonsdorf et al., 2019) x
    % [nanmean(first 5 CS+ retention) - nanmean(first 5 CS- retention)] - [nanmean(last 5 CS+ extinction) - nanmean(last 5 CS- extinction)]
    M(i_sub) = (nanmean(Retention(R_CSp(1:5),1))-nanmean(Retention(R_CSm(1:5),1)))-(nanmean(Extinction(E_CSp((length(E_CSp)-4):end),1))-nanmean(Extinction(E_CSm((length(E_CSm)-4):end),1)));