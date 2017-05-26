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

The function \code{t.test.rv} is essentially a replacement for
\code{t.test}, the standard R function for significance tests and
confidence intervals for means. (Only the two-sample case is handled
currently.)  If the user anticipates making m intervals or tests, she
should set \code{bonf} to m.

The function \code{coef.rv} is like the R function \code{coef}, which
extracts coefficients from objects such as the value returned by
\code{lm}.  If a Bonferroni adjustment is specified, then the Bonferroni
factor is the length of the coefficient vector.
}

% \value{
% }

\examples{
}

\author{
Norm Matloff
}

