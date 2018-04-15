function [handles] = generate_labels(handles)
% 
%        15     2x2 Contingency Table           
%        96     Pearson Correlation 
%       137     R-squared
%       187     Regression Effects
%       238     Ind. 2 Grps Difference
%       299     Dep. 2 Grps Difference
%       362     Linear Mean Contrasts
%       436     Binomial Proportion
%       492     SEM Fit Statistics 
% 
% 
% 
   %% ====== 2x2 Contingency Table ================================================

   pm02.hd_labels = char(                                  ...     % 2x2 Contingency Table
                     'Odds Ratio in 2x2 Table',            ...     % 1
                     'Risk Ratio in 2x2 Table',            ...     % 2
                     'Inter-Rater Reliability',            ...     % 3
                     ' Inverted Odds Ratios  '             ...     % 4
                     ) ;

   pm02.bg1_labels = char(                                 ...     % 2x2 Contingency Table
                     'Odds ratio',                         ...     % 1
                     'Risk ratio',                         ...     % 2
                     'Inter-rater'                         ...     % 3
                     ) ;   

   pm02.bg2_labels = char(                                  ...    % 2x2 Contingency Table
                     'Invert Ratios'                       ...     % 1
                     ) ;

   pm02.pg1_labels = char(                                 ...     % 2x2 Contingency Table
                     'Cell A',                             ...     % 1
                     'Cell B',                             ...     % 2
                     'Cell C',                             ...     % 3
                     'Cell D',                             ...     % 4
                     'Grp = 1 / Result = True',            ...     % 5
                     'Grp = 1 / Result = False',           ...     % 6
                     'Grp = 2 / Result = True',            ...     % 7
                     'Grp = 2 / Result = False',           ...     % 8
                     'Rater1 = Y / Rater2 = Y',            ...     % 9
                     'Rater1 = Y / Rater2 = N',            ...     % 10
                     'Rater1 = N / Rater2 = Y',            ...     % 11
                     'Rater1 = N / Rater2 = N',            ...     % 12
                     'CI width (%)'                        ...     % 13
                     ) ;

   pm02.pg2_labels = char(                                 ...     % 2x2 Contingency Table
                     'Unadjusted OR',                      ...     % 1
                     'Gart-adjusted (+0.5/cell)',          ...     % 2
                     'Agresti-smoothed',                   ...     % 3
                     'Unadjusted risk ratio',              ...     % 4
                     'Agresti-adjusted (+1)',              ...     % 5
                     'Cohen''s kappa',                     ...     % 6
                     'BA kappa (bias-adj.)',               ...     % 7
                     'PBA kappa (prev. & BA)',             ...     % 8
                     'Observed agreement'                  ...     % 9
                     ) ;

   pm02.pg3_labels = char(                                 ...     % 2x2 Contingency Table
                     'Unadjusted OR',                      ...     % 1
                     'Gart-adjusted (+0.5/cell)',          ...     % 2
                     'Agresti-smoothed',                   ...     % 3
                     'Cornfield exact',                    ...     % 4
                     'Cornfield mid-point',                ...     % 5
                     'Baptista-Pike exact',                ...     % 6
                     'Baptista-Pike mid-point',            ...     % 7
                     'Unadjusted RR',                      ...     % 8
                     'Agresti-adjusted (+1)',              ...     % 9
                     'Cohen''s kappa',                     ...     % 10
                     'PBA kappa (Score-based)',            ...     % 11
                     'PBA kappa (Clopper-Pearson)',          ...   % 12
                     'Agreement (Score-based)',            ...     % 13
                     'Agreement (Clopper-Pearson)',          ...   % 14
                     'Clopper-Pearson exact'               ...     % 15
                     ) ;

   pm02.pg4_labels = char(                                 ...     % 2x2 Contingency Table
                     'Pearson chi-square',                 ...     % 1
                     'Pearson P value',                    ...     % 2
                     'Continuity-correct chi-sq',          ...     % 3
                     'Continuity-correct P value',         ...     % 4
                     '1-sided Exact P value',              ...     % 5
                     '2-sided Exact P value',              ...     % 6
                     '1-sided Mid-P value',                ...     % 7
                     '2-sided Mid-P value',                ...     % 8
                     'Chance agreement',                   ...     % 9
                     'Prevalence index',                   ...     % 10
                     'Bias index'                          ...     % 11
                     ) ;



   %% ====== Pearson Correlations =================================================

   pm03.hd_labels = char(                                  ...     % Correlations
                     '    Pearson Correlation    ',        ...     % 1
                     'Pearson Partial Correlation'         ...     % 2
                     ) ;

   pm03.bg1_labels = char(                                 ...     % Correlations
                     'Zero-order',                         ...     % 1
                     'Partial'                             ...     % 2
                     ) ;

   pm03.pg1_labels = char(                                 ...     % Correlations
                     'Sample correlation',                 ...     % 1
                     'Sample size',                        ...     % 2
                     'Null hypothesised Rho',              ...     % 3
                     'No. partialled variables',           ...     % 4
                     'CI width (%)'                        ...     % 5
                     ) ;

   pm03.pg2_labels = char(                                 ...     % Correlations
                     'Sample correlation',                 ...     % 1
                     'Unbiased correlation',               ...     % 2
                     'Partial correlation'                 ...     % 3
                     ) ;

   pm03.pg3_labels = char(                                 ...     % Correlations
                     'Fisher''s r to z',                   ...     % 1
                     'Unbiased Fisher''s r to z',          ...     % 2
                     'Exact (sample)',                     ...     % 3
                     'Exact (unbiased)'                    ...     % 4
                     ) ;

   pm03.pg4_labels = char(                                 ...     % Correlations
                     'Observed t value',                   ...     % 1
                     'Degrees of freedom',                 ...     % 2
                     'Obtained P value',                   ...     % 3
                     'P value (null rho):'                 ...     % 4
                     ) ;


   %% ====== R-squared ============================================================

   pm04.hd_labels = char(                                  ...     % R-squared
                     'R-squared Statistic'                 ...     % 1
                     ) ;

   pm04.bg1_labels = char(                                 ...     % R-squared
                     'Obs. R-sq',                          ...     % 1
                     'Obs. F value'                        ...     % 2
                     ) ;

   pm04.pg1_labels = char(                                 ...     % R-squared
                     'Observed R-square',                  ...     % 1
                     'Number of IVs',                      ...     % 2
                     'Sample size',                        ...     % 3
                     'Null hypothesised Rho-sq',           ...     % 4
                     'Observed F statistic',               ...     % 5
                     'CI width (%)'                        ...     % 6
                     ) ;

   pm04.pg2_labels = char(                                 ...     % R-squared
                     'Observed R-sq (Eta-sq)',             ...     % 1
                     'Unbiased R-sq (O-P)',                ...     % 2
                     'Multiple R',                         ...     % 3
                     'Omega-squared'                       ...     % 4
                     ) ;

   pm04.pg3_labels = char(                                 ...     % R-squared
                     'Large-sample R-squared',             ...     % 1
                     'Eta-squared (fixed scores)',         ...     % 2
                     'R-squared (random scores)',          ...     % 3
                     'Unbiased R-squared (O-P)',           ...     % 4
                     'Multiple R (random scores)',         ...     % 5
                     'Omega-squared (fixed scores)',       ...     % 6
                     'Noncentral parameters)'              ...     % 7
                     ) ;

   pm04.pg4_labels = char(                                 ...     % R-squared
                     'F value',                            ...     % 1
                     'Numerator df',                       ...     % 2
                     'Denominator df',                     ...     % 3
                     'Obtained P value',                   ...     % 4
                     'F Value (Null Rho-sq)',              ...     % 5
                     'Numerator df',                       ...     % 6
                     'Denominator df',                     ...     % 7
                     'Pr(Rho-sq > R-sq)'                   ...     % 8
                     ) ;



   %% ====== Regression Effects ===================================================

   pm05.hd_labels = char(                                  ...     % Regression Effects
                     'Regression Coefficients'             ...     % 1
                     ) ;

   pm05.bg1_labels = char(                                 ...     % Regression Effects
                     'Std Err',                            ...     % 1
                     'Tolerance'                           ...     % 2
                     ) ;

   pm05.pg1_labels = char(                                 ...     % Regression Effects
                     'Regression coefficient',             ...     % 1
                     'Observed R-square',                  ...     % 2
                     'Standard error',                     ...     % 3
                     'Sample size',                        ...     % 4
                     'Number of IVs',                      ...     % 5
                     'SD of DV',                           ...     % 6
                     'SD of IV',                           ...     % 7
                     'Corr. DV & IV',                      ...     % 8
                     'Tolerance',                          ...     % 9
                     'CI width (%)'                        ...     % 10
                     ) ;

   pm05.pg2_labels = char(                                 ...     % Regression Effects
                     'Unstd. regression coeff.',           ...     % 1
                     'Beta coefficient',                   ...     % 2
                     'Semipartial correlation',            ...     % 3
                     'Sq. semipartial corr.',              ...     % 4
                     'Squared partial corr.'               ...     % 5
                     ) ;

   pm05.pg3_labels = char(                                 ...     % Regression Effects
                     'Unstd. regression coeff.',           ...     % 1
                     'Std. regression coeff.',             ...     % 2 
                     'Semipartial corr. (sym)',            ...     % 3
                     'Semipartial corr. (asym)',           ...     % 4
                     'Sq-semipartial corr. (sym)',         ...     % 5
                     'Sq-semipartial corr. (asym)'         ...     % 6
                     ) ;

   pm05.pg4_labels = char(                                 ...     % Regression Effects
                     'Observed t value',                   ...     % 1
                     'Standard error',                     ...     % 2
                     'Degrees of freedom',                 ...     % 3
                     'Obtained P value',                   ...     % 4
                     'Tolerance of IV'                     ...     % 5
                     ) ;



   %% ====== Ind. 2 Grps Difference ===============================================

   pm06.hd_labels = char(                                  ...     % Ind. 2 Grps Difference
                     'Two Independent Groups'              ...     % 1
                     ) ;

   pm06.bg1_labels = char(                                 ...     % Ind. 2 Grps Difference
                     'Means & SDs',                        ...     % 1
                     'Obs. t value'                        ...     % 2
                     ) ;

   pm06.pg1_labels = char(                                 ...     % Ind. 2 Grps Difference
                     'Mean (Grp 1)',                       ...     % 1
                     'Mean (Grp 2)',                       ...     % 2
                     'SD (Grp 1)',                         ...     % 3
                     'SD (Grp 2)',                         ...     % 4
                     'Sample size (Grp 1)',                ...     % 5
                     'Sample size (Grp 2)',                ...     % 6
                     'Observed. t value',                  ...     % 7
                     'CI width (%)'                        ...     % 8
                     ) ;

   pm06.pg2_labels = char(                                 ...     % Ind. 2 Grps Difference
                     'Mean difference',                    ...     % 1
                     'Hedges'' g',                         ...     % 2
                     'Unbiased g',                         ...     % 3
                     'Glass'' delta',                      ...     % 4
                     'Unbiased delta',                     ...     % 5
                     'Bonett''s d'                         ...     % 6
                     ) ;

   pm06.pg3_labels = char(                                 ...     % Ind. 2 Grps Difference
                     'Mean difference',                    ...     % 1
                     'Hedges'' g',                         ...     % 2
                     'Unbiased g',                         ...     % 3
                     'Glass'' delta',                      ...     % 4
                     'Unbiased delta',                     ...     % 5
                     'Bonett''s d',                        ...     % 2
                     'Noncentral (equal var.)',            ...     % 7
                     'Noncentral (unequal var.)',          ...     % 8
                     'NC parameters (equal var.)',         ...     % 9
                     'NC parameters (uneq. var.)'          ...     % 10
                     ) ;

   pm06.pg4_labels = char(                                 ...     % Ind. 2 Grps Difference
                     't value (equal var.)',               ...     % 1
                     'df (equal var.)',                    ...     % 2
                     'P value (equal var.)',               ...     % 3
                     'Hedges'' c(m) adjuster',             ...     % 4
                     't value (unequal var.)',             ...     % 5
                     'df (unequal var.)',                  ...     % 6
                     'P value (unequal var.)',             ...     % 7
                     'Std. error (equal var.)',            ...     % 8
                     'Std. error (unequal var.)',          ...     % 9
                     'Observed t value',                   ...     % 10
                     'Degrees of freedom',                 ...     % 12
                     'Obtained P value'                    ...     % 13
                     ) ;



   %% ====== Dep. 2 Grps Difference ===============================================

   pm07.hd_labels = char(                                  ...     % Dep. 2 Grps Difference
                     'Two Dependent Groups',               ...     % 1
                     ' Group Differences',                 ...     % 2
                     ' Individual Change'                  ...     % 3
                     ) ;

   pm07.bg1_labels = char(                                 ...     % Dep. 2 Grps Difference
                     'Means/SDs & r',                      ...     % 1
                     'Means/SDs & t',                      ...     % 2
                     'Obs. t & r'                          ...     % 3
                     ) ;

   pm07.bg2_labels = char(                                 ...     % Dep. 2 Grps Difference
                     'Grp Difference',                     ...     % 1
                     'Ind. Change'                         ...     % 2
                     ) ;

   pm07.pg1_labels = char(                                 ...     % Dep. 2 Grps Difference
                     'Mean (Grp 1)',                       ...     % 1
                     'Mean (Grp 2)',                       ...     % 2
                     'SD (Grp 1)',                         ...     % 3
                     'SD (Grp 2)',                         ...     % 4
                     'Paired correlation',                 ...     % 5
                     'Sample size',                        ...     % 6
                     'Observed. t value',                  ...     % 7
                     'CI width (%)'                        ...     % 8
                     ) ;

   pm07.pg2_labels = char(                                 ...     % Dep. 2 Grps Difference
                     'Mean difference',                    ...     % 1
                     'Glass'' delta',                      ...     % 2
                     'Unbiased delta',                     ...     % 3
                     'Bonett''s d',                        ...     % 4
                     'Dunlap''s d',                        ...     % 5
                     'Hedges'' g',                         ...     % 6
                     'Unbiased g'                          ...     % 7
                     ) ;

   pm07.pg3_labels = char(                                 ...     % Dep. 2 Grps Difference
                     'Mean difference',                    ...     % 1
                     'Glass'' delta',                      ...     % 2
                     'Unbiased delta',                     ...     % 3
                     'Bonett''s d',                        ...     % 4
                     'Dunlap''s d',                        ...     % 5
                     'Noncentral',                         ...     % 6
                     'Noncentrality parameters',           ...     % 7
                     'Hedges'' g',                         ...     % 8
                     'Unbiased g'                          ...     % 9
                     ) ;

   pm07.pg4_labels = char(                                 ...     % Dep. 2 Grps Difference
                     'Observed t value',                   ...     % 1
                     'Degrees of freedom',                 ...     % 2
                     'Obtained P value',                   ...     % 3
                     'Sample correlation',                 ...     % 4
                     'Hedges'' c(m) adjuster',             ...     % 5
                     'Standard error'                      ...     % 6
                     ) ;



   %% ====== Linear Mean Contrasts ================================================

   pm08.hd_labels = char(                                  ...     % Linear Mean Contrasts
                     '  Between-Subjects Design  ',        ...     % 1
                     '   Within-Subjects Design  ',        ...     % 2
                     'Mixed Within-Between Design'         ...     % 3
                     ) ;

   pm08.bg1_labels = char(                                 ...     % Linear Mean Contrasts
                     'Between',                            ...     % 1
                     'Within',                             ...     % 2
                     'Mixed'                               ...     % 3
                     ) ;

   pm08.bg2_labels = char(                                 ...     % Linear Mean Contrasts
                     'B/S contrast',                       ...     % 1
                     'W/S contrast'                        ...     % 2
                     ) ;

   pm08.bg3_labels = char(                                 ...     % Linear Mean Contrasts
                     'Order No.',                          ...     % 1
                     'User MSE',                           ...     % 2 
                     'User df',                            ...     % 3
                     'No rescaling'                        ...     % 4
                     ) ;

   pm08.pg1_labels = char(                                 ...     % Linear Mean Contrasts
                     'Number of cell means',               ...     % 1
                     'CI width (%)',                       ...     % 2
                     'User-defined MSE value',             ...     % 3
                     'User-defined df value'               ...     % 4
                     ) ;

   pm08.pg2_labels = char(                                 ...     % Linear Mean Contrasts
                     'Raw mean contrast',                  ...     % 1
                     'Bonett''s d',                        ...     % 2
                     'Standardized d (pooled)',            ...     % 3
                     'Hedges'' g (Indv. Change)'           ...     % 4 
                     ) ;

   pm08.pg3_labels = char(                                 ...     % Linear Mean Contrasts
                     'Raw mean contrast',                  ...     % 1
                     'Bonett''s d',                        ...     % 2
                     'Standardized d (pooled)',            ...     % 3
                     'Standardized d (separate)',          ...     % 4
                     'Noncentral (Algina)',                ...     % 5
                     'Noncentrality parameters'            ...     % 6
                     ) ;

   pm08.pg4_labels = char(                                 ...     % Linear Mean Contrasts
                     'Observed t value',                   ...     % 1
                     'Degrees of freedom',                 ...     % 2
                     'Obtained P value',                   ...     % 3
                     'F value for contrast',               ...     % 4
                     'MS error',                           ...     % 5
                     't value (unequal var.)',             ...     % 6
                     'df (unequal var.)',                  ...     % 7
                     'P value (unequal var.)'              ...     % 8
                     ) ;

   pm08.pg5_labels = char(                                 ...     % Linear Mean Contrasts
                     'Cell means',                         ...     % 1
                     'B/S cell sample variances',          ....    % 2
                     'Sample Ns in each B/S cell',         ...     % 3
                     'Cell contrast weights',              ...     % 4
                     'W/S cell covariance matrix',         ...     % 5
                     'Sample size',                        ...     % 6
                     'Order number for design',            ...     % 7
                     'B/Subj:',                            ...     % 8
                     'W/Subj:'                             ...     % 9
                     ) ;



   %% ====== Binomial Proportion ==================================================

   pm09.hd_labels = char(                                  ...     % Binomial Proportion
                     ' Binomial Proportion',               ...     % 1
                     'Continuity-Correction'               ...     % 2
                     ) ;

   pm09.bg1_labels = char(                                 ...     % Binomial Proportion
                     'Proportion',                         ...     % 1
                     'No. successes'                       ...     % 2
                     ) ;

   pm09.bg2_labels = char(                                 ...     % Binomial Proportion
                     'Cont. correction',                   ...     % 1
                     'Wald test'                           ...     % 2
                     ) ;

   pm09.pg1_labels = char(                                 ...     % Binomial Proportion
                     'Sample proportion',                  ...     % 1
                     'Sample size',                        ...     % 2
                     'Null hypothesised pi',               ...     % 3
                     'No. of successes',                   ...     % 4
                     'CI width (%)'                        ...     % 5
                     ) ;

   pm09.pg2_labels = char(                                 ...     % Binomial Proportion
                     'ML estimate',                        ...     % 1
                     'Agresti-Coull estimate',             ...     % 2
                     'Wilson mid-point'                    ...     % 3
                     ) ;

   pm09.pg3_labels = char(                                 ...     % Binomial Proportion
                     'Large-sample Wald',                  ...     % 1
                     'Wilson score interval',              ...     % 2
                     'Agresti-Coull',                      ...     % 3
                     'Agresti-Coull +2/+4',                ...     % 4
                     'Mid-P interval',                     ...     % 5
                     'Blaker exact',                       ...     % 6
                     'Clopper-Pearson exact'               ...     % 7
                     ) ;

   pm09.pg4_labels = char(                                 ...     % Binomial Proportion
                     'Ex. Pr (p'' <= Pi || Pi >= p)',      ...     % 1
                     'Ex. Pr (p <= Pi || Pi >= p'')',      ...     % 2
                     'Exact Pr (Pi >= p)',                 ...     % 3
                     'Exact Pr (Pi <= p)',                 ...     % 4
                     'One-sided Mid-Pr (Pi > p)',          ...     % 5
                     'Z statistic (Score Test)',           ...     % 6
                     'P value (Score Test)',               ...     % 7
                     'Opposite extreme number',            ...     % 8
                     'Z statistic (Wald Test)',            ...     % 9
                     'P value (Wald Test)'                 ...     % 10
                     ) ;



   %% ====== SEM Fit Statistics ===================================================

   pm10.hd_labels = char(                                  ...     % SEM Fit Statistics
                     'SEM Fit Statistics ',                ...     % 1
                     'Mean Structure Model'                ...     % 2
                     ) ;

   pm10.bg1_labels = char(                                 ...     % SEM Fit Statistics
                     'Chi-square',                         ...     % 1
                     'Discrep. value'                      ...     % 2
                     ) ;

   pm10.bg2_labels = char(                                 ...     % SEM Fit Statistics
                     'ML-ECVI',                            ...     % 1
                     '# Model Parms',                      ...     % 2
                     'Mean Structure'                      ...     % 3
                     ) ;

   pm10.pg1_labels = char(                                 ...     % SEM Fit Statistics
                     'Model chi-square',                   ...     % 1
                     'Degree of freedom',                  ...     % 2
                     'Sample size',                        ...     % 3
                     'Number of groups',                   ...     % 4
                     'Null hypothesised RMSEA',            ...     % 5
                     'No. observed variables',             ...     % 6
                     'Sample discrepancy',                 ...     % 7
                     'No. model parameters',               ...     % 8
                     'CI width (%)'                        ...     % 9
                     ) ;

   pm10.pg2_labels = char(                                 ...     % SEM Fit Statistics
                     'Population discrepancy',             ...     % 1
                     'McDonald''s NCP',                    ...     % 2
                     'RMSEA',                              ...     % 3
                     'Gamma 1 (Pop. GFI)',                 ...     % 4
                     'Gamma 2 (Pop. AGFI)',                ...     % 5
                     'ECVI',                               ...     % 6
                     'ML ECVI'                             ...     % 7
                     ) ;

   pm10.pg3_labels = char(                                 ...     % SEM Fit Statistics
                     'Population discrepancy',             ...     % 1
                     'McDonald''s NCP',                    ...     % 2
                     'RMSEA',                              ...     % 3
                     'Gamma 1 (Pop. GFI)',                 ...     % 4
                     'Gamma 2 (Pop. AGFI)',                ...     % 5
                     'ECVI',                               ...     % 6
                     'NC parameters',                      ...     % 7
                     'ML ECVI',                            ...     % 8
                     'NC parameters (ML ECVI)'             ...     % 9
                     ) ;

   pm10.pg4_labels = char(                                 ...     % SEM Fit Statistics
                     'Model chi-square value',             ...     % 1
                     'Degrees of freedom',                 ...     % 2
                     'Exact P value',                      ...     % 3
                     'Approx. P value (accept)',           ...     % 4 
                     'Approx. P value (reject)',           ...     % 5
                     'No. model parameters',               ...     % 6
                     'No. observed variables'              ...     % 7
                     ) ;




%% ====== Setting Handles Structure ====================================================================================

   handles.pm02.hd_labels  = pm02.hd_labels ;
   handles.pm02.bg1_labels = pm02.bg1_labels ;
   handles.pm02.bg2_labels = pm02.bg2_labels ;
   handles.pm02.pg1_labels = pm02.pg1_labels ;
   handles.pm02.pg2_labels = pm02.pg2_labels ;
   handles.pm02.pg3_labels = pm02.pg3_labels ;
   handles.pm02.pg4_labels = pm02.pg4_labels ;

   handles.pm03.hd_labels  = pm03.hd_labels ;
   handles.pm03.bg1_labels = pm03.bg1_labels ;
   handles.pm03.pg1_labels = pm03.pg1_labels ;
   handles.pm03.pg2_labels = pm03.pg2_labels ;
   handles.pm03.pg3_labels = pm03.pg3_labels ;
   handles.pm03.pg4_labels = pm03.pg4_labels ;

   handles.pm04.hd_labels  = pm04.hd_labels ;
   handles.pm04.bg1_labels = pm04.bg1_labels ;
   handles.pm04.pg1_labels = pm04.pg1_labels ;
   handles.pm04.pg2_labels = pm04.pg2_labels ;
   handles.pm04.pg3_labels = pm04.pg3_labels ;
   handles.pm04.pg4_labels = pm04.pg4_labels ;

   handles.pm05.hd_labels  = pm05.hd_labels ;
   handles.pm05.bg1_labels = pm05.bg1_labels ;
   handles.pm05.pg1_labels = pm05.pg1_labels ;
   handles.pm05.pg2_labels = pm05.pg2_labels ;
   handles.pm05.pg3_labels = pm05.pg3_labels ;
   handles.pm05.pg4_labels = pm05.pg4_labels ;

   handles.pm06.hd_labels  = pm06.hd_labels ;
   handles.pm06.bg1_labels = pm06.bg1_labels ;
   handles.pm06.pg1_labels = pm06.pg1_labels ;
   handles.pm06.pg2_labels = pm06.pg2_labels ;
   handles.pm06.pg3_labels = pm06.pg3_labels ;
   handles.pm06.pg4_labels = pm06.pg4_labels ;

   handles.pm07.hd_labels  = pm07.hd_labels ;
   handles.pm07.bg1_labels = pm07.bg1_labels ;
   handles.pm07.bg2_labels = pm07.bg2_labels ;
   handles.pm07.pg1_labels = pm07.pg1_labels ;
   handles.pm07.pg2_labels = pm07.pg2_labels ;
   handles.pm07.pg3_labels = pm07.pg3_labels ;
   handles.pm07.pg4_labels = pm07.pg4_labels ;

   handles.pm08.hd_labels  = pm08.hd_labels ;
   handles.pm08.bg1_labels = pm08.bg1_labels ;
   handles.pm08.bg2_labels = pm08.bg2_labels ;
   handles.pm08.bg3_labels = pm08.bg3_labels ;
   handles.pm08.pg1_labels = pm08.pg1_labels ;
   handles.pm08.pg2_labels = pm08.pg2_labels ;
   handles.pm08.pg3_labels = pm08.pg3_labels ;
   handles.pm08.pg4_labels = pm08.pg4_labels ;
   handles.pm08.pg5_labels = pm08.pg5_labels ;

   handles.pm09.hd_labels  = pm09.hd_labels ;
   handles.pm09.bg1_labels = pm09.bg1_labels ;
   handles.pm09.bg2_labels = pm09.bg2_labels ;
   handles.pm09.pg1_labels = pm09.pg1_labels ;
   handles.pm09.pg2_labels = pm09.pg2_labels ;
   handles.pm09.pg3_labels = pm09.pg3_labels ;
   handles.pm09.pg4_labels = pm09.pg4_labels ;

   handles.pm10.hd_labels  = pm10.hd_labels ;
   handles.pm10.bg1_labels = pm10.bg1_labels ;
   handles.pm10.bg2_labels = pm10.bg2_labels ;
   handles.pm10.pg1_labels = pm10.pg1_labels ;
   handles.pm10.pg2_labels = pm10.pg2_labels ;
   handles.pm10.pg3_labels = pm10.pg3_labels ;
   handles.pm10.pg4_labels = pm10.pg4_labels ;

%% Setting handles for individual static text, edit, and check boxes ===================================================   

   % Identify and make handles of various handles numbers for various components of figure
   st_pg1 = char('st1_1', 'st1_2', 'st1_3', 'st1_4', 'st1_5', 'st1_6', 'st1_7', 'st1_8', 'st1_9');
   eb_pg1 = char('eb1_1', 'eb1_2', 'eb1_3', 'eb1_4', 'eb1_5', 'eb1_6', 'eb1_7', 'eb1_8', 'eb1_9');

   st_pg2 = char('st2_1', 'st2_2', 'st2_3', 'st2_4', 'st2_5', 'st2_6', 'st2_7');
   eb_pg2 = char('eb2_1', 'eb2_2', 'eb2_3', 'eb2_4', 'eb2_5', 'eb2_6', 'eb2_7');

   st_pg3 = char('st3_01', 'st3_02', 'st3_03', 'st3_04', 'st3_05', 'st3_06', ...
                 'st3_07', 'st3_08', 'st3_09', 'st3_10', 'st3_11');
   eb_pg3 = char('eb3_01a', 'eb3_01b', 'eb3_02a', 'eb3_02b', 'eb3_03a', 'eb3_03b', ...
                 'eb3_04a', 'eb3_04b', 'eb3_05a', 'eb3_05b', 'eb3_06a', 'eb3_06b', ...
                 'eb3_07a', 'eb3_07b', 'eb3_08a', 'eb3_08b', 'eb3_09a', 'eb3_09b', ...
                 'eb3_10a', 'eb3_10b', 'eb3_11a', 'eb3_11b');

   st_pg4 = char('st4_1', 'st4_2', 'st4_3', 'st4_4', 'st4_5', 'st4_6', 'st4_7', 'st4_8');
   eb_pg4 = char('eb4_1', 'eb4_2', 'eb4_3', 'eb4_4', 'eb4_5', 'eb4_6', 'eb4_7', 'eb4_8');

   st_pg5 = char('st5_1', 'st5_2', 'st5_3', 'st5_4', 'st5_5', 'st5_6', 'st5_7');
   eb_pg5 = char('eb5_1', 'eb5_2', 'eb5_3', 'eb5_4');

   rb_bg1 = char('rb1', 'rb2', 'rb3');
   rb_bg2 = char('rb4', 'rb5');
   cb_bg2 = char('cb1', 'cb2', 'cb3');
   cb_bg3 = char('cb4', 'cb5', 'cb6', 'cb7');
   st_hds = char('hd1', 'hd2', 'hd3');

   hst_pg1 = set_handles(st_pg1, 'Tag');
   hst_pg2 = set_handles(st_pg2, 'Tag');
   hst_pg3 = set_handles(st_pg3, 'Tag');
   hst_pg4 = set_handles(st_pg4, 'Tag');
   hst_pg5 = set_handles(st_pg5, 'Tag');
   hst_hds = set_handles(st_hds, 'Tag');

   heb_pg1 = set_handles(eb_pg1, 'Tag');
   heb_pg2 = set_handles(eb_pg2, 'Tag');
   heb_pg3 = set_handles(eb_pg3, 'Tag');
   heb_pg4 = set_handles(eb_pg4, 'Tag'); 
   heb_pg5 = set_handles(eb_pg5, 'Tag');

   hrb_bg1 = set_handles(rb_bg1, 'Tag');
   hrb_bg2 = set_handles(rb_bg2, 'Tag');
   hcb_bg2 = set_handles(cb_bg2, 'Tag');
   hcb_bg3 = set_handles(cb_bg3, 'Tag');

   handles.hst_pg1 = hst_pg1;
   handles.hst_pg2 = hst_pg2;
   handles.hst_pg3 = hst_pg3;
   handles.hst_pg4 = hst_pg4;
   handles.hst_pg5 = hst_pg5;
   handles.hst_hds = hst_hds;

   handles.heb_pg1 = heb_pg1;
   handles.heb_pg2 = heb_pg2;
   handles.heb_pg3 = heb_pg3;
   handles.heb_pg4 = heb_pg4;
   handles.heb_pg5 = heb_pg5;

   handles.hrb_bg1 = hrb_bg1;
   handles.hrb_bg2 = hrb_bg2;
   handles.hcb_bg2 = hcb_bg2;
   handles.hcb_bg3 = hcb_bg3;

   set (handles.hst_pg1,  'String', '' );
   set (handles.hst_pg2,  'String', '' );
   set (handles.hst_pg3,  'String', '' );
   set (handles.hst_pg4,  'String', '' );
   set (handles.hst_pg5,  'String', '' );

   set (handles.heb_pg1,  'String', '' );
   set (handles.heb_pg2,  'String', '' );
   set (handles.heb_pg3,  'String', '' );
   set (handles.heb_pg4,  'String', '' );
   set (handles.heb_pg5,  'String', '' );

   set (handles.hst_hds,  'String', '' );

   set (handles.pm1,      'Value', 1 );
   set (handles.pm2,      'Value', 1 );
   set (handles.pm3,      'Value', 1 );

   set (handles.rb1,      'Value', 1 );
   set (handles.rb2,      'Value', 0 );
   set (handles.rb3,      'Value', 0 );
   set (handles.rb4,      'Value', 1 );
   set (handles.rb5,      'Value', 0 );

   set (handles.cb1,      'Value', 0 );
   set (handles.cb2,      'Value', 0 );
   set (handles.cb3,      'Value', 0 );
   set (handles.cb4,      'Value', 0 );
   set (handles.cb5,      'Value', 0 );
   set (handles.cb6,      'Value', 0 );
   set (handles.cb7,      'Value', 0 );

   set (handles.heb_pg1,  'UserData', [] );
   set (handles.heb_pg2,  'UserData', [] );
   set (handles.heb_pg3,  'UserData', [] );
   set (handles.heb_pg4,  'UserData', [] );
   set (handles.heb_pg5,  'UserData', [] );

   set (handles.hst_pg1,  'Visible', 'off');
   set (handles.hst_pg2,  'Visible', 'off');
   set (handles.hst_pg3,  'Visible', 'off');
   set (handles.hst_pg4,  'Visible', 'off');
   set (handles.hst_pg5,  'Visible', 'off');

   set (handles.heb_pg1,  'Visible', 'off');
   set (handles.heb_pg2,  'Visible', 'off');
   set (handles.heb_pg3,  'Visible', 'off');
   set (handles.heb_pg4,  'Visible', 'off');
   set (handles.heb_pg5,  'Visible', 'off');

   set (handles.hst_hds,  'Visible', 'off' );

   set (handles.hrb_bg1,  'Visible', 'off' );
   set (handles.hrb_bg2,  'Visible', 'off' );
   set (handles.hcb_bg2,  'Visible', 'off' );
   set (handles.hcb_bg3,  'Visible', 'off' );

   set (handles.st_l,     'Visible', 'off');
   set (handles.st_u,     'Visible', 'off');   

   set (handles.heb_pg1,  'BackgroundColor', [1    , 1    , 1]);
   set (handles.heb_pg5,  'BackgroundColor', [1    , 1    , 1]);

   set (handles.pm2,      'BackgroundColor', [1    , 1    , 1]);
   set (handles.pm3,      'BackgroundColor', [1    , 1    , 1]);

   set (handles.tb1,      'BackgroundColor', [1    , 0    , 0]);      % Red
   
   set (handles.tb1,      'String', 'Enter data...');
   set (handles.tb1,      'Value', 0);


end 