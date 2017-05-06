
# overview:

# original code is in file named origcodenm; makebranch0() converts that
# to the master branch, named origcodenm.0; further branches will be
# origcodenm.1.R, origcodenm.2.R etc.
 
# a branch is merely a .R code file, but with the first line being a
# comment holding a brief description of this particular branch
 
# see README.md for more

# initialize rvisit; the R environment rvenv will contain the relevant
# information about the currently-in-use branch

rvinit <- function() {
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
   descline <- '# original code'
   code <- c(descline,code)
   rvenv$currbasenm <<- tools::file_path_sans_ext(origcodenm)
   br0filenm <- paste(rvenv$currbasenm,'.0.R',sep='')
   writeLines(code,br0filenm)
}

# create new branch, with suffix the number in branchnum, prefix
# rvenv$currbasenm; the note desc describes the branch
saveb <- function(branchnum,desc) {
   code <- rvenv$currcode
   code[1] <- paste('#',desc)
   branchname <- paste(rvenv$currbasenm,'.',branchnum,'.R',sep='')
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
# loops, if(); startline is 1 by default, use 'c' to continue from
# present line

runb <- function(
           startline = 1,
           throughline=length(rvenv$currcode))  {
        if (startline == 'c') {
           startline <- rvenv$pc
           if (rvenv$firstrunafteredit) {
              print('code has changed since last run, now at')
              catn(rvenv$currcode[startline])
              ans <- readline('start run? (Enter for yes)')
              if (!ans == '') return()
           }
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

# list current code
lcc <- function() {
   code <- rvenv$currcode
   for (i in 1:length(code)) catn(i,code[i])
}

# edit current code; not pretty, definitely need a GUI; if 'listresult',
# then new code will be printed to the screen
edt <- function(listresult=TRUE) {
   rvenv$firstrunafteredit <<- TRUE
   code <- rvenv$currcode
   # code <- as.vector(edit(matrix(code,ncol=1)))
   code <- edit(code)
   rvenv$currcode <<- code
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
# ("Bonferroni") is the number of anticipated comparisons

t.test.rv <- function(x,y,alpha=0.05,bonf=1) {
   alpha <- alpha / bonf
   tout <- t.test(x,y,conf.level=1-alpha)
   muhat1 <- tout$estimate[1]  
   muhat2 <- tout$estimate[2]  
   catn('sample means: ',muhat1, muhat2)
   catn('confidence interval:')
   catn(tout$conf.int)
   pv <- tout$p.value
   if (pv < alpha) {
      catn('H0 rejected')
      if (abs(muhat1 - muhat2)/ abs(muhat1) < 0.05) 
         warning(paste('small p-value but effect size',
                       'may be of little practical interest'))
   }
}


