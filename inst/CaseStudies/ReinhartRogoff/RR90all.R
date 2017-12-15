library(foreign)
library(plyr)

prtWeightByCountry <- function(df, label){
  Country <- c("Australia","Belgium","Canada","Greece","Ireland","Italy","Japan","New Zealand","UK","US")
  country <- data.frame(Country)
  cc <- ddply(df, .(Country), summarize, dRGDP=mean(dRGDP))
  tot <- mean(cc$dRGDP)
  cc <- merge(country, cc, all.x = TRUE)
  cat(sprintf("%6.1f %7.1f %6.1f %6.1f %7.1f %6.1f %6.1f %7.1f %6.1f %6.1f %6.2f  %s\n",
              cc$dRGDP[1], cc$dRGDP[2], cc$dRGDP[3], cc$dRGDP[4], cc$dRGDP[5],
              cc$dRGDP[6], cc$dRGDP[7], cc$dRGDP[8], cc$dRGDP[9], cc$dRGDP[10], tot, label))
}

prtWeightByCountryYr <- function(df, label){
  cc <- ddply(df, .(Country), summarize, dRGDP=mean(dRGDP))
  cat(sprintf("%6.1f %7.1f %6.1f %6.1f %7.1f %6.1f %6.1f %7.1f %6.1f %6.1f %6.2f  %s\n",
              cc$dRGDP[1], cc$dRGDP[2], cc$dRGDP[3], cc$dRGDP[4], cc$dRGDP[5],
              cc$dRGDP[6], cc$dRGDP[7], cc$dRGDP[8], cc$dRGDP[9], cc$dRGDP[10], mean(df$dRGDP), label))
}

# The data file "RR-processed.dta" comes from the Herndon, Ash and Pollin (HAP) zip file
# https://www.peri.umass.edu/images/WP322HAP-RR-GITD-code-2013-05-17.zip
# which is linked to at
# https://www.peri.umass.edu/publication/item/526-does-high-public-debt-consistently-stifle-economic-growth-a-critique-of-reinhart-and-rogo-ff .
# RR-processed.dta is created by the HAP program RR.R, also in the zip file.

datapath <- system.file("data", package="revisit")                              
filepath <- paste0(datapath, "/RR-processed.dta")
RRp <- read.dta(filepath)
print("number of data in RR-processed.dta")
print(dim(RRp)[1])
RR90 <- RRp[!is.na(RRp$dRGDP) & !is.na(RRp$debtgdp) & RRp$debtgdp > 90,]
print("number of data with debtgdp > 90")
print(dim(RR90)[1])
RR1 <- RR90[RR90$Country != "Belgium" &
            RR90$Country != "Australia" &
            RR90$Country != "Canada" &
            (RR90$Country != "New Zealand" | RR90$Year > 1949),]
RR0 <- RR1
RR0$dRGDP[RR0$Country == "New Zealand" & RR0$Year == 1951] <- -7.9 # transcription  error
print("number of data used by RR")
print(dim(RR1)[1])

hdr1 <- c("  Aus-","       ","      ","      ","       ",
          "      ","      ","    New","\n")
hdr2 <- c("tralia","Belgium","Canada","Greece","Ireland",
          " Italy"," Japan","Zealand","    UK","    US", " TOTAL  Scenario\n")
cat(hdr1)
cat(hdr2)
prtWeightByCountry(RR0, "RR (Reinhart and Rogoff)")
prtWeightByCountry(RR1, "+ fix NZ transcription")

RR2 <- RR90[RR90$Country != "Australia" &
            RR90$Country != "Canada" &
            (RR90$Country != "New Zealand" | RR90$Year > 1949),]
prtWeightByCountry(RR2, "+ fix Excel error")

RR3 <- RR90[RR90$Country != "Australia" &
            RR90$Country != "Canada",]
prtWeightByCountry(RR3, "+ include 1946-1949 for NZ")

prtWeightByCountry(RR90, "+ include all data (1946-09)")
prtWeightByCountryYr(RR90, "+ use country-year weighting")

RR4 <- RR90[RR90$Year >= 1947,]
prtWeightByCountry(RR4, "all data for 1947-2009")

RR5 <- RR90[RR90$Year >= 1952,]
prtWeightByCountry(RR5, "all data for 1952-2009")

RR6 <- RR90[RR90$Year >= 1980,]
prtWeightByCountry(RR6, "all data for 1980-2009")
