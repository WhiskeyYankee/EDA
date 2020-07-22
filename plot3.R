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

NEI_Q3 <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year, type) %>%
  summarise(TotalEmissions = sum(Emissions))

###############################################################################################################
# Step 3:Create a barplots with trendlines with facets set to the type 
###############################################################################################################

ggsave( filename = "C:/Users/peted/Desktop/Data_Science/ExploratoryDataAnalysis/Week 4/Repo/Plot3.png",
  plot = ggplot(data = NEI_Q3, mapping = aes(x = year,y = TotalEmissions)) +
  geom_col() +
  geom_smooth(formula = y ~ x, method = "lm", se = FALSE)+
  facet_wrap(~type,scales = "free" ,ncol = 2, nrow = 2) +
  scale_x_continuous(breaks =c(1999,2002,2005,2008)) +
  ggtitle("Baltimore Total Emissions by year and type"))
