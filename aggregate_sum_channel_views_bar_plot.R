library(ggplot2)
library(dplyr)
library(scales)
library(tidyverse)

# Gets the current directory and adds the "csv" folder to the path
# This assumes that the path is set up the same way as my local machine
working_dir <- getwd()
directory_path <- paste(working_dir, "/csv", sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

pdf("Bar Plot of Total Views for Every Channel.pdf")

# Create an empty data frame to store aggregated data
aggregate_data <- data.frame()

sum_views <- NULL

# Iterate through each file
for (file in files) {
  # Read the CSV file
  data <- read.csv(file, sep = '~')
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(views = as.numeric(gsub(",", "", views)))
  
  # Calculate the sum of views
  sum_views <- sum(data$views, na.rm = TRUE)
  
  # Append the data to the aggregate data frame
  aggregate_data <- rbind(aggregate_data, data.frame(file = file, sum_views = sum_views))
}

# Create a bar plot of the aggregated data
ggplot(aggregate_data, aes(x = file, y = sum_views)) +
  geom_bar(stat = "identity") +
  labs(title = "Bar Plot of Aggregate Views", x = "Channel", y = "Sum of Views") +
  theme_minimal()

dev.off()
