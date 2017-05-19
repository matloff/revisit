
# overview:

# original code is in file named origcodenm; makebranch0() converts that
# to the master branch, named origcodenm.0; further branches will be
# origcodenm.1.R, origcodenm.2.R etc.

# a branch is merely a .R code file, but with the first line being a
# comment holding a brief description of this particular branch

# see README.md for more

# initialize rvisit; the R environment rvenv will contain the relevant
# information about the currently-in-use branch

rvinit <- function(smalleffect=0.05) {
   rvenv <<- new.env()
   rvenv$currb <<- NULL
   rvenv$currbasenm <<- NULL
   rvenv$desc <<- NULL
   rvenv$currcode <<- NULL
   rvenv$pc <<- NULL
}

# load original code, a .R file, and make the first branch from it
makebranch0 <- function(origcodenm) {
   code <- readLines(con = origcodenm)
   desclines <-
      c('# RV history start','# original code','# RV history end')
   code <- c(desclines,code)
   rvenv$currbasenm <<- tools::file_path_sans_ext(origcodenm)
   br0filenm <- paste(rvenv$currbasenm,'.0.R',sep='')
   writeLines(code,br0filenm)
}

# create new branch, with "midfix" ("middle suffix") midfix, in a file
# whose name is the concatenization of our original prefix
# rvenv$currbasenm; the midfix; and '.R'; the note desc describes the
# branch
saveb <- function(midfix,desc) {
   code <- rvenv$currcode

   # add lines at top of file with the description of the branch,
   # consisting of the change history
   #
   # find end of description
   g <- grep('# RV history end',code)
   if (length(g) > 0){
      endline <- g[1]
      toplines <- code[1:(endline-1)]
      toplines <- c(toplines,paste('#',desc))
      code <- c(toplines,code[endline:length(code)])
   } else {
      toplines <- c('# RV history start','# WARNING: RV history missing and recreated',paste('#',desc),'# RV history end')
      code <- c(toplines,code)
   }

   branchname <- paste(rvenv$currbasenm,'.',midfix,'.R',sep='')
   # should add code asking user if OK to overwrite
   writeLines(code,branchname)
}

# set current branch to br, a filename
loadb <- function(br) {
   rvenv$currb <<- br
   tmp <- tools::file_path_sans_ext(br)  # remove '.R'
   tmp <- tools::file_path_sans_ext(tmp)  # remove branch number
   rvenv$currbasenm <<- tmp
   rvenv$currcode <<- readLines(br)
   rvenv$pc <<- 1
   rvenv$desc <<- rvenv$currcode[1]
   rvenv$firstrunafteredit <<- FALSE
}

# run the code from lines startline through throughline; neither of
# those can be inside a function call or function definition, including
# loops, if(); startline is 1 by default, use 'f' to finish the run from
# the present line, or use 'n' to step just one line

runb <- function(
           startline = 1,
           throughline=length(rvenv$currcode))  {
        if (startline == 'f' || startline == 'n') {
           if (startline == 'n') throughline <- rvenv$pc + 1
           startline <- rvenv$pc
        }
        lcode <- length(rvenv$currcode)
        if (startline < 1 || startline > lcode ||
            throughline > lcode)
               stop('line number out of range')
        execrange <- startline:throughline
        writeLines(rvenv$currcode[execrange],'tmprv.R')
        source('tmprv.R')
        rvenv$pc <- throughline + 1
        rvenv$firstrunafteredit <<- FALSE
}

# single-step, as with debuggers
nxt <- function() runb('n')

# resume execution from the current line; execution will finish the
# remaining lines, unless throughline is specified
go <- function(throughline=length(rvenv$currcode))
         runb(startline=rvenv$pc,throughline)

# list current code
lcc <- function() {
   code <- rvenv$currcode
   print('next line to execute indicated by ***')
   for (i in 1:length(code)) {
      if (i == rvenv$pc) code[i] <- paste('***',code[i])
      catn(i,code[i])
   }
}

# edit current code; edits the current code file, not an R object; if
# 'listresult', then new code will be printed to the scree
#
# current implementation rather kludgy, repeatedly going back and forthe
# to disk

edt <- function(listresult=TRUE) {
   rvenv$firstrunafteredit <<- TRUE
   code <- rvenv$currcode
   writeLines(code,'tmprv.R')
   tmprv <- edit(file='tmprv.R')  # tmprv just a dummy to prevent execution
   rvenv$currcode <<- readLines('tmprv.R')
   if (listresult) lcc()
}

# do one line of code from a branch
docmd <- function(toexec)
   eval(parse(text=toexec),envir=.GlobalEnv)

# to be inserted after each app line that does a plot
pause <- function() {
   readline('hit Enter ')
}

catn <- function(...) {
   cat(...,'\n')
}

# overload t.test() to check for misleadingly low p-value, and also
# adjust for for multiple comparisons; 2-sample only; bonf
# ("Bonferroni") is the number of anticipated comparisons; many other
# possibilities, e.g. p.adjust() in base R

t.test.rv <- function(x,y,alpha=0.05,bonf=1) {
   alpha <- alpha / bonf
   tout <- t.test(x,y,conf.level=1-alpha)
   muhat1 <- tout$estimate[1]
   muhat2 <- tout$estimate[2]
   ## catn('sample means: ',muhat1, muhat2)
   ## catn('confidence interval:')
   ## catn(tout$conf.int)
   tout$p.value <- tout$p.value * bonf
   if (tout$p.value < alpha) {
      ## catn('H0 rejected')
      if (abs(muhat1 - muhat2)/ abs(muhat1) < rvenv$smalleffect)
         warning(paste('small p-value but effect size',
                       'could be of little practical interest'))
   }
   tout
}

# finds Bonferroni CIs and p-values; obj is any R object to which coef()
# and vcov() can be applied
coef.rv <- function(obj,alpha=0.05) {
   cfs <- coef(obj)
   lc <- length(cfs)
   alpha <- alpha / lc
   vc <- vcov(obj)
   ses <- sqrt(diag(vc))
   zcut <- qnorm(1-alpha/2)
   for (i in 1:lc) {
      rad <- zcut*ses[i]
      cfi <- cfs[i]
      ci1 <- cfi - rad
      ci2 <- cfi + rad
      tmp <- pnorm(abs(cfi) / ses[i])
      pval <- (2 * (1 - tmp)) * lc
      catn(names(cfs[i]),ci1,ci2,pval)
   }
}


