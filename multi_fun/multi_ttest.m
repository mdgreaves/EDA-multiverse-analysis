function [tStat, pValue] = multi_ttest(data1, data2)

% MULTI_TTEST Performs a paired t-test on two datasets.
%
%   [tStat, pValue] = MULTI_TTEST(data1, data2)
%
%   This function computes the t-statistic and p-value for a paired t-test
%   comparing two sets of paired observations. It checks for and handles
%   NaN values, ensures that the input data vectors are of the same length,
%   and validates that the data is real and non-complex.
%
%   Inputs:
%   - data1: A vector of observations from the first condition.
%   - data2: A vector of observations from the second condition.
%
%   Outputs:
%   - tStat: The calculated t-statistic for the paired t-test.
%   - pValue: The two-tailed p-value corresponding to the t-statistic.
%
%   Example:
%   [tStat, pValue] = multi_ttest([1.2, 2.3, 3.4], [1.1, 2.5, 3.6]);
%
%   Notes:
%   - The function ensures that the input vectors `data1` and `data2` have 
%     the same length and are real numbers.
%   - NaN values in the input vectors are removed before computation.
%   - The function checks for sufficient data points (at least 2) to 
%     perform the t-test.
%   - A paired t-test is used, which assumes that the two sets of 
%     observations 
%     are related or paired.
%   - The function calculates the t-statistic and the corresponding p-value 
%     for a two-tailed hypothesis test.
%   - The function also calculates Cohen's d for paired samples as an 
%     effect size, and displays it in a table along with the t-statistic 
%     and p-value.

    % Check if the input vectors are of the same size
    if length(data1) ~= length(data2)
        error('The input vectors must have the same length.');
    end

    % Check for NaN values and handle them
    nanFilter = ~isnan(data1) & ~isnan(data2);
    data1 = data1(nanFilter);
    data2 = data2(nanFilter);

    % Check for complex numbers
    if ~isreal(data1) || ~isreal(data2)
        error('The input data must not contain complex numbers.');
    end

    % Number of observations
    n = length(data1);
    
    % Ensure there are enough data points
    if n < 2
        error('Not enough data points to perform t-test.');
    end

    % Calculate the difference
    diffData = data1 - data2;
    
    % Calculate the mean and standard deviation of the differences
    meanDiff = mean(diffData);
    stdDiff = std(diffData);
    
    % Check for negative or zero standard deviation
    if stdDiff <= 0
        error('Standard deviation of differences is non-positive, check your data.');
    end

    % t-Statistic for paired t-test
    tStat = meanDiff / (stdDiff / sqrt(n));
    
    % Two-tailed p-value for the t-test
    pValue = 2 * tcdf(-abs(tStat), n - 1);
    
    % Use meanEffectSize for effect size
    % Assuming we want to compute Cohen's d for paired samples
    effectSizeTable = meanEffectSize(data1, data2, 'Effect',...
        'cohen', 'Paired', true);

    % Display the results
    disp(['t-Statistic: ' num2str(tStat)]);
    disp(['p-Value: ' num2str(pValue)]);
    disp('Effect Size Table: ');
    disp(effectSizeTable);
end

