% Initialise matricies for multiverse (Study 1 or 2)

switch study
    case "dim"
        % Study 1
        
        % Initialise 22 x 2 matricies ([3 CS contrasts x 3 phases + 13
        % Extinction Retention indices (ERIs)] x 2 different 
        % helathy-anxious permuations [i.e., high-low state axiety; 
        % and dimensional state axiety]); and matricies for RL model
        % output.
        

        p_matrix = nan(22,2);           % for p values
        t_or_rho_matrix = nan(22,2);    % for t and rho values
        
        % Initialise 22 x 2  cell array for all statistical output of tests
        all_stats_matrix = cell(22,2);
              
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
        
        % Initialise 4 x N x 1  cell array for all statistical RL model output
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
        % dimension trai axiety]); and matricies for RL model output.
        
        p_matrix = nan(22,5);           % for p values
        t_or_rho_matrix = nan(22,5);    % for t and rho values
        
        % Initialise 26 x 5  cell array for all statistical output of tests
        all_stats_matrix = cell(22,5);
        
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
              
        % Initialise 4 x N x 1  cell array for all statistical RL model output
        RW_all_stats_matrix = cell(N,1);
        PH_all_stats_matrix = cell(N,1);
        LCM_all_stats_matrix = cell(N,1);
        LS_all_stats_matrix = cell(N,1);
        
end