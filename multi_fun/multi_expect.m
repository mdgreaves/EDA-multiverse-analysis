function multi_expect()

% MULTI_EXPECT Extracts and processes expectancy data from studies for 
%   analysis.
%
%   MULTI_EXPECT()
%
%   This function performs the extraction and analysis of expectancy data 
%   for two studies ("dim" and "cat"). It loads the relevant model and 
%   expectancy data files, calculates learned responses for conditioned 
%   stimuli (CS+ and CS-) across subjects, and performs statistical tests 
%   on the processed data.
%
%   Procedure:
%   1. Define paths for the expectancy data and model data for both 
%      studies.
%   2. Loop through all subjects in Study 1 to find and match model and 
%      expectancy data files.
%   3. For each matched file, calculate the mean CR for CS+ and CS- during 
%      the acquisition phase.
%   4. Perform statistical tests (paired t-test and Bayesian t-test) on the 
%      processed CR data, both for all subjects and after applying 
%      exclusion criteria.
%   5. Display the results of the statistical tests, including p-values and
%      log Bayes factors.
%   6. Process Study 2 data by calling the `multi_extract` function.
%
%   Inputs:
%   - None. The function uses pre-defined paths and settings.
%
%   Outputs:
%   - The function does not return outputs, but it displays the results 
%     of statistical analyses in the console.

% Study 1 and 2 expectancy paths
study_1_EXP_path = fullfile('..', 'multi_data', 'dim', 'expectancy');
study_2_EXP_path = fullfile('..', 'multi_data', 'cat', 'expectancy');

% Study 1 and 2 model paths
study_1_model_path = fullfile('..', 'multi_data', 'dim', 'data_structures');
study_2_model_path = fullfile('..', 'multi_data', 'cat', 'data_structures');

% Number of trials per study
hab = 8;
acq = 10;
N = 101;
valid_files = false(N,1);
NL = false(N,1);
[CR_CSp, CR_CSm] = deal(NaN(N,1));

for i_subject = 1:N

    % Find subjects' model and EXP files
    model_files = dir(fullfile(study_1_model_path,...
        '*S1.mat'));
    EXP_files = dir(fullfile(study_1_EXP_path,...
        '*S1_EX.mat'));
    model_file_name = model_files(i_subject).name;
    file_name_pattern = extractBetween(model_file_name, 'model_',...
        '_S1.mat');

    % Loop through each file and check for the pattern
    for i = 1:length(EXP_files)
        current_file_name = EXP_files(i).name;
        if contains(current_file_name, file_name_pattern)
            valid_files(i_subject) = true;
            EXP_file_name = current_file_name;
            break; % Exit loop if pattern is found
        end
    end

    if ~exist(fullfile(study_1_EXP_path, EXP_file_name), 'file') == 2
        break;
    else
        % Load subjects' model and EXP files
        data = load(fullfile(...
            study_1_model_path,...
            model_file_name));
        EX_data = load(fullfile(...
            study_1_EXP_path,...
            EXP_file_name));

        % Update model structure
        data.Model_data.CR = EX_data.EX;

        acq_CSp_indx = data.Model_data.CS(hab+1:hab+acq,1) == 1;
        acq_EX = data.Model_data.CR(hab+1:hab+acq,1);
        CSp = mean(acq_EX(acq_CSp_indx), 'omitnan');
        CSm = mean(acq_EX(~acq_CSp_indx), 'omitnan');
        CR_CSp(i_subject) = CSp;
        CR_CSm(i_subject) = CSm;
        if CSp <= CSm
            NL(i_subject) = true;
        end
    end
end

% Condition 1
% Tests
disp('Study: 1')
disp('Method: EXP')
disp('Condition: 1')
disp(['N: ', num2str(sum(valid_files))])
CSp_indx = (~isnan(CR_CSp) + valid_files) == 2;
CSm_indx = (~isnan(CR_CSm) + valid_files) == 2;
[~, pValue] = multi_ttest(CR_CSp(CSp_indx), CR_CSm(CSm_indx));
        if pValue < .001
            disp('p < .001 ***')
        elseif pValue < .01
            disp('p < .01 **')
        elseif pValue < .05
            disp('p < .05 *')
        end
[bf, ~] = bf_ttest(CR_CSp(CSp_indx), CR_CSm(CSm_indx));
disp(['lnBF: ', num2str(log(bf))])
disp(newline);

% Condition 2
disp('Study: 1')
disp('Method: EXP')
disp('Condition: 2')
disp(['N: ', num2str(sum(valid_files))])
New_N = (valid_files + ~NL) == 2;
disp(['N after NL exclusion: ', num2str(sum(New_N))])
CSp_indx = (~isnan(CR_CSp) + valid_files + ~NL) == 3;
CSm_indx = (~isnan(CR_CSm) + valid_files + ~NL) == 3;
[~, pValue] = multi_ttest(CR_CSp(CSp_indx), CR_CSm(CSm_indx));
        if pValue < .001
            disp('p < .001 ***')
        elseif pValue < .01
            disp('p < .01 **')
        elseif pValue < .05
            disp('p < .05 *')
        end
[bf, ~] = bf_ttest(CR_CSp(CSp_indx), CR_CSm(CSm_indx));
disp(['lnBF: ', num2str(log(bf))])
disp(newline);

% Study 2
multi_extract(fullfile(study_2_EXP_path,...
    'EX.xlsx'), study_2_model_path);

end


