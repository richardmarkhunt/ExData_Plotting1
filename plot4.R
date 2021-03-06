## MASTER SCRIPT FOR PRODUCING PLOT 4 ##

# If no "data" folder exists as a subdirectory of the working directory
# create folder and download Dataset.zip
if (!file.exists("data")) {
  dir.create("data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "./data/household_power_consumption.zip", method = "curl")
dateDownloaded <- date()
#
# unzip and extract files into "data" subfolder
unzip("./data/household_power_consumption.zip", exdir = "./data")

# Set variables to be used for specific dataframe subset extraction from main datafile
# Beginning observation (row) in main datafile (obtained by viewing downloaded txt file)
beginDateTime <- strptime("2006-12-16 17:24:00", "%Y-%m-%d %H:%M:%S")
# Start observation (row) for dataframe subset extract (obtained by viewing downloaded txt file)
startDateTime <- strptime("2007-02-01 00:01:00", "%Y-%m-%d %H:%M:%S")

# Calculate and set variables for skip() and nrow() attributes for proposed dataframe
start <- startDateTime - beginDateTime
# first row of datafile to read in to dataframe
startRow <- as.numeric(start) * 24 * 60
# minutes in 48 hours, total number of rows to read in to dataframe
numRows <- 48 * 60 

# create character vector of coloumn names for dataframe
data_colnames <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

# read in datafile and create dataframe subset extract
one_twoFeb07_dataframe <- read.table("./data/household_power_consumption.txt", header = FALSE, col.names = data_colnames, skip = startRow, as.is = c(1:2), nrows = numRows, sep = ";")

# convert Date and Time variables from character to "Date" and "POSIXct/POSIXt" class respectively
one_twoFeb07_dataframe$Time <- dmy_hms(paste(one_twoFeb07_dataframe$Date, one_twoFeb07_dataframe$Time))
one_twoFeb07_dataframe$Date <- as.Date(one_twoFeb07_dataframe$Date, "%d/%m/%Y")

# produce line plots and send output to png file in current working directory
png(file = "plot4.png")
par(mfcol = c(2,2))
# top left plot
with(one_twoFeb07_dataframe, plot(Time, Global_active_power, type = "l", xlab = "", ylab = "Global Active Power"))
# bottom left plot
with(one_twoFeb07_dataframe, plot(Time, Sub_metering_1, xlab = "", ylab = "Energy sub metering", type = "n"))
with(one_twoFeb07_dataframe, points(Time, Sub_metering_1, type = "l"))
with(one_twoFeb07_dataframe, points(Time, Sub_metering_2, type = "l", col = "red"))
with(one_twoFeb07_dataframe, points(Time, Sub_metering_3, type = "l", col = "blue"))
legend("topright", lty=c(1,1), bty = "n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ))
# top right plot
with(one_twoFeb07_dataframe, plot(Time, Voltage, type = "l", xlab = "datetime"))
#bottom right plot
with(one_twoFeb07_dataframe, plot(Time, Global_reactive_power, type = "l", xlab = "datetime"))
dev.off()
# end of script