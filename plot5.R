###############################################################################################################
# Step 0: load packages
###############################################################################################################
library(tidyverse)

###############################################################################################################
# Step 1: Read in the RDS files from the source
###############################################################################################################

DataCon <- gzcon(url("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"))
SCC <-readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")
close(DataCon)

###############################################################################################################
# Step 2: Filter the data to only include Onroad sources as these seem to all be vehicles
# Then Aggregate the Total Emissions by year to determine the total PM2.5 emissions 
###############################################################################################################

NEI_Q5 <- inner_join(NEI, subset(SCC, Data.Category == "Onroad") %>% select(SCC), by = "SCC") %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(TotalEmissions = sum(Emissions))

###############################################################################################################
# Step 3:Create a barplots with trendlines with facets set to the type 
###############################################################################################################

ggsave( filename = "C:/Users/peted/Desktop/Data_Science/ExploratoryDataAnalysis/Week 4/Repo/Plot5.png",
        plot = ggplot(data = NEI_Q5, mapping = aes(x = year, y = TotalEmissions)) +
          geom_smooth()+
          scale_x_continuous(breaks =c(1999,2002,2005,2008))+
          ggtitle("Baltimore Vehicle (On road) Emissions from 1999-2008"))
