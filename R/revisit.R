
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
}

# run the code from lines startline through throughline; neither of
# those can be inside a function call or function definition, including 
# loops, if(); startline is 1 by default, use 'c' to continue from
# present line

runb <- function(
           startline = 1,
           throughline=length(rvenv$currcode))  {
        if (startline == 'c') startline <- rvenv$pc
        if (startline < 1 || throughline > length(rvenv$currcode))
           stop('line number out of range')
        execrange <- startline:throughline
        for (codeline in execrange) {
           docmd(rvenv$currcode[codeline])
        }
        rvenv$pc <- throughline + 1
}

# edit current code; not pretty, definitely need a GUI
edt <- function() {
   code <- rvenv$currcode
   code <- as.vector(edit(matrix(code,ncol=1)))
   rvenv$currcode <<- code
}

# do one line of code from a branch
docmd <- function(toexec) 
   eval(parse(text=toexec),envir=.GlobalEnv)

# to be inserted after each app line that does a plot
pause <- function() {
   readline('hit Enter ')
}

# overload t.test() to check for misleadingly low p-value, and also
# adjust for for multiple comparisons; 2-sample only; bonf
# ("Bonferroni") is the number of anticipated comparisons

t.test.rv <- function(x,y,alpha=0.05,bonf=1) {
   tout <- t.test(x,y)
   if (tout$p.value < alpha/bonf) {
      muhat1 <- tout$estimate[1]  
      muhat2 <- tout$estimate[2]  
      if (abs(muhat1 - muhat2)/ abs(muhat1) < 0.05) 
         warning(paste('small p-value but effect size',
                       'may be of little practical interest'))
   }
   tout
}


