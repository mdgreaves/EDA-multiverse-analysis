function [p, t_or_rho, stats] = multi_stats(ACQ_CSp_all,...
    ACQ_CSm_all, ACQ_CSd_all, EXT_CSp_all, EXT_CSm_all,...
    EXT_CSd_all, RET_CSp_all, RET_CSm_all, RET_CSd_all, A, B,...
    C, D, E, F, G, H, I, J, K, L, M, modifiers)

% MULTI_STATS Computes statistical comparisons.
%
%   This function performs statistical tests across multiple datasets
%   provided as input arguments. It supports several types of comparisons
%   based on the nature of the 'modifiers' argument:
%
%   1.  Simple Comparison: If 'modifiers' is a logical vector, it compares
%       data associated with 'true' versus 'false' in 'modifiers' using a
%       two-sample t-test.
%
%   2.  Modified Comparison: If 'modifiers' is a single-column vector with
%       values 1 or 2, it compares data associated with these values using 
%       a two-sample t-test.
%
%   3.  Simple Correlation: If 'modifiers' is a numeric vector without 1s
%       and 2s, it computes the Pearson correlation between the data and
%       'modifiers'.
%
%   4.  Modified Correlation: If 'modifiers' is a two-column matrix, it
%       computes the Pearson correlation between the data associated with a
%       'true' value in the first column of 'modifiers' and the 
%       corresponding values in the second column.
%
%   The function outputs:
%       - p: A vector of p-values from the statistical tests.
%       - t_or_rho: A vector of test statistics (t-values or correlation 
%         coefficients).
%       - stats: A cell array containing additional statistics for each test.
%
%   If insufficient data variance or length is detected, the function skips 
%   the test for that particular dataset and displays a message.
%
%   Example:
%   [p, t_stats, stats] = multi_stats(data1, data2, data3,..., 
%       dataN, modifiers)
%
%   Inputs:
%   - ACQ_CSp_all, ACQ_CSm_all, ..., M: Datasets to be tested.
%   - modifiers: Logical vector or numeric array specifying how to group or
%                correlate the datasets for the statistical tests.

N_tests = nargin-1;
[p, t_or_rho] = deal(nan(N_tests,1));
stats = cell(N_tests,1);

if islogical(modifiers)
    % Simple comparison
    % With/high versus without/low
    for i = 1:N_tests
        data1 = eval([inputname(i) '(modifiers)']);
        data2 = eval([inputname(i) '(~modifiers)']);
        if var(data1, 'omitnan') > 0 && var(data2, 'omitnan') > 0 &&...
                length(data1) > 1 && length(data2) > 1
            [~, p(i), ci, stats{i}] = ttest2(data1, data2);
            t_or_rho(i) = stats{i}.tstat;
            stats{i}.ci = ci;
        else
            disp(['Skipping t-test for variable ' inputname(i)...
                ' due to insufficient variance or data points']);
            disp('Variances: Lengths:')
            disp([var(data1), var(data2), length(data1), length(data2)])
            disp(data1)
            disp(data2)
        end
    end
end

if ~islogical(modifiers) && size(modifiers, 2) == 1 &&...
        checkVectorElements(modifiers)
    % Modified comparison
    % With/high versus without/low
    for i = 1:N_tests
        data1 = eval([inputname(i) '(modifiers == 2)']);
        data2 = eval([inputname(i) '(modifiers == 1)']);
        if var(data1, 'omitnan') > 0 && var(data2, 'omitnan') > 0 &&...
                length(data1) > 1 && length(data2) > 1
            [~, p(i), ci, stats{i}] = ttest2(data1, data2);
            t_or_rho(i) = stats{i}.tstat;
            stats{i}.ci = ci;
        else
            disp(['Skipping t-test for variable ' inputname(i)...
                ' due to insufficient variance or data points']);
            disp('Variances: Lengths:')
            disp([var(data1), var(data2), length(data1), length(data2)])
            disp(data1)
            disp(data2)
        end
    end
end


if ~islogical(modifiers) && size(modifiers, 2) == 1 &&...
        ~checkVectorElements(modifiers)
    % Simple Correlation
    % Dimension compared to responses
    for i = 1:N_tests
        data1 = eval(inputname(i));
        if var(data1, 'omitnan') > 0 && var(modifiers, 'omitnan') > 0 &&...
                length(data1) > 1 && length(modifiers) > 1
            [t_or_rho(i), p(i)] = corr(data1, modifiers, 'Rows',...
                'pairwise');
            stats{i}.p = p(i);
            stats{i}.rho = t_or_rho(i);
        else
            disp(['Skipping corr test for variable ' inputname(i)...
                ' due to insufficient variance or data points']);
            disp('Variances: Lengths:')
            disp([var(data1), var(modifiers), length(data1), length(modifiers)])
            disp(data1)
            disp(modifiers)
        end
    end
end

if ~islogical(modifiers) && size(modifiers, 2) == 2
    % Modified Correlation
    for i = 1:N_tests
        data = eval([inputname(i) '(logical(modifiers(:,1)))']);
        modData = modifiers(logical(modifiers(:,1)), 2);
        if var(data, 'omitnan') > 0 && var(modData, 'omitnan') > 0 &&...
                length(data) > 1 && length(modData) > 1
            [t_or_rho(i), p(i)] = corr(data, modData, 'Rows', 'pairwise');
            stats{i}.p = p(i);
            stats{i}.rho = t_or_rho(i);
        else
            disp(['Skipping corr test for variable ' inputname(i)...
                ' due to insufficient variance or data points']);
            disp('Variances: Lengths:')
            disp([var(data), var(modData), length(data), length(modData)])
            disp(data)
            disp(modData)
        end
    end
end
end

function isOnly012 = checkVectorElements(vector)
    uniqueElements = unique(vector);
    isOnly012 = all(ismember(uniqueElements, [0, 1, 2]));
end






