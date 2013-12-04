#!/usr/bin/Rscript

# This script is intended to download daily
# GPS raw data for a requested year.

# Input variables
# year  -- requested year

year <- "2002"

# Example link: ftp://cddis.gsfc.nasa.gov/gps/data/daily/2002/175/02n/brdc1750.02n.Z
# Example link 2: ftp://cddis.gsfc.nasa.gov//pub/gps/data/daily/2000/brdc/brdc0010.00n.Z


# This function will download daily GPS data
# for given day in a year and will store it
# on disk as a data frame.
# Input parameters: year, day
# Output: file on disk, data frame

downloadDay <- function(year,day)
{
  short_year <- substr(year, 3, 4)
  
  zipLink <- paste0(
    "ftp://cddis.gsfc.nasa.gov//pub/gps/data/daily/",
    year,
    "/brdc/brdc",
    day,
    "0.",
    short_year,
    "n.Z"
  )
  
  zippedData <- readLines(zipLink)
  data <- unzip(zippedData)
}

fr <- downloadDay(2002,175)