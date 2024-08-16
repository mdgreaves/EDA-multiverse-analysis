function table_1()

% TABLE_1 Generates and displays statistical tests for conditioning 
%   effects.
%
%   TABLE_1()
%
%   This function calculates and displays the results of statistical tests
%   for conditioning effects across two studies using various electrodermal
%   activity (EDA) processing methods and expectancy ratings. The function
%   processes conditioned responses (CR) to conditioned stimuli (CS+ and
%   CS-) for each subject and method, applying both classical paired
%   t-tests and Bayesian t-tests. It also accounts for non-learners and
%   prints the results of these tests along with log Bayes factors.
%        
%   Inputs:
%   - None. The function uses pre-defined paths and settings.
%
%   Outputs:
%   - The function does not return outputs, but it prints the results 
%     of the statistical analyses to the console.

% Add necessary directories to PATH
addpath('../multi_fun/')
addpath('../multi_fun/ext')

% Study 1 and 2
study_multiverse_dirs = {fullfile('..', 'multi_out', 'study_1', 'none'),...
    fullfile('..', 'multi_out', 'study_2', 'none')};
study_model_dirs = {...
    fullfile('..', 'multi_data', 'dim', 'data_structures'),...
    fullfile('..', 'multi_data', 'cat', 'data_structures')};

% Conditions 1 and 2 (non-learner inclusion/exclusion)
conditions = {1, 2};

% EDA processing methods considered
methods_considered = {'DCM', 'GLM', 'TTP', 'BLC'};

% Number of trials per study
hab = {8, 4};
acq = {10, 16};
N = {101, 51};
[CR_CSp, CR_CSm] = deal(cell(2,1));

for i_study = 1:length(study_model_dirs)

    % Initialise matricies
    CR_CSp{i_study} = nan(N{i_study}, 4);
    CR_CSm{i_study} = nan(N{i_study}, 4);

    for i_subject = 1:N{i_study}

        % Load subjects
        model_files = dir(fullfile(study_model_dirs{i_study},...
            '*S1.mat'));
        data = load(fullfile(...
            study_model_dirs{i_study},...
            model_files(i_subject).name));

        CSp_trials_acq = data.Model_data.CS(...
            hab{i_study}+1:hab{i_study}+acq{i_study}, 1);

        for i_method = 1:length(methods_considered)

            % Obtain indicies
            CR_N = length(data.Model_data.CR);
            CSp_trial_index = logical([zeros(hab{i_study}, 1);...
                CSp_trials_acq;...
                zeros(CR_N-(hab{i_study}+acq{i_study}), 1)]);
            CSm_trial_index = logical([zeros(hab{i_study}, 1);...
                ~CSp_trials_acq;...
                zeros(CR_N-(hab{i_study}+acq{i_study}), 1)]);

            % Fill matricies
            CR_CSp{i_study}(i_subject, i_method) = mean(...
                data.Model_data.CR(CSp_trial_index, i_method),...
                'omitnan');
            CR_CSm{i_study}(i_subject, i_method) = mean(...
                data.Model_data.CR(CSm_trial_index, i_method),...
                'omitnan');
        end
    end
end

for i_study = 1:length(study_model_dirs)

    for i_method = 1:length(methods_considered)
    
    % Load multiverse
    multiverse = load(fullfile(study_multiverse_dirs{i_study},...
        sprintf('%s_multiverse.mat',...
        methods_considered{i_method})));

    for i_condition = 1:length(conditions)

        % Apply NL removal if necessary
        data1 = CR_CSp{i_study}(:, i_method);
        data2 = CR_CSm{i_study}(:, i_method);
        if conditions{i_condition} == 2
            data1 = data1(~multiverse.NL);
            data2 = data2(~multiverse.NL);
        end

        % Tests
        disp(['Study: ', num2str(i_study)]);
        disp(['Method: ', methods_considered{i_method}]);
        disp(['Condition: ', num2str(conditions{i_condition})]);
        disp(['N: ', num2str(N{i_study})])
        if conditions{i_condition} == 2
            disp(['N after NL exclusion: ', num2str(sum(~multiverse.NL))])
        end
        if i_study == 2
            healthy_controls = ~multiverse.NL + ~multiverse.SP;
            healthy_controls = healthy_controls == 2;
            disp(['Healthy controls after NL exclusion: ',...
                num2str(sum(healthy_controls))])
        end
        [~, pValue] = multi_ttest(data1, data2);
        if pValue < .001
            disp('p < .001 ***')
        elseif pValue < .01
            disp('p < .01 **')
        elseif pValue < .05
            disp('p < .05 *')
        end
        [bf, ~] = bf_ttest(data1, data2);
        disp(['logBF: ',...
                num2str(log(bf))])
        disp(newline);
    end
    end
end

% Print the expectancy results
multi_expect()

% Remove the directories from the MATLAB path
rmpath('../multi_fun/')
rmpath('../multi_fun/ext')


end


