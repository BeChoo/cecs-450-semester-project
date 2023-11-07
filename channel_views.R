library(ggplot2)
library(dplyr)
library(scales)

# Get the working directory path, then update it to the path of the files to create a plot for
# Path manually set here, but should be able to be updated so that it is automatically found
working_dir <- getwd()
folder1_25 <- "/data/1-50/1-25"
directory_path <- paste(working_dir, folder1_25, sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory
files <- list.files(directory_path)

# Create a single PDF file for saving the graphs
pdf("Views Over Time for All Channels.pdf")

for(file in files) {
  # Read the CSV file with a ~ delimiter
  data <- read.csv(file, sep = "~")
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(views = as.numeric(gsub(",", "", views)))
  
  # Create a line graph
  p <- ggplot(data, aes(x = since_upload, y = views, group = 1)) +
    geom_line() +
    labs(title = "Line Graph of Views Over Time", x = "Time Since Upload", y = "Views") +
    scale_x_discrete(guide = guide_axis(check.overlap = TRUE)) +
    scale_y_continuous(labels = label_comma()) +
    theme(axis.text.y = element_text(size = 10),
          axis.text.x = element_text(size = 10, angle = 90, vjust = 0.5, hjust = 1))
  
  print(p)
}

dev.off()
