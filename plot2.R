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
# Step 2: Filter the data to only include records for  Baltimore City, Maryland (fips == "24510")
# Then Aggregate the Total Emissions by year to determine the total PM2.5 emissions from all sources
###############################################################################################################

NEI_Q2 <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(TotalEmissions = sum(Emissions))

###############################################################################################################
# Step 3:Create a barplot to clearly show how the total emissions varies from 1999 - 2008
###############################################################################################################

png(filename = "C:/Users/peted/Desktop/Data_Science/ExploratoryDataAnalysis/Week 4/Repo/Plot2.png")

with(data = NEI_Q2,
     barplot(height = TotalEmissions
             , year 
             ,names.arg = as.character(year)
             ,main = "Total Balitimore PM2.5 Emissions 1999 - 2008"
     ))

dev.off()