function [z_val, ci_margin] = multi_fisher(stat, n, type, alpha)

% MULTI_FISHER Performs Fisher Z transformation and calculates confidence 
%   interval margin.
%
%   [z_val, ci_margin] = MULTI_FISHER(stat, n, type, alpha)
%
%   This function computes the Fisher Z transformation of a given
%   statistical value, which can be either a correlation coefficient ('r')
%   or a t-statistic ('t'). It also calculates the margin of the confidence
%   interval (CI) for the transformed value.
%
%   Inputs:
%   - stat: The statistical value to be transformed. This can be a 
%           correlation coefficient (if type is 'r') or a t-statistic (if 
%           type is 't').
%   - n: The sample size. It must be greater than 3.
%   - type: A string specifying the type of the input statistic:
%           - 'r' for a correlation coefficient
%           - 't' for a t-statistic
%   - alpha: The significance level for the confidence interval (optional).
%            Default is 0.05, corresponding to a 95% confidence interval.
%
%   Outputs:
%   - z_val: The Fisher Z transformed value of the input statistic.
%   - ci_margin: The margin of the confidence interval for the transformed 
%                value.
%
%   Example:
%   [z_val, ci_margin] = multi_fisher(0.5, 30, 'r', 0.05);
%
%   This computes the Fisher Z transformation for a correlation coefficient
%   of 0.5 with a sample size of 30 and a 95% confidence interval.
%
%   Notes:
%   - The function returns an error if the sample size (n) is less than or 
%     equal to 3, as the Fisher Z transformation requires at least 4 data 
%     points.
%   - If 't' is chosen as the type, the function converts the t-statistic 
%     to a correlation coefficient before applying the Fisher Z 
%     transformation.
%   - The confidence interval margin is calculated using the standard error
%     of the transformed value.



if nargin < 4
    alpha = 0.05; % Default to 95% confidence interval
end

if n <= 3
    error('Sample size n must be greater than 3.');
end

switch type
    case 'r'
        z_val = 0.5 * log((1 + stat) / (1 - stat));
        stderr = 1 / sqrt(n - 3);
    case 't'
        r_val = sign(stat) * sqrt(stat^2 / (stat^2 + n - 2));
        z_val = 0.5 * log((1 + r_val) / (1 - r_val));
        stderr = 1 / sqrt(n - 3);
    otherwise
        error('Invalid type. Type must be ''r'' or ''t''.');
end

ci_margin = norminv(1 - alpha/2) * stderr;
end
