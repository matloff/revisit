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

**pause():**  Insert of this call will pause execution at the given
point, useful for instance immediately following a plotting function to
give the user a chance to view the plot.

**t.test.rv(x,y,alpha,bonf):**  Substitute for R's **t.test()**.  Calls the
latter but warns the user if a small p-value arises merely from a large
sample size rather than from a substantial effect.  If **bonf** is
larger than 1, **alpha** will be divided by **bonf** to implement
Bonferroni Inequality-based multiple inference.
Many more of these are planned.

**edt():**  Make a change to the current code.  Primitive for now.

**lcc():**  Display the current code.

### GUI version

The current text-based version is just a prototype. A GUI version, much
more convenient to use, is planned.


### First example

Let's start with something very simple.  Here is code that the original
author might submit:

```
data(pima)  # load data
# divide into diabetic, non-diabetics
d <- which(pima$Diab == 1)
diab <- pima[d,]
nondiab <- pima[-d,]
# form a confidence interval for each variable, difference between
# diabetics and non-diabetics
for (i in 1:8)  {
   tmp <- t.test(diab[,i],nondiab[,i])$conf.int
   cat(names(pima)[i],'  ',tmp[1],tmp[2],'\n')
}
```

Suppose the author supplied that code in a file **pima.R**, in the
directory from which **revisit** is being run.  (This file is in the
**examples** directory in the package.)
We could
"replay" the code:


```
> rvinit()
> makebranch0('pima.R') 
> loadb('pima.0.R') 
> runb()

```

The output is

```
NPreg   1.046125 2.089219 
Gluc   26.80786 35.74707 
BP   -0.388326 5.66958 
Thick   0.007076644 4.993282 
Insul   12.75944 50.3282 
BMI   3.735`811 5.940864 
Genet   0.06891135 0.1726207 
Age   4.209236 7.545092 
```

But we might think, "Hmm, the author doesn't seem to have done any data
cleaning."  As a quick check, we might apply R's **range()** function to
each of the predictor variables.

```
> for (i in 1:8) {
+   rng <- range(pima[,i])
+    cat(names(pima)[i],rng,'\n')
+ }
NPreg 0 17 
Gluc 0 199 
BP 0 122 
Thick 0 99 
Insul 0 846 
BMI 0 67.1 
Genet 0.078 2.42 
Age 21 81 
```

Those 0s are troubling. How can variables such as Glucose and BMI be 0?
So, we add code to remove cases like that.  We'd call **edt()** (not
shown here), inserting

```
any0 <- function(pimarow) any(pimarow[c(2,3,4,6)] == 0) 
badrows <- apply(pima,1,any0) 
pima <- pima[-badrows,] 
```

after

```
data(pima)
```

We could check that the new code looks right:

```
1 # original code 
2 data(pima) 
3 any0 <- function(pimarow) any(pimarow[c(2,3,4,6)] == 0) 
4 badrows <- apply(pima,1,any0) 
5 pima <- pima[-badrows,] 
6 # divide into diabetic, non-diabetics 
7 d <- which(pima$Diab == 1) 
8 diab <- pima[d,] 
9 nondiab <- pima[-d,] 
10 # form a confidence interval for each variable, difference between 
11 # diabetics and non-diabetics 
12 for (i in 1:8)  { 
13 *    tmp <- t.test(diab[,i],nondiab[,i])$conf.int 
14    cat(names(pima)[i],'  ',tmp[1],tmp[2],'\n') 
15 } 

```

We then call **runb()** again:

```
> runb()
NPreg    1.040483 2.086364 
Gluc    26.77046 35.73396 
BP    -0.4010154 5.673465 
Thick    -0.04601711 4.950227 
Insul    13.0941 50.74512 
BMI    3.739046 5.949183 
Genet    0.06848236 0.1724766 
Age    4.159615 7.497838 
```

Not much change from before, but those 0s may have had impacts on other
analyses, say regression.

If we find this worthwhile, we call **saveb()** to save the current
code to a new branch:

```
> saveb(1,'adds removal of suspicious 0s')
```

This creates branch 1, in a file **pima.1.R**. The description, "adds
removal...," is inserted as a comment in the first line of the file.

Next, we might say, "Really, we should use muliple comparisons here."
We are forming 8 confidence intervals, so it may be desirable to have at
least some protection.  We then call **edt()** again, replacing R's
**t.test()** function.  Since we are forming 8 confidence intervals, we
set the argument **bonf** to 8.  After calling **edt()** to make the
change, we check the code:

```
> lcc()
1 # original code 
2 data(pima) 
3 any0 <- function(pimarow) any(pimarow[c(2,3,4,6)] == 0) 
4 badrows <- apply(pima,1,any0) 
5 pima <- pima[-badrows,] 
6 # divide into diabetic, non-diabetics 
7 d <- which(pima$Diab == 1) 
8 diab <- pima[d,] 
9 nondiab <- pima[-d,] 
10 # form a confidence interval for each variable, difference between 
11 # diabetics and non-diabetics 
12 for (i in 1:8)  { 
13    tmp <- t.test.rv(diab[,i],nondiab[,i],bonf=8)$conf.int 
14    cat(names(pima)[i],'  ',tmp[1],tmp[2],'\n') 
15 } 
```



