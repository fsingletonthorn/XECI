# output specification for XECI_corr. ####
spsspkg.StartProcedure("XECI output")
spsspivottable.Display(t(as.data.frame(output[1:3])), title = "Findings for statistical tests", collabels = "Value", rowlabels = c("Observed t value", "Degrees of freedom", "Obtained p value"), format=2)
spsspivottable.Display(t(as.data.frame(output[c(4, 6)])), title = "Correlation coefficents", collabels = "Value",  rowlabels = c("Sample correlation", "Unbiased r"), format=2)
spsspivottable.Display(
  t(as.data.frame(output[c(5, 7, 8, 9)])),
  title = "$$Confidence_interval_width$$ percent Confidence intervals",collabels = c("Lower limit", "Upper limit"), rowlabels =c("Fisher's r to z CI, sample r", "Fisher's r to z CI, unbiased r", "Exact CI, sample r","Exact CI, unbiased r"), format=2
)
spsspkg.EndProcedure()
