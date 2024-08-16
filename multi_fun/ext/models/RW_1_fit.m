function results = RW_1_fit(data)

% This function requires that the Bayesian Adaptive Direct Search (Acerbi 
% and Ma, 2017) optimisation algorithm be installed
% (https://github.com/lacerbi/bads). RW_1_fit fits the simple Rescorla and 
% Wagner's (1972) model to data using the following equation:
%
%   V_CS(t) = V_CS(t-1)+alpha*[lambda(t)-{CS(t)*V_CS(t)'}].
% 
% V_CS is the strength with which conditioned stimulus (CS) is associated 
% with an unconditioned stimulus (US) on trial t; alpha is a learning rate;
% lambda denotes whether the US is active; and CS denotes which CS is
% active. The conditioned response (CR) on trial t, is assumed to be a 
% linear function of the associative strength of CS(t):
% 
%   CR(t) = beta*[CS(t)*V_CS(t)']+e(t),
% 
% where beta is a scaling paramater estimated via ordinary least squares 
% (OLS) and e is a random noise term drawn from a normal distribution (M = 
% 0, SD = 1). The alpha paramater is fit using maximum likelihood (ML)
% estimation and Bayesian Adaptive Direct Search (BADS). The log likelihood
% of the data given the paramaters (alpha and beta) is given by:
% 
%   lnL(data) = (-(T/2))*(ln(2)+ln(pi)+ln(sigma^2))-(1/(2*sigma^2))...
%       *sum((CR-beta*V_CS).^2);
% 
% where T is the total number of trials, sigma^2 is the residual variance 
% and V_CS is a function of alpha. A Bayesian information criterion (BIC) 
% is then computed:
% 
%   BIC = -2*lnL(data)+(p+1)+ln(n),
% 
% where p is the number of free parammaters and n is the number of
% observations. To compare the model with a  null model in which alpha is
% fixed to zero, a log Bayes factor (logBF) is approximated via the 
% following:
% 
%   logBF = BIC(model)-BIC(null_model)
% 
% Usage: results = RW_1_fit(data)
% 
% Arguments:
%   data: structure containing the following...
%       .CR [nTrials x 1]: conditioned responses;
%       .CS [nTrials x nCues]: Boolean matrix for conditioned stimuli; and,
%       .US [nTrials x 1]: Boolean vector for unconditioned responses.
% 
% Returns:
%   results:
%       .alpha: [0,1]: learning rate estimate;
%       .beta: scaling paramater;
%       .V_CS [nTrials x 1]: associative strengths for active CSs;
%       .CR_hat [nTrials x 1]: predicted CR; 
%       .BIC [nIndicies x 1]: Bayesian information criteria; and,
%       .logBF: Log Bayes factor.

% Set up BADS options for a noisy, unknown function
OPTIONS = bads('defaults');
OPTIONS.UncertaintyHandling = true;
OPTIONS.NoiseSize = 1;

% Set paramater restraints
x0 = 0.50;  % Starting point
lb = 0;       % Lower bounds
ub = 1;     % Upper bounds
plb = x0/1.25;   % Plausible lower bounds
pub = x0*1.25;   % Plausible upper bounds

% Aquire ML estimate of alpha using BADS
try
    fun = @(x) RW_1_nlnL(x,data);
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

    model = @RW_1_nlnL;
    [Final_param, Final_nlnL] =...
        fminsearch(@(x) model(x, data), x0, options);
end

% Set up results structure
results.alpha = Final_param;
V_CS = RW_1(data, results.alpha);
beta = (V_CS'*V_CS)\(V_CS'*data.CR);
results.beta = beta;
results.V_CS = V_CS;
results.CR_hat = results.beta*V_CS; 

% Calculate BIC and AIC
results.lnL = -Final_nlnL;
results.BIC = -2*(-Final_nlnL)+(size(Final_param,2)+1)*log(size(data.CR,1));
results.AIC = -2*(-Final_nlnL)+2*size(Final_param,2);

end

function nlnL = RW_1_nlnL(param,data)

alpha = param;
V_CS = RW_1(data, alpha);               % Obtain US prediction
beta = (V_CS'*V_CS)\(V_CS'*data.CR);    % OLS estimate of beta
CR_hat = beta*V_CS;                     % Predicted CR
sd = sqrt(mean((data.CR - CR_hat).^2)); % Residual standard deviation

% Negative log-likelihood of data given paramaters
nlnL = -(sum(log(normpdf(data.CR,CR_hat,sd))));
end

function V_CS = RW_1(data, alpha)

% This section was adapted from code associated with Melinscak and Bach (2020)
initial_associative_weight = .50;
nTrials = length(data.US); nCues = size(data.CS,2);

% Initialize results
V = nan(nTrials + 1, nCues);
V(1, :) = initial_associative_weight;
rhat = nan(nTrials, 1);     % US prediction
delta = nan(nTrials, 1);    % Prediction error

%   V_CS(t) = V_CS(t-1)+alpha*[lambda(t)-{CS(t)*V_CS(t)'}].
% Loop over trials
for t = 1 : nTrials
    rhat(t) =  data.CS(t,:) * V(t,:)';  % Predict US
    delta(t) = data.US(t) - rhat(t);    % Calculate prediction error
    V(t+1, :) =  V(t,:) + alpha * delta(t) * data.CS(t,:); % Update weights for active cues
end
V_CS = rhat;

end

% 20/01/2021 - Created by Matthew Greaves
% 22/01/2021 - Updated by Matthew Greaves