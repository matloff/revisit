
data(prgeng)
pe <- prgeng
# dummies for MS, PhD
pe$ms <- as.integer(pe$educ == 14)
pe$phd <- as.integer(pe$educ == 16)
lmout <- lm(wageinc ~ age+sex+ms+phd,data=pe)
print(summary(lmout))
