\name{coef.rv}
\alias{coef.rv}
\alias{t.test.rv}

\title{
Statistical troubleshooting.
}

\description{
Functions to flag common statistical trouble spots. 
}

\usage{
t.test.rv(x,y,alpha=0.05,bonf=1) 
coef.rv(lmobj,alpha=0.05,usebonf=TRUE) 
}

\arguments{
  \item{x}{A numeric vector.}
  \item{y}{A numeric vector.}
  \item{lmobj}{An object of class \code{'lm'} (including \code{'glm'}).}
  \item{alpha}{Significance level or 1 - confidence level.}
  \item{bonf}{Factor to use in Bonferroni correction.}
  \item{usebonf}{If true, apply Bonferroni correction.}
}

\details{These functions search for common statistical trouble spots,
such as small p-values that are associated with very small, possibly 
practically insignificant, effects, and issues with multiple inference.

The package aims to move users more toward using confidence intervals
than p-values.  A narrow confidence interval near 0 but not containing
it may indicate lack of practically significance, while an interval
containing 0 but mostly in "interesting" territory may be of some
relevance.

The function \code{t.test.rv} is essentially a replacement for
\code{t.test}, the standard R function for significance tests and
confidence intervals for means. (Only the two-sample case is handled
currently.)  If the user anticipates making m intervals or tests, she
should set \code{bonf} to m.

The function \code{coef.rv} is like the R function \code{coef}, which
extracts coefficients from objects such as the value returned by
\code{lm} and \code{glm}.  This function again checks for misleadingly
small p-values.  If a Bonferroni adjustment is specified, then the
Bonferroni factor is the length of the coefficient vector.  

The output of \code{coef.rv} includes a warning column, which indicates
that a small p-value may be of little or no practical significance in
this particular case.

Computation of Bonferroni p-values is rudimentary; see the entry for R's
\code{p.adjust} for other methods.

Methods for multiple inference other than Bonferroni are planned.

}

% \value{
% }

\examples{
lmout <- lm(mpg ~ .,data=mtcars) 
summary(lmout)  # the usual output
coef.rv(lmout,usebonf=FALSE)  # add confidence intervals
coef.rv(lmout,usebonf=TRUE)  # add Bonferroni
}

\author{
norm Matloff
}

