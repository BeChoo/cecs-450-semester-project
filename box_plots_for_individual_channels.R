library(tidyverse)

# Gets the current directory
working_dir <- getwd()

# Save the plot to a PDF in the "graph_pics" folder
pdf("graph_pics/Box_Plots.pdf")

# Navigate to the CSV files and add the "csv" folder to the path
directory_path <- paste(working_dir, "/csv", sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

# Create an empty data frame to store aggregated data
aggregate_data <- data.frame()

# Create an empty list to store plots
plots <- list()

# Iterate through each file
for (file in files) {
  # Read the CSV file
  data <- read.csv(file, sep = '~')
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_views = as.numeric(gsub(",", "", views)))
  
  filename = basename(file)
  
  # Create a box plot for the current file
  plot <- ggplot(data, aes(x = filename, y = numeric_views)) +
    geom_boxplot() +
    labs(title = filename, x = "Channel", y = "Numeric Views") +
    scale_y_log10(labels = scales::comma)
  
  # Save the plot to the list
  plots[[filename]] <- plot
}

for (filename in names(plots)) {
  print(plots[[filename]])
}

dev.off()
