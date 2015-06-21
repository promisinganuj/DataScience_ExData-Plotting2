library(dplyr)   ## Using dplyr for filtering and summarising data
library(ggplot2) ## Using ggplot2 for plotting

## Reading the R Databases
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Filtering data to pick rows only for Baltimore City, Maryland (fips == "24510")
NEI.Baltimore <- filter(NEI, fips == "24510")

## Selecing the vehice related sources from SCC
SCC.MotorVehicle<- SCC[grep("Vehicle",SCC$EI.Sector, ignore.case = TRUE) ,1]

## Further filtering NEI data for above SCCs
NEI.Baltimore.Vehicle <- NEI.Baltimore[NEI.Baltimore$SCC %in% SCC.MotorVehicle,]  

## Now, grouping the dataset by year
by_year <- group_by(NEI.Baltimore.Vehicle, year)

## Creating a summarised dataframe
plot5.df <- summarise(by_year, tot.pm2.emission = sum(Emissions))

## Creating the plot based on the summarised dataset
plot <- qplot(year, tot.pm2.emission, data=plot5.df, geom="path", main="Emissions From Motor Vehicle Sources In Baltimore", xlab="Year", ylab="PM2.5 Emissions")

## Saving the plot
ggsave(plot, file="plot5.png", width=7, height=5)