library(tidyverse)

# Gets the current directory and adds the "csv" folder to the path
# This assumes that the path is set up the same way as my local machine
working_dir <- getwd()

# Save the plot to a PDF in the "graph_pics" folder
pdf("graph_pics/Bar_Plot_of_Aggregate_Views_With_LRM.pdf")

# Navigate to the CSV files
directory_path <- paste(working_dir, "/csv", sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <-
  list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

# Create an empty data frame to store aggregated data
aggregate_data <- data.frame()

sum_views <- NULL

# Iterate through each file
for (file in files) {
  # Read the CSV file
  data <- read.csv(file, sep = '~')
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_views = as.numeric(gsub(",", "", views)))
  
  # Calculate the sum of views
  sum_views <- sum(data$numeric_views, na.rm = TRUE)
  
  # Append the data to the aggregate data frame
  aggregate_data <-
    rbind(aggregate_data, data.frame(file = file, sum_views = sum_views))
}

aggregate_data$file <- str_extract(aggregate_data$file, "_([^_]+)_")

# Convert the 'file' column to a factor with levels based on the order they were read
aggregate_data$file <-
  factor(aggregate_data$file, levels = unique(aggregate_data$file))

# Convert 'file' to numeric representation for the trend line
aggregate_data$file_numeric <- as.numeric(aggregate_data$file)

# Create a bar plot of the aggregated data with a trend line
bar_plot <- ggplot(aggregate_data, aes(x = file, y = sum_views)) +
  geom_bar(stat = "identity") +
  geom_smooth(
    aes(x = file_numeric, y = sum_views),
    method = "lm",
    se = FALSE,
    color = "red"
  ) +
  labs(title = "Bar Plot of Aggregate Views", x = "Channel", y = "Sum of Views") +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(
    angle = 45,
    hjust = 1,
    vjust = 1,
    size = 7
  )) +
  scale_x_discrete(
    labels = function(x) {
      y_values <- aggregate_data$sum_views[match(x, aggregate_data$file)]
      ifelse(seq_along(x) %% 4 == 1 |
               seq_along(x) == length(x) | y_values > 50000000000,
             x,
             "")
    }
  )

# Print or save the combined plot
print(bar_plot)

dev.off()
