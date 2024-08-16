function correctedVariables = multi_nan(varargin)

% MULTI_NAN Replaces NaN values with zeros in numeric input.
%
%   correctedVariables = REPLACENANSWITHZERO(var1, var2, ..., varN)
%
%   This function takes multiple input variables, checks if they are
%   numeric, and replaces any NaN (Not-a-Number) values with zeros. The
%   function outputs a cell array containing the corrected variables.
%
%   Inputs:
%   - var1, var2, ..., varN: Input variables that may contain NaN values.
%                            The function expects these variables to be 
%                            numeric.
%
%   Outputs:
%   - correctedVariables: A cell array containing the input variables with 
%                         NaN values replaced by zeros. If a variable is 
%                         not numeric, it is left unchanged and a warning 
%                         is issued.
%
%   Example:
%   correctedVars = multi_nan(array1, array2, matrix1);
%

    % Initialize the output
    correctedVariables = cell(size(varargin));

    % Iterate through each input variable
    for i = 1:length(varargin)
        % Get the current variable
        currentVar = varargin{i};

        % Ensure it is numeric
        if isnumeric(currentVar)
            % Replace NaN with 0
            currentVar(isnan(currentVar)) = 0;
        else
            warning('Variable %d is not numeric and was not processed.', i);
        end

        % Store the corrected variable
        correctedVariables{i} = currentVar;
    end
end
