# Data

## Folder
if (!file.exists("./data")) {
    dir.create("./data")
}

## Download
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile="electric_power_consumption.zip")

## Unzip file
unzip("electric_power_consumption.zip", exdir="./data")

## Load file
pow <- read.table("./data/household_power_consumption.txt", sep=";", header=T)

## Reformat date
pow$Date <- as.Date(pow$Date, format="%d/%m/%Y")

## Subset data from 2007-02-01 and 2007-02-02
limited <- subset(pow, Date=="2007-02-01" | Date=="2007-02-02")

## Reformat time

### Merge date and time together
limited$DateTime <- paste(limited$Date, limited$Time, sep=":")

### Strip time
limited$DateTime <- strptime(limited$DateTime, format="%Y-%m-%d:%H:%M:%S")

limited$Date <- NULL
limited$Time <- NULL

## Convert "?" to NA
limited[limited=="?"] <- NA

## Convert classes to numeric
for (i in 1:7) {
    limited[, i] <- as.character(limited[, i])
    limited[, i] <- as.numeric(limited[, i])
}

str(limited)

# Plot
plot(limited$DateTime, limited$Sub_metering_1, xlab="", ylab="Energy sub metering", type="n", cex=0.5)
lines(limited$DateTime, limited$Sub_metering_1, col="Black")
lines(limited$DateTime, limited$Sub_metering_2, col="Red")
lines(limited$DateTime, limited$Sub_metering_3, col="Blue")
legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Copy to a PNG file
dev.copy(png, file="plot3.png")
dev.off()