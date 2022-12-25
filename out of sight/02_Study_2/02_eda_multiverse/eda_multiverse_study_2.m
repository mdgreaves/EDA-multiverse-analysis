function eda_multiverse_study_2(method, folder_00, folder_01)

% This function runs part of the EDA multiverse analysis for Study 2 
% associated with the EDA processing method specfied in the input. Ensure 
% that the "../00_Functions" directory has been added to the path.
%
% Usage: eda_multiverse_study_1(method, folder_00, folder_01)
% 
% Arguments:
%   method:     string specifying EDA processing method ('DCM', 'GLM', 
%               'TTP', or 'TTPf').
%   folder_00:  path to "00_self-report_and_demographic_data"
%   folder_01:  path to "01_conditioned_response_estimates"

%% Analysis-specific paths
model_data_path = fullfile(folder_01, sprintf('%s_model_data', method));

%% Identify cases

% Load and reformat self-report data and valid IDs
load(fullfile(folder_00, 'HC_SP.mat')); HC_SP = table2cell(HC_SP(:,:));
IDs = string(HC_SP(:,1)); N = length(IDs);
HC_SP(:,4) = num2cell(log(1+cell2mat(HC_SP(:,4)))); % Log-transform DASS scores
HC_SP(:,5) = num2cell(log(1+cell2mat(HC_SP(:,5)))); % Log-transform STAI scores

% Gather indices for clincal/control groups and above/below median anxiety
SP_group_indices = cell2mat(HC_SP(:,2)) == 1;
HC_group_indices = cell2mat(HC_SP(:,2)) == 2;
DASS_A_high_indices = cell2mat(HC_SP(:,4)) >= median(cell2mat(HC_SP(:,4)));
DASS_A_low_indices = cell2mat(HC_SP(:,4)) < median(cell2mat(HC_SP(:,4)));
STAI_high_indices = cell2mat(HC_SP(:,5)) >= median(cell2mat(HC_SP(:,5)));
STAI_low_indices = cell2mat(HC_SP(:,5)) < median(cell2mat(HC_SP(:,5)));

study = "cat";
run('initialise_matricies.m')

%% Fit all models

% Loop over all cases
for i_sub = 1:N
    ID = IDs(i_sub);

    % Model data files
    S1_model_data_file_name = sprintf('model_EX%s_S1.mat', ID); 
    S2_model_data_file_name = sprintf('model_EX%s_S2.mat', ID);
    
    % Load files
    S1_model_data = load(fullfile(model_data_path, S1_model_data_file_name));
    S2_model_data = load(fullfile(model_data_path, S2_model_data_file_name));
    
    % Model data structures
    % Remove habituation phase 
    data.US = S1_model_data.Model_data.US(5:34,:);
    data.CS = S1_model_data.Model_data.CS(5:34,:);
    data.CR = zscore(S1_model_data.Model_data.CR(5:34,:));
          
    % Create vectors for each phase
    Acquisition = [S1_model_data.Model_data.CR(5:20,1), S1_model_data.Model_data.CS(5:20,:)];
    Acquisition_diff_resp = (Acquisition(logical(Acquisition(:,2)),1))-(Acquisition(logical(Acquisition(:,3)),1));
    Extinction = [S1_model_data.Model_data.CR(21:34,1), S1_model_data.Model_data.CS(21:34,:)];
    Extinction_diff_resp = (Extinction(logical(Extinction(:,2)),1))-(Extinction(logical(Extinction(:,3)),1));
    Retention = [S2_model_data.Model_data.CR(1:end,1), S2_model_data.Model_data.CS(1:end,:)];
    Retention_diff_resp = (Retention(logical(Retention(:,2)),1))-(Retention(logical(Retention(:,3)),1));
    
    % Find indices for CSs       
    % CS+ trials
        % Acquisition
        A_CSp = find(logical(Acquisition(:,2)));  
        A_CSp_sort = sort(Acquisition(A_CSp,1), 'descend');
        % Extinction
        E_CSp = find(logical(Extinction(:,2)));
        % Retention
        R_CSp = find(logical(Retention(:,2)));
        
    % CS- trials
        % Acquisition
        A_CSm = find(logical(Acquisition(:,3)));               
        % Extinction
        E_CSm = find(logical(Extinction(:,3)));
        % Retention
        R_CSm = find(logical(Retention(:,3)));
    
    % Move individual means to initialised vectors
    % Acquisition
    ACQ_CSp_all(i_sub) = mean(Acquisition(A_CSp,1), 'omitnan');
    ACQ_CSm_all(i_sub) = mean(Acquisition(A_CSm,1), 'omitnan');
    ACQ_CSd_all(i_sub) = mean(Acquisition_diff_resp, 'omitnan');
    % Extinction
    EXT_CSp_all(i_sub) = mean(Extinction(E_CSp,1), 'omitnan');
    EXT_CSm_all(i_sub) = mean(Extinction(E_CSm,1), 'omitnan');
    EXT_CSd_all(i_sub) = mean(Extinction_diff_resp, 'omitnan');
    % Retention
    RET_CSp_all(i_sub) = mean(Retention(R_CSp,1), 'omitnan');
    RET_CSm_all(i_sub) = mean(Retention(R_CSm,1), 'omitnan');
    RET_CSd_all(i_sub) = mean(Retention_diff_resp, 'omitnan');
      
    % ERIs
    run('ERIs.m')
end

% Add means to matricies
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

% Save workspace before preceeding to other tests
save(sprintf('workspace_%s', method))
save(sprintf('%s_p_matrix', method), 'p_matrix')
save(sprintf('%s_t_or_rho_matrix', method), 't_or_rho_matrix')

% Non-learner exclusion
run('nonlearners_script_cat.m')
save(sprintf('workspace_%s_condition_2', method))
save(sprintf('%s_p_matrix_condition_2', method), 'p_matrix')
save(sprintf('%s_t_or_rho_matrix_condition_2', method), 't_or_rho_matrix')

end