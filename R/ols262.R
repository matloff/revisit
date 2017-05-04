# The file public.dta and the Stata code on which this R code is based is courtesy of M. Zavodny
library(foreign)
dd <- read.dta("data/public.dta")
dd = dd[dd$year < 2008,]

dd$emprate_native   <- dd$emp_native / dd$pop_native * 100
dd$lnemprate_native <- log(dd$emprate_native)
dd$immshare_emp_stem_e_grad   <- dd$emp_edus_stem_grad / dd$emp_total * 100
dd$immshare_emp_stem_n_grad   <- dd$emp_nedus_stem_grad / dd$emp_total * 100
dd$lnimmshare_emp_stem_e_grad <- log(dd$immshare_emp_stem_e_grad)
dd$lnimmshare_emp_stem_n_grad <- log(dd$immshare_emp_stem_n_grad)
dd$fyear  <- as.factor(dd$year)
dd$fstate <- as.factor(dd$statefip)
dd$sum_pop_native <- with(dd, ave(pop_native, year, FUN=sum))
dd$weight_native <- dd$pop_native / dd$sum_pop_native

kk <- dd[dd$emp_edus_stem_grad > 0 & dd$emp_nedus_stem_grad > 0,] # must limit to values with valid logs
mm <- (with(kk, lm(lnemprate_native ~ lnimmshare_emp_stem_e_grad + lnimmshare_emp_stem_n_grad + fyear + fstate, weights=weight_native)))
slope <- mm$coefficients[2]
ols <- round(slope, 3) # ROUND-OFF ERROR INTRODUCED IN CALCULATION BY USING ROUNDED VALUE FROM TABLE 2
jobs <- sum(dd$emp_native)/sum(dd$emp_edus_stem_grad) * ols * 100
mmsum <- summary(mm)
pvalue <- mmsum$coefficients[2,4]
print(paste("Slope     =", slope))
print(paste("P-value   =", pvalue))
print(paste("Jobs      =", jobs))