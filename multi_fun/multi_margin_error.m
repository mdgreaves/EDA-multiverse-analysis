function [mean_val, margin_error] = multi_margin_error(data)

% MULTI_MARGIN_ERROR Calculates the mean and margin of error for a dataset.
%
%   [mean_val, margin_error] = MULTI_MARGIN_ERROR(data)
%
%   This function computes the mean and the margin of error for a given
%   vector of data points, ignoring any NaN values. The margin of error is
%   calculated for a 95% confidence interval using the t-distribution.
%
%   Inputs:
%   - data: A vector of data points, which may contain NaN values.
%
%   Outputs:
%   - mean_val: The mean of the data, calculated after removing any NaN 
%               values.
%   - margin_error: The margin of error for the 95% confidence interval.
%
%   Notes:
%   - If the input data vector is empty or contains only NaN values, both 
%     `mean_val` and `margin_error` are returned as NaN.
%   - If the sample size after removing NaNs is less than 2, the margin of 
%     error cannot be calculated and is returned as NaN.
%   - The function uses a significance level of 0.05 to calculate the 
%     margin of error for a 95% confidence interval.

    if isempty(data) || all(isnan(data))
        mean_val = NaN;
        margin_error = NaN;
        return;
    end

    % Remove NaN values from the data
    data = data(~isnan(data));

    % Constants
    alpha = 0.05; % Significance level for 95% CI

    % Sample size
    n = length(data); % Adjusted for NaN values

    % Check for sufficient data points
    if n < 2
        mean_val = mean(data); % Mean of the data
        margin_error = NaN; % Margin of error not calculable with less than 2 data points
        return;
    end

    % Mean and standard deviation
    mean_val = mean(data); % Mean of the data
    std_dev = std(data); % Standard deviation

    % Critical value from the t-distribution
    t_critical = tinv(1 - alpha/2, n - 1);

    % Calculate the margin of error
    margin_error = t_critical * (std_dev / sqrt(n));
end
