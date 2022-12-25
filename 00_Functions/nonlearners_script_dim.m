%% Non-learner exclusion
% Individuals were classified as "non-learners" if they "did not
% demonstrate greater SCRs to the CS+ relative to the CS- on average across
% all acquisition trials.

NL = ACQ_CSd_all <= 0;

% Update sel-report data frame
HC(NL,:) = [];

% Update vectors for individual aquisition mean responses
ACQ_CSp_all(NL) = [];
ACQ_CSm_all(NL) = [];
ACQ_CSd_all(NL) = [];

% Update vectors for individual extinction mean responses
EXT_CSp_all(NL) = [];
EXT_CSm_all(NL) = [];
EXT_CSd_all(NL) = [];

% Update vectors for individual retention mean responses
RET_CSp_all(NL) = [];
RET_CSm_all(NL) = [];
RET_CSd_all(NL) = [];

% Update 13 vectors for ERIs
A(NL) = []; B(NL) = []; C(NL) = []; D(NL) = []; E(NL) = []; F(NL) = [];
G(NL) = []; H(NL) = []; I(NL) = []; J(NL) = []; K(NL) = []; L(NL) = [];
M(NL) = [];

% Gather new indices for above/below median anxiety
% Initialise upper and lower median variable
DASS_A_high_indices = HC(:,2) >= round(median(HC(:,2)));
DASS_A_low_indices = HC(:,2) < round(median(HC(:,2)));

% Add participants' mean CR to vectors
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

%% Statistical tests

% 1st Column: DASS high-low (Z)
Y_1 = ["DASS_A_ACQ_CSp_low","DASS_A_ACQ_CSm_low","DASS_A_ACQ_CSd_low",...
    "DASS_A_EXT_CSp_low","DASS_A_EXT_CSm_low","DASS_A_EXT_CSd_low",...
    "DASS_A_RET_CSp_low","DASS_A_RET_CSm_low","DASS_A_RET_CSd_low",...
    "DASS_A_A_low","DASS_A_B_low","DASS_A_C_low","DASS_A_D_low","DASS_A_E_low","DASS_A_F_low","DASS_A_G_low","DASS_A_H_low","DASS_A_I_low","DASS_A_J_low","DASS_A_K_low","DASS_A_L_low","DASS_A_M_low"];
X_1 = Y_1;
for i = 1:length(Y_1)
    X_1(i) = strrep(Y_1(i),'low','high');
end
for i = 1:length(X_1)
    eval(sprintf('[H0,P,CI,STATS] = ttest2(%s'', %s'');', X_1(i), Y_1(i)));
    STATS.CI = CI; STATS.p_value = P; 
    all_stats_matrix{i,1} = STATS;
    p_matrix(i,1) = STATS.p_value;          % for two-tailed p value
    t_or_rho_matrix(i,1) = STATS.tstat;     % for t test statistic
end

clear STATS

%2nd column dimensional DASS_A
X_2 = ["ACQ_CSp_all", "ACQ_CSm_all", "ACQ_CSd_all", "EXT_CSp_all", "EXT_CSm_all", "EXT_CSd_all", "RET_CSp_all", "RET_CSm_all", "RET_CSd_all", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"];
for i = 1:length(X_2)
    eval(sprintf('[RHO,PVAL] = corr(%s, HC(:,2));', X_2(i)));
    STATS.RHO = RHO;
    STATS.PVAL = PVAL;
    all_stats_matrix{i,2} = STATS;
    p_matrix(i,2) = PVAL;           % for p values
    t_or_rho_matrix(i,2) = RHO;     % for t and rho values
end

% Matthew Greaves 08.10.2021