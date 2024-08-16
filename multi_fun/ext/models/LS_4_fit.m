function results = LS_4_fit(data)

% This function requires that the Bayesian Adaptive Direct Search (Acerbi
% and Ma, 2017) optimisation algorithm be installed
% (https://github.com/lacerbi/bads). LS_4_fit fits Latent State model 
% described in Cochrane and Cisler (2019):
% doi: 10.1371/journal.pcbi.1007331
%
% Usage: results = LS_4_fit(data)
%
% Arguments:
%   data: structure containing the following...
%       .CR [nTrials x 1]: conditioned responses;
%       .CS [nTrials x nCues]: Boolean matrix for conditioned stimuli; and,
%       .US [nTrials x 1]: Boolean vector for unconditioned responses.
%
% Returns:
%   results:
%       ...
%       .V [nTrials x 1]: observation function;
%       .beta: OLS scale paramater;
%       .CR_hat [nTrials x 1]: predicted CR;
%       .lnL: [nIndicies x 1]: log-likelihood of the model;
%       .BIC [nIndicies x 1]: Bayesian information criterion; and,
%       .AIC [nIndicies x 1]: Akaike information criterion.

% Set up BADS options for a noisy, unknown function
OPTIONS = bads('defaults');
OPTIONS.UncertaintyHandling = true;
OPTIONS.NoiseSize = 1;

% Set parameter restraints
x0 = [0.1, 0.1, 0.5, 0.01];     % Starting point
lb = [0.02, 0.02, 0.1, 0];      % Lower bounds
ub = [1, 1, 0.9, 1];            % Upper bounds
plb = lb;   % Plausible lower bounds
pub = ub;   % Plausible upper bounds

% Aquire ML estimate of parameters using BADS
try
    fun = @(x) LS_nlnL(x, data);
    [Final_param, Final_nlnL] =...
        bads(fun,x0,lb,ub,plb,pub,OPTIONS);
catch
    % If BADS produces an error estimate parameters using fMinSearch

    % fMin setup
    nfuncevals = 2500;
    nIter      = 2500;
    defopts = optimset ('fminsearch');
    options = optimset (defopts, 'Display', 'iter', 'MaxFunEvals',...
        nfuncevals, 'MaxIter', nIter);

    model = @LS_nlnL;
    [Final_param, Final_nlnL] =...
        fminsearch(@(x) model(x, data), x0, options);
end

% Set up results structure
[~, MU, ~, ~, lsb, ~, ~] = LS_prediction(Final_param, data);
ix  = ~isnan(data.CR);
if isempty(lsb)
    obs_fun  = zscore(MU(ix));
else    
    par.L        = 1;                   % Initial number of latent states
    dB  = sqrt(sum((diff([zeros(1,par.L)/par.L,zeros(1,size(lsb,2)-par.L); ones(1,par.L)/par.L,zeros(1,size(lsb,2)-par.L); lsb]).^2),2));                
    obs_fun = [zscore(MU(ix)),zscore(dB(ix))];
end

beta = (obs_fun'*obs_fun)\(obs_fun'*data.CR);
results.V = obs_fun(:,1);               % Association vector
results.dB = obs_fun(:,2);
results.beta = beta;                    % OLS scale paramater
results.alpha0 = Final_param(1);        % Learning rate for associative strength     
results.alpha1 = Final_param(2);        % Learning rate for variance
results.alpha2 = Final_param(1);        % Learning rate for covariance
results.gamma  = Final_param(4);        % Transition probability between states
results.sigma0 = Final_param(3);        % Initial standard deviation
results.CR_hat = obs_fun*beta;  % Prediction

% Calculate BIC and AIC
results.lnL = -Final_nlnL;
results.BIC = -2*(-Final_nlnL)+(size(Final_param,2)+1)*log(size(data.CR,1));
results.AIC = -2*(-Final_nlnL)+2*(size(Final_param,2)+1);

end

%% Obtain negative log-likelihood of data given paramaters
function nlnL = LS_nlnL(param, data)

% Obtain US prediction
[~, MU, ~, ~, lsb, ~, ~] = LS_prediction(param, data);
ix  = ~isnan(data.CR);
if isempty(lsb)
    obs_fun  = zscore(MU(ix));
else    
    par.L        = 1;                   % Initial number of latent states
    dB  = sqrt(sum((diff([zeros(1,par.L)/par.L,zeros(1,size(lsb,2)-par.L); ones(1,par.L)/par.L,zeros(1,size(lsb,2)-par.L); lsb]).^2),2));                
    obs_fun = [zscore(MU(ix)), zscore(dB(ix))];
end

beta = (obs_fun'*obs_fun)\(obs_fun'*data.CR); % OLS estimate of beta
CR_hat = obs_fun*beta;                        % Predicted CR
sd = sqrt(mean((data.CR - CR_hat).^2));       % Residual standard deviation

% Negative log-likelihood of data given paramaters
nlnL = -(sum(log(normpdf(data.CR,CR_hat,sd))));

end

%% Obtain Associative Strength
function [logL,MU,agent,logL0,lsb,V,associability] = LS_prediction(param,data) 

% Paramaters
%--------------------------------------------------------------------------
% Soft max parameter
par.tau              = 10;        % Exploration-exploitation parameter

% Latent-state learning
par.ls.alpha0        = param(1);  % Learning rate for associative strength     
par.ls.alpha1        = param(2);  % Learning rate for variance
par.ls.alpha2        = param(1);  % Learning rate for covariance
par.ls.gamma         = param(4);  % Transition probability between states
par.ls.ncop          = 10;        % Maximum number of replicates of latent states                                
par.ls.eta           = 0.2;       % Threshold to activate new state
par.ls.delta         = 0.6;       % Constant involved in change point statistic
par.ls.chi           = 5;         % Number of rumination updates

par.ls.sigma0 = param(3);       % Initial standard deviation

% Add in example-specific parameters
par.ntrials  = size(data.CR,1);     % Number of trials
par.A        = 1;                   % Number of arms
par.D        = 1;                   % Dimension of outcomes 
par.C        = size(data.CS,2); %4  % Number of cues
par.L        = 1;                   % Initial number of latent states
par.center   = 0;                   % Reward centering value
par.sigma0   = 1/2;                 % Initial standard deviation
pts          = 150;                 % Number of start points

% Adjust data structure
dta.R     = data.US-1/2; % threat centred to 0.5
dta.CR    = data.CR; 
dta.arm   = ones(par.ntrials,1);
dta.c_vec = data.CS; 

% Add replications of cue vector
dta.c_vec = reshape(repmat(dta.c_vec,1,par.ls.ncop),par.ntrials,[]);

% Initialize variables 
agent  = LatentState(par, []);
logL   = 0;

% Loop through trials
for t = 1:par.ntrials

    % Get rewards and feature vector
    par.t        = t;           % Add in current time
    world.c_vec  = reshape(dta.c_vec(t,:),par.D,par.C,par.ls.ncop,par.A);
    world.win    = reshape(repmat(dta.R(t,:),1,par.A), par.D, par.A);        
    world.arm    = dta.arm(t);
    
    % Update agent
    agent        = LatentState(par,agent,world);
    
    % Get probability of arm choice
    [~,p]        = SoftMaxChoice(agent.mu,par);
    
    % Log-probability of picked arm
    logL       = logL + log( p( world.arm ) );
    logL0(t,1) = p( world.arm );
    
    % Save expectations
    MU(t,:) = agent.mu(:)';
    
    
    % Save beliefs
     if isfield(agent,'lsb')
         lsb(t,:) = agent.lsb(:)';
         
         % Save associative strengths per cue
         if size(lsb,2)==size(agent.V,3)
             if t==1
                 tmp = reshape([ones(1,par.L)/par.L,zeros(1,size(lsb,2)-par.L)],1,1,size(agent.V,3) );
             else
                 tmp    = reshape(lsb(t-1,:),1,1,size(agent.V,3));
             end
             V(t,:) = reshape(sum(agent.V.*tmp,3) , 1, []);
         else
             V(t,:) = agent.V(:,:,1);
         end
     else
         lsb = [];
         V(t,:) = agent.V(:,:,1);
     end
     if isfield(agent,'associability')
         associability(t,:) = agent.associability(:)'/2;
     else
         associability = [];
     end
end
end

% 18/04/2022 - Created by Matthew Greaves