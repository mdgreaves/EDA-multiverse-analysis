function data = multi_plot(S1_multiverse_path,...
    S2_multiverse_path,...
    S1_model_path,...
    S2_model_path,...
    EXP_workspace_path)

% MULTI_PLOT Extracts and processes multiverse analysis results for 
%   plotting.
%
%   data = MULTI_PLOT(S1_multiverse_path, S2_multiverse_path, ...
%                     S1_model_path, S2_model_path, EXP_workspace_path)
%
%   This function loads and processes data from multiverse analyses and 
%   reinforcement learning models across two studies (Study 1 and Study 2). 
%   The function computes Bayesian Information Criterion (BIC) values, 
%   log-likelihoods (lnL), and confidence intervals (CI) for various 
%   methods and models. The processed data is returned in a structure 
%   format suitable for plotting and further analysis.
%
%   Inputs:
%   - S1_multiverse_path: File path to the multiverse analysis results for 
%                         Study 1.
%   - S2_multiverse_path: File path to the multiverse analysis results for 
%                         Study 2.
%   - S1_model_path: File path to the model data for Study 1.
%   - S2_model_path: File path to the model data for Study 2.
%   - EXP_workspace_path: File path to the workspace containing expectancy 
%                         results and participant indices for Study 1.
%
%   Outputs:
%   - data: A structure containing the following fields:
%       - means_BIC: A matrix of mean BIC values for different methods and 
%                      models.
%       - CIs_BIC: A matrix of BIC confidence intervals for different
%                  methods and models.
%       - means_lnL: A matrix of mean log-likelihood values for different 
%                    methods and models.
%       - CIs_lnL: A matrix of log-likelihood confidence intervals for 
%                  different methods and models.
%       - tests: A structure with fields 'lnL' and 'logBF', containing 
%                log-likelihood and log Bayes factor values, respectively, 
%                for within-subject and between-subject comparisons.
%       - HC_means_BIC_diff: A matrix of mean BIC differences for healthy 
%                            control (HC) participants.
%       - SP_means_BIC_diff: A matrix of mean BIC differences for specific 
%                            phobia (SP) participants.
%       - HC_CIs_BIC_diff: A matrix of BIC difference confidence intervals 
%                          for HC participants.
%       - SP_CIs_BIC_diff: A matrix of BIC difference confidence intervals 
%                          for SP participants.
%
%   Notes:
%   - The function initializes and processes the BIC and log-likelihood 
%     values for different methods (DCM, GLM, TTP, BLC, EXP) and models 
%     (RW, PH, LCM, LS).
%   - The data is split and processed according to participant groups 
%     (HC and SP) for Study 2, and the BIC differences are calculated for 
%     RL models.
%   - The function returns a comprehensive data structure that can be used 
%     for generating plots or conducting further statistical analysis.

study_paths = {S1_multiverse_path, S2_multiverse_path};
model_paths = {S1_model_path, S2_model_path};

% Load EXP workspace and S2 multiverse to obtain Ns
S1_EXP = load(EXP_workspace_path);
indx = S1_EXP.valid_expectancy_indicies;
x = load(fullfile(study_paths{2}, 'DCM_multiverse.mat'), 'SP');
SP = x.SP;
Ns = [length(indx), length(SP)];

% Dimensions of matricies for S1 and S2
matrixSize = {[Ns(1), 1], [Ns(2), 1]};

% Methods
studies_considered = {'S1', 'S2'};
methods_considered = {'DCM', 'GLM', 'TTP', 'BLC', 'EXP'};
models_considered = {'RW', 'PH', 'LCM', 'LS'};

% Initialise cells arrays and matricies
for i_study = 1:length(studies_considered)
    for i_method = 1:length(methods_considered)
        for i_model = 1:length(models_considered)
            % Skip expectancy ratings for Study 2
            if i_study == length(studies_considered)...
                    && i_method == length(methods_considered)
                continue;
            else
                eval([studies_considered{i_study}, '_',...
                    methods_considered{i_method}, '_',...
                    models_considered{i_model},...
                    '_BIC = nan(matrixSize{i_study});']);
                eval([studies_considered{i_study}, '_',...
                    methods_considered{i_method}, '_',...
                    models_considered{i_model},...
                    '_lnL = nan(matrixSize{i_study});']);
                if i_method ~= length(methods_considered)
                    fullPathToFile = fullfile(study_paths{i_study},...
                        [methods_considered{i_method}, '_RL_models.mat']);
                    eval([studies_considered{i_study}, '_',...
                        methods_considered{i_method}, ' = load(''',...
                        fullPathToFile, ''');']);
                end
            end
        end
    end
end

% Obtain BIC and predicted CR
for i_study = 1:length(studies_considered)
    for i_method = 1:length(methods_considered)
        for i_model = 1:length(models_considered)
            for i_sub = 1:Ns(i_study)
                study = studies_considered{i_study};
                method = methods_considered{i_method};
                model = models_considered{i_model};
                % For Study 1
                if i_study ~= length(studies_considered)
                    % Use indicies if not considering the EXP data
                    if i_method ~= length(methods_considered)
                        eval([study, '_', method, '_', model,...
                            '_BIC(i_sub) = ', study, '_',...
                            method, '.', model,...
                            '_all_stats_matrix{indx(i_sub), 1}.BIC;']);
                        eval([study, '_', method, '_', model,...
                            '_lnL(i_sub) = ', study, '_',...
                            method, '.', model,...
                            '_all_stats_matrix{indx(i_sub), 1}.lnL;']);
                    else
                        eval([study, '_', method, '_', model,...
                            '_BIC(i_sub) = ', study, '_',...
                            method, '.', model,...
                            '_all_stats_matrix{i_sub, 1}.BIC;']);
                        eval([study, '_', method, '_', model,...
                            '_lnL(i_sub) = ', study, '_',...
                            method, '.', model,...
                            '_all_stats_matrix{i_sub, 1}.lnL;']);
                    end
                else
                    % For Study 2
                    if i_method == length(methods_considered)
                        continue;
                    else
                        eval([study, '_', method, '_', model,...
                            '_BIC(i_sub) = ', study, '_',...
                            method, '.', model,...
                            '_all_stats_matrix{i_sub, 1}.BIC;']);
                    end
                end
            end
        end
    end
end

%% Study 1 data
% The mean R2 and 95% CI for each method and model

study = studies_considered{1};
for i_method = 1:length(methods_considered)
    for i_model = 1:length(models_considered)
        method = methods_considered{i_method};
        model = models_considered{i_model};
        eval(['[', study, '_', method, '_', model, '_mean_BIC, ',...
            study, '_', method, '_', model, '_CI_BIC] = ',...
            'multi_margin_error(',...
            study, '_', method, '_', model, '_BIC);']);
        eval(['[', study, '_', method, '_', model, '_mean_lnL, ',...
            study, '_', method, '_', model, '_CI_lnL] = ',...
            'multi_margin_error(',...
            study, '_', method, '_', model, '_lnL);']);
    end
end

% Concatenate new matrices
for i_method = 1:length(methods_considered)
    method = methods_considered{i_method};
    eval([study, '_', method, '_means_BIC = [];']);
    eval([study, '_', method, '_CIs_BIC = [];']);
    eval([study, '_', method, '_means_lnL = [];']);
    eval([study, '_', method, '_CIs_lnL = [];']);
    for i_model = 1:length(models_considered)
        model = models_considered{i_model};
        eval([study, '_', method, '_means_BIC = ',...
            '[', study, '_', method, '_means_BIC, ',...
            study, '_', method, '_', model, '_mean_BIC];']);
        eval([study, '_', method, '_CIs_BIC = ',...
            '[', study, '_', method, '_CIs_BIC, ',...
            study, '_', method, '_', model, '_CI_BIC];']);
                eval([study, '_', method, '_means_lnL = ',...
            '[', study, '_', method, '_means_lnL, ',...
            study, '_', method, '_', model, '_mean_lnL];']);
        eval([study, '_', method, '_CIs_lnL = ',...
            '[', study, '_', method, '_CIs_lnL, ',...
            study, '_', method, '_', model, '_CI_lnL];']);
    end
end
data.means_BIC = [S1_DCM_means_BIC', S1_GLM_means_BIC',...
    S1_TTP_means_BIC', S1_BLC_means_BIC', S1_EXP_means_BIC'];
data.CIs_BIC = [S1_DCM_CIs_BIC', S1_GLM_CIs_BIC',S1_TTP_CIs_BIC',...
    S1_BLC_CIs_BIC', S1_EXP_CIs_BIC'];
data.means_lnL = [S1_DCM_means_lnL', S1_GLM_means_lnL',...
    S1_TTP_means_lnL', S1_BLC_means_lnL', S1_EXP_means_lnL'];
data.CIs_lnL = [S1_DCM_CIs_lnL', S1_GLM_CIs_lnL',S1_TTP_CIs_lnL',...
    S1_BLC_CIs_lnL', S1_EXP_CIs_lnL'];

% For within-method tests
data.tests.lnL = cell(length(methods_considered), length(models_considered));
for i_method = 1:length(methods_considered)
    for i_model = 1:length(models_considered)
        eval(['data.tests.lnL{i_method, i_model} = S1_',...
            methods_considered{i_method}, '_', ...
            models_considered{i_model}, '_lnL;']);
    end
end



%% Study 2 data
% The BIC difference and 95% CI for each method and model-based RL model, and
% two clinical conditions

% First calculate the BIC difference
RL_models_considered = {'LCM', 'LS'};
study = studies_considered{2};
for i_method = 1:length(methods_considered)-1
    method = methods_considered{i_method};
    for i_model = 1:length(RL_models_considered)
        model = RL_models_considered{i_model};
        eval([study, '_', method, '_', model, '_BIC_diff = ',...
            study, '_', method, '_', model, '_BIC - ',...
            study, '_', method, '_RW_BIC;']);
    end
end

% Split data according to SP or HC
participant_groups = {'HC', 'SP'; '~logical(SP)', 'logical(SP)'};
for i_group = 1:length(participant_groups)
    for i_method = 1:length(methods_considered)-1
        method = methods_considered{i_method};
        for i_model = 1:length(RL_models_considered)
            model = RL_models_considered{i_model};
            eval([participant_groups{1, i_group}, '_', method, '_',...
                model, '_BIC_diff = ',...
                study, '_', method, '_', model, '_BIC_diff(',...
                participant_groups{2, i_group}, ');']);
        end
    end
end

% Obtain mean and CI for the
for i_group = 1:length(participant_groups)
    for i_method = 1:length(methods_considered)-1
        method = methods_considered{i_method};
        for i_model = 1:length(RL_models_considered)
            model = RL_models_considered{i_model};
            eval(['[', participant_groups{1, i_group}, '_', method, '_',...
                model, '_BIC_diff_mean, ',...
                participant_groups{1, i_group}, '_', method, '_',...
                model, '_BIC_diff_CI] = ',...
                'multi_margin_error(',...
                participant_groups{1, i_group}, '_', method, '_',...
                model, '_BIC_diff);']);
        end
    end
end

% Concatenate new matrices
for i_group = 1:length(participant_groups)
    for i_method = 1:length(methods_considered)-1
        method = methods_considered{i_method};
        eval([participant_groups{1, i_group}, '_', method,...
            '_BIC_diff_means = [];']);
        eval([participant_groups{1, i_group}, '_', method,...
            '_BIC_diff_CIs = [];']);
        for i_model = 1:length(RL_models_considered)
            model = RL_models_considered{i_model};
            eval([participant_groups{1, i_group}, '_', method,...
                '_BIC_diff_means = ',...
                '[', participant_groups{1, i_group}, '_', method,...
                '_BIC_diff_means, ',...
                participant_groups{1, i_group}, '_', method, '_', model,...
                '_BIC_diff_mean];']);
            eval([participant_groups{1, i_group}, '_', method,...
                '_BIC_diff_CIs = ',...
                '[', participant_groups{1, i_group}, '_', method,...
                '_BIC_diff_CIs, ',...
                participant_groups{1, i_group}, '_', method, '_', model,...
                '_BIC_diff_CI];']);
        end
    end
end

data.HC_means_BIC_diff = [HC_DCM_BIC_diff_means', HC_GLM_BIC_diff_means',...
    HC_TTP_BIC_diff_means', HC_BLC_BIC_diff_means'];
data.SP_means_BIC_diff = [SP_DCM_BIC_diff_means', SP_GLM_BIC_diff_means',...
    SP_TTP_BIC_diff_means', SP_BLC_BIC_diff_means'];
data.HC_CIs_BIC_diff = [HC_DCM_BIC_diff_CIs', HC_GLM_BIC_diff_CIs',...
    HC_TTP_BIC_diff_CIs', HC_BLC_BIC_diff_CIs'];
data.SP_CIs_BIC_diff = [SP_DCM_BIC_diff_CIs', SP_GLM_BIC_diff_CIs',...
    SP_TTP_BIC_diff_CIs', SP_BLC_BIC_diff_CIs'];

% For between-subject tests
data.tests.HC_logBF = cell(length(methods_considered)-1,...
    length(RL_models_considered));
data.tests.SP_logBF = cell(length(methods_considered)-1,...
    length(RL_models_considered));

for i_group = 1:length(participant_groups)
    for i_method = 1:length(methods_considered)-1
        for i_model = 1:length(RL_models_considered)
            eval(['data.tests.', participant_groups{1, i_group},...
                '_logBF{i_method, i_model} = ',...
                participant_groups{1, i_group}, '_',...
                methods_considered{i_method}, '_', ...
                RL_models_considered{i_model}, '_BIC_diff;']);
        end
    end
end

end

