Study 1
00_self-report_and_demographic_data
    Data in HC.mat per column: ID; DASS-A; sex (1 = female); and, age.

01_conditioned_response_estimates 
    Each "model" structure contains the following:
        .CR [nTrials x 1]: conditioned responses;
        .CS [nTrials x nCues]: Boolean matrix for conditioned stimuli; and,
        .US [nTrials x 1]: Boolean vector for unconditioned responses.

02_expectancy_ratings
    Each "EX" file contains the following:
        .CR [nTrials x 1]: expectancy ratings.

03_eda_multiverse
    Refer to description in the eda_multiverse_study_1.m header.

Study 2
00_self-report_and_demographic_data
    Data in HC_SP.mat described in table's column names. 
    ClinStatus = 1 for spider phobia.

01_conditioned_response_estimates 
    Each "model" structure contains the following:
        .CR [nTrials x 1]: conditioned responses;
        .CS [nTrials x nCues]: Boolean matrix for conditioned stimuli; and,
        .US [nTrials x 1]: Boolean vector for unconditioned responses.

02_eda_multiverse
    Refer to description in the eda_multiverse_study_2.m header.

