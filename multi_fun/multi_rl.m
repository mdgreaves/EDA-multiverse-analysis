function output = multi_rl(data, ID, figure_on)

% MULTI_RL Fits multiple reinforcement learning models to data.
%
%   This function fits four different reinforcement learning (RL) models to
%   the provided behavioral data: the Rescorla-Wagner (RW) model, the
%   Pearce-Hall (PH) model, the Latent Cause (LC) model, and the Latent
%   State (LS) model. The function calculates model fits and compares them
%   based on Akaike Information Criterion (AIC) and Bayesian Information
%   Criterion (BIC) scores. It also provides a visual comparison of the
%   models' performance if desired.
%
%   Inputs:
%   - data: A structure containing the behavioral data. The structure 
%           should include fields for Conditioned Response (CR), 
%           Unconditioned Stimulus (US), and Conditioned Stimulus (CS).
%   - ID: A string representing the subject ID, used in the figure titles.
%   - figure_on: A boolean flag (true/false) indicating whether to generate 
%                figures showing the model comparison and fit.
%
%   Outputs:
%   - output: A structure containing the results from each of the models:
%             - results_1: Results from the Rescorla-Wagner (RW) model.
%             - results_2: Results from the Pearce-Hall (PH) model.
%             - results_3: Results from the Latent Cause (LC) model.
%             - results_4: Results from the Latent State (LS) model.
%
%   Notes:
%   - The function first fits each of the four models to the data, using 
%     different approaches for each model.
%   - The Latent Cause (LC) model uses a particle filter with specified 
%     options (e.g., concentration parameter, number of particles) and then 
%     estimates the Conditioned Response (CR) using a regression approach.
%   - If 'figure_on' is set to true, the function generates a figure with 
%     six subplots: AIC and BIC comparisons, and plots comparing the 
%     observed CR with the predicted CR for each model.
%   - The model with the lowest BIC is identified as the winning model, and 
%     its name is displayed in the figure.

    % Rescorla-Wagner (RW) model
    results_1 = RW_1_fit(data);
    
    % Pearce-Hall (PH) model
    results_2 = HM_fit_Tzovara(data, 1);
    
    % Latent Cause (LC) model
    % Set-up LC options (using 500 particles)
    opts.a = 1;             % (hyperparameter of beta prior: pseudo-count 
                            % for feature presence)
    opts.b = 1;             % (hyperparameter of beta prior: pseudo-count 
                            % for feature absence)
    opts.alpha = .5;        % (concentration parameter for Chinese 
                            % restaurant process prior)
    opts.stickiness = 0;    % (stickiness parameer for Chinese restaurant 
                            % process prior)
    opts.K = 10;            % (maximum number of latent causes)
    opts.M = 500;           % (number of particles; 1 = local MAP)
    
    results_3 = LCM_fit(data, opts);
    
    % Obtain estimate of CR using posterior alpha estimate
    opts.alpha = results_3.alpha;
    opts.M = 1;
    results_temp = LCM_infer([data.US data.CS],opts);
    X = results_temp.V;
    b = (X'*X)\(X'*data.CR);
    results_3.CR_hat = X*b;
    
    % Latent State (LS) model
    results_4 = LS_4_fit(data);   

% Winning model
model_names = ["RW", "PH", "LCM", "LS"];
[~, winning_index] = min([results_1.BIC, results_2.BIC,...
    results_3.BIC, results_4.BIC]);

if figure_on == true
    close all

    % Figure
    f = figure;
    f.Position = [100 100 700 600];
    tiledlayout(3,2);

    % Tile 1
    nexttile
    X = categorical({'RW','PH','LCM','LS'});
    X = reordercats(X,{'RW','PH','LCM','LS'});
    Y = [results_1.AIC, results_2.AIC, results_3.AIC, results_4.AIC];
    bar(X,Y)
    xlabel('Model')
    ylabel('AIC')
    title(sprintf('Subject %s \n', ID))

    % Tile 2
    nexttile
    X = categorical({'RW','PH','LCM','LS'});
    X = reordercats(X,{'RW','PH','LCM','LS'});
    Y = [results_1.BIC, results_2.BIC, results_3.BIC, results_4.BIC];
    bar(X,Y)
    xlabel('Model')
    ylabel('BIC')
    title(sprintf('Winning model = %s \n', model_names(winning_index)))

    % Tile 3
    nexttile
    plot(1:length(data.CR), [data.CR, results_1.CR_hat]);
    xlabel('RW')
    ylabel('CR/CR_{hat}')

    % Tile 4
    nexttile
    plot(1:length(data.CR), [data.CR, results_2.CR_hat]);
    xlabel('PH')
    ylabel('CR/CR_{hat}')

    % Tile 5
    nexttile
    plot(1:length(data.CR), [data.CR, results_3.CR_hat]);
    xlabel('LCM')
    ylabel('CR/CR_{hat}')

    % Tile 5
    nexttile
    plot(1:length(data.CR), [data.CR, results_4.CR_hat]);
    xlabel('LS')
    ylabel('CR/CR_{hat}')

    drawnow
end

output.results_1 = results_1;
output.results_2 = results_2;
output.results_3 = results_3;
output.results_4 = results_4;
end



