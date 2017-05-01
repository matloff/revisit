# revisit: an R Package for Statistical Reproducibility and Alternate Analysis

### About

In recent years, scientists, especially those who run academic journals
or fund research projects, have been greatly concerned about lack of
*reproducibility* of research.  A study performed by one research group,
with certain findings, is then attempted by another group, with
different findings.  [As reported for
instance](http://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970)
in the top journal *Nature*, the problem is considered by many to have
reached crisis stage.

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

* Other researchers -- say a referee for the manuscript or other
  scientists seeking to learn from the published version of the paper --
  would then use the **revisit** package as follows.

   - The package would be used to "replay" the entire analysis, to check
     that the results match those in the manuscript/paper. 

   - The code would also be checked for coding errors. This would be 
     done by hand, not by the software, but the package would
     facilitate it, as it would allow executing the code one line at a
     time, with pauses.

   - **Most important, the package allows one to revisit the statistical
     analysis itself, trying alternate scenarios**.  What, for instance,
     would occur if one would more aggressively weed out outliers?  How
     would the results change?  What if different predictor variables
     were used, or squared and interaction terms added?  How valid are
     the models and assumptions?  What about entirely different 
     statistical approaches?

As the package develops, advice and warnings will be added, especially
in light of concerns that too many "false positives" are being reported
in published research.  For example, the package may emit a message
like, "Warning: small p-value does not seem to correspond to an effect
of practical importance."  Procedures for multiple inference, ranging
from simple Bonferroni to advanced methods, will be made available.

*On the other hand, the package is not aimed to "automate" statistical
analysis.*  The user decides which analyses to try, with the core
package consisting of tools that facilitate exploring, recording and
packaging alternative analyses.

For instance, the user might use the package's **runb()** function to
run the original author's code through, say, line 12.  The user might
then change that line, and then call **runb()** again to resume
execution through line 27, then make another change there, depending on
the outcome of that first change.  If this produces interesting results,
the user could then save the modified code in a *branch*.

Suppose the user here is a scientist who is revisiting the original work
after publication, and she wishes to share the results of her
modifications with a group of other scientists.  Since each of her
branches is conveniently packaged into a separate file, she then simply
sends the files to the other researchers.  They may produce further
branches.

### Language and Interface

The software is written in R, and in its current prototype form, it runs
from the R command line.  Future versions will use a GUI, either on the
RStudio Shiny platform or RStudio *add-ons*.

### Main Functions

**rvinit():**  Initializes the **revisit** system.

**makebranch0(origcodenm):**  Inputs the original author's code and
forms a branch copy of it.

**loadb(br):**  Loads a branch.

**runb(startline,throughline):**  Runs a branch through a user-specified
set of lines in the code, pausing at the end. (*Restriction:* The start
and finish lines cannot be inside a function, including loops and
if-then-else.)

**saveb(br,desc):**  Save all the code changes to a new branch with the
given name and brief description.

**edt():**  Make a change to the current code.

**pause():**  Insert of this call will pause execution at the given
point, useful for instance immediately following a plotting function to
give the user a chance to view the plot.

**t.test.rv():**  Overloads R's **t.test()**.  Calls the latter but
warns the user if a small p-value arises merely from a large sample size
rather than from a substantial effect.  Many more of these are planned.



### First Example

