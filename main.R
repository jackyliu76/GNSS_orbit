#!/usr/bin/Rscript

# This script is intended to download daily
# GPS raw data for a requested year.

# Input variables
# year  -- requested year

year <- "2002"

# Example link: ftp://cddis.gsfc.nasa.gov/gps/data/daily/2002/175/02n/brdc1750.02n.Z
# Example link 2: ftp://cddis.gsfc.nasa.gov//pub/gps/data/daily/2000/brdc/brdc0010.00n.Z

base_link <- paste0(
  "ftp://cddis.gsfc.nasa.gov/gps/data/daily/",
  year,
  day,
  shortYear,
  "n/"
)


downloadFile <- function(year,day)
{
  
}
