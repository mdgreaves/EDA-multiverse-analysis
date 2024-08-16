function multi_extract(excel_file_path, model_file_path)

% MULTI_EXTRACT Extracts and processes data from Excel and model files for 
%   analysis.
%
%   MULTI_EXTRACT(excel_file_path, model_file_path)
%
%   This function imports data from specified Excel sheets and model files,
%   processes the data to match the valid participant IDs, and performs
%   statistical analyses comparing phobic (SP) and healthy control (HC)
%   groups. The function outputs statistical results including p-values and
%   log Bayes factors.
%
%   Inputs:
%   - excel_file_path: Full path to the Excel file containing expectancy 
%                      ratings.
%   - model_file_path: Full path to the directory containing model files 
%                      for participants.
%
%   Procedure:
%   1. The function imports phobic and healthy expectancy ratings for both 
%      CS+ and CS- from specified ranges in the Excel file.
%   2. It matches the imported data to valid participant IDs based on the 
%      model files.
%   3. The expectancy ratings are processed and transformed using a 
%      logarithmic transformation.
%   4. The function conducts paired t-tests and Bayesian t-tests on the 
%      processed data, first including all participants and then applying 
%      exclusion criteria.
%   5. The results, including p-values and log Bayes factors, are displayed
%      in the console.
%
%   Example:
%   multi_extract('path_to_excel_file.xlsx', 'path_to_model_files/');
%
%   Notes:
%   - The Excel file should have specific sheets and ranges corresponding 
%     to the phobic and healthy groups for both CS+ and CS- expectancy 
%     ratings.
%   - The exclusion criteria retain participants where CS+ > CS- in both 
%     groups.
%   - Statistical significance levels are indicated by *, **, or *** based 
%     on p-values.
%   - Log Bayes factors are calculated and displayed for each condition.

% Import phobic CS+
opts = spreadsheetImportOptions("NumVariables", 34);
% Specify sheet and range
opts.Sheet = "Expectancy CS+";
opts.DataRange = "B2:AI23";
% Specify column names and types
opts.VariableNames = ["VarName2", "VarName3", "VarName4",...
    "contraceptives", "VarName6", "VarName7", "VarName8",...
    "VarName9", "VarName10", "VarName11", "VarName12", "VarName13",...
    "VarName14", "VarName15", "VarName16", "VarName17", "VarName18",...
    "VarName19", "VarName20", "VarName21", "VarName22", "VarName23",...
    "VarName24", "VarName25", "VarName26", "VarName27", "VarName28",...
    "VarName29", "VarName30", "VarName31", "VarName32", "VarName33",...
    "VarName34", "VarName35"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char"];
% Import the data
data.phobic_CSp = readtable(excel_file_path, opts, "UseExcel", false);
clear opts

% Import health CS+
opts = spreadsheetImportOptions("NumVariables", 27);
% Specify sheet and range
opts.Sheet = "Expectancy CS+";
opts.DataRange = "B26:AB47";
% Specify column names and types
opts.VariableNames = ["VarName2", "VarName3", "VarName4",...
    "contraceptives", "VarName6", "VarName7", "VarName8", "VarName9",...
    "VarName10", "VarName11", "VarName12", "VarName13", "VarName14",...
    "VarName15", "VarName16", "VarName17", "VarName18", "VarName19",...
    "VarName20", "VarName21", "VarName22", "VarName23", "VarName24",...
    "VarName25", "VarName26", "VarName27", "VarName28"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char"];
% Import the data
data.healthy_CSp = readtable(excel_file_path, opts, "UseExcel", false);
% Remove last column (subject misisng CS- data)
data.healthy_CSp(:, end) = [];
clear opts

% Import phobic CS-
opts = spreadsheetImportOptions("NumVariables", 34);
% Specify sheet and range
opts.Sheet = "Expectancy CS-";
opts.DataRange = "B2:AI22";
% Specify column names and types
opts.VariableNames = ["VarName2", "VarName3", "VarName4", "VarName5",...
    "VarName6", "VarName7", "VarName8", "VarName9", "VarName10",...
    "VarName11", "VarName12", "VarName13", "VarName14", "VarName15",...
    "VarName16", "VarName17", "VarName18", "VarName19", "VarName20",...
    "VarName21", "VarName22", "VarName23", "VarName24", "VarName25",...
    "VarName26", "VarName27", "VarName28", "VarName29", "VarName30",...
    "VarName31", "VarName32", "VarName33", "VarName34", "VarName35"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char"];
% Import the data
data.phobic_CSm = readtable(excel_file_path, opts, "UseExcel", false);
clear opts

% Import healthy CS-
opts = spreadsheetImportOptions("NumVariables", 26);
% Specify sheet and range
opts.Sheet = "Expectancy CS-";
opts.DataRange = "B25:AA45";
% Specify column names and types
opts.VariableNames = ["VarName2", "VarName3", "VarName4", "VarName5",...
    "VarName6", "VarName7", "VarName8", "VarName9", "VarName10",...
    "VarName11", "VarName12", "VarName13", "VarName14", "VarName15",...
    "VarName16", "VarName17", "VarName18", "VarName19", "VarName20",...
    "VarName21", "VarName22", "VarName23", "VarName24", "VarName25",...
    "VarName26", "VarName27"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char", "char", "char", "char", "char",...
    "char", "char", "char", "char"];
% Import the data
data.healthy_CSm = readtable(excel_file_path, opts, "UseExcel", false);
clear opts


valid_files = struct2cell(dir(fullfile(model_file_path, '*S1.mat')));
valid_files = extractBetween(valid_files(1,:), 'model_', '_S1.mat');

fields = fieldnames(data);
phobic_IDs = table2array(data.(fields{1})(2,:));
healthy_IDs = table2array(data.(fields{2})(2,:));
data.(fields{1}) = data.(fields{1})(:,contains(phobic_IDs, valid_files));
data.(fields{3}) = data.(fields{3})(:,contains(phobic_IDs, valid_files));
data.(fields{2}) = data.(fields{2})(:,contains(healthy_IDs, valid_files));
data.(fields{4}) = data.(fields{4})(:,contains(healthy_IDs, valid_files));

SP_CSp = mean(str2double(table2array(data.(fields{1})(7:13,:))),1);
HC_CSp = mean(str2double(table2array(data.(fields{2})(7:13,:))),1);
SP_CSm = mean(str2double(table2array(data.(fields{3})(7:13,:))),1);
HC_CSm = mean(str2double(table2array(data.(fields{4})(7:13,:))),1);
CSp = [SP_CSp, HC_CSp];
CSm = [SP_CSm, HC_CSm];
CSp = log(10 + CSp);
CSm = log(10 + CSm);


% Cond 1: HC and SP combined
disp('Study: 2')
disp('Method: EXP')
fprintf('Condition 1 \nN: %s\n',...
    num2str(length(CSp)))
fprintf('Healthy controls: %s\n',...
    num2str(length(table2array(data.(fields{2})(7:13,:)))))
[~, pValue] = multi_ttest(CSp, CSm);
        if pValue < .001
            disp('p < .001 ***')
        elseif pValue < .01
            disp('p < .01 **')
        elseif pValue < .05
            disp('p < .05 *')
        end
[bf, ~] = bf_ttest(CSp, CSm);
disp(['lnBF: ',...
    num2str(log(bf))])
disp(newline);

% Apply exclusion criteria
SP_keep = SP_CSp > SP_CSm; 
HC_keep = HC_CSp > HC_CSm;
HC_keep_n = sum(HC_keep); N_keep = sum(SP_keep)+HC_keep_n;
SP_CSp = SP_CSp(SP_keep); SP_CSm = SP_CSm(SP_keep);
HC_CSp = HC_CSp(HC_keep); HC_CSm = HC_CSm(HC_keep);
CSp = [SP_CSp, HC_CSp];
CSm = [SP_CSm, HC_CSm];
CSp = log(10 + CSp);
CSm = log(10 + CSm);

% Cond 2: HC and SP combined
disp('Study: 2')
disp('Method: EXP')
fprintf('Condition 2 \nN after NL exclusion: %s\n', num2str(N_keep))
fprintf('Healthy controls after NL exclusion: %s\n', num2str(HC_keep_n))
[~, pValue] = multi_ttest(CSp, CSm);
        if pValue < .001
            disp('p < .001 ***')
        elseif pValue < .01
            disp('p < .01 **')
        elseif pValue < .05
            disp('p < .05 *')
        end
[bf, ~] = bf_ttest(CSp, CSm);
disp(['lnBF: ',...
num2str(log(bf))])
disp(newline);

end