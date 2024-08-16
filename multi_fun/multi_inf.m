function correctedVariables = multi_inf(varargin)

% MULTI_INF Replaces Inf and -Inf values in numeric input variables 
%   with a specified value.
%
%   correctedVariables = MULTI_INF(var1, var2, ..., varN)
%
%   This function takes multiple input variables, checks if they are
%   numeric, and replaces any Inf (positive infinity) and -Inf (negative
%   infinity) values with a specified "reasonable" value. The function
%   outputs a cell array containing the corrected variables.
%
%   Inputs:
%   - var1, var2, ..., varN: Input variables that may contain Inf or -Inf 
%                            values. The function expects these variables 
%                            to be numeric.
%
%   Outputs:
%   - correctedVariables: A cell array containing the input variables with 
%                         Inf and -Inf values replaced by the specified 
%                         reasonable value. If a variable is not numeric, 
%                         it is left unchanged and a warning is issued.
%
%   Example:
%   correctedVars = correctInfinities(array1, array2, matrix1);
%
%   Notes:
%   - The function checks each input variable and processes it only if it 
%     is numeric.
%   - If a variable is not numeric, a warning is displayed and the variable 
%     is returned unchanged in the output.
%   - The default value used to replace Inf and -Inf is set to 1e6. This 
%     value can be adjusted within the function as needed.

    % Set a reasonable value to replace Inf/-Inf
    reasonableValue = 1e6;

    % Initialize the output
    correctedVariables = cell(size(varargin));

    % Iterate through each input variable
    for i = 1:length(varargin)
        % Get the current variable
        currentVar = varargin{i};

        % Ensure it is numeric
        if isnumeric(currentVar)
            % Replace Inf and -Inf with the reasonable value
            currentVar(isinf(currentVar)) = reasonableValue;
        else
            warning('Variable %d is not numeric and was not processed.',...
                i);
        end

        % Store the corrected variable
        correctedVariables{i} = currentVar;
    end
end
