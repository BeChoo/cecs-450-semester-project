library(tidyverse)

# Gets the current directory and adds the "csv" folder to the path
# This assumes that the path is set up the same way as my local machine
working_dir <- getwd()
pdf_path <- paste0(working_dir,"/graph_pics/Scatter_Plot_of_subs_vs_views.pdf")

# Save the plot to a PDF in the "graph_pics" folder
#file.create(pdf_path)
#pdf(pdf_path)

channel_data <- read.csv('channel_info.csv', sep = '~')

# Navigate to the CSV files
directory_path <- paste(working_dir, "/csv", sep = '')

# Set the working directory to the directory path set above
setwd(directory_path)

# List all files in the directory, ignoring files that are not CSVs
files <- list.files(directory_path, pattern = "\\.csv$", full.names = TRUE)

# Create an empty data frame to store aggregated data
channel_aggregate_data <- data.frame()
viedo_aggregate_data <- data.frame()



# Iterate through each file
for (file in files) {
  channel_name = str_match(file,"[0-9]{1,2}_(.*)([_-][0-9]{1,2}){3}")[2]
  channel_info=channel_data[channel_data$name==channel_name,]
  sub_count = as.double(str_match(channel_info$subscribers,"[0-9]+")[1])
  rank = strtoi(channel_info$rank)
  
  # Read the CSV file
  data <- read.csv(file, sep = '~')
  
  # 'views' is being read as a string, this will update it to an int
  data <- data %>%
    mutate(numeric_views = as.numeric(gsub(",", "", views)))
  
  # Calculate the sum of views
  avg_views <- mean(data$numeric_views, na.rm = TRUE)
  med_views <- median(data$numeric_views, na.rm = TRUE)
  yearly_data <- data %>% group_by(data$uptime_y)
  
  # Append the data to the aggregate data frame
  channel_aggregate_data <- rbind(channel_aggregate_data, data.frame(name = channel_name, mil_subs=sub_count, median_views = med_views,average_views = avg_views))
  vid_aggregate_data <- rbind(video_aggregate_data, data.frame(year=2022-yearly_data$uptime_y))
}

setwd(working_dir)
scatter <- ggplot(data=channel_aggregate_data, mapping=aes(x=mil_subs, y=average_views/1000000))+geom_point()
show(scatter)



dev.off