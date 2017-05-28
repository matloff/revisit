\name{saveb}
\alias{saveb}

\title{
Save Branch
}

\description{
Creates a new branch containing the current code in rvenv$currcode.
}

\usage{
saveb(bid, desc)
}

\arguments{
  \item{bid}{Branch id, inserted before the .R extension in the name of the newly-created file.}
  \item{desc}{Description of the branch.}
}

\details{
This function creates a new branch file containing the current code in rvenv$currcode.  The name of the new file will be created by appending rvenv$currbasenm, '.', the branch id \code{bid}, and '.R'.  In addtion, the description \code{desc} will have '# ' prepended to it and placed before the "# RV history end" line in the file.

For example, file \code{pima.0.R} begins with the following lines:

\preformatted{
# RV history start
# original code
# RV history end
}

If the code is changed and then saved with the command \code{saveb(1, "save branch 1")}, the newly-created file \code{pima.1.R} will begin with the following lines:

\preformatted{
# RV history start
# original code
# save branch 1
# RV history end
}

If no "# RV history end" line is found in the code being saved (because it was mistakenly edited by the user or for other reasons), the following lines will be prepended to the file in this case:

\preformatted{
# RV history start
# WARNING: RV history missing and recreated
# save branch 1
# RV history end
}

The new file can then be loaded with the \code{loadb} command.  For example, suppose that the file \code{pima.0.R} is loaded with \code{loadb("pima.0.R")}, edited, and then saved with \code{saveb(1, "save branch 1")}.  That will create file \code{pima.1.R} which can later be reloaded with \code{loadb("pima.1.R")}.

}

% \value{
% }

\seealso{
\code{\link{edt}}\cr
\code{\link{loadb}}\cr
\code{\link{makebranch0}}\cr
\code{\link{nxt}}\cr
\code{\link{runb}}\cr
\code{\link{rvinit}}
}

\examples{
saveb(1, "save branch 1")
saveb(2, "Remove cases with missing data")
}

\author{
Norm Matloff
}
