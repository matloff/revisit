# revisit: an R Package for Statistical Reproducibility and Alternate Analysis

### About

In recent years, scientists, especially those who run academic journals
or fund research projects, have been greatly concerned about lack of
*reproducibility* of research.  A study performed by one research group,
with certain findings, is then attempted by another group, with
different findings.  [As reported for
instance](http://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970)
in the top journal *Nature*, the problem is considered by many to have
reach crisis stage.

Much of the concern is statistical in nature. As noted in the above
*Nature* report (emphasis added):

> The survey asked scientists what led to problems in reproducibility.
> More than 60% of respondents said that each of two factors — pressure to
> publish and selective reporting — always or often contributed. More than
> half pointed to insufficient replication in the lab, poor oversight or
> low statistical power.
> 
> Respondents were asked to rate 11 different approaches to improving
> reproducibility in science, and all got ringing endorsements. Nearly 90%
> — more than 1,000 people — ticked "More robust experimental design"
> "better statistics"...

The **revisit** package is aimed to help remedy such problems, as
follows:

* The original researcher would, when submitting a manuscript for
  publication, be required to include both code and data. In the case of
  code, it would be *complete*, including not only statistical
  operations for also data cleaning and "wrangling."

* The **revisit** package would then be used in two ways:

   - The package would be used to "replay" the entire analysis, to check
     that the results match those in the manuscript. 

   - The code would also be checked for coding errors. This would be 
     done by hand, not by the software, but the package would
     facilitate it, as it would allow executing the code one line at a
     time, with pauses.

   - Most important, the package allows one to revisit the statistical
     analysis itself, trying alternate scenarios.  What, for instance,
     would occur if one would more aggressively weed out outliers?  How
     would the results change?  One can check models and assumptions,
     transform variables, calculate confidence intervals instead of
     p-values and so on.

As the package develops, advice and warnings will be added, especially
in light of concerns that too many "false positives" are being reported
in published research.  For example, the package may emit a message
like, "Warning: small p-value does not seem to correspond to an effect
of practical importance."  Procedures for multiple inference, ranging
from simple Bonferroni to advanced methods, will be made available.

For now, the core package consists of tools by which to not only try
alternate analyses but also to record them in *branches*.  The user
might, for instance, use to package to run to line 15 of the original
code and pause.  The user would then change that line to some desired
alternative analytical path, then resume execution.  If this alternative
path produces insight, the user can save it, developing several
different alternatives, which others can then explore.



