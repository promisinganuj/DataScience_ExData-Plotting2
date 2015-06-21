## Using dplyr for filtering and summarising data
library(dplyr)
library(ggplot2)
## Reading the R Databases
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Get the SCC column values for filtering coal related emission
SCC_Coal <- SCC[grep("Coal", SCC$Short.Name, ignore.case = TRUE),1]

## Filter NEI dataset for the above SCCs
NEI.Coal <- NEI[NEI$SCC %in% SCC_Coal,]

## Now, grouping the dataset by year
by_year <- group_by(NEI.Coal, year)

## Creating a summarised dataframe
plot4.df <- summarise(by_year, tot.pm2.emission = sum(Emissions))

## Creating the plot based on the summarised dataset
plot <- qplot(year, tot.pm2.emission, data=plot4.df, geom="path", main="Emissions From Coal-Combustion Related Sources In USA", xlab="Year", ylab="PM2.5 Emissions")

## Saving the plot
ggsave(plot, file="plot4.png", width=7, height=5)