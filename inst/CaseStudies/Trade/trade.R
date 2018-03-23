library(reshape2)
library(ggplot2)

getTrade <- function(overwrite=FALSE) {
   filepath <- "goods.xls"
   if (!file.exists(filepath) | overwrite == TRUE) {
      download.file("https://www.census.gov/foreign-trade/statistics/historical/goods.xls", "goods.xls", mode = "wb")
   }
   xx <- read_excel(filepath, col_names = FALSE, skip = 6, col_types = "numeric")
   dd <- as.data.frame(xx[!is.na(xx[,1]),c(1,10,6,2)])
   colnames(dd) <- c("Year","Imports","Exports","Balance")
   # Convert from $millions to $billions
   dd$Imports <- dd$Imports / 1000
   dd$Exports <- dd$Exports / 1000
   dd$Balance <- dd$Balance / 1000
   trade <- dd
}
gdp <- getGDP(span="year", overwrite=FALSE)
trade <- getTrade(overwrite=FALSE)
minyr <- max(min(gdp$year), min(trade$Year))
maxyr <- min(max(gdp$year), max(trade$Year))
gdp   <- gdp  [gdp$year   >= minyr & gdp$year   <= maxyr,]
trade <- trade[trade$Year >= minyr & trade$Year <= maxyr,]
tradegdp <- trade
tradegdp$Imports <- 100 * tradegdp$Imports / gdp$gdp_curr
tradegdp$Exports <- 100 * tradegdp$Exports / gdp$gdp_curr
tradegdp$Balance <- 100 * tradegdp$Balance / gdp$gdp_curr
X11() # comment out if using png and readPNG
tradem <- melt(tradegdp, id="Year")
vcolor <- c("blue","green","red")
gg <- ggplot(tradem, aes(x=Year, y=value, group=variable)) +
   geom_line(aes(color = variable), size = 1, alpha = 0.7) +
   geom_point(aes(color=variable, shape=variable), size=3, alpha=0.7) +
   scale_x_continuous(breaks = seq(1960,2020,10)) +
   scale_y_continuous(breaks = seq(-8,16,4)) +
   geom_hline(yintercept = 0) +
   scale_color_manual(values = c("red","green4","blue")) +
   scale_shape_manual(values = c(15,16,17)) +
   ggtitle("U.S. Imports, Exports, and Trade Balance") +
   labs(x = "Source: https://www.census.gov/foreign-trade/statistics/historical/goods.xls") +
   labs(y = "Percent of GDP")
print(gg)
trade$GDP      <- gdp$gdp_curr
trade$ImportsP <- tradegdp$Imports
trade$ExportsP <- tradegdp$Exports
trade$BalanceP <- tradegdp$Balance
trade$Imports <- format(round(trade$Imports, 1), nsmall = 1, big.mark = ",")
trade$Exports <- format(round(trade$Exports, 1), nsmall = 1, big.mark = ",")
trade$Balance <- format(round(trade$Balance, 1), nsmall = 1, big.mark = ",")
trade$GDP     <- format(round(trade$GDP,     1), nsmall = 1, big.mark = ",")
trade$ImportsP <- format(round(trade$ImportsP, 3), nsmall = 1)
trade$ExportsP <- format(round(trade$ExportsP, 3), nsmall = 1)
trade$BalanceP <- format(round(trade$BalanceP, 3), nsmall = 1)
colnames(trade) <- c("Year","_Imports","_Exports","_Balance","______GDP","Imports%","Exports%","Balance%")
print(trade)