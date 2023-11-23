library(ggplot2)
library(dplyr)
library(scales)

# Get the working directory path, then update it to the path of the files to create a plot for
# Path manually set here, but should be able to be updated so that it is automatically found
working_dir <- getwd()
csv_files <- "/csv"
directory_path <- paste(working_dir, csv_files, sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

# Create a single PDF file for saving the graphs
pdf("Views Over Time for All Channels.pdf")

for(file in files) {
  # Read the CSV file with a ~ delimiter
  data <- read.csv(file, sep = "~")
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_views = as.numeric(gsub(",", "", views)))
  
  # 'uptime_d' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_uptime_d = as.numeric(gsub(",", "", uptime_d)))
  
  # TODO
  # implement unique and distinct on uptime_d
  # see which gets better results and use that method
  
  # unique implementation
  data$numeric_uptime_d <- unique(data$numeric_uptime_d)

  # # distinct implementation
  # data <- distinct(data, numeric_uptime_d)
  
  # Create a line graph
  p <- ggplot(data, aes(x = numeric_uptime_d, y = numeric_views, group = 1)) +
    geom_line() +
    labs(title = paste(file, "Line Graph of Views Over Time", sep = ': '), x = "Time Since Upload", y = "Views") +
    scale_y_log10(labels = comma) +
    scale_x_log10(labels = comma) +
    theme(axis.text.y = element_text(size = 10),
          axis.text.x = element_text(size = 10, angle = 45, vjust = 0.5, hjust = 1))
    # guides(x = guide_axis(check.overlap = TRUE))
    
  print(p)
}

dev.off()

# AVERAGE VIEW AND MAX VALUE OF EACH CHANNEL
# COMPARE AVERAGE AND THE MOST THEY'VE GOTTEN
