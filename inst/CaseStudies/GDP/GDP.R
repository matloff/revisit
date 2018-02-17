library(reshape2)
library(ggplot2)
aa <- getGDP(span="year", overwrite="TRUE")
qq <- getGDP(span="quarter")
print(head(aa))
print(tail(aa))
print(head(qq))
print(tail(qq))

qq$change1y <- NA
for (i in min(aa$year):max(aa$year)){
   qq$change1y[qq$year == i] <- aa$change[aa$year == i]
   qq$change1y[qq$year == i+0.25] <- aa$change[aa$year == i]
   qq$change1y[qq$year == i+0.50] <- aa$change[aa$year == i]
   qq$change1y[qq$year == i+0.75] <- aa$change[aa$year == i]
}
gdp <- data.frame(qq$year, qq$change1y, qq$change, qq$change4q)
colnames(gdp) <- c("year", "year_1", "qtrs_1", "qtrs_4")
print(gdp)
print(tail(gdp,40))
X11() # comment out if using png and readPNG
gdpm <- melt(gdp, id="year")
gdpm <- gdpm[gdpm$year >= 2008,]
gg <- ggplot(gdpm, aes(x=year, y=value, group=variable)) +
   geom_line(aes(color = variable), size = 1, alpha = 0.7) +
   geom_hline(yintercept = 3) +
   geom_vline(xintercept = 2009) +
   geom_vline(xintercept = 2017) +
   scale_x_continuous(breaks = seq(2008,2017,2)) +
   scale_y_continuous(breaks = seq(-8,6,2)) +
   ggtitle("Real U.S. GDP Growth") +
   labs(x = "Year", y = "Percent Annualized")
print(gg)