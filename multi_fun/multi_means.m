function [ACQ_CSp_mean, ACQ_CSm_mean, ACQ_CSd_mean, EXT_CSp_mean,...
    EXT_CSm_mean, EXT_CSd_mean, RET_CSp_mean, RET_CSm_mean,...
    RET_CSd_mean] = multi_means(Acquisition, Extinction,...
    Retention, Acquisition_diff_resp,...
    Extinction_diff_resp, Retention_diff_resp)

% MULTIM_EANS Computes the mean responses for CS+ and CS- trials 
%   across different phases.
%
%   This function calculates the mean responses for Conditioned Stimulus
%   positive (CS+), Conditioned Stimulus negative (CS-), and difference
%   scores during three phases of an experiment: Acquisition, Extinction,
%   and Retention. The means are computed separately for each condition and
%   phase, with NaN values omitted from the calculations.
%
%   Inputs:
%   - Acquisition: A matrix containing the acquisition phase data. The 
%                  first column should contain the response data, the 
%                  second column should indicate CS+ trials (logical), and 
%                  the third column should indicate CS- trials (logical).
%   - Extinction: A matrix containing the extinction phase data, structured 
%                 similarly to the Acquisition matrix.
%   - Retention: A matrix containing the retention phase data, structured 
%                similarly to the Acquisition matrix.
%   - Acquisition_diff_resp: A vector containing the difference scores for
%                            the acquisition phase.
%   - Extinction_diff_resp: A vector containing the difference scores for  
%                           the extinction phase.
%   - Retention_diff_resp: A vector containing the difference scores for
%                          the retention phase.
%
%   Outputs:
%   - ACQ_CSp_mean: The mean response during the acquisition phase for CS+.
%   - ACQ_CSm_mean: The mean response during the acquisition phase for CS-.
%   - ACQ_CSd_mean: The mean difference score during the acquisition phase.
%   - EXT_CSp_mean: The mean response during the extinction phase for CS+.
%   - EXT_CSm_mean: The mean response during the extinction phase for CS-.
%   - EXT_CSd_mean: The mean difference score during the extinction phase.
%   - RET_CSp_mean: The mean response during the retention phase for CS+.
%   - RET_CSm_mean: The mean response during the retention phase for CS-.
%   - RET_CSd_mean: The mean difference score during the retention phase.
%
%   Notes:
%   - The function assumes that the input matrices are structured with 
%     response data in the first column, CS+ indicators in the second 
%     column, and CS- indicators in the third column.
%   - NaN values are omitted from the mean calculations using 'omitnan'.

    % CS+ trials
    % Acquisition
    A_CSp = logical(Acquisition(:,2));
    % Extinction
    E_CSp = logical(Extinction(:,2));
    % Retention
    R_CSp = logical(Retention(:,2));

    % CS- trials
    % Acquisition
    A_CSm = logical(Acquisition(:,3));
    % Extinction
    E_CSm = logical(Extinction(:,3));
    % Retention
    R_CSm = logical(Retention(:,3));

    % Compute individual means for each phase and condition
    % Acquisition
    ACQ_CSp_mean = mean(Acquisition(A_CSp,1), 'omitnan');
    ACQ_CSm_mean = mean(Acquisition(A_CSm,1), 'omitnan');
    ACQ_CSd_mean = mean(Acquisition_diff_resp, 'omitnan');
    
    % Extinction
    EXT_CSp_mean = mean(Extinction(E_CSp,1), 'omitnan');
    EXT_CSm_mean = mean(Extinction(E_CSm,1), 'omitnan');
    EXT_CSd_mean = mean(Extinction_diff_resp, 'omitnan');
    
    % Retention
    RET_CSp_mean = mean(Retention(R_CSp,1), 'omitnan');
    RET_CSm_mean = mean(Retention(R_CSm,1), 'omitnan');
    RET_CSd_mean = mean(Retention_diff_resp, 'omitnan');

end
