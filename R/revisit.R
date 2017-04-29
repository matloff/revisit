
# initialize rvisit

rvinit <- function() {
   rvenv <- new.env()
   rvenv$currb <- NULL
   rvenv$currcode <- NULL
}

# set current branch to br, a filename
setb <- function(br) {
   rvenv$currb <- br
   rvenv$currcode <- readLines(con=br)
}

runb <- function(throughline=length((rvenv$currcode)) {
   for (codeline in rvenv$currcode) {
      docmd(codeline)
   }
}

# do one line of code from a branch
docmd <- function(toexec) 
   eval(parse(text=toexec),envir=.GlobalEnv)

