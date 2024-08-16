function [A, B, C, D, E, F, G, H, I, J, K, L, M] = ...
    multi_eri(Acquisition, Acquisition_diff_resp, Extinction, Retention)

% MULTI_ERI Computes Extinction Retention Indices (ERIs) based on conditioned 
%   response data.
%
%   [A, B, C, D, E, F, G, H, I, J, K, L, M] = ERI_FUN(Acquisition, ...
%    Acquisition_diff_resp, Extinction, Retention)
%
%   This function calculates a set of Extinction Retention Indices (ERIs)
%   as defined in Lonsdorf et al. (2019). These indices quantify various
%   aspects of the retention of conditioned responses across different
%   experimental phases: Acquisition, Extinction, and Retention. The
%   indices are computed based on Conditioned Stimulus positive (CS+),
%   Conditioned Stimulus negative (CS-), and differential response data.
%
%   Inputs:
%   - Acquisition: A matrix containing the acquisition phase data. The 
%                  first column contains the response data, the second 
%                  column indicates CS+ trials (logical), and the third 
%                  column indicates CS- trials (logical).
%   - Acquisition_diff_resp: A vector containing the differential response 
%                            scores during the acquisition phase (e.g., CS+ 
%                            minus CS-).
%   - Extinction: A matrix containing the extinction phase data, structured
%                 similarly to the Acquisition matrix.
%   - Retention: A matrix containing the retention phase data, structured 
%                similarly to the Acquisition matrix.
%
%   Outputs:
%   - A to M: The calculated ERIs, where:
%       - A: ERI 1 - Retention of the first CS+ relative to the maximum CS+ 
%                    during acquisition.
%       - B: ERI 2 - Retention of the first two CS+ relative to the maximum 
%                    CS+ during acquisition.
%       - C: ERI 3 - Mean retention of the first two CS+ relative to the 
%                    mean of the two largest CS+ during acquisition.
%       - D: ERI 4 - Mean retention of the first two CS+ relative to the 
%                    maximum CS+ during acquisition.
%       - E: ERI 5 - Mean retention of the first four CS+ relative to the 
%                    maximum CS+ during acquisition.
%       - F: ERI 6 - Difference between the first CS+ during retention and 
%                    the last CS+ during extinction.
%       - G: ERI 7 - Difference between the first CS- during retention and 
%                    the last CS- during extinction.
%       - H: ERI 8 - Retention difference between CS+ and CS- relative to 
%                    the maximum differential response during acquisition.
%       - I: ERI 9 - Retention difference between the first two CS+ and CS- 
%                    during retention.
%       - J: ERI 10 - Difference in mean CS- and CS+ responses during 
%                     retention, relative to mean CS- retention.
%       - K: ERI 11 - Retention difference between the first four CS+ and 
%                     CS- relative to the maximum differential response 
%                     during acquisition.
%       - L: ERI 12 - Retention difference between the first five CS+ and 
%                     CS- relative to the difference during extinction 
%                     trials 2-5.
%       - M: ERI 13 - Retention difference between the first five CS+ and 
%                     CS- relative to the difference during the last five 
%                     extinction trials.
%
%   Notes:
%   - The ERIs are calculated using specific formulas outlined in Lonsdorf 
%     et al. (2019).
%   - The function assumes that the input matrices are structured with 
%     response data in the first column, CS+ indicators in the second 
%     column, and CS- indicators in the third column.

    % Find indices for CSs       
    % CS+ trials
        % Acquisition
        A_CSp = find(logical(Acquisition(:,2)));  
        A_CSp_sort = sort(Acquisition(A_CSp,1), 'descend');
        % Extinction
        E_CSp = find(logical(Extinction(:,2)));
        % Retention
        R_CSp = find(logical(Retention(:,2)));
        
    % CS- trials
        % Acquisition
        % A_CSm = find(logical(Acquisition(:,3)));               
        % Extinction
        E_CSm = find(logical(Extinction(:,3)));
        % Retention
        R_CSm = find(logical(Retention(:,3)));

    % Calculate ERIs
    % Nondifferential Indices (CS+ Based)
    % ERI 1 x
    % 100 - [100 × first CS+ of retention/max(CS+ acquisition)]
    A = 100-(100*Retention(R_CSp(1),1)/max(Acquisition(A_CSp,1)));
    
    % ERI 2 x
    % 100 - [100 × nanmean(first 2 CS+ retention)/max(CS+ acquisition)]
    B = 100-(100*nanmean(Retention(R_CSp(1:2),1))/max(Acquisition(A_CSp,1)));
    
    % ERI 3 x
    % 100 × [1 - [nanmean(first 2 CS+ retention)/(nanmean(two largest CS+ acquisition)]
    C = 100*(1-nanmean(Retention(R_CSp(1:2),1))/nanmean(A_CSp_sort(1:2)));
    
    % ERI 4 (5 in Lonsdorf et al., 2019) x
    % 100 × nanmean(first 2 CS+ retention)/max(CS+ acquisition)
    D = 100*nanmean(Retention(R_CSp(1:2),1))/max(Acquisition(A_CSp,1));
    
    % ERI_5 (8 in Lonsdorf et al., 2019) x
    % 100 × nanmean(first 4 CS+ retention)/max(CS+ acquisition)
    E = 100*nanmean(Retention(R_CSp(1:4),1))/max(Acquisition(A_CSp,1));
    
    % ERI_6 (9a in Lonsdorf et al., 2019) x
    % (first CS+ retention) - (last CS+ extinction)
    F = Retention(R_CSp(1),1)-Extinction(E_CSp(end),1);
    
    % Nondifferential Indices (CS- Based)
    % ERI_7 (9b in Lonsdorf et al., 2019) x
    % (first CS- retention) - (last CS- extinction)
    G = Retention(R_CSm(1),1)-Extinction(E_CSm(end),1);
    
    % Differential Indices
    % ERI_8 (10 in Lonsdorf et al., 2019) x
    % 100 - (100 × [(nanmean first 2 CS+ retention) -...
    % (nanmean first two CS- retention)]/max pair(CS+) - (CS-) acquisition)
    H = 100-(100*(nanmean(Retention(R_CSp(1:2),1))-nanmean(Retention(R_CSm(1:2),1)))/max(Acquisition_diff_resp));
    
    % ERI_9 (11 in Lonsdorf et al., 2019) x
    % nanmean(first 2 CS+ retention) - nanmean(first 2 CS- trials retention)
    I = nanmean(Retention(R_CSp(1:2),1))-nanmean(Retention(R_CSm(1:2),1));
    
    % ERI_10 (12 in Lonsdorf et al., 2019) x
    % 100 × [(nanmean CS- retention) - (nanmean CS+ retention)]/(nanmean CS- retention)
    J = 100*((nanmean(Retention(R_CSm,1))-nanmean(Retention(R_CSp,1)))/nanmean(Retention(R_CSm,1)));
    
    % ERI_11 (13 in Lonsdorf et al., 2019) x
    % 100 - [100 × nanmean(first 4 CS+ retention) - (nanmean[first 4 CS- retention])/(max pairh(CS+) - (CS-) acquisition)]
    K = 100-(100*nanmean(Retention(R_CSp(1:4),1))-nanmean(Retention(R_CSm(1:4),1))/max(Acquisition_diff_resp));
    
    % ERI_12 (15 in Lonsdorf et al., 2019) x
    % [nanmean(first 5 CS+ retention) - nanmean(first 5 CS- retention)] - [nanmean(trial 2-5 CS+ extinction) - nanmean(trial 2-5 CS- extinction)]
    L = (nanmean(Retention(R_CSp(1:5),1))-nanmean(Retention(R_CSm(1:5),1)))-(nanmean(Extinction(E_CSp(2:5),1))-nanmean(Extinction(E_CSm(2:5),1)));
    
    % ERI_13 (16 in Lonsdorf et al., 2019) x
    % [nanmean(first 5 CS+ retention) - nanmean(first 5 CS- retention)] - [nanmean(last 5 CS+ extinction) - nanmean(last 5 CS- extinction)]
    M = (nanmean(Retention(R_CSp(1:5),1))-nanmean(Retention(R_CSm(1:5),1)))-(nanmean(Extinction(E_CSp((length(E_CSp)-4):end),1))-nanmean(Extinction(E_CSm((length(E_CSm)-4):end),1)));

end