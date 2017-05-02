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
  operations for also data cleaning and "wrangling."  It must be such
  that running it "replays" the entire set of operations on the data.

* Other researchers -- say a referee for the manuscript or other
  scientists seeking to learn from the published version of the paper --
  would then use to **revisit** package as follows.  
  
  The user thinks of questions involving alternate scenarios.  What, for
  instance, would occur if one would more aggressively weed out
  outliers?  How would the results change?  What if different predictor
  variables were used, or squared and interaction terms added?  How
  valid are the models and assumptions?  What about entirely different
  statistical approaches?

  In each case, the user calls a **revisit** function to run the code to
  the line that she wishes to modify, makes the change, then resumes
  running the code from that point.  If the results are useful, the user
  then save the entire code, including modifications, to a new *branch*.

* The package spots troublesome statistical situations, and issues
  advice and warnings, in light of concerns that too many "false
  positives" are being reported in published research.  For example, the
  package may emit a message like, "Warning: small p-value does not seem
  to correspond to an effect of practical importance."  Procedures for
  multiple inference, are also available.

*On the other hand, the package is not aimed to "automate" statistical
analysis.*  The user decides which analyses to try, with the core
package consisting of tools that facilitate exploring, recording and
packaging alternative analyses.

If the original data file is, say, **x.R**, then the branches will be
named **x.1.R**, **x.2.R** and so on.  Each branch will have a brief,
user-supplied description.

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

### Main functions

**rvinit():**  Initializes the **revisit** system.

**makebranch0(origcodenm):**  Inputs the original author's code and
forms a branch copy of it.

**loadb(br):**  Loads a branch.

**runb(startline,throughline):**  Runs a branch through a user-specified
set of lines in the code, pausing at the end. (*Restriction:* The start
and finish lines cannot be inside a function, including loops and
if-then-else.)

**saveb(branchnum,desc):**  Save all the code changes to a new branch with the
given name and brief description.

**edt():**  Make a change to the current code.  Primitive for now.

**pause():**  Insert of this call will pause execution at the given
point, useful for instance immediately following a plotting function to
give the user a chance to view the plot.

**t.test.rv(x,y):**  Overloads R's **t.test()**.  Calls the latter but
warns the user if a small p-value arises merely from a large sample size
rather than from a substantial effect.  Many more of these are planned.

### GUI version

The current text-based version is just a prototype. A GUI version, much
more convenient to use, is planned.


### First example

