# Electrodermal Activity Multiverse Analysis

This repository contains processed data and MATLAB code associated with the electrodermal activity (EDA) multiverse analysis described in [Greaves et al. (2024)](https://doi.org/10.1016/j.brat.2024.104598).

## Overview

The primary function in this repository is `multiverse_run.m`, which initiates the multiverse analysis (`multiverse.m`). The analysis explores the impact of different analytic choices on conclusions vis-à-vis fear learning and anxiety. Details are summarised in Fig. 1.

<p align="center">
<img src=https://ars.els-cdn.com/content/image/1-s2.0-S0005796724001256-gr1_lrg.jpg width="800" height="500" border="10" />
</p>

**Fig. 1.**  Processing and analysis decisions applied to EDA time series data. Four different methods were used to pre-process EDA data and estimate trial-by-trial conditioned responses: dynamic causal modelling (DCM), a trial-by-trial general linear model (GLM), a trough-to-peak analysis (TTP), and a baseline-corrected (BLC) trough-to-peak analysis. Four formal reinforcement learning models—the Rescorla-Wagner, Pearce-Hall, latent cause, and latent state models—were then fitted to the resulting conditioned response estimates. Nine stimulus- and phase-related parameters—mean responses per conditioned threat stimulus (CS+), conditioned safety stimulus (CS-), and differential response (ΔCR)—and 13 extinction retention indices (ERIs)—using functions reported in the literature—were calculated under two conditions: the inclusion (Condition 1) and the exclusion (Condition 2) of non-learners. Per the non-learner exclusion criterion, participants were excluded if their mean ΔCR for the acquisition phase was less than or equal to zero. Note that part of the pipeline—labelled with an A—represents a switch (for switching between conditions 1 and 2).

## Directory and Data Structure

- **`multi_fun/`** contains many of the custom multiverse-related functions, whereas **`multi_fun/ext/`** contains external functions associated with various reinforcement learning (RL) models, in addition to visualisation and optimisation tools:
  - Rescorla-Wagner model
  - Pearce-Hall model
  - Latent Cause model (see [here](https://github.com/sjgershm/LCM))
  - Latent State model (see [here](https://github.com/cochran4/OnlineLatentStateLearning))
  - Bayesian Adaptive Direct Search (BADS) - v1.0.6 (see[ here](https://papers.nips.cc/paper_files/paper/2017/hash/df0aab058ce179e4f7ab135ed4e641a9-Abstract.html))
  - Superbar - v1.5.0 (see[ here](https://github.com/scottclowe/superbar))
  - Bayes Factors for Paired T-tests (see [here](https://viewer.mathworks.com/?viewer=plain_code&url=https%3A%2F%2Fwww.mathworks.com%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2F538c7be5-f6fc-4eec-9e69-a3395de394fa%2F1715750036%2Ffiles%2Fexternal%2FbayesFactor%2F%2Bbf%2Fttest.m&embed=web))

- **`multi_data/dim/data_structures/`**: Contains data structures for each subject in Study 1. The data structure is organised as follows:
  - `.CS`: [*n* × 2 logical] Conditioned stimuli for *n* trials (CS+/CS-)
  - `.US`: [*n* × 1 logical] Unconditioned stimulus for *n* trials
  - `.CR`: [*n* × 4 double] Conditioned responses for *n* trials using four EDA response estimation methods
  - `.ER`: [*n* × 4 double] Evoked responses for *n* trials using four EDA response estimation methods
  - `.DASS`: [1 x 1 double] State anxiety score (Depression, Anxiety, and Stress Scale)
  - `.NL`: [1 x 4 logical] Non-learner status for each EDA response estimation method

- **`multi_data/cat/data_structures/`**: Contains data structures for each subject in Study 2. The data structure is organised per Study 1, with additional fields:
  - `.SP`: [1 x 1 logical] Specific phobia status
  - `.STAI`: [1 x 1 double] Trait anxiety score (State-Trait Anxiety Inventory)

- **`multi_data/dim/demog.mat`**: Demographic data for Study 1, providing IDs, state anxiety score, sex (1 = female), and age.

- **`multi_data/cat/demog.mat`**: Demographic data for Study 2, providing IDs, clinical status (1 = specific phobia), age, state anxiety score, and trait anxiety score.

- Note that **`multi_data/dim/expectancy/`** contains an expectancy file per subject in Study 1, whereas **`multi_data/cat/expectancy/`** contains a single .xlxs file. Note too, that for the sake of simplicity, expectancy-related model fit statistics are included here: **`multi_data/dim/exp_results.mat`**; one can, however, modify the `multiverse.m` function to re-fit RL models to expectancy data.

## Running the Multiverse Analysis

The main function to run the analysis is `multiverse_run.m`. It takes the following inputs:

- `study_selector`: 1 for (Study 1) or 2 for (Study 2)
- `fit_RL_models`: Boolean (true/false) indicating whether to fit RL models to EDA data
- `transformation`: String ("none" or "log") to specify the data transformation to apply

### Example Usage:

```matlab
% Study 1
multiverse_run(1, false, "none");

% Study 2
multiverse_run(2, false, "none");
```
**Note on Computation Time:**
Fitting RL models in both datasets—i.e., using `fit_RL_models = true`—takes approximately three hours on a local computer. This estimated computation time is based on running the analysis using MATLAB R2023b Update 5 on a macOS system (Darwin 21.6.0) with an 8-core Quartz CPU. The system was configured with Java 1.8.0_392-b08, utilising Amazon’s OpenJDK 64-Bit Server VM.

**Using Pre-Computed Fit Statistics:**
Fitting the RL models is not strictly necessary if one simply wishes to generate the visualisations presented in the associated study. The pre-computed fit statistics for the RL models have been uploaded to **`multi_out/dim/none/`** and **`multi_out/cat/none/`** for Study 1 and 2, respectively, so that users can bypass the model fitting step and focus on visualising results.

## Output Structure:
### Study 1
All output is saved in the directory: **`multi_out/`**. With regards to the RL models, the model fit statistics are organised per EDA response estimation method (e.g., the file `DCM_RL_models.mat` contains dynamic-causal-model-related results). These files are organised per RL model and subject. Other (statistical) output, saved in the `*_multiverse.mat` files, is organised in 22 x 4 matrices and cell arrays:
- 22 variables: 3 CS contrasts x 3 phases + 13 ERIs
- 4 anxiety-related permutations:
    - Comparison between high-low state anxiety
    - State anxiety treated dimensionally
    - Comparison between high-low state anxiety (excluding non-learners)
    - State anxiety treated dimensionally (excluding non-learners)

### Study 2
Again, model fit statistics are organised per EDA response estimation method. These `*_RL_models.mat` files contain results for each RL model and subject. Other output, saved in the `*_multiverse.mat` files, is organised in 22 x 10 matrices and cell arrays:
- 22 variables: 3 CS contrasts x 3 phases + 13 ERIs
- 10 anxiety-related permutations:
    - Clinical-healthy comparison
    - Comparison between high-low state anxiety
    - Comparison between high-low trait anxiety
    - State anxiety treated dimensionally
    - Trait anxiety treated dimensionally
    - Clinical-healthy comparison (excluding non-learners)
    - Comparison between high-low state anxiety (excluding non-learners)
    - Comparison between high-low trait anxiety (excluding non-learners)
    - State anxiety treated dimensionally (excluding non-learners)
    - Trait anxiety treated dimensionally (excluding non-learners)

## Visualisations

The visualisations operate on the *untransformed* output (obtained using `transformation = "none"`). If the relevant output is available (i.e., the user has followed the example usage above), then the visualisation-related scripts and functions saved in **`multi_viz/`** can be properly evaluated. All code related to Figures 2-4 and Table 1 are provided in this directory.

## Contact

Questions? Please feel free to reach out.

## Reference

Greaves, M. D., Felmingham, K. L., Ney, L. J., Nicholson, E., Li, S., Vervliet, B., Harrison, B. J., Graham, B. M., and Steward, T. (2024). Using Electrodermal Activity to Estimate Fear Learning Differences in Anxiety: A Multiverse Analysis. Behaviour Research and Therapy, 104598. DOI: https://doi.org/10.1016/j.brat.2024.104598
