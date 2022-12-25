function eda_multiverse_study_1(method, folder_00, folder_01)

% This function runs part of the EDA multiverse analysis for Study 1 
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
load(fullfile(folder_00, 'HC.mat'));
IDs = addnaught(HC(:,1)); N = length(IDs);
HC(:,2) = log(1+HC(:,2)); % Log-transform DASS scores

% Initialise upper and lower median variable
DASS_A_high_indices = HC(:,2) >= round(median(HC(:,2)));
DASS_A_low_indices = HC(:,2) < round(median(HC(:,2)));

study = "dim";
run('initialise_matricies.m')

%% Fit all models

% Loop over all cases
for i_sub = 1:N
    ID = IDs(i_sub);

    % Model data files
    S1_model_data_file_name = sprintf('model_ECB%s_S1.mat', ID); 
    S2_model_data_file_name = sprintf('model_ECB%s_S2.mat', ID);
    
    % Load files
    S1_model_data = load(fullfile(model_data_path, S1_model_data_file_name));
    S2_model_data = load(fullfile(model_data_path, S2_model_data_file_name));
    
    % Model data structures
    % Remove of habituation phase 
    data.US = S1_model_data.Model_data.US(9:38,:);
    data.CS = S1_model_data.Model_data.CS(9:38,:);
    data.CR = zscore(S1_model_data.Model_data.CR(9:38,:));
               
    % Create vectors for ease for ease
    Acquisition = [S1_model_data.Model_data.CR(9:18,1), S1_model_data.Model_data.CS(9:18,:)];
    Acquisition_diff_resp = (Acquisition(logical(Acquisition(:,2)),1))-(Acquisition(logical(Acquisition(:,3)),1));
    Extinction = [S1_model_data.Model_data.CR(19:38,1), S1_model_data.Model_data.CS(19:38,:)];
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

% Save workspace before preceeding to other tests
save(sprintf('workspace_%s', method))
save(sprintf('%s_p_matrix', method), 'p_matrix')
save(sprintf('%s_t_or_rho_matrix', method), 't_or_rho_matrix')

% Non-learner exclusion
run('nonlearners_script_dim.m')
save(sprintf('workspace_%s_condition_2', method))
save(sprintf('%s_p_matrix_condition_2', method), 'p_matrix')
save(sprintf('%s_t_or_rho_matrix_condition_2', method), 't_or_rho_matrix')

end