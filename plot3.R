library(dplyr)   ## Using dplyr for filtering and summarising data
library(ggplot2) ## Using ggplot2 for plotting

## Reading the R Databases
if (!exists("NEI")) {NEI <- readRDS("summarySCC_PM25.rds")}
if (!exists("SCC")) {SCC <- readRDS("Source_Classification_Code.rds")}

## Filtering data to pick rows only for Baltimore City, Maryland (fips == "24510")
filter_by_fips <- filter(NEI, fips == "24510")

## Now, grouping the dataset by year
by_year <- group_by(filter_by_fips, year, type)

## Creating a summarised dataframe
plot3.df <- summarise(by_year, tot.pm2.emission = sum(Emissions))

## Creating the plot using ggplot based on the summarised dataset
ggplot(plot3.df, aes(x = factor(year), y = tot.pm2.emission, fill=type)) +# base
  geom_point() + # printing it
  geom_bar(stat="identity") +# adding bars for representing the emission values
  facet_grid(. ~ type) +# adding different facets for each type
  xlab("year") +# adding X label
  ylab("Total PM2.5 emission") +# adding Y label
  ggtitle("PM2.5 emissions for various source types in different years in Baltimore City")

## Saving the plot
ggsave(file = "plot3.png") 