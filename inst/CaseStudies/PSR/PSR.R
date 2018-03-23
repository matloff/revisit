library(readxl)
library(reshape2)
library(ggplot2)

getPop <- function(overwrite=FALSE) {
   filepath <- "pop1.xlsx"
   if (!file.exists(filepath) | overwrite == TRUE) {
      download.file("https://esa.un.org/unpd/wpp/DVD/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES.xlsx", "pop1.xlsx", mode = "wb")
   }
   xx <- read_excel(filepath, col_names = TRUE, skip = 16, sheet = "MEDIUM VARIANT")
}
getPSR <- function(overwrite=FALSE) {
   filepath <- "psr2065.xlsx"
   if (!file.exists(filepath) | overwrite == TRUE) {
      #download.file("https://esa.un.org/unpd/wpp/DVD/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2017_POP_F14_A_POTENTIAL_SUPPORT_RATIO_1564_65.xlsx", "psr1565.xlsx", mode = "wb")
      download.file("https://esa.un.org/unpd/wpp/DVD/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2017_POP_F14_B_POTENTIAL_SUPPORT_RATIO_2064_65.xlsx", "psr2065.xlsx", mode = "wb")
   }
   xx <- read_excel(filepath, col_names = TRUE, skip = 16, sheet = "MEDIUM VARIANT")
}
xx <- getPop()
colnames(xx)[3] <- "Name"
colnames(xx)[5] <- "Code"
xx$Name[xx$Name == "Russian Federation"] <- "Russia"
xx$Name[xx$Name == "United States of America"] <- "United States"
xx$Region <- ""
region <- ""
for (i in 1:NROW(xx)){
   if (xx[i, "Name"] %in% c("WORLD","AFRICA","ASIA","EUROPE",
                            "LATIN AMERICA AND THE CARIBBEAN",
                            "NORTHERN AMERICA", "OCEANIA")){
      region <- xx[i, "Name"]
   }
   xx[i, "Region"] <- region
}
cc <- xx[xx$Code < 900,]
moredev <- cc[cc$Region %in% c("EUROPE","NORTHERN AMERICA") |
              cc$Name %in% c("Japan","Australia","New Zealand"),]
lessdev <- cc[!(cc$Region %in% c("EUROPE","NORTHERN AMERICA")) &
              !(cc$Name %in% c("Japan","Australia","New Zealand")),]
moredev <- moredev[order(-moredev["2015"]),]
lessdev <- lessdev[order(-lessdev["2015"]),]
moredf <- as.data.frame(moredev[,c("Name","2015")])
lessdf <- as.data.frame(lessdev[,c("Name","2015")])
moredf[,2] <- format(round(as.numeric(moredf[,2]/1000), 2), nsmall = 2)
lessdf[,2] <- format(round(as.numeric(lessdf[,2]/1000), 2), nsmall = 2)
cat("\nPOPULATION IN 2015 (millions, most populous more-developed countries)\n\n")
print(head(moredf,10))
cat("\nPOPULATION IN 2015 (millions, most populous less-developed countries)\n\n")
print(head(lessdf,10))
moredevg <- moredev$Name[1:6]
lessdevg <- lessdev$Name[1:6]
moredevp <- moredev$Name[1:10]
lessdevp <- lessdev$Name[1:10]

xx <- getPSR()
colnames(xx)[3] <- "Name"
colnames(xx)[5] <- "Code"
xx$Name[xx$Name == "Russian Federation"] <- "Russia"
xx$Name[xx$Name == "United States of America"] <- "United States"

more <- xx[xx$Name %in% moredevp,]
less <- xx[xx$Name %in% lessdevp,]
tmore <- t(more[-seq(1:5)])
tless <- t(less[-seq(1:5)])
colnames(tmore) <- more$Name
colnames(tless) <- less$Name
tmorep <- as.data.frame(tmore[,moredevp])
tlessp <- as.data.frame(tless[,lessdevp])
for (i in 1:NCOL(tmorep)){
   tmorep[,i] <- format(round(as.numeric(tmorep[,i]), 2), nsmall = 2, big.mark = ",")
}
for (i in 1:NCOL(tlessp)){
   tlessp[,i] <- format(round(as.numeric(tlessp[,i]), 2), nsmall = 2, big.mark = ",")
}
cat("\nWORKERS PER RETIREE (most populous more-developed countries)\n\n")
print(tmorep)
cat("\nWORKERS PER RETIREE (most populous less-developed countries)\n\n")
print(tlessp)
tmore <- tmore[,moredevg]
tless <- tless[,lessdevg]
mmore <- melt(tmore)
colnames(mmore) <- c("Year", "variable", "value")
gg <- ggplot(mmore, aes(x=Year, y=value, group=variable)) +
   geom_line(aes(color = variable), size = 1, alpha = 0.7) +
   geom_point(aes(color=variable, shape=variable), size=3, alpha=0.7) +
   scale_x_continuous(breaks = seq(2010,2100,10), minor_breaks = seq(2010,2100,10)) +
   scale_y_continuous(breaks = seq(0,5,1)) +
   geom_hline(yintercept = 0) +
   #scale_color_manual(values = c("red","green4","blue")) +
   #scale_shape_manual(values = c(15,16,17)) +
   ggtitle("Workers Per Retiree (ages 20-64 per ages 65+)") +
   labs(x = "Source: https://esa.un.org/unpd/wpp/Download/Standard/Population/") +
   labs(y = "Workers Per Retiree")
X11() # comment out if using png and readPNG
print(gg)

mless <- melt(tless)
colnames(mless) <- c("Year", "variable", "value")
gg <- ggplot(mless, aes(x=Year, y=value, group=variable)) +
   geom_line(aes(color = variable), size = 1, alpha = 0.7) +
   geom_point(aes(color=variable, shape=variable), size=3, alpha=0.7) +
   scale_x_continuous(breaks = seq(2010,2100,10), minor_breaks = seq(2010,2100,10)) +
   scale_y_continuous(breaks = seq(0,20,2), minor_breaks = seq(0,20,2)) +
   geom_hline(yintercept = 0) +
   #scale_color_manual(values = c("red","green4","blue")) +
   #scale_shape_manual(values = c(15,16,17)) +
   ggtitle("Workers Per Retiree (ages 20-64 per ages 65+)") +
   labs(x = "Source: https://esa.un.org/unpd/wpp/Download/Standard/Population/") +
   labs(y = "Workers Per Retiree")
X11() # comment out if using png and readPNG
print(gg) # cannot currently output more than one plot on Shiny
