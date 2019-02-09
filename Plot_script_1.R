## This script generates plot 1, a histogram
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

#Read the file
EPiC <- fread("household_power_consumption.txt", stringsAsFactors = FALSE)
EPiC <- filter(EPiC, (Date == "1/2/2007" | Date == "2/2/2007"))
EPiC[EPiC == "?"] <- NA
EPiC[,3:8] <- sapply(EPiC[,3:8], function(x) as.double(x))

# Here's the parameters to reproduce the plot - can be added later, but it's more readable this way
gCol = "red"
gMain = "Global Active Power"
gXlab = "Global Active Power (kilowatts)"
gYlab = "Frequency"
with(EPiC, hist(Global_active_power, col = gCol, main = gMain, xlab = gXlab, ylab = gYlab))

# It can be printed directly in png, but this way I can run the first lines, see if I like it and go on
dev.copy(png, 'plot1.png', height = 480, width = 480)
dev.off()
