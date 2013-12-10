#!/usr/bin/Rscript

# This script is a parser of a RINEX GPS NAVIGATION MESSAGE FILE
# Header section description is skipped

# RINEX FORMAT DESCRIPTION

# PRN / EPOCH / SV CLK
fmtPrnEpochSvclk <- c(
  "I2",
  "1X","I2.2",
  "1X","I2",
  "1X","I2",
  "1X","I2",
  "1X","I2",
  "F5.1",
  "3D19.12",
  "3D19.12",
  "3D19.12"
  )

# BROADCAST ORBIT - N
fmtBrdcOrbit <- c(
  "3X","4D19.12"
  )

# 80-char string
fmt <- c("A80")

file <- "src/brdc0010.11n"
prn <- 3
headerLimit <- 100

rnxData <- readLines(file)

# Number of lines in a file
nLines <- length(rnxData)

# Header will be skipped
for (i in 1:headerLimit)
  if (grepl("END OF HEADER", rnxData[i])) break

# Stop if we can't find the end of header 
if ( i > headerLimit - 10)
{
  msg <- paste(
    "Stopped. Can't find the end of header after reading",
    headerLimit,
    "lines."
    )
  stop(msg)
}

# Line number of a section with PRN data
beginOfBlock <- i + 1

# Reading PRN data
while (beginOfBlock <= nLines)
{
  # Getting line numbers of BROADCAST ORBIT
  startLine <- beginOfBlock + 1
  endLine <- startLine + 6

  # Reading "PRN / EPOCH / SV CLK " record
  epoch <- rnxData[beginOfBlock]
  conEpch <- textConnection(epoch)
  recEpch <- read.table(conEpch)
  close(conEpch)

  # Skip if current PRN is not matching
  if (recEpch[1] != prn)
  {
    beginOfBlock <- beginOfBlock + 8
    next
  }

  # Reading "BROADCAST ORBIT 1-7" records
  orbit <- rnxData[startLine:endLine]
  conOrb <- textConnection(orbit)
  recOrb <- read.table(conEpch)
  close(conOrb)
  
  # Exctracting orbit parameters
  
  
}
