## Using dplyr for filtering and summarising data
library(dplyr)

## Reading the R Databases
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Filtering data to pick rows only for Baltimore City, Maryland (fips == "24510")
filter_by_fips <- filter(NEI, fips == "24510")

## Now, grouping the dataset by year
by_year <- group_by(filter_by_fips, year)

## Creating a summarised dataframe
plot2.df <- summarise(by_year, tot.pm2.emission = sum(Emissions))

## Open PNG device; create "plot1.png" in working directory
png(file = "plot2.png", width = 480, height = 480, units = "px")

## Creating the barplot based on the summarised dataset
with(plot2.df, barplot(height = tot.pm2.emission, names.arg = year, xlab = "Years", ylab = "Total PM2.5 emission", main = "Total PM2.5 emissions for various years in Baltimore City, Maryland"))

dev.off()         ## Close the PNG file device