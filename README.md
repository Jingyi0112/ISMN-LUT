# ISMN Soil Moisture LUT Genartor

## Overview
This project processes **International Soil Moisture Network (ISMN)** data in R and generates a **quality-filtered Look-Up Table (LUT)**. Only reliable observations (quality flag `"G"`) are retained. The resulting LUT can be used for climate analysis, land surface modeling, or satellite soil moisture validation.

## Features
- Reads multiple ISMN `.stm` files
- Extracts metadata: network, station, latitude, longitude, depth, date range
- Filters soil moisture data based on ISMN quality flags
- Computes missing data count and percentage
- Generates a summary LUT CSV for all stations


```r
master_dir <- "Data_separate_files_header_19960101_20241231_12472_cBBd_20250831"
