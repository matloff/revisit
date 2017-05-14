# the file public.dta and the Stata code on which this R code is based
# is courtesy of M. Zavodny

data(zav) # zav.txt is .txt version of Zav. file public.dta
zav = zav[zav$year < 2008,] # 2000-2007 (first year in zav.txt is 2000)

##### traditional employment rate and immigrant share model #####

# employment rate for natives = employed natives divided by total native
# population
zav$emprate_native   <- zav$emp_native / zav$pop_native * 100

# immigrant stem workers with advanced degrees from U.S. universities, 
# share of total workers employed

zav$immshare_emp_stem_e_grad   <- zav$emp_edus_stem_grad / zav$emp_total * 100

# immigrant stem workers with advanced degrees from non-U.S.
# universities - share of total workers employed
zav$immshare_emp_stem_n_grad   <- zav$emp_nedus_stem_grad / zav$emp_total * 100

# logs of prior three values
zav$lnemprate_native           <- log(zav$emprate_native)
zav$lnimmshare_emp_stem_e_grad <- log(zav$immshare_emp_stem_e_grad)
zav$lnimmshare_emp_stem_n_grad <- log(zav$immshare_emp_stem_n_grad)

# year in sample (in this case, 2000-2007), converted to factors for
# use as an instrumental variable
zav$fyear  <- as.factor(zav$year)

# 50 states plus Washington D.C., converted to factors for use as an
# instrumental variable
zav$fstate <- as.factor(zav$statefip)

# need to normalize population weights so that each year has same weight;
# otherwise, too much weight assigned to later years
# do for total native population (age 16-64)
zav$sum_pop_native <- with(zav, ave(pop_native, year, FUN=sum))
zav$weight_native <- zav$pop_native / zav$sum_pop_native

# remove non-positive values so that their logs are valid values (not
# NaN or infinite, plus or minus)
kk <- zav[zav$emp_edus_stem_grad > 0 & zav$emp_nedus_stem_grad > 0,]

# do regression with two independent variables, two instrumental
# variables, and weights to treat years equally

mm <- (with(kk, 
   lm(lnemprate_native ~ 
      lnimmshare_emp_stem_e_grad + 
      lnimmshare_emp_stem_n_grad + 
      fyear + 
      fstate, 
      weights=weight_native)))

# extract slope and p-value from summary
slope <- mm$coefficients[2]
pvalue <- summary(mm)$coefficients[2,4]

# calculate number of native jobs associated with change in immigrant share
ols <- round(slope, 3)
jobs <- sum(zav$emp_native)/sum(zav$emp_edus_stem_grad) * ols * 100
print(paste("Slope   =", slope))
print(paste("P-value =", pvalue))
print(paste("Jobs    =", jobs))
