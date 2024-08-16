% Fig 4
% RL figure

% Add necessary directories to PATH
addpath('../multi_fun/')
addpath('../multi_fun/ext/superbar/')


S1_multiverse_path = fullfile('..', 'multi_out', 'study_1', 'none');
S2_multiverse_path = fullfile('..', 'multi_out', 'study_2', 'none');
EXP_workspace_path = fullfile('..', 'multi_data', 'dim', 'exp_results.mat');
S1_model_path = fullfile('..', 'multi_data', 'dim', 'data_structures');
S2_model_path = fullfile('..', 'multi_data', 'cat', 'data_structures');


% Obtain data for plots
data = multi_plot(S1_multiverse_path,...
    S2_multiverse_path,...
    S1_model_path,...
    S2_model_path,...
    EXP_workspace_path);

%% Figure
titles = {'Study 1: Fitted Reinforcement Learning Models',...
    'Study 2: Model-based Versus Model-free Learning'};

figure('Renderer', 'painters', 'Position', [100 250 1000 700])
tPlot = tiledlayout(1, length(titles), 'TileSpacing', 'loose');

buffer = 0.5;
methods_considered = {'DCM', 'GLM', 'TTP', 'BLC', 'EXP'};
X_models = categorical({'RW','PH','LC','LS'});
X_models = reordercats(X_models,{'RW','PH','LC','LS'});
X_models_2 = categorical({'LC_{Healthy}','LC_{Spider phobic}',...
    'LS_{Healthy}','LS_{Spider phobic}'});

%% Comparison between HC and SP
nexttile

% Data
model_series = [data.HC_means_BIC_diff(1,:);...
    data.SP_means_BIC_diff(1,:);...
    data.HC_means_BIC_diff(2,:);...
    data.SP_means_BIC_diff(2,:)];
model_series = -0.5*model_series;
model_error = [data.HC_CIs_BIC_diff(1,:);...
    data.SP_CIs_BIC_diff(1,:);...
    data.HC_CIs_BIC_diff(2,:);...
    data.SP_CIs_BIC_diff(2,:)];

% Superbar with pair-wise comparison p values
face_colours = [0, 0.4470, 0.7410;...
    0.8500, 0.3250, 0.0980;...
    0.2000, 0.6000, 0.5000;...
    0.4940, 0.1840, 0.5560;...
    0.3000, 0.7000, 0.9000];

C = nan(4, 4, 3);
C(1, 1, :) = face_colours(1,:);
C(1, 2, :) = face_colours(2,:);
C(1, 3, :) = face_colours(3,:);
C(1, 4, :) = face_colours(4,:);
C(2, 1, :) = face_colours(1,:);
C(2, 2, :) = face_colours(2,:);
C(2, 3, :) = face_colours(3,:);
C(2, 4, :) = face_colours(4,:);
C(3, 1, :) = face_colours(1,:);
C(3, 2, :) = face_colours(2,:);
C(3, 3, :) = face_colours(3,:);
C(3, 4, :) = face_colours(4,:);
C(4, 1, :) = face_colours(1,:);
C(4, 2, :) = face_colours(2,:);
C(4, 3, :) = face_colours(3,:);
C(4, 4, :) = face_colours(4,:);

P = nan(numel(model_series), numel(model_series));
P(3,4) = 0.001;
PT = P';
lidx = tril(true(size(P)), -1);
P(lidx) = PT(lidx);
h = superbar(model_series, 'E', model_error, 'P', P, 'BarFaceColor', C,...
    'ErrorbarColor', 'k', 'ErrorbarLineWidth', 1, 'PLineWidth', 1);

% Decorate and add titles
text(0.02, 1.02, titles{2}, 'Units', 'normalized',...
    'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
ax = gca;
ax.FontSize = 14;
set(gca, 'XTick',1:4, 'XTickLabel', X_models_2)
xline([1.5, 3.5], ':')
xline(2.5, '-')
ylim([-8, 8])
ylabel(sprintf('Mean log-Bayes factors\n'), 'FontSize', 16,...
    'Interpreter', 'tex');
legend(h(1,1:4),methods_considered(1:end-1),...
    'Location', 'best', 'FontSize', 14)
hold off;

%% Comparison between Models
nexttile

% Data
model_series = -data.means_lnL;
model_error = data.CIs_lnL;

C = nan(5, 4, 3);
C(1, 1, :) = face_colours(1,:);
C(1, 2, :) = face_colours(2,:);
C(1, 3, :) = face_colours(3,:);
C(1, 4, :) = face_colours(4,:);
C(1, 5, :) = face_colours(5,:);
C(2, 1, :) = face_colours(1,:);
C(2, 2, :) = face_colours(2,:);
C(2, 3, :) = face_colours(3,:);
C(2, 4, :) = face_colours(4,:);
C(2, 5, :) = face_colours(5,:);
C(3, 1, :) = face_colours(1,:);
C(3, 2, :) = face_colours(2,:);
C(3, 3, :) = face_colours(3,:);
C(3, 4, :) = face_colours(4,:);
C(3, 5, :) = face_colours(5,:);
C(4, 1, :) = face_colours(1,:);
C(4, 2, :) = face_colours(2,:);
C(4, 3, :) = face_colours(3,:);
C(4, 4, :) = face_colours(4,:);
C(4, 5, :) = face_colours(5,:);
C(5, 1, :) = face_colours(1,:);
C(5, 2, :) = face_colours(2,:);
C(5, 3, :) = face_colours(3,:);
C(5, 4, :) = face_colours(4,:);
C(5, 5, :) = face_colours(5,:);

P = nan(numel(model_series), numel(model_series));
% First Model
P(1,17) = 0.001;
P(5,17) = 0.001;
P(9,17) = 0.001;
P(13,17) = 0.001;

% Second Model
P(2,18) = 0.001;
P(6,18) = 0.001;
P(10,18) = 0.001;
P(14,18) = 0.001;

% Third Model
P(3,19) = 0.001;
P(7,19) = 0.001;
P(11,19) = 0.001;
P(15,19) = 0.001;

PT = P';
lidx = tril(true(size(P)), -1);
P(lidx) = PT(lidx);
h = superbar(model_series, 'E', model_error, 'P', P, 'BarFaceColor', C,...
    'ErrorbarColor', 'k', 'ErrorbarLineWidth', 1, 'PLineWidth', 1,...
    'PLineOffset', 1.5);

% Decorate and add titles
text(0.02, 1.02, titles{1}, 'Units', 'normalized',...
    'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
ax = gca;
ax.FontSize = 14;
set(gca, 'XTick',1:4, 'XTickLabel', X_models)
ax.YAxis.Limits = [30, 50];
xline(1.5:1:3.5, ':')
ylabel(sprintf('Mean negative log-likelihood\n'), 'FontSize', 16);
legend(h(1,1:5),methods_considered,...
    'Location', 'northeast', 'FontSize', 14)
xlabel(sprintf('\n Models'), 'FontSize', 16);
hold off;

% Remove the directories from the MATLAB path
rmpath('../multi_fun/')
rmpath('../multi_fun/ext/superbar/')
