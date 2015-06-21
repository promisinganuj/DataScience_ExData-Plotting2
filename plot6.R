library(dplyr)   ## Using dplyr for filtering and summarising data
library(ggplot2) ## Using ggplot2 for plotting

## Reading the R Databases
if (!exists("NEI")) {NEI <- readRDS("summarySCC_PM25.rds")}
if (!exists("SCC")) {SCC <- readRDS("Source_Classification_Code.rds")}

## Selecing the vehice related sources from SCC
SCC.MotorVehicle<- SCC[grep("Vehicle",SCC$EI.Sector, ignore.case = TRUE) ,1]

## Filtering NEI data for above SCCs
NEI.Vehicle <- NEI.Bal.La[NEI.Bal.La$SCC %in% SCC.MotorVehicle,]  

## Selecting data only for Baltimore City, Maryland (fips == "24510")
NEI.Veh.Bal <- filter(NEI.Vehicle, fips == "24510")
## Selecting data only for Los Angeles County, California (fips == "06037")
NEI.Veh.La  <- filter(NEI.Vehicle, fips == "06037")

## Now, grouping the datasets by year
NEI.Veh.Bal.by_year <- group_by(NEI.Veh.Bal, year, fips)
NEI.Veh.La.by_year  <- group_by(NEI.Veh.La, year, fips)

## Creating summarised dataframes
NEI.Veh.Bal.by_year.Sum <- summarise(NEI.Veh.Bal.by_year, tot.pm2.emission = sum(Emissions))
NEI.Veh.La.by_year.Sum  <- summarise(NEI.Veh.La.by_year, tot.pm2.emission = sum(Emissions))

## Adding new variable for getting normalized percentage change against 1999
NEI.Veh.Bal.by_year.Sum <- transform(NEI.Veh.Bal.by_year.Sum, ems.since1999 = ((tot.pm2.emission - tot.pm2.emission[1])/tot.pm2.emission[1])*100)
NEI.Veh.La.by_year.Sum  <- transform(NEI.Veh.La.by_year.Sum,  ems.since1999 = ((tot.pm2.emission - tot.pm2.emission[1])/tot.pm2.emission[1])*100)

## Add county name against each fips
NEI.Veh.Bal.by_year.Sum$County = "Baltimore City, MD"
NEI.Veh.La.by_year.Sum$County  = "Los Angeles, CA"

## Creating the final dataframe by rbinding the two DFs
plot6.df <- rbind(NEI.Veh.Bal.by_year.Sum, NEI.Veh.La.by_year.Sum)

## Initializing the plot
png("plot6.png", width=960, height=480)

## Creating the plot based on the summarised dataset
g <- ggplot(plot6.df, aes(factor(year), ems.since1999, fill = County)) +
       facet_grid(. ~ County) + ## Creating different plots for each county
       geom_bar(stat = "identity") + ## Bar plot
       xlab("year") + ## X-Label
       ylab(expression('Total PM'[2.5]*" Emissions % Change Against Year 1999")) + ## Y-Label
       ggtitle('Total Emissions from motor vehicle (type=ON-ROAD) in Baltimore City, MD vs Los Angeles, CA during 1999-2008') ## Overall Title

## Printing the plot
print(g)

## Closing file device
dev.off()