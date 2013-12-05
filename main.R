#!/usr/bin/Rscript

# This script is intended to download daily
# GPS raw data for a requested year.

# Input variables
# year  -- requested year
# dir   -- catalog with download data
# 7zip  -- 7-zip command to extract files
year <- "2011"
myDir <- "src/"
cmd <- paste0("7za e -o", myDir, " -y ")

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
  
  filename <- paste0(
    "brdc",
    formatC(day, width=3, flag="0"),
    "0.",
    short_year,
    "n.Z"
  )
  
  link <- paste0(
    "ftp://cddis.gsfc.nasa.gov//pub/gps/data/daily/",
    year,
    "/brdc/",
    filename
  )
  
  if (!file.exists(myDir))
  {
    dir.create(myDir)
  }
  
  fullpath <- paste0(myDir,filename)
  
  download.file(link, fullpath)
  
  cmd <- paste0(
    cmd,
    fullpath
  )
print(cmd)
  system(cmd)
}

downloadData <- function()
{
  for (i in 1:365)
    downloadDay(year, i)
}

downloadData()