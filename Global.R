library(shiny)
library(rgdal)
library(tidyverse)
library(leaflet)
library(mapview)
library(leaflet.extras)

## read in all tracks -- will need to speed this up
# from: https://nps.maps.arcgis.com/home/item.html?id=83250a26864e47d9b45c2b14285a70df
# at_track <- readOGR("data/tracks/at_track/AT_Centerline_12-23-2014/doc.kml")
# from: https://continentaldividetrail.org/cdt-data/
cdt_track <- readOGR("data/tracks/cdt_track/cdnst/CDT_Google_Earth_2017.kml")
# from: https://www.pctmap.net/gps/
# pct_files <- list.files("data/tracks/pct_track", recursive = T, pattern = ".gpx", full.names = T)
# pct_files <- pct_files[!(grepl("waypoints", pct_files))]
# pct_track <- lapply(pct_files, readOGR, layer="tracks")
# pct_track <- do.call("rbind", pct_track)
# rm(pct_files)

## read in my data
# my points
track_colors <- RColorBrewer::brewer.pal(4, "Set1")
cdt_points <- read_csv("data/my_track_marked_offtrail.csv") %>%
    mutate(color = ifelse(offtrail == "yes", track_colors[1], track_colors[3]))
# add locations where slept 
cdt_days <- cdt_points %>%
    group_by(time_day) %>%
    filter(time_utc == max(time_utc)) %>%
    mutate(tentsite = paste0("End Day ", day))
## resupply
# add jitter to town points so we can see sleep and town popup
cdt_resupply <- read_csv("data/resupply.csv") %>%
    mutate(lat_town = jitter(lat_town, factor = 0.000001),
           lng_town = jitter(lng_town, factor = 0.000001))
# image gps
image_gps <- read_csv("data/image_gps.csv") %>%
    filter(!is.na(GPSLatitude) & !is.na(GPSLongitude)) %>%
    arrange(posix) %>%
    mutate(id = row_number())

