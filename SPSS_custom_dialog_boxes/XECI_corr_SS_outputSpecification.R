# output specification for XECI_corr. ####


output<-XECI_corr(.5,50,0)
title=c("Findings for statistical tests","Correlation coefficents","confidence Intervals")

spsspkg.StartProcedure("XECI output")
spsspivottable.Display(t(as.data.frame(output[[1]])), title = title[1],
                       collabels = 'Value', rowlabels = names(output[[1]]), format =2)

spsspivottable.Display(t(as.data.frame(output[[2]])), title = title[2],
                       collabels = 'Value', rowlabels = names(output[[2]]), format=2)      

spsspivottable.Display(t(as.data.frame(output[[3]])),title =title[3],
                       collabels = c("Lower limit", "Upper limit"), rowlabels = names(output[[3]]), format=2)
spsspkg.EndProcedure()
