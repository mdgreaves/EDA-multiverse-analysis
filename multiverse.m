function multiverse(model_files_path, study, hab, acq, reference_scores,...
    fit_RL_models, transformation_flag)
% MULTIVERSE Performs a multiverse analysis of experimental data using
%   various statistical methods and reinforcement learning models.
%
%   MULTIVERSE(model_files_path, study, hab, acq, clinical_norms,...
%       fit_RL_models, transformation_flag)
%
%   This function conducts a multiverse analysis on a set of data files. It 
%   iterates over different statistical methods and reinforcement learning 
%   (RL) models to compute various statistical indices and Extinction 
%   Retention Indices (ERIs). The function is designed to accommodate two 
%   different study designs (dimensional, "dim", and categorical, "cat") 
%   and allows for the inclusion of clinical norms and optional data 
%   transformations.
%
%   Inputs:
%   - model_files_path: Path to the directory containing the model data 
%                       files for Session 1 and Session 2.
%   - study: A string specifying the study design. It can be either "dim" 
%            for dimensional analysis or "cat" for categorical analysis.
%   - hab: Number of trials in the habituation phase to exclude from the 
%          analysis.
%   - acq: Number of trials in the acquisition phase.
%   - reference_scores: A structure containing including median score on 
%                       the anxiety scale of the Depression Anxiety and 
%                       Stress Scale (DASS) and median trait anxiety score 
%                       on the State-Trait Anxiety Inventory (STAI).
%   - fit_RL_models: A boolean flag (true/false) indicating whether to fit 
%                    RL models to the data.
%   - transformation_flag: A string specifying whether to apply a 
%                          transformation to the data. Options include 
%                          "none" (no transformation) or "log" (log 
%                          transformation).
%
%   Outputs:
%   - The function does not return outputs directly. Instead, it saves the 
%     results of the multiverse analysis to .mat files in the current 
%     directory. The files include:
%       - p_matrix: A matrix of p-values from statistical tests.
%       - t_or_rho_matrix: A matrix of test statistics (t-values or 
%                          correlation coefficients).
%       - all_stats_matrix: A cell array containing detailed statistics 
%                           for each test.
%       - Clinical and non-learner (NL) information depending on the study 
%         design.
%       - Optional RL model results, including statistics for the 
%         Rescorla-Wagner (RW) model, the Pearce-Hall (PH) model, the 
%         Latent Cause (LC) model, and the Latent State (LS) model.
%
%   Procedure:
%   1. Loads the Session 1 and Session 2 model data files for each subject.
%   2. Corrects for infinite values in the data and optionally replaces NaN 
%      values with zeros (if fitting RL models).
%   3. Updates clinical and non-learner information based on the study 
%      design.
%   4. Fits RL models to the data if specified.
%   5. Applies the specified data transformation (e.g., log 
%      transformation).
%   6. Computes ERIs and trial means for each phase (acquisition, 
%      extinction, retention).
%   7. Runs statistical tests across different modifiers (e.g., DASS, 
%      STAI scores).
%   8. Saves the results of the analysis and RL model fits to .mat files.
%
%   Notes:
%   - The function handles different study designs ("dim" and "cat") and 
%     adjusts the analysis accordingly.
%   - The method considers multiple statistical approaches, including
%     the dynamic causal model (DCM), general linear model (GLM),
%     trough-to-peak (TTP), and baseline-corrected (BLC) methods.

S1_model_files = dir(fullfile(model_files_path, '*S1.mat'));
S2_model_files = dir(fullfile(model_files_path, '*S2.mat'));
N = length(S1_model_files);

% Clinical information
DASS_score = nan(N,1);
DASS_high = nan(N,1);
switch study
    case "cat"
        SP = nan(N,1);
        STAI_score = nan(N,1);
        STAI_high = nan(N,1);
end

% Methods considered
methods_considered = {'DCM', 'GLM', 'TTP', 'BLC'};
for i_method = 1:length(methods_considered)

    % Initalise useful matrices and cell arrays
    [p_matrix, t_or_rho_matrix, all_stats_matrix, ACQ_CSp_all,...
        ACQ_CSm_all, ACQ_CSd_all, EXT_CSp_all, EXT_CSm_all,...
        EXT_CSd_all, RET_CSp_all, RET_CSm_all, RET_CSd_all, A, B,...
        C, D, E, F, G, H, I, J, K, L, M, RW_all_stats_matrix,...
        PH_all_stats_matrix, LCM_all_stats_matrix,...
        LS_all_stats_matrix] = multi_init(N, study);

    if fit_RL_models == false
        clear RW_* PH_* LCM_* LS_*
    end

    % Non-learner information depends on the method
    NL = nan(N,1);

    for i_sub = 1:N
        S1 = load(fullfile(model_files_path,...
            S1_model_files(i_sub).name), 'Model_data');
        S2 = load(fullfile(model_files_path,...
            S2_model_files(i_sub).name), 'Model_data');

        % Split file names to get parts
        S1_file_parts = split(S1_model_files(i_sub).name, '_');
        S2_file_parts = split(S2_model_files(i_sub).name, '_');

        % Check if the relevant parts are the same
        if ~strcmp(S1_file_parts{end-1}, S2_file_parts{end-1})
            % The parts are different
            error(['Mismatch in subject identifiers between Session 1'...
                ' and Session 2 files.']);
        end

        % Ensure there are no Inf values
        correctedVariables = multi_inf(S1.Model_data.CR,...
            S2.Model_data.CR);
        [S1.Model_data.CR, S2.Model_data.CR] = deal(correctedVariables{:});

        % Update clinical and non-learner information
        DASS_score(i_sub,1) = S1.Model_data.DASS;
        DASS_high(i_sub,1) = DASS_score(i_sub,1) >= reference_scores.DASS;
        NL(i_sub,1) = S1.Model_data.NL(i_method);
        switch study
            case "cat"
                SP(i_sub,1) = S1.Model_data.SP;
                STAI_score(i_sub,1) = S1.Model_data.STAI;
                STAI_high(i_sub,1) = STAI_score(i_sub,1) >=...
                    reference_scores.STAI;
        end

        if fit_RL_models == true
            % Model data structures for RL
            % Remove habituation phase and zscore CRs
            data.US = S1.Model_data.US(hab+1:end,:);
            data.CS = S1.Model_data.CS(hab+1:end,:);

            % Ensure there are no NaN vales for the model fitting
            correctedVariables = multi_nan(...
                S1.Model_data.CR(hab+1:end,i_method));
            data.CR = zscore(correctedVariables{1});

            % Fit RL models
            output = multi_rl(data, S1_file_parts{end-1}, false);
            % RW model
            RW_all_stats_matrix{i_sub} = output.results_1;
            % PH model
            PH_all_stats_matrix{i_sub} = output.results_2;
            % LCM model
            LCM_all_stats_matrix{i_sub} = output.results_3;
            % LS model
            LS_all_stats_matrix{i_sub} = output.results_4;
        end

        % Transform data if requested
        switch transformation_flag
            case "none"
                % Do nothing
            case "log"
                S1.Model_data.CR = log(1e2 + S1.Model_data.CR);
        end

        % Create vectors for each phase
        Acquisition = [S1.Model_data.CR(hab+1:hab+acq,i_method),...
            S1.Model_data.CS(hab+1:hab+acq,:)];
        Acquisition_diff_resp =...
            (Acquisition(logical(Acquisition(:,2)),1))-(Acquisition(...
            logical(Acquisition(:,3)),1));
        Extinction = [S1.Model_data.CR(hab+acq+1:end,i_method),...
            S1.Model_data.CS(hab+acq+1:end,:)];
        Extinction_diff_resp =...
            (Extinction(logical(Extinction(:,2)),1))-(Extinction(...
            logical(Extinction(:,3)),1));
        Retention = [S2.Model_data.CR(1:end,i_method),...
            S2.Model_data.CS(1:end,:)];
        Retention_diff_resp = (Retention(logical(...
            Retention(:,2)),1))-(Retention(logical(Retention(:,3)),1));

        % Calculate ERIs
        [A(i_sub), B(i_sub), C(i_sub), D(i_sub), E(i_sub), F(i_sub),...
            G(i_sub), H(i_sub), I(i_sub), J(i_sub), K(i_sub), L(i_sub),...
            M(i_sub)] = multi_eri(Acquisition, Acquisition_diff_resp,...
            Extinction, Retention);

        % Obtain means for stimulus/phase
        [ACQ_CSp_all(i_sub), ACQ_CSm_all(i_sub), ACQ_CSd_all(i_sub),...
            EXT_CSp_all(i_sub), EXT_CSm_all(i_sub),...
            EXT_CSd_all(i_sub), RET_CSp_all(i_sub),...
            RET_CSm_all(i_sub), RET_CSd_all(i_sub)] =...
            multi_means(Acquisition, Extinction,...
            Retention, Acquisition_diff_resp,...
            Extinction_diff_resp, Retention_diff_resp);
    end

    % Run statistics

    % Study 1
    % Statistics [3 CS contrasts x 3 phases + 13
    % Extinction Retention indices (ERIs)] x 2 different
    % helathy-anxious permuations [i.e., high-low state axiety;
    % and dimensional state axiety]); and matricies for RL model
    % output. Additional NL consideration.
    modifiers = {DASS_score, logical(DASS_high), [~NL, DASS_score],...
        ((logical(DASS_high)+1).* ~NL)};
    switch study
        case "cat"
            % Study 2
            % Statistics [3 CS contrasts x 3 phases + 13 Extinction
            % Retention indices (ERIs)] x 5 different helathy-anxious
            % permuations [i.e., clinical-healthy; high-low state axiety;
            % high-low trait axiety; dimension state axiety; and dimension
            % trait axiety]). Additional NL consideration.
            modifiers = {logical(SP), logical(DASS_high),...
                logical(STAI_high), DASS_score, STAI_score,...
                ((logical(SP)+1).* ~NL), ((logical(DASS_high)+1).* ~NL),...
                ((logical(STAI_high)+1).* ~NL),...
                [~NL, DASS_score], [~NL, STAI_score]};
    end

    % Ensure there are no Inf values
    correctedVariables = multi_inf(ACQ_CSm_all, ACQ_CSd_all,...
        EXT_CSp_all, EXT_CSm_all, EXT_CSd_all, RET_CSp_all, RET_CSm_all,...
        RET_CSd_all, A, B, C, D, E, F, G, H, I, J, K, L, M);
    [ACQ_CSm_all, ACQ_CSd_all, EXT_CSp_all, EXT_CSm_all,...
        EXT_CSd_all, RET_CSp_all, RET_CSm_all, RET_CSd_all, A, B, C,...
        D, E, F, G, H, I, J, K, L, M] = deal(correctedVariables{:});

    for i_modify = 1:length(modifiers)
        [p_matrix(:, i_modify), t_or_rho_matrix(:, i_modify),...
            all_stats_matrix(:, i_modify)] =...
            multi_stats(ACQ_CSp_all,...
            ACQ_CSm_all, ACQ_CSd_all, EXT_CSp_all, EXT_CSm_all,...
            EXT_CSd_all, RET_CSp_all, RET_CSm_all, RET_CSd_all, A, B,...
            C, D, E, F, G, H, I, J, K, L, M, modifiers{i_modify});
    end

    % Save files
    switch study
        case "dim"
            save(sprintf('%s_multiverse', methods_considered{i_method}),...
                'p_matrix', 't_or_rho_matrix', 'all_stats_matrix',...
                'N', 'NL', 'DASS_score', 'DASS_high');
        case "cat"
            save(sprintf('%s_multiverse', methods_considered{i_method}),...
                'p_matrix', 't_or_rho_matrix', 'all_stats_matrix',...
                'N', 'NL', 'SP', 'DASS_score', 'DASS_high',...
                'STAI_score', 'STAI_high');
    end

    if fit_RL_models == true
        save(sprintf('%s_RL_models', methods_considered{i_method}),...
            'RW_all_stats_matrix', 'PH_all_stats_matrix',...
            'LCM_all_stats_matrix', "LS_all_stats_matrix")
    end

end
end
