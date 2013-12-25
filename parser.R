#!/usr/bin/Rscript

# This script is a parser of a RINEX GPS NAVIGATION MESSAGE FILE
# Header section description is skipped

# Usage:
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

# Values for plotting
time <- c()     # Time 
axis <- c()     # Semimajor Axis
ecc <- c()      # Eccentricity

incl <- c()     # Inclination
lgtd <- c()     # Longitude of the ascending node
argp <- c()     # Argument of periapsis 
anmly <- c()    # Mean anomaly

# astronomic parameters
mu <- 3.986004418e+14
omega_e <- 7.2921151467e-5
c <- 299792458.0


## input parameters
# file <- "src/brdc0010.11n"
prn <- 3
headerLimit <- 100
year <- 2011

dir <- "src/brdc/"

for (file in list.files(dir))
{
  
  rnxData <- readLines(paste0(dir, file))
  
  # Number of lines in a file
  nLines <- length(rnxData)
  
  ## Pseudorange calculation
  # Reading DELTA-UTC
  # DELTA-UTC: A0,A1,T,W
  # We need to read T
  for (l in 1:headerLimit)
    if (grepl("DELTA-UTC", rnxData[l]))
    {
      # Replacing scientific D with E
      strUTC <- gsub("(\\d\\.\\d{12})(D)", "\\1E", rnxData[l], perl=TRUE)
      
      conDUTC <- textConnection(strUTC) 
      recDUTC <- read.fwf(conDUTC, width=c(22, 19, 9, 9), n=1)
      #recDUTC1 <- read.fortran(conDUTC, c("3X","2D19.12","2I9"))
      
      deltaUTC <- recDUTC[1,3]
      close(conDUTC)
      break
    }
  
  # Stop if we can't find delta utc
  if ( l > headerLimit - 10)
  {
    msg <- paste(
      "Stopped. Can't find DELTA-UTC record in the header in a range of",
      headerLimit,
      "lines."
    )
    stop(msg)
  }
  
  # Skipping lines till the end of the header
  for (i in l:headerLimit)
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
    
    # Replacing scientific D with E
    epoch <- gsub("D", "E", epoch)
    
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
    
    # Replacing scientific D with E
    orbit <- gsub("D", "E", orbit)
    
    conOrb <- textConnection(orbit)
    recOrb <- read.fwf(conEpch, width=c(22, 19, 19, 19), n=7)
    close(conOrb)
    
    ## Orbit calculation
    # Reading a moment of observation
    dt <- ISOdatetime(year, recEpch[3], recEpch[4], recEpch[5], recEpch[6], recEpch[7])
    time <- append(time, dt) 
    
    # Mean anomaly
    n0 <- sqrt(mu)/recOrb[2,4]**3                   # Step 1.
#     tem <- dt - deltaUTC  # Step 2.
#     t <- tem - recOrb[3,1]                          # Step 3.
    n <- n0 - recOrb[1,3]                           # Step 4.
#     anml <- recOrb[1,4] + n * t                     # Step 5.
    
    axis <- append(axis, recOrb[2,4])
    ecc <- append(ecc, recOrb[2,2])
    
    incl <- append(incl, recOrb[4,1])
    lgtd <- append(lgtd, recOrb[3,3])
    argp <- append(argp, recOrb[4,3])
    
    # Mean anomaly calculation
    anmly <- append(anmly, n)
    
    break
  }
}


