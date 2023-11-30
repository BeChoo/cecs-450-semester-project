# # Check if patchwork is already installed
# if (!requireNamespace("patchwork", quietly = TRUE)) {
#   # If not installed, install the package
#   install.packages('patchwork')
# }
# 
# library(tidyverse)
# library(patchwork)
# 
# # Gets the current directory
# working_dir <- getwd()
# 
# # Save the plot to a PDF in the "graph_pics" folder
# pdf("graph_pics/Box_Plots_for_Comparison.pdf")
# 
# # Navigate to the CSV files and add the "csv" folder to the path
# directory_path <- paste(working_dir, "/csv", sep = '')
# 
# # Set the working directory to the directory path set above
# setwd(directory_path)
# 
# # List all files in the directory, ignoring files that are not CSVs
# files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)
# 
# # Create an empty data frame to store aggregated data
# aggregate_data <- data.frame()
# 
# # Create an empty list to store plots
# plots <- list()
# 
# # Iterate through each file
# for (i in seq_along(files)) {
#   file <- files[i]
#   # Read the CSV file
#   data <- read.csv(file, sep = '~')
# 
#   # 'views' is being read as a string, this will update it to an int
#   data <- data %>%
#     mutate(numeric_views = as.numeric(gsub(",", "", views)))
# 
#   filename <- basename(file)
# 
#   # Create a box plot for the current file
#   plot <- ggplot(data, aes(x = filename, y = numeric_views)) +
#     geom_boxplot() +
#     labs(title = filename, x = "Channel", y = "Numeric Views") +
#     scale_y_log10(labels = scales::comma)
# 
#   # Save the plot to the list
#   plots[[filename]] <- plot
# 
#   # Check if it's the fifth plot or the last plot
#   if (i %% 5 == 0 || i == length(files)) {
#     # Combine all plots into a single plot side by side
#     combined_plot <- wrap_plots(plots, ncol = 5)
# 
#     # Print the combined plot
#     print(combined_plot)
# 
#     # Clear the list for the next set of plots
#     plots <- list()
#   }
# }
# 
# dev.off()


# Check if cowplot is already installed
if (!requireNamespace("cowplot", quietly = TRUE)) {
  # If not installed, install the package
  install.packages("cowplot")
}

library(tidyverse)
library(cowplot)

# Gets the current directory
working_dir <- getwd()

# Create a new PDF file
pdf("graph_pics/Testing_Box_Plots_for_Comparison.pdf")

# Navigate to the CSV files and add the "csv" folder to the path
directory_path <- paste(working_dir, "/csv", sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

# Number of plots per page
plots_per_page <- 5

# Create an empty list to store plots
plots <- list()

# Iterate through each file
for (i in seq_along(files)) {
  file <- files[i]
  # Read the CSV file
  data <- read.csv(file, sep = '~')
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_views = as.numeric(gsub(",", "", views)))
  
  filename <- basename(file)
  
  # Create a box plot for the current file
  plot <- ggplot(data, aes(x = "Channel", y = numeric_views)) +
    geom_boxplot() +
    labs(title = filename, x = "Channel", y = "Numeric Views") +
    scale_y_log10(labels = scales::comma) +
    facet_wrap(~dummy + filename, scales = 'free_x', ncol = 1)
  
  # Save the plot to the list
  plots[[filename]] <- plot
  
  # Check if it's the fifth plot or the last plot
  if (i %% plots_per_page == 0 || i == length(files)) {
    # Combine all plots into a single plot side by side
    combined_plot <- plot_grid(plotlist = plots, ncol = plots_per_page, align = 'h', rel_heights = rep(1, length(plots)))
    
    # Print the combined plot
    print(combined_plot)
    
    # Clear the list for the next set of plots
    plots <- list()
  }
}

# Close the PDF file
dev.off()
