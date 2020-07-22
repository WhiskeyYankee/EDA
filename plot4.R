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
# Step 2:
# Create a Coal attribute for the SCC data set that indicates true if the Short.Name
# starts with "coal" or contains " coal" note the space in front of the second coal
# is to ensure words like Charcoal which is produced by burning wood and is not
# a fossil fuel.
###############################################################################################################

SCC$Coal <- grepl("[^aA:zZ][cC][oO][aA][lL]",SCC$Short.Name)
Coal <- SCC %>%
  filter(Coal == TRUE) %>%
  select(SCC)


###############################################################################################################
# Step 3:
# Create a data set for question 4 by selecting only the NEI data with an SCC code related
# to coal and summarize the total emmissions by year
###############################################################################################################
NEI_Q4 <- inner_join(NEI,Coal, by = c("SCC")) %>%
  group_by(year) %>%
  summarise(TotalEmissions = sum(Emissions))

###############################################################################################################
# Step 4: create smooth plot to indicate the US Coal emissions from 1999-2008
###############################################################################################################

ggsave( filename = "C:/Users/peted/Desktop/Data_Science/ExploratoryDataAnalysis/Week 4/Repo/Plot4.png",
        plot = ggplot(data = NEI_Q4, mapping = aes(x = year, y = TotalEmissions)) +
          geom_smooth()+
          scale_x_continuous(breaks =c(1999,2002,2005,2008))+
          ggtitle("US Coal Emissions from 1999-2008"))
