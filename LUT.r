library(dplyr)

# Import data
master_dir <- "Data_separate_files_header_19960101_20241231_12472_cBBd_20250831"
stm_files <- list.files(path = master_dir, pattern = "\\.stm$", recursive = TRUE, full.names = TRUE)

# Define function to process first file
process_file <- function(file_path) {
  meta <- read.table(file_path, nrows = 1, stringsAsFactors = FALSE)
  network   <- meta[1, 1]
  station   <- meta[1, 3]
  latitude  <- as.numeric(meta[1, 4])
  longitude <- as.numeric(meta[1, 5])
  depth     <- as.numeric(meta[1, 7])
  
  col_names <- c("date", "time", "soil_moisture", "quality_flag", "origiflag")
  data <- read.table(file_path, skip = 1, header = FALSE, stringsAsFactors = FALSE)
  colnames(data) <- col_names
  
  # Clean quality_flag and mark unreliable observations as NA
  data$quality_flag <- trimws(as.character(data$quality_flag))
  data$soil_moisture[data$quality_flag != "G"] <- NA
  
  # Missing data
  missing_count <- sum(is.na(data$soil_moisture))
  missing_percent <- missing_count / nrow(data) * 100
  
  # Start and end dates
  start_date <- as.Date(data$date[1])
  end_date   <- as.Date(data$date[nrow(data)])
  duration_days <- as.numeric(difftime(end_date, start_date, units = "days")) + 1
  
  # Return a summary data frame
  data.frame(
    network = network,
    station = station,
    latitude = latitude,
    longitude = longitude,
    depth = depth,
    start_date = start_date,
    end_date = end_date,
    duration_days = duration_days,
    missing_count = missing_count,
    missing_percent = missing_percent,
    stringsAsFactors = FALSE
  )
}

# Apply the function to all files
all_summary <- do.call(rbind, lapply(stm_files, process_file))

# Save to CSV
write.csv(all_summary, "ISMN_LUT_summary.csv", row.names = FALSE)

