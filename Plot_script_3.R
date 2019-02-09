## This script generates plot 3, an overlay line chart
# Check for packages and install if the reviewer does not have them
if (!require("data.table",character.only = TRUE))
{
  install.packages("data.table",dep=TRUE)
  if(!require("data.table",character.only = TRUE)) stop("Package data.table not found")
}

if (!require("dplyr",character.only = TRUE))
{
  install.packages("dplyr",dep=TRUE)
  if(!require("dplyr",character.only = TRUE)) stop("Package dplyr not found")
}

# File download to have the script run everywhere
if (!file.exists("household_power_consumption.txt")) {
  myUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(myUrl, "household_power_consumption.zip", method = "auto")
  unzip("household_power_consumption.zip")
} 

Sys.setlocale(category = "LC_TIME", locale = "C") # I need this line to have weekdays in English

# Reads the file
EPiC <- fread("household_power_consumption.txt", stringsAsFactors = FALSE)
EPiC <- filter(EPiC, (Date == "1/2/2007" | Date == "2/2/2007"))
EPiC[EPiC == "?"] <- NA
EPiC$gTime <- strptime(paste(EPiC$Date, EPiC$Time), format = "%d/%m/%Y %H:%M:%S", tz = "America/New_York")
EPiC[,3:8] <- sapply(EPiC[,3:8], function(x) as.double(x))

# Define some variables for later use
gYlab = "Energy sub metering"
gYlim = c(min(EPiC[,7:9], na.rm = TRUE), max(EPiC[,7:9], na.rm = TRUE))
windows(height = 8, width = 8)

# Lines function only works on existing plots
with(EPiC, plot(gTime, Global_active_power, type="n", xlab = "", ylab = gYlab, ylim = gYlim))
with(EPiC, lines(gTime, Sub_metering_1, type = "l", col = "black", lwd =1.5))
with(EPiC, lines(gTime, Sub_metering_2, type = "l", col = "red", lwd =1.5))
with(EPiC, lines(gTime, Sub_metering_3, type = "l", col = "blue", lwd =1.5))
legend("topright", legend=names(EPiC[7:9]), col=c("black", "red", "blue"), lty=1, lwd =1.5)

# It can be printed directly in png, but this way I can run the first lines, see if I like it and go on
dev.copy(png, 'plot3.png', height = 480, width = 480)
dev.off()
