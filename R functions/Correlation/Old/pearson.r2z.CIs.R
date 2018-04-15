fisher.r2z.CIs<-function(n,r,CI = 95){
fisher.r2z <- function(r) { 0.5 * (log(1+r) - log(1-r)) } 
fisher.z2r<-function(z){((exp(2*z))-1)/((exp(2*z))+1)} 
#calculating standard error 
SE<-1/sqrt(n-3) 
#transforming r to z 
z<-fisher.r2z(r) 
# calculating CIs 
zForCI<- -qnorm((1-(CI/100))/2) 
upperBound<- z + zForCI*SE 
lowerBound<- z - zForCI*SE 
CIsZ<-c(lowerBound,upperBound) 
CIs<-fisher.z2r(CIsZ)
return(CIs)
}

