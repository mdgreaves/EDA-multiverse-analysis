function results = HM_fit_Tzovara(data, obs)

% This function requires that the Bayesian Adaptive Direct Search (Acerbi
% and Ma, 2017) optimisation algorithm be installed
% (https://github.com/lacerbi/bads). HM_fit_Tzovara fits Hybrid RW/PH model
% from Tsovara et al. (2018; https://doi.org/10.1371/journal.pcbi.1006243),
% which takes the form:
%
%   x(t+1) = x(t) + eta(t) * (lambda(t) - x(t));
%
% x(t) is the strength with which a conditioned stimulus (CS) is associated
% with an unconditioned stimulus (US) on trial t; eta is a learning
% rate parameter that changes on a trial-by-trial basis; and, lambda 
% denotes whether the US is active. Trial-by-trial eta is calculated 
% via the following:
%
%   eta(t+1) = k * |x(t)-lambda(t)| + (1-k) * eta(t);
%
% where k is a participant-specific positive free scaling parameter common 
% to both CS, reflecting how fast each participant's predictions are 
% updated, with 0<k<1. Depending on the chosen observation function
% (obs), the conditioned response (CR) on trial t, is assumed to be a
% linear function of either the associative strength of x(t), or the
% learning rate eta(t):
%
%   Option 1:   CR(t) = beta*eta(t); or,
%   Option 2:   CR(t) = beta*x(t).
%
% where beat is a scaling parameter estimated via ordinary least squares
% (OLS). The k parameter is estimated using maximum likelihood (ML)
% estimation and Bayesian Adaptive Direct Search (BADS). The log
% likelihood of the data given the parameters is given by:
%
%   lnL(data) = (-(T/2))*(ln(2)+ln(pi)+ln(sigma^2))-(1/(2*sigma^2))...
%       *sum((CR-beta*obs).^2);
%
% where T is the total number of trials, sigma^2 is the residual variance
% and obs is either x(t) or eta(t). A Bayesian information criterion (BIC)
% and Akaike information criterion (AIC) is then computed:
%
%   BIC = -2*lnL(data)+(p+1)+ln(n),
%
%   AIC = -2*lnL(data)+2*p
%
% where p is the number of free parameters and n is the number of
% observations.
%
% Usage: results = HM_fit_Tzovara(data, obs)
%
% Arguments:
%   data: structure containing the following...
%       .CR [nTrials x 1]: conditioned responses;
%       .CS [nTrials x nCues]: Boolean matrix for conditioned stimuli; and,
%       .US [nTrials x 1]: Boolean vector for unconditioned responses.
%   obs: selector variable, used to select either eta(t; obs = 1)
%       or x(t; obs = 2) as the observation function.
%
% Returns:
%   results:
%       .k [0,1]: participant-specific positive free scaling parameter;
%       .obs: selector variable;
%       .beta: OLS scale paramater;
%       .obs_fun [nTrials x 1]: observation function;
%       .CR_hat [nTrials x 1]: predicted CR;
%       .lnL: [nIndicies x 1]: log-likelihood of the model;
%       .BIC [nIndicies x 1]: Bayesian information criterion; and,
%       .AIC [nIndicies x 1]: Akaike information criterion.

%% Optimization

    % Potentially useful options for a noisy, unknown function.
    % OPTIONS = bads('defaults');
    % OPTIONS.UncertaintyHandling = true;
    % OPTIONS.NoiseSize = 1;

% Set parameter restraints
x0 = 0.50;  % Starting point
lb = 0;     % Lower bounds
ub = 1;     % Upper bounds
plb = lb;   % Plausible lower bounds
pub = ub;   % Plausible upper bounds

try
    fun = @(x) HM_nlnL(x, data, obs);
    [Final_param, Final_nlnL] =...
        bads(fun,x0,lb,ub,plb,pub,OPTIONS);
catch
    % If BADS produces an error estimate parameters using fMinSearch
    nfuncevals = 2500;
    nIter      = 2500;
    defopts = optimset ('fminsearch');
    options = optimset (defopts, 'Display', 'iter', 'MaxFunEvals',...
        nfuncevals, 'MaxIter', nIter);

    model = @HM_nlnL;
    [Final_param, Final_nlnL] =...
        fminsearch(@(x) model(x, data, obs), x0, options);
end

% Set up results structure
results.k = Final_param;
results.obs = obs;
obs_fun = HM(data, Final_param, obs);
beta = (obs_fun'*obs_fun)\(obs_fun'*data.CR);
results.bk = beta;
results.obs_fun = obs_fun;
results.CR_hat = results.bk*obs_fun;

% Calculate BIC and AIC
results.lnL = -Final_nlnL;
results.BIC = -2*(-Final_nlnL)+(size(Final_param,2)+1)*log(size(data.CR,1));
results.AIC = -2*(-Final_nlnL)+2*size(Final_param,2);

end

%% Likelihood
function nlnL = HM_nlnL(param, data, obs)

k = param;
% Obtain US prediction using chosen observation function
obs_fun = HM(data, k, obs);
beta = (obs_fun'*obs_fun)\(obs_fun'*data.CR);   % OLS estimate of beta
CR_hat = beta*obs_fun;                          % Predicted CR
sd = sqrt(mean((data.CR - CR_hat).^2));         % Residual standard deviation

% Negative log-likelihood of data given paramaters
nlnL = -(sum(log(normpdf(data.CR,CR_hat,sd))));

end

%% Hybrid Model
function obs_fun = HM(data, k, obs)

nTrials = length(data.US); nCues = size(data.CS,2);
initial_associative_weight = .50; initial_rate_parameter = 1;

% Initialize results
x = nan(nTrials + 1, nCues); x(1, :) = initial_associative_weight;
eta = nan(nTrials + 1, 1); eta(1, 1) = initial_rate_parameter;
y = nan(nTrials, 1); 

% Loop over trials
for t = 1 : nTrials
        % Update x for active cues
        x(t+1,logical(data.CS(t, :))) = x(t,logical(data.CS(t, :))) + eta(t) * (data.US(t) - x(t,logical(data.CS(t, :))));
        % Update x for inactive cues
        x(t+1,~logical(data.CS(t, :))) = x(t,~logical(data.CS(t, :)));
        % Store the current prediction
        y(t) = x(t+1,logical(data.CS(t, :)));
        % Update eta
        eta(t+1) = k * abs(x(t,logical(data.CS(t, :)))-data.US(t)) + (1-k) * eta(t);
end

% HM could have two different observation functions to ANS responses: 
% the current associability (HM1), and the current US prediction (HM2)

if obs == 1
    obs_fun = eta(2:end, 1);
elseif obs == 2
    obs_fun = y;
end

end

% 28/02/2023 - Updated by Matthew Greaves