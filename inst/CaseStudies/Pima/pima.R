# start of pima.R
### data(pima)
datapath <- system.file("data", package="revisit")                              
pima <- read.table(paste0(datapath, "/pima.txt"), header = TRUE)                
# divide into diabetic, non-diabetics
d <- which(pima$Diab == 1)
diab <- pima[d,]
nondiab <- pima[-d,]
# form a confidence interval for each variable, difference between
# diabetics and non-diabetics
for (i in 1:8)  {
   tmp <- t.test(diab[,i],nondiab[,i])$conf.int
   cat(names(pima)[i],'  ',tmp[1],tmp[2],'\n')
}
