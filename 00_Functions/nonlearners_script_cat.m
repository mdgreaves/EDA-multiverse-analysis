%% Non-learner exclusion
% Individuals were classified as "non-learners" if they "did not
% demonstrate greater SCRs to the CS+ relative to the CS- on average across
% all acquisition trials.

NL = ACQ_CSd_all <= 0;

% Update sel-report data frame
HC_SP(NL,:) = [];

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

% Gather indices for clincal/control groups and above/below median anxiety
SP_group_indices = cell2mat(HC_SP(:,2)) == 1;
HC_group_indices = cell2mat(HC_SP(:,2)) == 2;
DASS_A_high_indices = cell2mat(HC_SP(:,4)) >= median(cell2mat(HC_SP(:,4)));
DASS_A_low_indices = cell2mat(HC_SP(:,4)) < median(cell2mat(HC_SP(:,4)));
STAI_high_indices = cell2mat(HC_SP(:,5)) >= median(cell2mat(HC_SP(:,5)));
STAI_low_indices = cell2mat(HC_SP(:,5)) < median(cell2mat(HC_SP(:,5)));

run('add_means.m')

%% Statistical tests

% 1st Column: clinical-control
X_1 = ["SP_ACQ_CSp","SP_ACQ_CSm","SP_ACQ_CSd",...
    "SP_EXT_CSp","SP_EXT_CSm","SP_EXT_CSd",...
    "SP_RET_CSp","SP_RET_CSm","SP_RET_CSd",...
    "SP_A","SP_B","SP_C","SP_D","SP_E","SP_F","SP_G","SP_H","SP_I","SP_J","SP_K","SP_L","SP_M"];
Y_1 = ["HC_ACQ_CSp","HC_ACQ_CSm","HC_ACQ_CSd",...
    "HC_EXT_CSp","HC_EXT_CSm","HC_EXT_CSd",...
    "HC_RET_CSp","HC_RET_CSm","HC_RET_CSd",...
    "HC_A","HC_B","HC_C","HC_D","HC_E","HC_F","HC_G","HC_H","HC_I","HC_J","HC_K","HC_L","HC_M"];
for i = 1:length(X_1)
    eval(sprintf('[H0,P,CI,STATS] = ttest2(%s'', %s'');', X_1(i), Y_1(i)));
    STATS.CI = CI; STATS.p_value = P; 
    all_stats_matrix{i,1} = STATS;
    p_matrix(i,1) = STATS.p_value;          % for two-tailed p value
    t_or_rho_matrix(i,1) = STATS.tstat;     % for t test statistic
end

clear STATS

% 2nd Column: DASS high-low
Y_2 = ["DASS_A_ACQ_CSp_low","DASS_A_ACQ_CSm_low","DASS_A_ACQ_CSd_low",...
    "DASS_A_EXT_CSp_low","DASS_A_EXT_CSm_low","DASS_A_EXT_CSd_low",...
    "DASS_A_RET_CSp_low","DASS_A_RET_CSm_low","DASS_A_RET_CSd_low",...
    "DASS_A_A_low","DASS_A_B_low","DASS_A_C_low","DASS_A_D_low","DASS_A_E_low","DASS_A_F_low","DASS_A_G_low","DASS_A_H_low","DASS_A_I_low","DASS_A_J_low","DASS_A_K_low","DASS_A_L_low","DASS_A_M_low"];
X_2 = Y_2;
for i = 1:length(Y_2)
    X_2(i) = strrep(Y_2(i),'low','high');
end
for i = 1:length(X_2)
    eval(sprintf('[H0,P,CI,STATS] = ttest2(%s'', %s'');', X_2(i), Y_2(i)));
    STATS.CI = CI; STATS.p_value = P; 
    all_stats_matrix{i,2} = STATS;
    p_matrix(i,2) = STATS.p_value;          % for two-tailed p value
    t_or_rho_matrix(i,2) = STATS.tstat;     % for t test statistic
end

clear STATS

% 3rd Column: STAI high-low (Z)
X_3 = X_2;
Y_3 = Y_2;
for i = 1:length(X_3)
    X_3(i) = strrep(X_2(i),'DASS_A','STAI');
    Y_3(i) = strrep(Y_2(i),'DASS_A','STAI');
end
for i = 1:length(X_3)
    eval(sprintf('[H0,P,CI,STATS] = ttest2(%s'', %s'');', X_3(i), Y_3(i)));
    STATS.CI = CI; STATS.p_value = P; 
    all_stats_matrix{i,3} = STATS;
    p_matrix(i,3) = STATS.p_value;          % for two-tailed p value
    t_or_rho_matrix(i,3) = STATS.tstat;     % for t test statistic
end

clear STATS

% 4th column dimensional DASS_A
X_4and5 = ["ACQ_CSp_all", "ACQ_CSm_all", "ACQ_CSd_all", "EXT_CSp_all", "EXT_CSm_all", "EXT_CSd_all", "RET_CSp_all", "RET_CSm_all", "RET_CSd_all", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M"];
for i = 1:length(X_4and5)
    eval(sprintf('[RHO,PVAL] = corr(%s, cell2mat(HC_SP(:,4)));', X_4and5(i)));
    STATS.RHO = RHO;
    STATS.PVAL = PVAL;
    all_stats_matrix{i,4} = STATS;
    p_matrix(i,4) = PVAL;           % for p values
    t_or_rho_matrix(i,4) = RHO;     % for t and rho values
end

clear STATS

% 5th column dimensional STAI
for i = 1:length(X_4and5)
    eval(sprintf('[RHO,PVAL] = corr(%s, cell2mat(HC_SP(:,5)));', X_4and5(i)));
    STATS.RHO = RHO;
    STATS.PVAL = PVAL;
    all_stats_matrix{i,5} = STATS;
    p_matrix(i,5) = PVAL;           % for p values
    t_or_rho_matrix(i,5) = RHO;     % for t and rho values
end

clear STATS
close all

% Matthew Greaves 08.10.2021