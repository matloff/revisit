# the file public.dta and the Stata code on which this R code is based
# is courtesy of M. Zavodny

doreg <- function(zav, startyear, endyear, id){

   zav <- zav[zav$year >= startyear & zav$year <= endyear,]

   ##### traditional employment rate and immigrant share model #####

   # employment rate for natives = employed natives divided by total native
   # population
   zav$emprate_native   <- zav$emp_native / zav$pop_native * 100

   # immigrant stem workers with advanced degrees from U.S. universities,
   # share of total workers employed

   zav$immshare_emp_stem_e_grad   <- zav$emp_edus_stem_grad / zav$emp_total * 100

   # immigrant stem workers with advanced degrees from non-U.S.
   # universities - share of total workers employed
   zav$immshare_emp_stem_n_grad   <- zav$emp_nedus_stem_grad / zav$emp_total * 100

   # logs of prior three values
   zav$lnemprate_native           <- log(zav$emprate_native)
   zav$lnimmshare_emp_stem_e_grad <- log(zav$immshare_emp_stem_e_grad)
   zav$lnimmshare_emp_stem_n_grad <- log(zav$immshare_emp_stem_n_grad)

   # year in sample (in this case, 2000-2007), converted to factors for
   # use as an instrumental variable
   zav$fyear  <- as.factor(zav$year)

   # 50 states plus Washington D.C., converted to factors for use as an
   # instrumental variable
   zav$fstate <- as.factor(zav$statefip)

   # need to normalize population weights so that each year has same weight;
   # otherwise, too much weight assigned to later years
   # do for total native population (age 16-64)
   zav$sum_pop_native <- with(zav, ave(pop_native, year, FUN=sum))
   zav$weight_native <- zav$pop_native / zav$sum_pop_native

   # remove non-positive values so that their logs are valid values (not
   # NaN or infinite, plus or minus)
   kk <- zav[zav$emp_edus_stem_grad > 0 & zav$emp_nedus_stem_grad > 0,]

   # do regression with two independent variables, two instrumental
   # variables, and weights to treat years equally

   mm <- (with(kk,
               lm(lnemprate_native ~
                     lnimmshare_emp_stem_e_grad +
                     lnimmshare_emp_stem_n_grad +
                     fyear +
                     fstate,
                  weights=weight_native)))

   # extract slope and p-value from summary
   slope <- mm$coefficients[2]
   stderr <- summary(mm)$coefficients[2,2]
   pvalue <- summary(mm)$coefficients[2,4]

   # calculate number of native jobs associated with change in immigrant share
   ols <- round(slope, 3)
   jobs <- sum(zav$emp_native)/sum(zav$emp_edus_stem_grad) * ols * 100

   if (id == 1){
      return(slope)
   } else if (id == 2){
      return(stderr)
   } else if (id == 3){
      return(pvalue)
   } else if (id == 4){
      return(jobs)
   } else {
      return -1
   }
}

yearTable <- function(
      func,       # user function to call with next four parameters
      df,         # dataframe containing the data
      minyear,    # minimum year of spans in table
      maxyear,    # maximum year of spans in table
      ind=1,      # indicator of value user function is to return
      minspan=1,  # minimum length of a span in the table
      dp=3,       # number of decimal places in table values
      wid=7,      # width of table columns (columns are separated by an additional space)
      title="",   # title to place above table
      divs=NULL,  # interval boundaries for html formatting
      color=NULL, # interval color (e.g., "red", #ff0000", ""), should be one longer than divs
      style=NULL  # interval style (e.g., "b", "i", ""), should be one longer than divs
   ){
   dashes <- strrep("-", wid)
   dots   <- strrep(".", wid)
   dashstr <- "----"
   for (i in (minyear+minspan):maxyear){
      dashstr <- paste(dashstr, dashes)
   }
   yearstr <- "Year"
   for (i in (minyear+minspan):maxyear){
      yearstr <- paste(yearstr, format(i, width = wid))
   }
   cat(title, sep = "\n")
   cat(dashstr, sep = "\n")
   cat(yearstr, sep = "\n")
   cat(dashstr, sep = "\n")
   for (i in minyear:(maxyear-minspan)){
      thiscolor <- ""
      thisstyle <- ""
      str <- i
      if (minyear < i){
         for (j in (minyear+1):i){
            str <- paste(str, dots)
         }
      }
      for (j in (i+minspan):maxyear){
         lastcolor <- thiscolor
         laststyle <- thisstyle
         n <- func(df, i, j, ind)
         nrnd <- round(n, dp)
         nstr <- format(nrnd, nsmall = dp, width = wid, scientific = FALSE)
         idiv <- length(divs)+1
         if (!is.null(divs)){
            for (k in 1:length(divs)){
               if (nrnd < divs[k]){
                  #nstr <- paste0("<b>", nstr, "</b>")
                  idiv <- k
                  break;
               }
            }
            thiscolor <- ""
            thisstyle <- ""
            if (idiv <= length(color)){
               thiscolor <- color[idiv]
            }
            if (idiv <= length(style)){
               thisstyle <- style[idiv]
            }
            if (thiscolor != lastcolor | thisstyle != laststyle){
               if (thisstyle != ""){
                  nstr <- paste0("<", thisstyle, ">", nstr)
               }
               if (thiscolor != ""){
                  nstr <- paste0('<font color="', thiscolor, '">', nstr)
               }
               if (lastcolor != ""){
                  nstr <- paste0("</font>", nstr)
               }
               if (laststyle != ""){
                  nstr <- paste0("</", laststyle, ">", nstr)
               }
            }
         }
         str <- paste(str, nstr)
      }
      if (thisstyle != ""){
         str <- paste0(str, "</", thisstyle, ">")
      }
      if (thiscolor != ""){
         str <- paste0(str, "</font>")
      }
      cat(str, sep = "\n")
   }
}

### data(zav) # zav.txt is .txt version of Zav. file public.dta
datapath <- system.file("data", package="revisit")                              
zav <- read.table(paste0(datapath, "/zav.txt"), header = TRUE)                
zav0 <- zav

cat("", sep = "\n")
title <- "                                      SLOPE"
yearTable (doreg, zav0, 2000, 2010, 1, 1, 4, 7, title, c(0), c("red",""), c("b",""))
cat("", sep = "\n")
title <- "                                      STDERR"
yearTable (doreg, zav0, 2000, 2010, 2, 1, 4, 7, title, c(0), c("red"), c("b",""))
cat("", sep = "\n")
title <- "                                     P-VALUE"
yearTable (doreg, zav0, 2000, 2010, 3, 1, 3, 7, title, c(0.01,0.05,0.1), c("red","orange","#00aa00"), c("b","b","b"))
cat("", sep = "\n")
title <- "    NEW NATIVE JOBS PER 100 FOREIGN-BORN STEM WORKERS WITH ADVANCED U.S. DEGREES"
yearTable (doreg, zav0, 2000, 2010, 4, 1, 2, 7, title, c(-0.0001,0.0001), c("#ff0000","#ff9900"), c("b","b"))
