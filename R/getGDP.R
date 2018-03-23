library(readxl)

# gets GDP data from the Bureau of Economic Analysis web site;
# span="year" (default) or "quarter" - get annual or quarterly GDP data;
# overwrite=FALSE (default) or TRUE  - overwrite local data if already gotten;
# year fields: year, gdp_curr, gdp_const, change=real growth of year (percent);
# quarter fields: quarter, gdp_curr, gdp_const, change=real annualized growth of quarter,
#  change4q=real growth of last 4 quarters; iyear, qtr, & year - calculated from quarter

getGDP <- function(span="year",overwrite=FALSE) {
   filepath <- "gdplev.xlsx"
   if (!file.exists(filepath) | overwrite == TRUE) {
      download.file("https://www.bea.gov/national/xls/gdplev.xlsx", "gdplev.xlsx", mode = "wb")
   }
   xx <- read_excel(filepath, col_names = FALSE, skip = 8)
   if (span == "year") {
      gg <- as.data.frame(xx[!is.na(xx[,1]),1:3])
      colnames(gg) <- c("year", "gdp_curr", "gdp_const")
      change <- 100 * diff(gg$gdp_const, 1) / gg$gdp_const[1:(length(gg$gdp_const)-1)]
      gg$change <- NA
      gg$change[2:(length(gg$change))] <- change
      gg$year <- as.numeric(gg$year)
   }
   else {
      gg <- as.data.frame(xx[!is.na(xx[,5]),5:7])
      colnames(gg) <- c("quarter", "gdp_curr", "gdp_const")
      change <- 100 * (diff(gg$gdp_const, 1) / gg$gdp_const[1:(length(gg$gdp_const)-1)] + 1)^4 - 100
      gg$change <- NA
      gg$change[2:(length(gg$change))] <- change
      change4q <- 100 * diff(gg$gdp_const, 4) / gg$gdp_const[1:(length(gg$gdp_const)-4)]
      gg$change4q <- NA
      gg$change4q[5:(length(gg$change4q))] <- change4q
      
      gg$iyear <- as.numeric(substr(gg$quarter,1,4))
      gg$qtr   <- as.numeric(substr(gg$quarter,6,6))
      gg$year  <- gg$iyear + (gg$qtr-1)/4
   }
   gdp <- gg
}
