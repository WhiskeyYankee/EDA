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
# Step 2: Filter the data to only include onroad sources (as these seem to all be vehicles)
# for Balitimore and Los Angeles and
# Then Aggregate the Total Emissions by year to determine the total PM2.5 emissions 
###############################################################################################################

NEI_Q6 <- inner_join(NEI, subset(SCC, Data.Category == "Onroad") %>% select(SCC), by = "SCC") %>%
  filter(fips %in% c("24510","06037")) %>%
  group_by(fips,year) %>%
  summarise(TotalEmissions = sum(Emissions))

###############################################################################################################
# Step 3:Create a smooth plots to show the trends for each
###############################################################################################################

ggsave( filename = "C:/Users/peted/Desktop/Data_Science/ExploratoryDataAnalysis/Week 4/Repo/Plot6.png",
        plot = ggplot(data = NEI_Q6, mapping = aes(x = year, y = TotalEmissions,color = fips)) +
          geom_smooth()+
          scale_x_continuous(breaks =c(1999,2002,2005,2008))+
          ggtitle("Vehicle (On road) Emissions from 1999-2008"))
