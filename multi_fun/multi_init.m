function [p_matrix, t_or_rho_matrix, all_stats_matrix, ACQ_CSp_all,...
    ACQ_CSm_all, ACQ_CSd_all, EXT_CSp_all, EXT_CSm_all, EXT_CSd_all,...
    RET_CSp_all, RET_CSm_all, RET_CSd_all, A, B, C, D, E, F, G, H, I, J,...
    K, L, M, RW_all_stats_matrix, PH_all_stats_matrix,...
    LCM_all_stats_matrix, LS_all_stats_matrix] = multi_init(N,...
    study)

% MULTI_INIT Initializes matrices and variables for statistical analysis.
%
%   This function initializes various matrices, vectors, and cell arrays
%   required for statistical analysis based on the study type specified. It
%   sets up the structures to hold p-values, test statistics, mean
%   responses across different phases (acquisition, extinction, retention),
%   extinction retention indices (ERIs), and Reinforcement Learning (RL)
%   model outputs.
%
%   Inputs:
%   - N: Number of subjects (or observations) to be used for initializing 
%        the vectors and matrices.
%   - study: String specifying the study type. It must be either "dim" or 
%            "cat".
%            - "dim": Initializes matrices for a study involving
%                     dimensional analysis with 22 variables and 4 
%                     different permutations of healthy-anxious states.
%            - "cat": Initializes matrices for a study involving
%                     categorical analysis with 22 variables and 5 
%                     different permutations of healthy-anxious states.
%
%   Outputs:
%   - p_matrix: Matrix for storing p-values from statistical tests.
%   - t_or_rho_matrix: Matrix for storing t-statistics or correlation 
%                      coefficients.
%   - all_stats_matrix: Cell array for storing detailed statistical output.
%   - ACQ_CSp_all, ACQ_CSm_all, ACQ_CSd_all: Vectors for storing 
%                                            acquisition phase responses.
%   - EXT_CSp_all, EXT_CSm_all, EXT_CSd_all: Vectors for storing extinction 
%                                            phase responses.
%   - RET_CSp_all, RET_CSm_all, RET_CSd_all: Vectors for storing retention 
%                                            phase responses.
%   - A, B, C, ..., M: Vectors for storing extinction retention indices 
%                      (ERIs).
%   - RW_all_stats_matrix, PH_all_stats_matrix, LCM_all_stats_matrix, 
%     LS_all_stats_matrix: Cell arrays for storing RL model output for 
%                          different model types.

    switch study
        case "dim"
        % Study 1
        
        % Initialise 22 x 2 matricies ([3 CS contrasts x 3 phases + 13
        % Extinction Retention indices (ERIs)] x 2 different 
        % helathy-anxious permuations [i.e., high-low state axiety; 
        % and dimensional state axiety]); and matricies for RL model
        % output.
        

        p_matrix = nan(22,4);           % for p values
        t_or_rho_matrix = nan(22,4);    % for t and rho values
        
        % Initialise 22 x 2  cell array for all statistical output of tests
        all_stats_matrix = cell(22,4);
              
        % Initialise vectors for individual aquisition mean responses
        ACQ_CSp_all = nan(N,1);
        ACQ_CSm_all = nan(N,1);
        ACQ_CSd_all = nan(N,1);
        
        % Initialise vectors for individual extinction mean responses
        EXT_CSp_all = nan(N,1);
        EXT_CSm_all = nan(N,1);
        EXT_CSd_all = nan(N,1);
        
        % Initialise vectors for individual retention mean responses
        RET_CSp_all = nan(N,1);
        RET_CSm_all = nan(N,1);
        RET_CSd_all = nan(N,1);
        
        % Initialise 13 vectors for ERIs
        [A, B, C, D, E, F, G, H, I, J, K, L, M] = deal(nan(N,1));
        
        % Initialise 4 x N x 1  cell array for all statistical RL model 
        % output
        RW_all_stats_matrix = cell(N,1);
        PH_all_stats_matrix = cell(N,1);
        LCM_all_stats_matrix = cell(N,1);
        LS_all_stats_matrix = cell(N,1);
            
        case "cat"
        % Study 2
        
        % Initialise 22 x 5 matricies ([3 CS contrasts x 3 phases + 13
        % Extinction Retention indices (ERIs)] x 5 different 
        % helathy-anxious permuations [i.e., clinical-healthy; high-low 
        % state axiety; high-low trait axiety; dimension state axiety; and 
        % dimension trait axiety]); and matricies for RL model output.
        
        p_matrix = nan(22,10);           % for p values
        t_or_rho_matrix = nan(22,10);    % for t and rho values
        
        % Initialise 26 x 5  cell array for all statistical output of tests
        all_stats_matrix = cell(22,10);
        
        % Initialise vectors for individual aquisition mean responses
        ACQ_CSp_all = nan(N,1);
        ACQ_CSm_all = nan(N,1);
        ACQ_CSd_all = nan(N,1);
        
        % Initialise vectors for individual extinction mean responses
        EXT_CSp_all = nan(N,1);
        EXT_CSm_all = nan(N,1);
        EXT_CSd_all = nan(N,1);
        
        % Initialise vectors for individual retention mean responses
        RET_CSp_all = nan(N,1);
        RET_CSm_all = nan(N,1);
        RET_CSd_all = nan(N,1);
                
        % Initialise 13 vectors for ERIs
        [A, B, C, D, E, F, G, H, I, J, K, L, M] = deal(nan(N,1));
              
        % Initialise 4 x N x 1  cell array for all statistical RL model 
        % output
        RW_all_stats_matrix = cell(N,1);
        PH_all_stats_matrix = cell(N,1);
        LCM_all_stats_matrix = cell(N,1);
        LS_all_stats_matrix = cell(N,1);
        otherwise
            error('Invalid study type. Choose "dim" or "cat".');
    end
end
