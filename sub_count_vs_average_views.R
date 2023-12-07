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
vid_aggregate_data <- data.frame()



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
  yearly_data <- data %>% group_by(data$uptime_y) %>% summarise(
    n = n(),
    view_total = sum(numeric_views)
  )
  
  
  # Append the data to the aggregate data frame
  channel_aggregate_data <- rbind(channel_aggregate_data, data.frame(name = channel_name, subs_in_millions=sub_count/1000000, subs=sub_count, median_views_in_millions=med_views/1000000, median_views = med_views, average_views_in_millions=avg_views/1000000, average_views = avg_views))
  vid_aggregate_data <- rbind(vid_aggregate_data, data.frame(year=2022-yearly_data$`data$uptime_y`, vid_count=yearly_data$n, total_views=yearly_data$view_total ))
}
setwd(working_dir)

vid_aggregate_data <- vid_aggregate_data %>% group_by(year) %>% 
  summarise(total_views=sum(total_views), vid_count=sum(vid_count)) %>%
  mutate(avg_views=total_views/vid_count)

sub_vs_average_by_channel <- ggplot(data=channel_aggregate_data, mapping=aes(x=subs/1000000, y=average_views/1000000))+geom_point()
show(sub_vs_average_by_channel)




dev.off