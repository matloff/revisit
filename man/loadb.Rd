\name{loadb}
\alias{loadb}

\title{
Load Branch
}

\description{
Loads the specified branch into memory.
}

\usage{
loadb(br)
}

\arguments{
  \item{br}{Filename, including path, of branch to be loaded.}
}

\details{This functions loads the specified branch into memory so that
it can be edited, run, and/or saved.  In the process, the following
variables are set in rvenv, the environment initialized by rvinit().

   \tabular{lll}{
      VARIABLE          \tab DESCRIPTION \tab EXAMPLE\cr
      rvenv$currb       \tab Current branch name, including path, if any \tab "inst/examples/pima.0.R"\cr
      rvenv$currbasenm  \tab Same as rvenv$currb above but without branch id or extension \tab "inst/examples/pima"\cr
      rvenv$currcode    \tab A character vector with one member for each line of code \tab "# RV history start" ...\cr
      rvenv$desc        \tab Description from file (line before "# RV history end") \tab "# original code"\cr
      rvenv$pc          \tab Program counter, starting at 1 \tab 1\cr
      rvenv$smalleffect \tab Value used for significance testing (as in t.test.rv) \tab 0.05
   }
   The 0 branch (e.g., pima.0.R) is created with the makebranch0 command and other branches (e.g., pima.1.R) are created with the saveb command.

}

% \value{
% }

\seealso{
edt\cr
makebranch0\cr
next\cr
runb\cr
saveb
}

\examples{
loadb("pima.0.R")
loadb("inst/examples/pima.1.R")
}

\author{
Norm Matloff
}

