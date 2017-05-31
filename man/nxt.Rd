\name{nxt}
\alias{nxt}

\title{
Next Statement
}

\description{
Run the current line of code in rvenv$currcode as indicated by the program counter rvenv$pc.
}

\usage{
nxt()
}

\arguments{
}

\details{
This function executes the current line of code in rvenv$currcode as indicated by the program counter rvenv$pc.  After execution, rvenv$pc will be incremented to point to the next line.

A restriction is that the line being executed cannot contain one of the starting or ending braces of a function, loop, or conditional block (such as an if or else clause) and not the other.  This is because the line is executed as an independent block of code.  If it contains only one of the opening and closing braces of a function, loop, or conditional block, it will not by syntactically valid.  The use of \code{nxt}, along with the more general \code{runb}, can be seen by running the following sample program:

\preformatted{
 1  pnum <- function(n){
 2     print(paste("call",n))
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

Because of the restrictions, \code{runb} must be used to run through line 9.  That's because all of those lines except for 2, 5, and 8 contain one of an opening or closing brace but not the other.  However, nxt cannot be used to run those lines because there is no standard way to get the program pointer rvenv$pc to point at any of them.  However, \code{nxt} can be used to execute the last two statements as shown in the following test run that uses the smallest possible steps to step through the entire program:

\preformatted{
> runb(throughline = 3)
> runb(startline = 4,throughline = 6)
[1] "call 1"
[1] "call 2"
[1] "call 3"
> runb(7,9)
[1] "i == 3"
> nxt()
[1] "call 4"
> nxt()
[1] "done"
>
}

As can be seen, \code{nxt} was used to execute the last two statements and the expected result was output in both cases.
}

% \value{
% }

\seealso{
\code{\link{edt}}\cr
\code{\link{loadb}}\cr
\code{\link{makebranch0}}\cr
\code{\link{runb}}\cr
\code{\link{rvinit}}\cr
\code{\link{saveb}}
}

\examples{
nxt()
}

\author{
Norm Matloff
}
