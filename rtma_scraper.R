# change from desktop

library(tidyverse)
library(rvest)

# This is the most recent service change notice for RTMA and URMA
# https://www.weather.gov/media/notification/pdf_2023_24/scn23-02_rtma_v2.10.1_and_urma_v2.10.1.pdf


# RTMA at
# https://nomads.ncep.noaa.gov/pub/data/nccf/com/rtma/prod/

# Example: https://nomads.ncep.noaa.gov/pub/data/nccf/com/rtma/prod/rtma2p5.20231205/
# a few different grib2s in this 'rtma2p5.YYYYMMDD/' tree

# rtma2p5.t14z.2dvarges_ndfd.grb2_wexp
# this kicks out cloud_ceiling, Dewpoint, ...11 items in total.

# rqirtma.2023120515.grb2
# this is radar quality. Not quite sure what I'm looking at, but potentially important.

# rtma2p5.2023120515.pcp.184.grb2
# this is the one I want. Dropped 15 minutes after the hour. Whole CONUS.




# create function to print out UTC time with utc_time()
now_utc <- function() {
  now <- Sys.time()
  attr(now, "tzone") <- "UTC"
  now
}

# create character string of the hour
hour_char<-str_sub(as.character(now_utc()),start=12,end=13)
# create numeric hour
hour_num<-as.numeric(hour_char)

# create character string for date
date_char<- str_sub(as.character(now_utc()),start=1,end=10) %>% str_remove_all("-")
# create dateclass date with utc timezone
now_utc_date<-as.Date(now_utc(),tz="UTC")


# read nomads stg4 html page using date from utc_time()
stg4_http_page<-read_html(paste0("https://nomads.ncep.noaa.gov/pub/data/nccf/com/rtma/prod/rtma2p5.",date_char,"/"))

# find only files that end with .grb2 and have 'pcp' somewhere in the string
grib2_available <- stg4_http_page %>%
  html_elements("a") %>%
  html_text() %>%
  str_subset("pcp") %>%
  str_subset(".grb2$") 



# create path to download
source_path<-paste0("https://nomads.ncep.noaa.gov/pub/data/nccf/com/rtma/prod/rtma2p5.",date_char,"//",tail(grib2_available,n=1))

# create download destination
#destination_path<-paste0("C:\\texas_mpe\\de_grib\\wgrib2_precompiled\\wgrib2\\",tail(grib2_available,n=1))
destination_path<-paste0("C:\\Downloads\\",tail(grib2_available,n=1))

#download the file  
download.file (source_path,destination_path,method = "curl")
