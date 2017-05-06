# revisit: an R Package for Statistical Reproducibility and Alternate Analysis

### The reproducibility crisis

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

### The **revisit** package 

The package is aimed to help remedy such problems.  It has two main functions:

*  It makes it easier and more convenient for the user to explore the
   effects of various changes that might be made on the original
   author's analyses.  The package facilitates changing, replaying and
   recording various versions of the analyses.  

*  The package spots troublesome statistical situations, and issues
   advice and warnings, in light of concerns that too many "false
   positives" are being reported in published research.  For example, the
   package may emit a message like, "Warning: small p-value does not seem
   to correspond to an effect of practical importance."  Procedures for
   multiple inference, are also available.

More specifically, suppose the user here is a scientist who is
revisiting the original work after publication:  

*  The user thinks of questions involving alternate scenarios.  What,
   for instance, would occur if one would more aggressively weed out
   outliers?  How would the results change?  What if different predictor
   variables were used, or squared and interaction terms added?  How
   valid are the models and assumptions?  What about entirely different
   statistical approaches?

*  In exploring such questions, this user will modify the original
   author's code, producing at least one new version of the code, and
   likely several versions.  The **revisit** package facilitates this,
   making easier for the user to make changes and record them into
   different *branches* of the code.

*  In addition, this user may wish to share the results of her 
   exploration of alternate analyses of the data with other scientists.  
   Since each of her branches is conveniently packaged into a separate
   file, she then simply sends the files to the other researchers.  The
   package allows the latter to easily "replay" the analyses, and they
   in turn may use the package to produce further branches.

*On the other hand, the package is not aimed to "automate" statistical
analysis.*  The user decides which analyses to try, with the core
package consisting of tools that facilitate exploring, recording and
packaging alternative analyses.

If the original data file is, say, **x.R**, then the branches will be
named **x.1.R**, **x.2.R** and so on.  Each branch will have a brief,
user-supplied description.


### Language and Interface

The software is written in R, and *in its current prototype form*, it runs
from the R command line.  Future versions will use a GUI, say using
RStudio *add-ons*.

### Main functions

**rvinit():**  Initializes the **revisit** system.

**makebranch0(origcodenm):**  Inputs the original author's code and
forms a branch copy of it.

**loadb(br):**  Loads a branch.

**runb(startline,throughline):**  Runs a branch through a user-specified
set of lines in the code, pausing at the end.  By default, these are the
numbers of the first and last lines of the code, but other numbers can
be specified.  Use 'c' to continue from the current line, or 's' to
execute just the current line.  (*Restriction:* The start and finish
lines cannot be inside a function, including loops and if-then-else.)  

**saveb(branchnum,desc):**  Save all the code changes to a new branch
with the given name and brief description.

**edt():**  Make a change to the current code.  Primitive for now.

**pause():**  Insert of this call will pause execution at the given
point, useful for instance immediately following a plotting function to
give the user a chance to view the plot.

**t.test.rv(x,y,alpha,bonf):**  Substitute for R's **t.test()**.  Calls the
latter but warns the user if a small p-value arises merely from a large
sample size rather than from a substantial effect.  If **bonf** is
larger than 1, **alpha** will be divided by **bonf** to implement
Bonferroni Inequality-based multiple inference.
Many more of these are planned.

### GUI version

The current text-based version is just a prototype. A GUI version, much
more convenient to use, is planned.


### First example

Let's start with something very simple.  Here is code that the original
author might submit:

```
data(pima)
print(summary(glm(Diab ~ .,data=pima)))
```

Suppose the author supplied that code in a file **pima.R**.  We could
"replay" the code:


```
> rvinit()
> makebranch0('pima.R') 
> loadb('pima.0.R') 
> runb()

```

The output is

```
...
Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.8538943  0.0854850  -9.989  < 2e-16 ***
NPreg        0.0205919  0.0051300   4.014 6.56e-05 ***
Gluc         0.0059203  0.0005151  11.493  < 2e-16 ***
BP          -0.0023319  0.0008116  -2.873  0.00418 ** 
Thick        0.0001545  0.0011122   0.139  0.88954    
Insul       -0.0001805  0.0001498  -1.205  0.22857    
BMI          0.0132440  0.0020878   6.344 3.85e-10 ***
Genet        0.1472374  0.0450539   3.268  0.00113 ** 
Age          0.0026214  0.0015486   1.693  0.09092 .  
...
```

But we might think, "Hmm, the author doesn't seem to have done any data
cleaning."  As a quick check, we might apply R's **range()** function to
each of the predictor variables.

```
> for (i in 1:8) print(range(pima[,i]))
[1]  0 17
[1]   0 199
[1]   0 122
[1]  0 99
[1]   0 846
[1]  0.0 67.1
[1] 0.078 2.420
[1] 21 81
```

Those 0s are troubling. How can variables such as Glucose and BMI be 0?
So, we could add code to remove cases like that.  We'd call **edit()**,
then call **runb()** again:

If we find this interesting, we call **saveb()** to save that branch.


