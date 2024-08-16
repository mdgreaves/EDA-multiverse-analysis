function multiverse_run(study_selector, fit_RL_models, transformation)
% MULTIVERSE_RUN Executes the electrodermal activity multiverse analysis 
% with specified parameters as described in Greaves et al. (2024), DOI: 
% https://doi.org/10.1016/j.brat.2024.104598
%
%   MULTIVERSE_RUN(study_selector, fit_RL_models, transformation)
%
%   This function runs the multiverse analysis for a specified study (or
%   dataset), using reinforcement learning models and data transformations
%   as configured by the input parameters. The function also organizes the
%   output files into appropriate directories based on the analysis
%   settings.
%
%   Inputs:
%   - study_selector: An integer (1 or 2) to select the study:
%       1 -> 'dim': predominantly dimensional analyses with the healthy 
%                   controls (Ney et al., 2021; Schenker et al., 2022).
%       2 -> 'cat': predominantly categorical analyses with the healthy
%                   controls and individuals with specific phobia (Li & 
%                   Graham, 2016). 
%   - fit_RL_models: A boolean flag (true/false) indicating whether to fit 
%                    reinforcement learning models as part of the analysis.
%   - transformation: A string specifying the data transformation to apply:
%       'none' -> No transformation
%       'log'  -> Apply a logarithmic transformation
%
%   Outputs:
%   - The function does not return any outputs. It runs the multiverse 
%     analysis and saves the results to files, which are then moved to a 
%     designated output directory.
%
%   Example:
%   multiverse_run(1, false, "none");
%
%   Notes:
%   - The function performs error checking on the input arguments to ensure 
%     they are within the expected ranges.
%   - Output files are moved to a directory organized by study and 
%     transformation type.

    % Error trapping for input arguments
    if ~ismember(study_selector, [1, 2])
        error('study_selector must be 1 or 2.');
    end
    
    if ~islogical(fit_RL_models)
        error('fit_RL_models must be true or false.');
    end
    
    if ~ismember(transformation, {'none', 'log'})
        error('transformation must be "none" or "log".');
    end

    % Add necessary directories to PATH
    addpath('./multi_fun/')
    addpath('./multi_fun/ext/bads-master/')
    addpath('./multi_fun/ext/models/')

    studies = {"dim", "cat"};
    study = studies{study_selector};

    % Run multiverse
    data_files_path = fullfile('.', 'multi_data', study, 'data_structures');

    switch study
        case "cat"
            hab = 4;    % Number of habituation trials
            acq = 16;   % Number of acquisition trials
            load(fullfile('.', 'multi_data', study, 'demog.mat'), 'HC_SP');
            HC_SP = table2cell(HC_SP);
            reference_scores.DASS = median(log(1+cell2mat(HC_SP(:,4)))); 
            reference_scores.STAI = median(log(1+cell2mat(HC_SP(:,5))));
        case "dim"
            hab = 8;    % Number of habituation trials
            acq = 10;   % Number of acquisition trials
            load(fullfile('.', 'multi_data', study, 'demog.mat'), 'HC');
            reference_scores.DASS = median(log(1+HC(:,2)));
    end

    multiverse(data_files_path, study, hab, acq, reference_scores,...
        fit_RL_models, transformation);

    % Define the output directory
    output_dir = fullfile('multi_out', sprintf('study_%s',...
        num2str(study_selector)), transformation);

    % Create the output directory if it doesn't exist
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Get a list of all files matching the patterns
    multiverse_files = dir('*multiverse.mat');
    models_files = dir('*models.mat');

    % Concatenate the two lists of files
    all_files = [multiverse_files; models_files];

    % Move each file to the output directory
    for i = 1:length(all_files)
        % Construct the source and destination file paths
        src = fullfile(all_files(i).folder, all_files(i).name);
        dest = fullfile(output_dir, all_files(i).name);
        
        % Move the file
        movefile(src, dest);
    end

    % Remove the directories from the MATLAB path
    rmpath('./multi_fun/')
    rmpath('./multi_fun/ext/bads-master/')
    rmpath('./multi_fun/ext/models/')
end
