# The file public.dta and the Stata code on which this R code is based is courtesy of M. Zavodny
data(zav) # zav.txt is .txt version of public.dta
zav = zav[zav$year < 2008,] # 2000-2007

zav$emprate_native   <- zav$emp_native / zav$pop_native * 100
zav$lnemprate_native <- log(zav$emprate_native)
zav$immshare_emp_stem_e_grad   <- zav$emp_edus_stem_grad / zav$emp_total * 100
zav$immshare_emp_stem_n_grad   <- zav$emp_nedus_stem_grad / zav$emp_total * 100
zav$lnimmshare_emp_stem_e_grad <- log(zav$immshare_emp_stem_e_grad)
zav$lnimmshare_emp_stem_n_grad <- log(zav$immshare_emp_stem_n_grad)
zav$fyear  <- as.factor(zav$year)
zav$fstate <- as.factor(zav$statefip)
zav$sum_pop_native <- with(zav, ave(pop_native, year, FUN=sum))
zav$weight_native <- zav$pop_native / zav$sum_pop_native

kk <- zav[zav$emp_edus_stem_grad > 0 & zav$emp_nedus_stem_grad > 0,] # must limit to values with valid logs
mm <- (with(kk, lm(lnemprate_native ~ lnimmshare_emp_stem_e_grad + lnimmshare_emp_stem_n_grad + fyear + fstate, weights=weight_native)))
slope <- mm$coefficients[2]
ols <- round(slope, 3)
jobs <- sum(zav$emp_native)/sum(zav$emp_edus_stem_grad) * ols * 100
mmsum <- summary(mm)
pvalue <- mmsum$coefficients[2,4]
print(paste("Slope   =", slope))
print(paste("P-value =", pvalue))
print(paste("Jobs    =", jobs))