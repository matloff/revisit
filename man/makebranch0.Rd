\name{makebranch0}
\alias{makebranch0}

\title{
Make Branch 0
}

\description{
Creates the initial branch of the original code file being studied.
}

\usage{
makebranch0(origcodenm)
}

\arguments{
  \item{origcodenm}{Filename, including path, of the original code file.}
}

\details{
This function creates the initial branch of the original code file, giving it a branch id of 0.  For example, \code{makebranch0("pima.R")} will create file \code{pima.0.R}.  The new file will contain the code of the original file, prepended by the following lines:

\preformatted{
# RV history start
# original code
# RV history end
}

The new file can then be loaded with the \code{loadb} command.  For example, \code{makebranch0("pima.R")} will create file \code{pima.0.R} which can then be loaded with \code{loadb("pima.0.R")}.

}

% \value{
% }

\seealso{
\code{\link{edt}}\cr
\code{\link{loadb}}\cr
\code{\link{next}}\cr
\code{\link{runb}}\cr
\code{\link{rvinit}}\cr
\code{\link{saveb}}
}

\examples{
makdbranch0("pima.R")
makdbranch0("inst/examples/pima.R")
}

\author{
Norm Matloff
}
