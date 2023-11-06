# Load the ggplot2 package if it's not already loaded
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(ggplot2)
library(dplyr)

# Set the file path using file.path()
# Will need to update this for the bash script, just using this as a placeholder to test for a single file
file_path <- file.path("data", "1-50", "1-25", "24_chuchu_tv_nursey_rhymes_and_kids_songs_10-17-23.mhtml.csv")

# Read the CSV file with a ~ delimiter
data <- read.csv(file_path, sep = "~")

# 'views' is being read as a string, this will update it to an int
data <- data %>%
  mutate(views = as.numeric(gsub(",", "", views)))

# View the first few rows of the data
head(data)

# Create a line graph
ggplot(data, aes(x = since_upload, y = views, group = 1)) +
  geom_line() +
  labs(title = "Line Graph of Views Over Time", x = "Time Since Upload", y = "Views") +
  # Line below will be used to avoid overcrowding on the x-axis once that is converted to seconds only
  # Currently omits overlapping labels
  scale_x_discrete(guide = guide_axis(check.overlap = TRUE))
  theme(axis.text.y = element_text(size = 10),
        axis.text.x = element_text(size = 10, angle = 90, vjust = 0.5, hjust = 1))
