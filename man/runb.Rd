\name{runb}
\alias{runb}

\title{
Run Branch
}

\description{
Runs a specified block of the current code in rvenv$currcode.
}

\usage{
runb(startline, throughline)
}

\arguments{
  \item{startline}{Index of first line of code to execute.}
  \item{throughline}{Index of last line of code through which to execute.}
}

\details{
This function runs the specified block of the current code in rvenv$currcode.  The limits of the block to be executed are specified by startline and throughline.  If startline is not specified, execution will start with the first line (1) and, if throughline is not specified, execution will continue through all of rvenv$currcode.  After execution, the program counter, rvenv$pc, will be set to the last line executed plus 1.

A restriction is that the execution cannot start or finish within a function, a loop, or a conditional block (such as an if or else clause).  This is because the block is executed as an independent block of code.  If it contains just a portion of a function, loop, or conditional block, it will not by syntactically valid.  The use of the \code{runb}, along with these restrictions, can be seen by running the following sample program:

\preformatted{
 1  pnum <- function(n){
 2  print(paste("call",n))
 3  }
 4  for (i in 1:3){
 5     pnum(i)
 6  }
 7  if (i == 3){
 8     print("i == 3")
 9  }
10  pnum(4)
11  print("done")
}

Because of the restrictions, startline can only be 1, 4, 7, 10, or 11 and throughline can only be 3, 6, 9, 10, or 11.  Hence, the following test run uses the smallest possible steps to step through the entire program:

\preformatted{
> runb(throughline = 3)
> runb(startline = 4,throughline = 6)
[1] "call 1"
[1] "call 2"
[1] "call 3"
> runb(7,9)
[1] "i == 3"
> runb(10,10)
[1] "call 4"
> runb(11)
[1] "done"
>
}

The first call to runb does not contain a value for startline so it defaults to 1 and executes through statement 3.  The second call to runb executes statements 4 through 6.  The third call to runb uses positional instead of named parameters and executes statements 7 through 9.  The fourth call to runb then executes statement 10 and the fifth call executes line 11.  Since this last call doesn't specify a value for throughline, it defaults to the end of the program.

The last two calls could have been replaced with calls to \code{nxt()} and accomplished the same thing.  That's because \code{nxt} is identical to a call to runb where both startline and throughline are equal to the current program counter, rvenv$pc.

One item of note is that it is possible to use runb to execute a block of code totally within a function, for loop, or conditional block.  For example, it would be possible to call \code{runb(2,2)}.  However, the user would need to make sure that the variable n was defined first.  Also, the user can only include statement inside, but not including, the opening and closing braces.  Hence, using runb in this way should be done with care.
}

% \value{
% }

\seealso{
\code{\link{edt}}\cr
\code{\link{loadb}}\cr
\code{\link{makebranch0}}\cr
\code{\link{nxt}}\cr
\code{\link{rvinit}}\cr
\code{\link{saveb}}
}

\examples{
runb(throughline = 3)
runb(startline = 4,throughline = 6)
runb(7,9)
runb(10,10)
runb(11)
}

\author{
Norm Matloff
}
