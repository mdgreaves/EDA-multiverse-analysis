% Fig 3
% ERI figure

% Add necessary directories to PATH
addpath('../multi_fun/')

study_1_multiverse_path = fullfile('..', 'multi_out', 'study_1', 'none');
study_2_multiverse_path = fullfile('..', 'multi_out', 'study_2', 'none');

% Methods
methods_considered = {'DCM', 'GLM', 'TTP', 'BLC'};

% Dimensions of Z, CI, and p matricies for all combined methods
matrixSize = [26, 1];

%% Study 1
for i = 1:length(methods_considered)
    % For each EDA processing method
    method = methods_considered{i};
    method_NL = [method, '_NL'];
    fullPathToFile = fullfile(study_1_multiverse_path,...
        [method, '_multiverse.mat']);
    eval([method, ' = load(''', fullPathToFile, ''');']);

    % Initialize NaN matrices for each suffix
    assignin('caller', [method '_Z'],  nan(matrixSize));
    assignin('caller', [method '_CI'], nan(matrixSize));
    assignin('caller', [method '_p'],  nan(matrixSize));
    assignin('caller', [method_NL '_Z'],  nan(matrixSize));
    assignin('caller', [method_NL '_CI'], nan(matrixSize));
    assignin('caller', [method_NL '_p'],  nan(matrixSize));

    for j = 1:matrixSize(1)/2
        % For each test of interest conducted
        eval(['t_rho', sprintf(' = %s.t_or_rho_matrix;', method)]);
        eval(['n', sprintf(' = %s.N;', method)]);
        eval(['p', sprintf(' = %s.p_matrix;', method)]);

        % Condition 1: no non-learner exclusion
        Z_output = [method '_Z(j)'];
        CI_output = [method '_CI(j)'];
        p_output = [method '_p(j)'];

        % Dynamically assign the results
        eval([sprintf('[%s, %s] = ', Z_output, CI_output),...
            'multi_fisher(t_rho(j+9,1), n, ''r'');']);

        % Indicate whether p < .05
        eval([sprintf('%s = ', p_output), 'p(j+9,1) < .05;']);

        % Condition 2: non-learner exclusion
        % Update n
        eval(['n', sprintf(' = sum(~%s.NL);', method)]);

        % Update output
        Z_output = [method_NL '_Z(j)'];
        CI_output = [method_NL '_CI(j)'];
        p_output = [method_NL '_p(j)'];

        % Dynamically assign the results
        eval([sprintf('[%s, %s] = ', Z_output, CI_output),...
            'multi_fisher(t_rho(j+9,3), n, ''r'');']);

        % Indicate whether p < .05
        eval([sprintf('%s = ', p_output), 'p(j+9,3) < .05;']);
    end
end

%% Study 2
for i = 1:length(methods_considered)
    % For each EDA processing method
    method = methods_considered{i};
    method_NL = [method, '_NL'];
    fullPathToFile = fullfile(study_2_multiverse_path,...
        [method, '_multiverse.mat']);
    eval([method, ' = load(''', fullPathToFile, ''');']);


    for j = 1:matrixSize(1)/2
        % For each test of interest conducted
        eval(['t_rho', sprintf(' = %s.t_or_rho_matrix;', method)]);
        eval(['n', sprintf(' = %s.N;', method)]);
        eval(['p', sprintf(' = %s.p_matrix;', method)]);

        % Condition 1: no non-learner exclusion
        Z_output = [method '_Z(j+matrixSize(1)/2)'];
        CI_output = [method '_CI(j+matrixSize(1)/2)'];
        p_output = [method '_p(j+matrixSize(1)/2)'];

        % Dynamically assign the results
        eval([sprintf('[%s, %s] = ', Z_output, CI_output),...
            'multi_fisher(t_rho(j+9,1), n, ''t'');']);

        % Indicate whether p < .05
        eval([sprintf('%s = ', p_output), 'p(j+9,1) < .05;']);

        % Condition 2: non-learner exclusion
        % Update n
        eval(['n', sprintf(' = sum(~%s.NL);', method)]);

        % Update output
        Z_output = [method_NL '_Z(j+matrixSize(1)/2)'];
        CI_output = [method_NL '_CI(j+matrixSize(1)/2)'];
        p_output = [method_NL '_p(j+matrixSize(1)/2)'];

        % Dynamically assign the results
        eval([sprintf('[%s, %s] = ', Z_output, CI_output),...
            'multi_fisher(t_rho(j+9,6), n, ''t'');']);

        % Indicate whether p < .05
        eval([sprintf('%s = ', p_output), 'p(j+9,6) < .05;']);
    end
end

%% Making the figure
titles = {'Study 1: Condition 1',...
    'Study 1: Condition 2',...
    'Study 2: Condition 1',...
    'Study 2: Condition 2'};

% Study 1
ERI_effects_Z_1 = [DCM_Z(1:13), GLM_Z(1:13), TTP_Z(1:13), BLC_Z(1:13)];
ERI_effects_CI_1 = [DCM_CI(1:13), GLM_CI(1:13), TTP_CI(1:13),...
    BLC_CI(1:13)];
ERI_effects_p_1 = [DCM_p(1:13), GLM_p(1:13), TTP_p(1:13), BLC_p(1:13)];

% After NL exclusion
ERI_effects_Z_2 = [DCM_NL_Z(1:13), GLM_NL_Z(1:13), TTP_NL_Z(1:13),...
    BLC_NL_Z(1:13)];
ERI_effects_CI_2 = [DCM_NL_CI(1:13), GLM_NL_CI(1:13), TTP_NL_CI(1:13),...
    BLC_NL_CI(1:13)];
ERI_effects_p_2 = [DCM_NL_p(1:13), GLM_NL_p(1:13), TTP_NL_p(1:13),...
    BLC_NL_p(1:13)];

% Categorical
ERI_effects_Z_3 = [DCM_Z(14:26), GLM_Z(14:26), TTP_Z(14:26), BLC_Z(14:26)];
ERI_effects_CI_3 = [DCM_CI(14:26), GLM_CI(14:26), TTP_CI(14:26),...
    BLC_CI(14:26)];
ERI_effects_p_3 = [DCM_p(14:26), GLM_p(14:26), TTP_p(14:26), BLC_p(14:26)];

% After NL exclusion
ERI_effects_Z_4 = [DCM_NL_Z(14:26), GLM_NL_Z(14:26), TTP_NL_Z(14:26),...
    BLC_NL_Z(14:26)];
ERI_effects_CI_4 = [DCM_NL_CI(14:26), GLM_NL_CI(14:26),...
    TTP_NL_CI(14:26), BLC_NL_CI(14:26)];
ERI_effects_p_4 = [DCM_NL_p(14:26), GLM_NL_p(14:26), TTP_NL_p(14:26),...
    BLC_NL_p(14:26)];

% Change ERIs (at the follwoing indicies) to reflect return of fear
flip_sign = [1 2 3 8 10 11];
for i = 1:length(titles)
    eval(['x = ERI_effects_Z_', num2str(i), ';']);
    for j = 1:size(x,2)
        for k = 1:size(flip_sign,2)
            x(flip_sign(k), j) = -x(flip_sign(k), j);
        end
    end
    eval(['ERI_effects_Z_', num2str(i), ' = x;']);
end

X_contrasts = categorical({'1','2','3',...
    '4','5','6',...
    '7','8','9', '10', '11', '12', '13'});
X_contrasts = reordercats(X_contrasts,{'1','2','3',...
    '4','5','6',...
    '7','8','9', '10', '11', '12', '13'});

%% Figure
% Define a buffer value for significance stars
star_buffer = 0.15;

figure('Renderer', 'painters', 'Position', [100 250 1000 700])
tPlot = tiledlayout(length(titles),1, 'TileSpacing', 'tight');

%% Tiles
for i = 1:length(titles)
    nexttile
    %% Bars and error
    % Data
    eval(['model_series = ERI_effects_Z_', num2str(i), ';']);
    eval(['model_error = ERI_effects_CI_', num2str(i) ';']);
    b = bar(model_series, 'grouped');
    set(b, 'EdgeColor', 'none');
    hold on

    % Get the x coordinates of the bars
    [ngroups, nbars] = size(model_series);
    x = nan(nbars, ngroups);
    for j = 1:nbars
        x(j,:) = b(j).XEndPoints;
    end
    % Plot the errorbars
    errorbar(x',model_series, model_error,'k','linestyle','none');

    %% Significance
    % New code to add stars for significant effects
    eval(['significance_flags = ERI_effects_p_', num2str(i), ';']);
    eval(['effect_sizes = ERI_effects_Z_', num2str(i), ';']);
    eval(['effect_cis = ERI_effects_CI_', num2str(i), ';']);

    hold on;
    for j = 1:size(significance_flags, 2)
        for k = 1:size(significance_flags, 1)
            if significance_flags(k, j)
                % Calculate star position with buffer
                starY = effect_sizes(k, j) + (effect_cis(k, j) * (effect_sizes(k, j) >= 0) - effect_cis(k, j) * (effect_sizes(k, j) < 0)) + star_buffer * (effect_sizes(k, j) >= 0) - star_buffer * (effect_sizes(k, j) < 0);
                plot(x(j,k), starY, '*', 'Color', 'black');
            end
        end
    end

    %% Finalise
    % Adjust colour
    b(3).FaceColor = [.2 .6 .5];

    % Add titles and legend
    title(newline)
    text(0.02, 1.02, titles{i}, 'Units', 'normalized',...
        'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
    ax = gca;
    ax.FontSize = 14;
    set(gca, 'XTick', 1:ngroups, 'XTickLabel',X_contrasts)
    ax.YAxis.Limits = [-1.25 1.25];
    xline(1.5:1:ngroups, ':')
    if i == 1
        legend(methods_considered, 'Location','northeastoutside', 'FontSize', 14)
    end
    if i == length(titles)
        xlabel(sprintf('\n Extinction Retention Indices'), 'FontSize', 16);
    end
    hold off;
end
ylabel(tPlot, 'Fisher''s {\it Z}', 'FontSize', 16);

% Remove the directories from the MATLAB path
rmpath('../multi_fun/')