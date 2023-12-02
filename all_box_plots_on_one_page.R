library(tidyverse)

# Gets the current directory
working_dir <- getwd()

# Save the plot to a PDF in the "graph_pics" folder
pdf("graph_pics/Combined_Box_Plots.pdf")

# Navigate to the CSV files and add the "csv" folder to the path
directory_path <- paste(working_dir, "/csv", sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

# Extract numerical values from filenames and sort files
sorted_files <- files %>%
  map_df(~ tibble(file = .x, numeric_value = as.numeric(str_extract(basename(.x), "\\d+")))) %>%
  arrange(numeric_value) %>%
  pull(file)

# Number of plots per page
plots_per_page <- 5

# Counter to keep track of the number of plots
plot_counter <- 0

# Initialize an empty list to store plots
plots <- list()

# Iterate through each file
for (file in sorted_files) {
  # Read the CSV file
  data <- read.csv(file, sep = '~')

  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_views = as.numeric(gsub(",", "", views)))

  filename <- basename(file)
  
  # Identify the common factor to scale the data
  common_factor <- 1000000

  # Create a box plot for the current file
  plot <- ggplot(data, aes(x = filename, y = numeric_views)) +
    geom_boxplot() +
    labs(title = filename, x = "Channel", y = "Numeric Views") +
    scale_y_log10(labels = scales::comma) +
    theme(axis.text.x = element_blank())

  # Increment the plot counter
  plot_counter <- plot_counter + 1

  # Save the plot to the list
  plots[[filename]] <- plot

  # Check if it's the fifth plot or the last plot
  if (plot_counter %% plots_per_page == 0 || plot_counter == length(files)) {
    # Combine all plots into a single plot side by side
    combined_plot <- patchwork::wrap_plots(plots, ncol = plots_per_page, align = 'h')

    # Print the combined plot
    print(combined_plot)

    # Clear the list for the next set of plots
    plots <- list()
  }
}

# Close the PDF file
dev.off()
