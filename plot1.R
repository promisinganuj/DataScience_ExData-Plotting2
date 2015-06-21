## Using dplyr for summarising data
library(dplyr)

## Reading the R Databases
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Grouping the dataset by year
by_year <- group_by(NEI, year)

## Creating a summarised dataframe
plot1.df <- summarise(by_year, tot.pm2.emission = sum(Emissions))

## Open PNG device; create "plot1.png" in working directory
png(file = "plot1.png", width = 480, height = 480, units = "px")

## Creating the barplot based on the summarised dataset
with(plot1.df, barplot(height = tot.pm2.emission, names.arg = year, xlab = "Years", ylab = "Total PM2.5 emission", main = "Total PM2.5 emissions for various years"))

dev.off()         ## Close the PNG file device