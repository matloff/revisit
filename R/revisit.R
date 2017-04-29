
# current code restrictions:

#    loops, if(), if() else must be contained in a single line
#    (semicolons allowed)

#    a pause should be placed after each action that produces a display,
#    e.g. hist(), by inserting a line like

#       readline('hit Enter ')

# initialize rvisit
rvinit <- function() {
   rvenv <<- new.env()
   rvenv$currb <- NULL
   rvenv$currcode <- NULL
   rvenv$pc <- NULL
}

# load original code and make the first branch from it
makebranch0 <- function(origcodenm) {
   code <- readLines(con = origcodenm)
   attr(code,'desc') <- 'original'
   save(code,file='branch0')
}

# create new branch, with file name br; saves rvenv$currcode;
# optional note desc describes the branch;
saveb <- function(br,desc=NULL) {
   code <- rvenv$currcode
   attr(code,'desc') <- desc
   save(code,file=br)
}

# set current branch to br, a filename
loadb <- function(br) {
   rvenv$currb <- br
   load(br)  # variable 'code' will now exist
   rvenv$currcode <- code
   rvenv$pc <- 1  # see note above on loops etc.
}

runb <- function(
           startline = rvenv$pc,
           throughline=length(rvenv$currcode))  {
        if (startline < 1 || throughline > length(rvenv$currcode))
           stop('line number out of range')
        execrange <- startline:throughline
        for (codeline in execrange) {
           docmd(rvenv$currcode[codeline])
        }
        rvenv$pc <- throughline + 1
}

# edit current code
edt <- function() {
   code <- rvenv$currcode
   code <- as.vector(edit(matrix(code,ncol=1)))
   rvenv$currcode <- code
}

# do one line of code from a branch
docmd <- function(toexec) 
   eval(parse(text=toexec),envir=.GlobalEnv)

