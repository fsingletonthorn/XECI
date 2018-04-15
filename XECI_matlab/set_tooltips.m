function set_tooltips(handles)
%
% Utility function for inserting the appropriate tooltip into a property handle, 
% depending on the kind of analysis being run and data being analysed
%
%   INPUT:
%       handles = structure with handles and user data (see GUIDATA)
%
%
%   OUTPUT:
%       [null]
%
%
% See also XECIm
%

%
% VERSION HISTORY
%       Created:    11 Nov 2009 
%       Revised:    21 Jan 2012
%                   15 May 2012
%


    pm1 = get(handles.pm1,  'Value');

    rb1 = get(handles.rb1,  'Value');
    rb2 = get(handles.rb2,  'Value');
    rb3 = get(handles.rb3,  'Value');
    rb4 = get(handles.rb4,  'Value');
    rb5 = get(handles.rb5,  'Value');

    cb1 = get(handles.cb1,  'Value');
    cb2 = get(handles.cb2,  'Value');
    cb4 = get(handles.cb4,  'Value');
    cb5 = get(handles.cb5,  'Value');
    cb7 = get(handles.cb7,  'Value');



    %% Main features of program

    set (handles.pm1, 'TooltipString', sprintf(' Select the desired kind of analysis ') );
%     set (handles.tb1, 'TooltipString', sprintf(' Press this red toggle button to get your results \n (it will change colour to "green" and say "Completed")') );
    set (handles.pb1, 'TooltipString', sprintf(' Press this button to reset the XECI interface window ') );



    %% 2 x 2 Contingency Table option -----------------------------------------

    if (pm1 == 2)
        set (handles.rb1, 'TooltipString', sprintf(' Calculates sample odds ratio estimates, confidence intervals, and exact tests ') );
        set (handles.rb2, 'TooltipString', sprintf(' Calculates sample relative risk ratio estimates, confidence intervals, and exact tests ') );
        set (handles.rb3, 'TooltipString', sprintf(' Calculates inter-rater reliability estimates and confidence intervals ') );

        if (rb1 == 1)
            set (handles.st1_1,  'TooltipString', sprintf(' Frequency count for cell (1,1) in 2x2 table ') );
            set (handles.st1_2,  'TooltipString', sprintf(' Frequency count for cell (1,2) in 2x2 table ') );
            set (handles.st1_3,  'TooltipString', sprintf(' Frequency count for cell (2,1) in 2x2 table ') );
            set (handles.st1_4,  'TooltipString', sprintf(' Frequency count for cell (2,2) in 2x2 table ') );
            set (handles.st1_5,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            set (handles.st2_1,  'TooltipString', sprintf(' Observed odds ratio calculated as (A*D)/(B*C) \n ...makes no adjustment for any zero cell frequencies ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Gart''s adjusted odds ratio, with 0.5 added to each cell value \n (avoids problems from cell zero frequencies) ') );
            set (handles.st2_3,  'TooltipString', sprintf(' Adjusted odds ratio using the Agresti-Coull method \n using smoothed cell frequencies from the independence model \n (avoids problems from zero cell frequencies) ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for Woolf''s (unadjusted) odds ratio \n (may not be calculated when zero cell frequencies occur) ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Gart''s adjusted odds ratio \n (calculated using +0.5 being added to all four cell frequencies) ') );
            set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for the Agresti-Coull adjusted odds ratio \n (using independence model smoothed cell frequencies) ') );
            set (handles.st3_04, 'TooltipString', sprintf(' Exact confidence interval for odds ratio using the Clopper-Pearson method ') );
            set (handles.st3_05, 'TooltipString', sprintf(' Exact confidence interval for odds ratio using the mid-P method ') );
            
            set (handles.cb1,    'TooltipString', sprintf(' Check this box to invert the odds ratio findings \n in the output boxes (then press Calculate... button again)') );
            

        elseif (rb2 == 1)
            set (handles.st1_1,  'TooltipString', sprintf(' Frequency count for "treatment" group with +ve outcome \n in 2x2 table [cell(1,1)] ') );
            set (handles.st1_2,  'TooltipString', sprintf(' Frequency count for "treatment" group with —ve outcome \n in 2x2 table [cell(1,2)] ') );
            set (handles.st1_3,  'TooltipString', sprintf(' Frequency count for "comparison" group with +ve outcome \n in 2x2 table [cell(2,1)] ') );
            set (handles.st1_4,  'TooltipString', sprintf(' Frequency count for "comparison" group with —ve outcome \n in 2x2 table [cell(2,2)] ') );
            set (handles.st1_5,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            set (handles.st2_1,  'TooltipString', sprintf(' Observed risk ratio...makes no adjustment for any zero cell frequencies ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Adjusted odds ratio, using Agresti''s +1 cell frequencies model (avoids problems from zero frequencies) ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for unadjusted risk ratio (may not be calculated when zero cell frequencies occur) ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Agresti''s adjusted risk ratio (calculated using 1 added to all cell frequencies) ') );

        elseif (rb3 == 1)
            set (handles.st1_1,  'TooltipString', sprintf(' Frequency count when rater 1 and rater 2 \n both equal YES [cell(1,1)] ') );
            set (handles.st1_2,  'TooltipString', sprintf(' Frequency count when rater 1 equals YES and \n rater 2 equals NO [cell(1,2)] ') );
            set (handles.st1_3,  'TooltipString', sprintf(' Frequency count when rater 2 equals NO and \n rater 1 equals YES [cell(2,1)] ') );
            set (handles.st1_4,  'TooltipString', sprintf(' Frequency count when rater 1 and rater 2 \n both equals NO [cell(2,2)] ') );
            set (handles.st1_5,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            set (handles.st2_1,  'TooltipString', sprintf(' Cohen''s kappa statistic ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Scott''s pi statistic (Byrt et al.''s kappa \n adjusted for bias in cell frequencies) ') );
            set (handles.st2_3,  'TooltipString', sprintf(' Byrt et al.''s prevalence-adjusted and \n bias-adjusted (PABAK) kappa statistic ') );
            set (handles.st2_4,  'TooltipString', sprintf(' Observed agreement proportion between two raters ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Large sample confidence interval for Cohen''s kappa ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Clopper-Pearson exact confidence interval \n for prevalence-adjusted and bias-adjusted kappa ') );
            set (handles.st3_03, 'TooltipString', sprintf(' Score confidence interval for prevalence-adjusted and bias-adjusted kappa \n (calculated using Wilson''s (1927) score test method) ') );
            set (handles.st3_04, 'TooltipString', sprintf(' Clopper-Pearson exact confidence interval for observed agreement ') );
            set (handles.st3_05, 'TooltipString', sprintf(' Score confidence interval for observed agreement \n (calculated using Wilson''s (1927) score test method) ') );

        end

        if (rb3 ~= 1)
            set (handles.st4_1, 'TooltipString', sprintf(' Pearson chi-square value for association \n between rows and columns of contingency table ') );
            set (handles.st4_2, 'TooltipString', sprintf(' Obtained P value for Pearson chi-square test statistic value ') );
            set (handles.st4_3, 'TooltipString', sprintf(' Yates'' continuity-corrected chi-square value for \n association between rows and columns of contingency table ') );
            set (handles.st4_4, 'TooltipString', sprintf(' Obtained P value for Yates'' continuity-corrected \n chi-square test statistic value ') );
            set (handles.st4_5, 'TooltipString', sprintf(' One-sided Fisher exact P value for testing independence \n in the 2-way contingency table ') );
            set (handles.st4_6, 'TooltipString', sprintf(' Two-sided Fisher exact P value for testing independence \n in the 2-way contingency table') );
            set (handles.st4_7, 'TooltipString', sprintf(' One-sided exact mid-P value for testing independence in \n the 2-way contingency table ') );
            set (handles.st4_8, 'TooltipString', sprintf(' Two-sided exact mid-P value for testing independence in \n the 2-way contingency table') );
        elseif (rb3 == 1)
            set (handles.st4_1, 'TooltipString', sprintf(' Chance agreement betwen raters based on their marginal totals ') );
            set (handles.st4_2, 'TooltipString', sprintf(' Proportion of agreement in A and D cells of table, \n i.e., cell (1,1) and cell(2,2) ') );
            set (handles.st4_3, 'TooltipString', sprintf(' Difference in B and C cells as a proportion of N, \n i.e., cell (1,2) and cell(2,1) ') );
        end
    end



    %% Pearson Correlations option --------------------------------------------

    if (pm1 == 3)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating associations between two continuously-measured constructs . ') );
        set (handles.rb1, 'TooltipString', sprintf(' Pearson correlation between scores on two variables. ') );
        set (handles.rb2, 'TooltipString', sprintf(' Pearson correlation between scores on two variables when partialling out scores on one or more other variables. ') );

        set (handles.st1_1, 'TooltipString', sprintf(' Sample correlation value ') );
        set (handles.st1_2, 'TooltipString', sprintf(' Sample size for correlation value ') );
        set (handles.st1_3, 'TooltipString', sprintf(' User-defined null hypothesised population correlation value (-1 < population rho < +1)') );

        if  (rb1 == 1)
            set (handles.st1_4,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );
            set (handles.st2_1,  'TooltipString', sprintf(' Sample correlation value ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Unbiased estimate of correlation value ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for sample Pearson correlation value \n using Fisher''s r-to-z transformation ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for unbiased estimate of Pearson correlation \n using Fisher''s r-to-z transformation ') );
            set (handles.st3_03, 'TooltipString', sprintf(' Exact confidence interval from CDF of Pearson correlation coefficient \n using the sample correlation value ') );
            set (handles.st3_04, 'TooltipString', sprintf(' Exact confidence interval from CDF of Pearson correlation coefficient \n using the unbiased sample estimate ') );

        elseif (rb2 == 1)
            set (handles.st1_4,  'TooltipString', sprintf(' Number of variables to be partialled out in calculating \n confidence interval for partial correlation ') );
            set (handles.st1_5,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );
            set (handles.st2_1,  'TooltipString', sprintf(' Sample partial correlation value ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Unbiased estimate of partial correlation value ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for partial correlation value \n using Fisher''s r-to-z transformation ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for unbiased estimate of partial correlation \n using Fisher''s r-to-z transformation ') );
            set (handles.st3_03, 'TooltipString', sprintf(' Exact confidence interval from CDF of Pearson correlation coefficient \n using the sample partial correlation value ') );
            set (handles.st3_04, 'TooltipString', sprintf(' Exact confidence interval from CDF of Pearson correlation coefficient \n using the unbiased estimate of the partial correlation ') );

        end

        set (handles.st4_1, 'TooltipString', sprintf(' Observed t statistic value (Ho: rho = 0)') );
        set (handles.st4_2, 'TooltipString', sprintf(' Degrees of freedom for t statistic ') );
        set (handles.st4_3, 'TooltipString', sprintf(' Observed P value for t statistic ') );
        set (handles.st4_4, 'TooltipString', sprintf(' Observed P value for user-defined null hypothesised rho value ') );

    end



    %% R-squared option --------------------------------------------

    if (pm1 == 4)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating strength of prediction in multiple linear regression models. ') );
        set (handles.rb1, 'TooltipString', sprintf(' Uses sample R-sq value directly as input to obtain confidence intervals. ') );
        set (handles.rb2, 'TooltipString', sprintf(' Derives sample R-square value indirectly from \n entering observed F test value associated with R-square. ') );

        if (rb1 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Sample R-squared value from fitting \n multiple linear regression model ') );
        elseif (rb2 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Observed F statistic from ANOVA table \n for multiple linear regression model ') );
        end

        set (handles.st1_2,  'TooltipString', sprintf(' Number of independent variables used in regression model ') );
        set (handles.st1_3,  'TooltipString', sprintf(' Sample size used in regression model ') );
        set (handles.st1_4,  'TooltipString', sprintf(' User-defined null hypothesised population \n rho-squared value (0 < population rho-sq < 1)') );
        set (handles.st1_5,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

        set (handles.st2_1,  'TooltipString', sprintf(' Sample R-squared value ') );
        set (handles.st2_2,  'TooltipString', sprintf(' Unbiased estimate of R-squared value ') );
        set (handles.st2_3,  'TooltipString', sprintf(' Sample multiple correlation coefficient value ') );

        set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for R-square \n under random scores assumption ') );
        set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Olkin-Pratt unbiased estimate \n of R-square under random scores assumption ') );
        set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for R-square under fixed scores assumption ') );
        set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for multiple correlation coefficient \n under random scores assumption ') );

        set (handles.st4_1,  'TooltipString', sprintf(' Usual observed F test value (for Ho: rho-sq = 0) ') );
        set (handles.st4_2,  'TooltipString', sprintf(' Degrees of freedom in numerator under null-hypothesised value of zero ') );
        set (handles.st4_3,  'TooltipString', sprintf(' Degrees of freedom in denominator under null-hypothesised value of zero ') );
        set (handles.st4_4,  'TooltipString', sprintf(' Observed P value for F test under null-hypothesised value of zero') );
        set (handles.st4_5,  'TooltipString', sprintf(' Observed F test value for user-defined null hypothesised non-zero value of rho-squared ') );
        set (handles.st4_6,  'TooltipString', sprintf(' Degrees of freedom in numerator under user-defined null-hypothesised value > zero ') );
        set (handles.st4_7,  'TooltipString', sprintf(' Degrees of freedom in denominator  under user-defined null-hypothesised value > zero ') );
        set (handles.st4_8,  'TooltipString', sprintf(' Observed P value for F test  under user-defined null-hypothesised value > zero ') );

    end



    %% Linear regression option -----------------------------------------------

    if (pm1 == 5)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating strength of prediction of a single independent variables in multiple linear regression models. ') );
        set (handles.rb1, 'TooltipString', sprintf(' Uses unstandardised regression coefficient and its standard error as input to obtain confidence intervals. ') );
        set (handles.rb2, 'TooltipString', sprintf(' Uses unstandardised regression coefficient and its tolerance as input to obtain confidence intervals. ') );
        set (handles.rb3, 'TooltipString', sprintf(' Uses semipartial correlation value coefficient and standard error of regression coefficient as input to obtain confidence intervals. ') );

        if (rb1 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Value of sample unstandardized regression coefficient for focal independent variable ') );
            set (handles.st1_3, 'TooltipString', sprintf(' Value of standard error of unstandardized regression coefficient for focal independent variable ') );
        elseif (rb2 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Value of sample unstandardized regression coefficient for focal independent variable ') );
            set (handles.st1_3, 'TooltipString', sprintf(' Tolerance value of focal independent variable ') );
        elseif (rb3 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Value of sample semipartial correlation coefficient for focal independent variable ') );
            set (handles.st1_3, 'TooltipString', sprintf(' Value of standard error of unstandardized regression coefficient for focal independent variable ') );
        end

        set (handles.st1_2,  'TooltipString', sprintf(' Sample R-sq value for multiple linear regression model ') );
        set (handles.st1_4,  'TooltipString', sprintf(' Sample size used in multiple linear regression model ') );
        set (handles.st1_5,  'TooltipString', sprintf(' Total number of independent variables in multiple linear regression model ') );
        set (handles.st1_6,  'TooltipString', sprintf(' Value of sample standard deviation of dependent variable ') );
        set (handles.st1_7,  'TooltipString', sprintf(' Value of sample standard deviation of focal independent variable ') );
        set (handles.st1_8,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

        set (handles.st2_1,  'TooltipString', sprintf(' Sample R-squared value ') );
        set (handles.st2_2,  'TooltipString', sprintf(' Unbiased estimate of R-squared value ') );
        set (handles.st2_3,  'TooltipString', sprintf(' Sample multiple correlation coefficient value ') );

        set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for R-square under random scores assumption ') );
        set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Olkin-Pratt unbiased estimate of R-square under random scores assumption ') );
        set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for R-square under fixed scores assumption ') );
        set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for multiple correlation coefficient under random scores assumption ') );

        set (handles.st4_1,  'TooltipString', sprintf(' Observed t statistic value for coefficients of focal independent variable ') );
        set (handles.st4_2,  'TooltipString', sprintf(' Standard error of unstandardised regression coefficient ') );
        set (handles.st4_3,  'TooltipString', sprintf(' Degrees of freedom for residual terms in multiple linear regression model ') );
        set (handles.st4_4,  'TooltipString', sprintf(' Observed P value for coefficients of focal independent variable ') );
        set (handles.st4_5,  'TooltipString', sprintf(' Tolerance value of focal independent variable ') );


    end



    %% Independent samples option ----------------------------------------------

    if (pm1 == 6)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating differences between two independent samples. ') );
        set (handles.rb1, 'TooltipString', sprintf(' Uses group means and SDs, but not observed t test value. ') );
        set (handles.rb2, 'TooltipString', sprintf(' Uses observed t statistic value when group means and SDs are unknown. ') );

        if  (rb1 == 1) && (rb2 == 0)
            set (handles.st1_1,  'TooltipString', sprintf(' Sample mean of 1st independent group ') );
            set (handles.st1_2,  'TooltipString', sprintf(' Sample mean of 2nd independent group ') );
            set (handles.st1_3,  'TooltipString', sprintf(' Sample standard deviation of 1st independent group ') );
            set (handles.st1_4,  'TooltipString', sprintf(' Sample standard deviation of 2nd independent group ') );
            set (handles.st1_5,  'TooltipString', sprintf(' Sample size of 1st independent group ') );
            set (handles.st1_7,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            set (handles.st2_1,  'TooltipString', sprintf(' Observed raw mean difference between sample means  of the two groups ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Hedges'' standardized mean difference using pooled SD ') );
            set (handles.st2_3,  'TooltipString', sprintf(' Hedges'' unbiased standardized mean difference using pooled SD ') );
            set (handles.st2_4,  'TooltipString', sprintf(' Glass'' standardized mean difference using SD of 1st group ') );
            set (handles.st2_5,  'TooltipString', sprintf(' Glass'' unbiased standardized mean difference using SD of 1st group ') );
            set (handles.st2_6,  'TooltipString', sprintf(' Bonett''s standardized mean difference (does not assume equal variances) ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Observed raw mean difference between sample means  of the two groups ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Hedges'' standardized mean difference using pooled SD ') );
            set (handles.st3_03, 'TooltipString', sprintf(' Hedges'' unbiased standardized mean difference using pooled SD ') );
            set (handles.st3_04, 'TooltipString', sprintf(' Glass'' standardized mean difference using SD of 1st group ') );
            set (handles.st3_05, 'TooltipString', sprintf(' Glass'' unbiased standardized mean difference using SD of 1st group ') );
            set (handles.st3_06, 'TooltipString', sprintf(' Bonett''s standardized mean difference (does not assume equal variances) ') );
            set (handles.st3_07, 'TooltipString', sprintf(' Exact CI for standardized mean difference (assumes equal variances) ') );
            set (handles.st3_08, 'TooltipString', sprintf(' Exact CI for standardized mean difference (does not assume equal variances) ') );
            set (handles.st3_09, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (assumption of equal variances) ') );
            set (handles.st3_10, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (no assumption of equal variances) ') );

            set (handles.st4_1,  'TooltipString', sprintf(' Observed t statistic value (equal variances)') );
            set (handles.st4_2,  'TooltipString', sprintf(' Degrees of freedom for t statistic (equal variances) ') );
            set (handles.st4_3,  'TooltipString', sprintf(' Observed P value for null hypothesis (equal variances) ') );
            set (handles.st4_4,  'TooltipString', sprintf(' Hedges'' correction statistic used in calculating unbiased g ') );
            set (handles.st4_5,  'TooltipString', sprintf(' Observed t statistic value (unequal variances) ') );
            set (handles.st4_6,  'TooltipString', sprintf(' Degrees of freedom for t statistic (unequal variances) ') );
            set (handles.st4_7,  'TooltipString', sprintf(' Observed P value for null hypothesis (unequal variances) ') );
            set (handles.st4_8,  'TooltipString', sprintf(' Pooled standard error of sample mean difference ') );

        elseif  (rb1 == 0) && (rb2 == 1)
            set (handles.st1_1,  'TooltipString', sprintf(' Observed t statistic value ') );
            set (handles.st1_2,  'TooltipString', sprintf(' Sample size of first group ') );
            set (handles.st1_3,  'TooltipString', sprintf(' Sample size of second group ') );
            set (handles.st1_4,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            set (handles.st2_1,  'TooltipString', sprintf(' Hedges'' standardized mean difference using pooled SD ') );
            set (handles.st2_2,  'TooltipString', sprintf(' Hedges'' unbiased standardized mean difference using pooled SD ') );

            set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for Hedges'' standardized mean difference ') );
            set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Hedges'' unbiased standardized mean difference ') );
            set (handles.st3_03, 'TooltipString', sprintf(' Exact CI for standardized mean difference (assumes equal variances) ') );
            set (handles.st3_04, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (assumption of equal variances) ') );

            set (handles.st4_1,  'TooltipString', sprintf(' Observed t statistic value (equal variances)') );
            set (handles.st4_2,  'TooltipString', sprintf(' Degrees of freedom for t statistic (equal variances) ') );
            set (handles.st4_3,  'TooltipString', sprintf(' Observed P value for null hypothesis (equal variances) ') );
            set (handles.st4_4,  'TooltipString', sprintf(' Hedges'' correction statistic used in calculating unbiased g ') );

        end

    end



    %% Dependent samples option ------------------------------------------------

    if (pm1 == 7)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating differences between two independent samples ') );
        set (handles.rb1, 'TooltipString', sprintf(' Uses group means and SDs, plus correlation between group scores ') );
        set (handles.rb2, 'TooltipString', sprintf(' Uses group means and SDs, plus observed t statistic value to derive paired correlation. ') );
        set (handles.rb3, 'TooltipString', sprintf(' Uses observed t value and correlation between group scores when group means and SDs are unknown. ') );

        if (rb1 == 1)

            set (handles.st1_1, 'TooltipString', sprintf(' Sample mean of 1st dependent group ') );
            set (handles.st1_2, 'TooltipString', sprintf(' Sample mean of 2nd dependent group ') );
            set (handles.st1_3, 'TooltipString', sprintf(' Sample standard deviation of 1st dependent group ') );
            set (handles.st1_4, 'TooltipString', sprintf(' Sample standard deviation of 2nd dependent group ') );
            set (handles.st1_5, 'TooltipString', sprintf(' Sample correlation between scores of two dependent groups ') );
            set (handles.st1_6, 'TooltipString', sprintf(' Sample size of paired groups ') );
            set (handles.st1_7, 'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            if (rb4 == 1) && (rb5 == 0)
                set (handles.st2_1,  'TooltipString', sprintf(' Hedges'' standardized mean difference using SD of individual change scores') );
                set (handles.st2_2,  'TooltipString', sprintf(' Hedges'' unbiased standardized mean difference using SD of individual change scores ') );

                set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for Hedges'' standardized mean change score ') );
                set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Hedges'' unbiased standardized mean change score ') );
                set (handles.st3_03, 'TooltipString', sprintf(' Exact confidence interval for standardized mean change score difference (assumes equal variances) ') );
                set (handles.st3_04, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (assumes equal variances) ') );

            elseif (rb4 == 0) && (rb5 == 1)
                set (handles.st2_1,  'TooltipString', sprintf(' Observed mean difference between the two dependent groups ') );
                set (handles.st2_2,  'TooltipString', sprintf(' Glass'' standardized mean group difference using 1st dependent group SD ') );
                set (handles.st2_3,  'TooltipString', sprintf(' Glass'' unbiased standardized mean difference using 1st dependent group SD ') );
                set (handles.st2_4,  'TooltipString', sprintf(' Dunlap et al.''s standardized mean difference (assumes equal variances) ') );
                set (handles.st2_5,  'TooltipString', sprintf(' Bonett''s standardized mean difference (does not assume equal variances) ') );

                set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for unstandardized mean difference ') );
                set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Glass'' standardized mean difference ') );
                set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for Glass'' unbiased standardized mean difference ') );
                set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for Dunlap et al.''s standardized mean difference (assumes equal variances) ') );
                set (handles.st3_05, 'TooltipString', sprintf(' Confidence interval for Bonett''s standardized mean difference (does not assume equal variances) ') );
                set (handles.st3_06, 'TooltipString', sprintf(' Exact confidence interval for standardized mean difference (assumes equal variances) ') );
                set (handles.st3_07, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (assumption of equal variances) ') );
            end


        elseif (rb2 == 1)

            set (handles.st1_1, 'TooltipString', sprintf(' Sample mean of 1st dependent group ') );
            set (handles.st1_2, 'TooltipString', sprintf(' Sample mean of 2nd dependent group ') );
            set (handles.st1_3, 'TooltipString', sprintf(' Sample standard deviation of 1st dependent group ') );
            set (handles.st1_4, 'TooltipString', sprintf(' Sample standard deviation of 2nd dependent group ') );
            set (handles.st1_5, 'TooltipString', sprintf(' Observed sample t test statistic value ') );
            set (handles.st1_6, 'TooltipString', sprintf(' Sample size of paired groups ') );
            set (handles.st1_7, 'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            if (rb4 == 1) && (rb5 == 0)
                set (handles.st2_1,  'TooltipString', sprintf(' Hedges'' standardized mean difference using SD of individual change scores') );
                set (handles.st2_2,  'TooltipString', sprintf(' Hedges'' unbiased standardized mean difference using SD of individual change scores ') );

                set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for Hedges'' standardized mean change score ') );
                set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Hedges'' unbiased standardized mean change score ') );
                set (handles.st3_03, 'TooltipString', sprintf(' Exact confidence interval for standardized mean change score difference (assumes equal variances) ') );
                set (handles.st3_04, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (assumes equal variances) ') );

            elseif (rb4 == 0) && (rb5 == 1)
                set (handles.st2_1,  'TooltipString', sprintf(' Observed mean difference between the two dependent groups ') );
                set (handles.st2_2,  'TooltipString', sprintf(' Glass'' standardized mean group difference using 1st dependent group SD ') );
                set (handles.st2_3,  'TooltipString', sprintf(' Glass'' unbiased standardized mean difference using 1st dependent group SD ') );
                set (handles.st2_4,  'TooltipString', sprintf(' Dunlap et al.''s standardized mean difference (assumes equal variances) ') );
                set (handles.st2_5,  'TooltipString', sprintf(' Bonett''s standardized mean difference (does not assume equal variances) ') );

                set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for unstandardized mean difference ') );
                set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Glass'' standardized mean difference ') );
                set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for Glass'' unbiased standardized mean difference ') );
                set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for Dunlap et al.''s standardized mean difference (assumes equal variances) ') );
                set (handles.st3_05, 'TooltipString', sprintf(' Confidence interval for Bonett''s standardized mean difference (does not assume equal variances) ') );
                set (handles.st3_06, 'TooltipString', sprintf(' Exact confidence interval for standardized mean difference (assumes equal variances) ') );
                set (handles.st3_07, 'TooltipString', sprintf(' Noncentrality parameter values from noncentral t distribution (assumption of equal variances) ') );
            end

        elseif (rb3 == 1)

            set (handles.st1_1, 'TooltipString', sprintf(' Observed sample t test statistic value ') );
            set (handles.st1_2, 'TooltipString', sprintf(' Sample correlation between scores of two dependent groups (give estimate if unknown)') );
            set (handles.st1_3, 'TooltipString', sprintf(' Sample size of the two dependent groups ') );
            set (handles.st1_4, 'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

            if (rb4 == 1) && (rb5 == 0)
                set (handles.st2_1,  'TooltipString', sprintf(' Hedges'' standardized mean difference using SD of individual change scores') );
                set (handles.st2_2,  'TooltipString', sprintf(' Hedges'' unbiased standardized mean difference using SD of individual change scores ') );

                set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for Hedges'' standardized mean change score ') );
                set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Hedges'' unbiased standardized mean change score ') );
                set (handles.st3_03, 'TooltipString', sprintf(' Exact confidence interval for standardized mean change score difference (assumes homoscedasticity) ') );
                set (handles.st3_04, 'TooltipString', sprintf(' Noncentrality parameter values obtained from quantiles of non-central t distribution for exact confidence interval ') );

            elseif  (rb4 == 0) && (rb5 == 1)
                set (handles.st2_1,  'TooltipString', sprintf(' Dunlap et al.''s standardized mean group difference (assumes equal variances)') );

                set (handles.st3_01, 'TooltipString', sprintf(' Exact confidence interval for standardized mean difference (assumes equal variances) ') );
                set (handles.st3_02, 'TooltipString', sprintf(' Noncentrality parameter values obtained from quantiles of non-central t distribution for exact confidence interval ') );
            end

        end


        set (handles.st4_1, 'TooltipString', sprintf(' Observed t test statistic value ') );
        set (handles.st4_2, 'TooltipString', sprintf(' Degrees of freedom for t test statistic ') );
        set (handles.st4_3, 'TooltipString', sprintf(' Observed P value for testing null hypothesis ') );
        set (handles.st4_4, 'TooltipString', sprintf(' Sample correlation between dependent sample scores ') );
        set (handles.st4_5, 'TooltipString', sprintf(' Unbiased estimate of population correlation between dependent sample scores (Olkin & Pratt, 1958)') );
        set (handles.st4_6, 'TooltipString', sprintf(' Hedges'' correction statistic used in calculating unbiased g ') );
        set (handles.st4_7, 'TooltipString', sprintf(' Standard error of sample mean difference ') );

    end



    %% Linear contrasts option ------------------------------------------------

    if (pm1 == 8)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating differences from linear contrasts using a cell means model approach') );

        set (handles.rb1, 'TooltipString', sprintf(' For between-subjects designs ') );
        set (handles.rb2, 'TooltipString', sprintf(' For within-subjects designs ') );
        set (handles.rb3, 'TooltipString', sprintf(' For mixed-designs ') );
        set (handles.rb4, 'TooltipString', sprintf(' For a between-subjects contrasts in a mixed designs ') );
        set (handles.rb5, 'TooltipString', sprintf(' For a within-subjects contrasts in a mixed designs ') );

        set (handles.cb4, 'TooltipString', sprintf(' Check this box if you wish to specify the order number of the contrast (default unchecked box is zero for main effects) ') );
        set (handles.cb5, 'TooltipString', sprintf(' Check this box if you wish to supply a user-defined mean square error value to use in calculations (default unchecked box uses internal calculation for MSE) ') );
        set (handles.cb6, 'TooltipString', sprintf(' Check this box if you DO NOT want the contrast weights to be rescaled to mean difference scaling for given order of contrast (default unchecked box means rescaling = YES) ') );
        set (handles.cb7, 'TooltipString', sprintf(' Check this box if you wish to supply a user-defined degrees of freedom value to use in calculations (default unchecked box uses internal calculation for df) ') );

        set (handles.st1_1, 'TooltipString', sprintf(' Number of cell means in the linear contrast being specified ') );
        set (handles.st1_2, 'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

        if (cb5 == 1)
            set (handles.st1_3, 'TooltipString', sprintf(' Specify user-defined mean square error value (rather than use default internal calculation) ') );
            if (cb7 == 1)
                set (handles.st1_4, 'TooltipString', sprintf(' Specify user-defined degrees of freedom (rather than use default internal calculation) ') );
            end
        elseif (cb5 == 0)
            if (cb7 == 1)
                set (handles.st1_3, 'TooltipString', sprintf(' Specify user-defined degrees of freedom (rather than use default internal calculation) ') );
            end
        end

        set (handles.st2_1,  'TooltipString', sprintf(' Raw mean contrast value ') );
        set (handles.st2_2,  'TooltipString', sprintf(' Bonett''s standardized mean contrast value (does not assume equal variances) ') );
        set (handles.st2_3,  'TooltipString', sprintf(' Bird''s standardized mean contrast value (assumes homogeneity of variances) ') );

        set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for raw mean contrast value ') );
        set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for Bonett''s standardized mean contrast value (assumes normality but not equal variances) ') );
        set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for Bird''s standardized mean contrast value (assumes homogeneity of variances) ') );
        set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for standardized mean contrast value (uses separate variances estimate) ') );
        set (handles.st3_05, 'TooltipString', sprintf(' Confidence interval for standardised mean contrast based on Algina-Keselman noncentrality parameter value method ') );
        set (handles.st3_06, 'TooltipString', sprintf(' Noncentral parameter values used in Algina-Keselman noncentrality parameter value confidence interval ') );

        set (handles.st5_1,  'TooltipString', sprintf(' Enter row vector of cell mean values ') );
        set (handles.st5_4,  'TooltipString', sprintf(' Enter row vector of contrast weights (must sum to zero) ') );


        if (rb1 == 1)
            set (handles.st5_2, 'TooltipString', sprintf(' Enter row vector of variances for each cell of B/S design ') );
            set (handles.st5_3, 'TooltipString', sprintf(' Enter row vector of sample sizes in each cell (if balanced, you can enter one value only) ') );

        elseif (rb2 == 1)
            set (handles.st2_4, 'TooltipString', sprintf(' Standardised mean contrast value assuming individual change rather than group difference ') );
            set (handles.st5_2, 'TooltipString', sprintf(' Enter full covariance matrix for cells of W/S design ') );
            set (handles.st5_3, 'TooltipString', sprintf(' Enter sample size for W/S design ') );

        elseif (rb3 == 1)
            set (handles.st5_2, 'TooltipString', sprintf(' Enter full covariance matrix for cells of W/S design for each level of the B/S design (can be stacked or block diagonal) ') );
            set (handles.st5_3, 'TooltipString', sprintf(' Enter row vector for each sample size in each level of the B/S design ') );
            if (rb5 == 1)
                set (handles.st5_4, 'TooltipString', sprintf(' Enter two row vectors for contrast weights for B/S (row 1) and W/S (row 2)...(each row must sum to zero). ') );
            end
        end

        if (cb4 == 1)
            set (handles.st5_5, 'TooltipString', sprintf(' Order number of design (e.g., 2-way interaction = 1, 3-way interaction = 2, etc). ') );
        end


        set (handles.st4_1, 'TooltipString', sprintf(' Observed t test statistic value for linear contrast ') );
        set (handles.st4_2, 'TooltipString', sprintf(' Degrees of freedom for linear contrast ') );
        set (handles.st4_3, 'TooltipString', sprintf(' Observed P value for testing null hypothesis ') );
        set (handles.st4_4, 'TooltipString', sprintf(' Observed F test statistic value for linear contrast ') );
        set (handles.st4_5, 'TooltipString', sprintf(' Mean square error value used in linear contrast ') );

    end



    %% Binomial Proportion ----------------------------------------------------

    if (pm1 == 9)

        set (handles.hd1, 'TooltipString', sprintf(' For investigating whether there is a difference in occurrence between two categories ') );
        set (handles.rb1, 'TooltipString', sprintf(' Uses value of sample proportion as input to obtain confidence intervals ') );
        set (handles.rb2, 'TooltipString', sprintf(' Uses number of cases with positive response as input to obtain confidence intervals ') );

        if (rb1 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Sample proportion value (must be between 0 and 1) ') );
        elseif (rb2 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Number of cases with positive response (must be between 0 and total sample size) ') );
        end

        set (handles.st1_2,  'TooltipString', sprintf(' Sample size used in binomial test ') );
        set (handles.st1_3,  'TooltipString', sprintf(' User-defined null hypothesised population value for pi (0 < population pi < 1) ') );
        set (handles.st1_4,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

        set (handles.st2_1,  'TooltipString', sprintf(' Maximum likelihood estimate of proportion (same as sample value) ') );
        set (handles.st2_2,  'TooltipString', sprintf(' Estimate of population proportion value using Agresti-Coull (1998) +2 method with Wald SE to form CI ') );
        set (handles.st2_3,  'TooltipString', sprintf(' Estimate of population proportion value using Wilson mid-P method [based on (x+2)/(n+4) calculation] ') );

        set (handles.st3_01, 'TooltipString', sprintf(' Large sample confidence interval using standard error calculated from sample proportion (traditional Wald interval) ') );
        set (handles.st3_02, 'TooltipString', sprintf(' Large sample confidence interval using standard error calculated from null hypothesised pi value (Wilson [Score] interval) ') );
        set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for proportion using Agresti-Coull (1998) scoring method based on critical z value squared (Eq. 2, p. 120) ') );
        set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for proportion using simplified Agresti-Coull (1998) method that adds 2 to both the number of successes and the number of failures ') );
        set (handles.st3_05, 'TooltipString', sprintf(' Confidence interval for proportion using mid-P method (Agresti & Coull, 1998, p. 124)  ') );
        set (handles.st3_06, 'TooltipString', sprintf(' Blaker (2000) improved exact confidence interval for proportion ') );
        set (handles.st3_07, 'TooltipString', sprintf(' Exact Clopper-Pearson confidence interval for proportion ') );

        set (handles.st4_1,  'TooltipString', sprintf(' Two-sided exact probability value for the user-specified null hypothesis for pi, where p'' is the opposite extreme proportion ') );
        set (handles.st4_2,  'TooltipString', sprintf(' One-sided exact probability value for exceeding the user-specified null hypothesis for pi ') );
        set (handles.st4_3,  'TooltipString', sprintf(' One-sided exact probability value for not exceeding the user-specified null hypothesis for pi ') );
        set (handles.st4_4,  'TooltipString', sprintf(' One-sided mid-P probability value for exceeding the user-specified null hypothesis for pi ') );
        set (handles.st4_5,  'TooltipString', sprintf(' Observed z test statistic for Wald-based large sample null hypothesis test of the user-defined pi value. ') );
        set (handles.st4_6,  'TooltipString', sprintf(' Obtained P value for large sample z test statistic value on pi') );
        set (handles.st4_7,  'TooltipString', sprintf(' Opposite extreme number of successes for 2-sided exact p value ') );
        
        set (handles.cb1,    'TooltipString', sprintf(' Check this box to provide continuity corrections to large-sample intervals and statistical test results (press Calculate... button again)') );
            
   
    end



    %% SEM Fit Statistics option -----------------------------------------

    if (pm1 == 10)

        set (handles.hd1, 'TooltipString', sprintf(' For calculating various goodness-of-fit statistics used in structural equation modelling. ') );
        set (handles.rb1, 'TooltipString', sprintf(' Uses observed chi-square value for fitted model to estimate fit statistics ') );
        set (handles.rb2, 'TooltipString', sprintf(' Uses observed discrepancy function value for fitted model to estimate fit statistics ') );
        set (handles.cb1, 'TooltipString', sprintf(' Check this box to additionally calculate ML-based estimate of ECVI (equivalent to a rescaled AIC value) ') );
        set (handles.cb2, 'TooltipString', sprintf(' Check this box to enter number of freely estimated model parameters directly rather (default = calculated internally by program) ') );
        set (handles.cb3, 'TooltipString', sprintf(' Check this box to correctly calculate number of model parameters if the model involves a mean structure ') );

        if (rb1 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Observed chi-square value for fitted model ') );
        elseif (rb2 == 1)
            set (handles.st1_1, 'TooltipString', sprintf(' Observed discrepancy function value for fitted model ') );
        end

        set (handles.st1_2,  'TooltipString', sprintf(' Degrees of freedom for fitted model ') );
        set (handles.st1_3,  'TooltipString', sprintf(' Total sample size across all groups ') );
        set (handles.st1_4,  'TooltipString', sprintf(' Number of independent groups in fitted model ') );
        set (handles.st1_5,  'TooltipString', sprintf(' Null hypothesised RMSEA value used in tests of approximate fit ') );
        set (handles.st1_7,  'TooltipString', sprintf(' Width of confidence interval being requested \n (expressed as a number > 0 and < 100) ') );

        set (handles.st2_1,  'TooltipString', sprintf(' Estimated population discrepancy value for fitted model ') );
        set (handles.st2_2,  'TooltipString', sprintf(' McDonald''s (1990) noncentral parameter fit statistic ') );
        set (handles.st2_3,  'TooltipString', sprintf(' Estimated root mean square error of approximation statistic (RMSEA) ') );
        set (handles.st2_4,  'TooltipString', sprintf(' Steiger''s (1990) population goodness-of-fit statistic (population GFI) ') );
        set (handles.st2_5,  'TooltipString', sprintf(' Steiger''s (1990) population adjusted goodness-of-fit statistic (population AGFI) ') );
        set (handles.st2_6,  'TooltipString', sprintf(' Estimated expected cross-validation index (ECVI) ') );

        set (handles.st3_01, 'TooltipString', sprintf(' Confidence interval for population discrepancy value for fitted model ') );
        set (handles.st3_02, 'TooltipString', sprintf(' Confidence interval for McDonald''s (1990) noncentral parameter fit statistic ') );
        set (handles.st3_03, 'TooltipString', sprintf(' Confidence interval for root mean square error of approximation statistic (RMSEA) ') );
        set (handles.st3_04, 'TooltipString', sprintf(' Confidence interval for Steiger''s (1990) population goodness-of-fit statistic (population GFI) ') );
        set (handles.st3_05, 'TooltipString', sprintf(' Confidence interval for Steiger''s (1990) population adjusted goodness-of-fit statistic (population AGFI) ') );
        set (handles.st3_06, 'TooltipString', sprintf(' Confidence interval for expected cross-validation index (ECVI) ') );

        set (handles.st4_1,  'TooltipString', sprintf(' Chi-squared value for fitted model ') );
        set (handles.st4_2,  'TooltipString', sprintf(' Degrees of freedom for fitted model ') );
        set (handles.st4_3,  'TooltipString', sprintf(' Obtained P value for null hypothesis of exact fit (i.e., Ho: RMSEA = 0) ') );
        set (handles.st4_4,  'TooltipString', sprintf(' Obtained P value for null hypothesis of approximate fit (under accept-support strategy) ') );
        set (handles.st4_5,  'TooltipString', sprintf(' Obtained P value for null hypothesis of approximate fit (under reject-support strategy) ') );

        if (cb1 == 1)
            set (handles.st2_7,  'TooltipString', sprintf(' ML-based expected cross-validation index (transformed AIC) ') );
            set (handles.st3_07, 'TooltipString', sprintf(' Confidence interval for ML-based expected cross-validation index (transformed AIC) ') );
        end

        if (cb2 == 1)
            set (handles.st1_6, 'TooltipString', sprintf(' Number of freely estimated parameters in fitted model ') );
        else
            set (handles.st1_6, 'TooltipString', sprintf(' Number of observed variables in model (assumes same number in each group if multiple-group specification) ') );
            set (handles.st4_6, 'TooltipString', sprintf(' Number of freely estimated parameters in fitted model ') );
        end

        

    end

%% End of tool tips for GUI -----------------------------------------------
return
