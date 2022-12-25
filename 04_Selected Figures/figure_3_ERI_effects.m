%% Figure 3: ERI effects

% Ensure that the "../00_Functions" directory has been added to the path.

% Initialise matricies for Fisher's Z
DCM_Z = zeros(26,1); DCM_CI = zeros(26,1); DCM_p = zeros(26,1);
DCM_Z_condition_2 = zeros(26,1); DCM_CI_condition_2 = zeros(26,1); DCM_p_condition_2 = zeros(26,1);
GLM_Z = zeros(26,1); GLM_CI = zeros(26,1); GLM_p = zeros(26,1);
GLM_Z_condition_2 = zeros(26,1); GLM_CI_condition_2 = zeros(26,1); GLM_p_condition_2 = zeros(26,1);
TTP_Z = zeros(26,1); TTP_CI = zeros(26,1); TTP_p = zeros(26,1);
TTP_Z_condition_2 = zeros(26,1); TTP_CI_condition_2 = zeros(26,1); TTP_p_condition_2 = zeros(26,1);
TTPf_Z = zeros(26,1); TTPf_CI = zeros(26,1); TTPf_p = zeros(26,1);
TTPf_Z_condition_2 = zeros(26,1); TTPf_CI_condition_2 = zeros(26,1); TTPf_p_condition_2 = zeros(26,1);

% Dimensional component
% Add Study 1 multiverse path
Study_1_path = fullfile('..', '01_Study_1', '03_eda_multiverse');

% Add workspaces
DCM_dim = load(fullfile(Study_1_path, 'workspace_DCM.mat'));
DCM_dim_condition_2 = load(fullfile(Study_1_path, 'workspace_DCM_condition_2.mat'));
GLM_dim = load(fullfile(Study_1_path, 'workspace_GLM.mat'));
GLM_dim_condition_2 = load(fullfile(Study_1_path, 'workspace_GLM_condition_2.mat'));
TTP_dim = load(fullfile(Study_1_path, 'workspace_TTP.mat'));
TTP_dim_condition_2 = load(fullfile(Study_1_path, 'workspace_TTP_condition_2.mat'));
TTPf_dim = load(fullfile(Study_1_path, 'workspace_TTPf.mat'));
TTPf_dim_condition_2 = load(fullfile(Study_1_path, 'workspace_TTPf_condition_2.mat'));

% Fisher Z-transform results
% DCM
for i = 1:13
    x = 10:22;
    [DCM_Z(i), DCM_CI(i)] = fisher_z_transform(...
        DCM_dim.t_or_rho_matrix(x(i),2), DCM_dim.N, 'r');
    DCM_p(i) = DCM_dim.p_matrix(x(i),2) < .05;
    
    % Non-learner
    [DCM_Z_condition_2(i), DCM_CI_condition_2(i)] = fisher_z_transform(...
        DCM_dim_condition_2.t_or_rho_matrix(x(i),2), sum(~DCM_dim_condition_2.NL), 'r');
    DCM_p_condition_2(i) = DCM_dim_condition_2.p_matrix(x(i),2) < .05;
end
% GLM
for i = 1:13
    x = 10:22;
    [GLM_Z(i), GLM_CI(i)] = fisher_z_transform(...
        GLM_dim.t_or_rho_matrix(x(i),2), GLM_dim.N, 'r');
    GLM_p(i) = GLM_dim.p_matrix(x(i),2) < .05;
    
    % Non-learner
    [GLM_Z_condition_2(i), GLM_CI_condition_2(i)] = fisher_z_transform(...
        GLM_dim_condition_2.t_or_rho_matrix(x(i),2), sum(~GLM_dim_condition_2.NL), 'r');
    GLM_p_condition_2(i) = GLM_dim_condition_2.p_matrix(x(i),2) < .05;
end
% TTP
for i = 1:13
    x = 10:22;
    [TTP_Z(i), TTP_CI(i)] = fisher_z_transform(...
        TTP_dim.t_or_rho_matrix(x(i),2), TTP_dim.N, 'r');
    TTP_p(i) = TTP_dim.p_matrix(x(i),2) < .05;
    
    % Non-learner
    [TTP_Z_condition_2(i), TTP_CI_condition_2(i)] = fisher_z_transform(...
        TTP_dim_condition_2.t_or_rho_matrix(x(i),2), sum(~TTP_dim_condition_2.NL), 'r');
    TTP_p_condition_2(i) = TTP_dim_condition_2.p_matrix(x(i),2) < .05;
end
% TTPf
for i = 1:13
    x = 10:22; % indicies for results matrix
    [TTPf_Z(i), TTPf_CI(i)] = fisher_z_transform(...
        TTPf_dim.t_or_rho_matrix(x(i),2), TTPf_dim.N, 'r');
    TTPf_p(i) = TTPf_dim.p_matrix(x(i),2) < .05;
    
    % Non-learner
    [TTPf_Z_condition_2(i), TTPf_CI_condition_2(i)] = fisher_z_transform(...
        TTPf_dim_condition_2.t_or_rho_matrix(x(i),2), sum(~TTPf_dim_condition_2.NL), 'r');
    TTPf_p_condition_2(i) = TTPf_dim_condition_2.p_matrix(x(i),2) < .05;
end

% Categorical component
% Add Study 2 multiverse path
Study_2_path = fullfile('..', '02_Study_2', '02_eda_multiverse');

% Add workspaces
DCM_cat = load(fullfile(Study_2_path, 'workspace_DCM.mat'));
GLM_cat = load(fullfile(Study_2_path, 'workspace_GLM.mat'));
TTP_cat = load(fullfile(Study_2_path, 'workspace_TTP.mat'));
TTPf_cat = load(fullfile(Study_2_path, 'workspace_TTPf.mat'));
DCM_cat_condition_2 = load(fullfile(Study_2_path, 'workspace_DCM_condition_2.mat'));
GLM_cat_condition_2 = load(fullfile(Study_2_path, 'workspace_GLM_condition_2.mat'));
TTP_cat_condition_2 = load(fullfile(Study_2_path, 'workspace_TTP_condition_2.mat'));
TTPf_cat_condition_2 = load(fullfile(Study_2_path, 'workspace_TTPf_condition_2.mat'));

% Fisher Z-transform results
% DCM
for i = 1:13
    x = 10:22; % indicies for results matrix
    y = 14:26; % indicies for figure matricies
    [DCM_Z(y(i)), DCM_CI(y(i))] = fisher_z_transform(...
        DCM_cat.t_or_rho_matrix(x(i),1), DCM_cat.N, 't');
    DCM_p(y(i)) = DCM_cat.p_matrix(x(i),1) < .05;
    
    % Non-learner
    [DCM_Z_condition_2(y(i)), DCM_CI_condition_2(y(i))] = fisher_z_transform(...
        DCM_cat_condition_2.t_or_rho_matrix(x(i),1), sum(~DCM_cat_condition_2.NL), 't');
    DCM_p_condition_2(y(i)) = DCM_cat_condition_2.p_matrix(x(i),1) < .05;
end
% GLM
for i = 1:13
    x = 10:22; % indicies for results matrix
    y = 14:26; % indicies for figure matricies
    [GLM_Z(y(i)), GLM_CI(y(i))] = fisher_z_transform(...
        GLM_cat.t_or_rho_matrix(x(i),1), GLM_cat.N, 't');
    GLM_p(y(i)) = GLM_cat.p_matrix(x(i),1) < .05;
    
    % Non-learner
    [GLM_Z_condition_2(y(i)), GLM_CI_condition_2(y(i))] = fisher_z_transform(...
        GLM_cat_condition_2.t_or_rho_matrix(x(i),1), sum(~GLM_cat_condition_2.NL), 't');
    GLM_p_condition_2(y(i)) = GLM_cat_condition_2.p_matrix(x(i),1) < .05;
end
% TTP
for i = 1:13
    x = 10:22; % indicies for results matrix
    y = 14:26; % indicies for figure matricies
    [TTP_Z(y(i)), TTP_CI(y(i))] = fisher_z_transform(...
        TTP_cat.t_or_rho_matrix(x(i),1), TTP_cat.N, 't');
    TTP_p(y(i)) = TTP_cat.p_matrix(x(i),1) < .05;

    % Non-learner
    [TTP_Z_condition_2(y(i)), TTP_CI_condition_2(y(i))] = fisher_z_transform(...
        TTP_cat_condition_2.t_or_rho_matrix(x(i),1), sum(~TTP_cat_condition_2.NL), 't');
    TTP_p_condition_2(y(i)) = TTP_cat_condition_2.p_matrix(x(i),1) < .05;
end
% TTPf
for i = 1:13
    x = 10:22; % indicies for results matrix
    y = 14:26; % indicies for figure matricies
    [TTPf_Z(y(i)), TTPf_CI(y(i))] = fisher_z_transform(...
        TTPf_cat.t_or_rho_matrix(x(i),1), TTPf_cat.N, 't');
    TTPf_p(y(i)) = TTPf_cat.p_matrix(x(i),1) < .05;

    % Non-learner
    [TTPf_Z_condition_2(y(i)), TTPf_CI_condition_2(y(i))] = fisher_z_transform(...
        TTPf_cat_condition_2.t_or_rho_matrix(x(i),1), sum(~TTPf_cat_condition_2.NL), 't');
    TTPf_p_condition_2(y(i)) = TTPf_cat_condition_2.p_matrix(x(i),1) < .05;
end

%% Making the figure

ERI_effects_Z_1 = [DCM_Z(1:13), GLM_Z(1:13), TTP_Z(1:13), TTPf_Z(1:13)];
ERI_effects_CI_1 = [DCM_CI(1:13), GLM_CI(1:13), TTP_CI(1:13), TTPf_CI(1:13)];
ERI_effects_p_1 = [DCM_p(1:13), GLM_p(1:13), TTP_p(1:13), TTPf_p(1:13)];

% Change ERIs (at the follwoing indicies) to reflect return of fear
flip_sign = [1 2 3 8 10 11]';
for j = 1:size(ERI_effects_Z_1,2)
    for i = 1:size(flip_sign,1)
        ERI_effects_Z_1(flip_sign(i),j) = -ERI_effects_Z_1(flip_sign(i),j);
    end
end

ERI_effects_Z_2 = [DCM_Z(14:26), GLM_Z(14:26), TTP_Z(14:26), TTPf_Z(14:26)];
ERI_effects_CI_2 = [DCM_CI(14:26), GLM_CI(14:26), TTP_CI(14:26), TTPf_CI(14:26)];
ERI_effects_p_2 = [DCM_p(14:26), GLM_p(14:26), TTP_p(14:26), TTPf_p(14:26)];

% Change ERIs (at the follwoing indicies) to reflect return of fear
for j = 1:size(ERI_effects_Z_2,2)
    for i = 1:size(flip_sign,1)
        ERI_effects_Z_2(flip_sign(i),j) = -ERI_effects_Z_2(flip_sign(i),j);
    end
end

ERI_effects_Z_3 = [DCM_Z_condition_2(1:13), GLM_Z_condition_2(1:13), TTP_Z_condition_2(1:13), TTPf_Z_condition_2(1:13)];
ERI_effects_CI_3 = [DCM_CI_condition_2(1:13), GLM_CI_condition_2(1:13), TTP_CI_condition_2(1:13), TTPf_CI_condition_2(1:13)];
ERI_effects_p_3 = [DCM_p_condition_2(1:13), GLM_p_condition_2(1:13), TTP_p_condition_2(1:13), TTPf_p_condition_2(1:13)];

% Change ERIs (at the following indicies) to reflect return of fear
for j = 1:size(ERI_effects_Z_3,2)
    for i = 1:size(flip_sign,1)
        ERI_effects_Z_3(flip_sign(i),j) = -ERI_effects_Z_3(flip_sign(i),j);
    end
end

ERI_effects_Z_4 = [DCM_Z_condition_2(14:26), GLM_Z_condition_2(14:26), TTP_Z_condition_2(14:26), TTPf_Z_condition_2(14:26)]; % Removed GLM_Z_condition_2(13:24)
ERI_effects_CI_4 = [DCM_CI_condition_2(14:26), GLM_CI_condition_2(14:26), TTP_CI_condition_2(14:26), TTPf_CI_condition_2(14:26)]; % Removed GLM_CI_condition_2(13:24)
ERI_effects_p_4 = [DCM_p_condition_2(14:26), GLM_p_condition_2(14:26), TTP_p_condition_2(14:26), TTPf_p_condition_2(14:26)]; % Removed GLM_p_condition_2(13:24)

% Change ERIs (at the follwoing indicies) to reflect return of fear
for j = 1:size(ERI_effects_Z_4,2)
    for i = 1:size(flip_sign,1)
        ERI_effects_Z_4(flip_sign(i),j) = -ERI_effects_Z_4(flip_sign(i),j);
    end
end

X_contrasts = categorical({'1','2','3',...
    '4','5','6',...
    '7','8','9', '10', '11', '12', '13'});
X_contrasts = reordercats(X_contrasts,{'1','2','3',...
    '4','5','6',...
    '7','8','9', '10', '11', '12', '13'});

close all
figure('Renderer', 'painters', 'Position', [100 250 1000 700])
tiledlayout(4,1, 'TileSpacing','Tight');

% Figure 1
nexttile
% Data 
model_series = ERI_effects_Z_1; % Dimensional, before exclusion
model_error = ERI_effects_CI_1; 
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',model_series,model_error,'k','linestyle','none');
% Adjust colour
b(3).FaceColor = [.2 .6 .5];
% Add titles and legend
% title(sprintf('Response Amplitude and State Anxiety \n'), 'FontSize', 16);
text(0.02, 1.02, 'Study 1: condition 1', 'Units', 'normalized', 'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
ax = gca;
ax.FontSize = 14;
set(gca, 'XTick',1:13, 'XTickLabel',X_contrasts)
ax.YAxis.Limits = [-1 1];
% xlabel(sprintf('\n CS Effects'), 'FontSize', 16);
ylabel('Fisher''s {\it z}', 'FontSize', 16);
xline([1.5:1:12.5], ':')
legend('DCM', 'GLM', 'TTP', 'TTPf','','','','','','','','','Location','northeastoutside', 'FontSize', 14)

% Figure 2
nexttile
% Example data 
model_series = ERI_effects_Z_3; % Dimensional, after exclusion
model_error = ERI_effects_CI_3; 
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',model_series,model_error,'k','linestyle','none');
% Adjust colour
b(3).FaceColor = [.2 .6 .5];
% Add titles and legend
% title(sprintf('Response Amplitude and State Anxiety \n'), 'FontSize', 16);
ax = gca;
ax.FontSize = 14;
set(gca, 'XTick',1:13, 'XTickLabel',X_contrasts)
ax.YAxis.Limits = [-1 1];
% set(ax,'yticklabel',[])
text(0.02, 1.02, 'Study 1: condition 2', 'Units', 'normalized', 'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
xlabel(newline, 'FontSize', 16);
xline([1.5:1:12.5], ':')


% Figure 3
nexttile
% Data 
model_series = ERI_effects_Z_2; % Categorical, before exclusion
model_error = ERI_effects_CI_2; 
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',model_series,model_error,'k','linestyle','none');
% Adjust colour
b(3).FaceColor = [.2 .6 .5];
% Add titles and legend
% title(sprintf('Response Amplitude and State Anxiety \n'), 'FontSize', 16);
text(0.02, 1.02, 'Study 2: condition 1', 'Units', 'normalized', 'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
ax = gca;
ax.FontSize = 14;
set(gca, 'XTick',1:13, 'XTickLabel',X_contrasts)
ax.YAxis.Limits = [-1 1];
% xlabel(sprintf('\n CS Effects'), 'FontSize', 16);
% ylabel('Fisher''s {\it z}', 'FontSize', 16);
xline([1.5:1:12.5], ':')
% legend('DCM', 'GLM', 'TTP', 'TTPf', 'Location','northwest', 'FontSize', 14)

% Figure 4
nexttile
% Example data 
model_series = ERI_effects_Z_4; % Categorical, after exclusion
model_error = ERI_effects_CI_4; 
b = bar(model_series, 'grouped');
hold on
% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(model_series);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',model_series,model_error,'k','linestyle','none');
% Adjust colour
b(3).FaceColor = [.2 .6 .5];
% Add titles and legend
% title(sprintf('Response Amplitude and State Anxiety \n'), 'FontSize', 16);
ax = gca;
ax.FontSize = 14;
set(gca, 'XTick',1:13, 'XTickLabel',X_contrasts)
ax.YAxis.Limits = [-1 1];
% set(ax,'yticklabel',[])
text(0.02, 1.02, 'Study 2: condition 2', 'Units', 'normalized', 'VerticalAlignment','Bottom', 'FontWeight','bold', 'FontSize', 16);
xlabel(sprintf('\n Extinction retention indicies'), 'FontSize', 16);
xline([1.5:1:12.5], ':')
text(12.025,(0.05),'*', 'FontSize', 16)
