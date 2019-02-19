function(input, output, session) {
    
    # action button logic taken from here: https://stackoverflow.com/a/45739826/8099834
    popup_html <- function(src, id) {
        paste0(
            "<div class = 'order-flex'>",
            "<div class = 'order-wrapper left-flex'>", 
            actionButton(paste0(id, "-left"), "", icon("arrow-left", lib = "glyphicon"), 
                         onclick = 'Shiny.setInputValue(\"select_image\", this.id, {priority: \"event\"})'),
            "</div>",
            "<div class = 'order-wrapper middle-flex'>", 
            "<img height=100%, width=100% src='", src, "' >",
            "</div>",
            "<div class = 'order-wrapper right-flex'>", 
            actionButton(paste0(id, "-right"), "", icon("arrow-right", lib = "glyphicon"),
                         onclick = 'Shiny.setInputValue(\"select_image\", this.id, {priority: \"event\"})'),
            "</div>",
            "</div>"
        )
    }
    popups <- unlist(lapply(1:nrow(image_gps), function(x) {
        y <- image_gps[x, ]
        popup_html(y$s3_path, y$id)
    }))
    
    output$trails_map <- renderLeaflet({
        # make icons
        my_makeAwesomeIcon <- function(icon, icon_color) {
            makeAwesomeIcon(icon, 
                            iconColor = 'white',
                            library = 'glyphicon',
                            markerColor = icon_color,
                            squareMarker = TRUE)
        }
        iconSet <- awesomeIconList(
            image = my_makeAwesomeIcon('picture', 'lightgreen'),
            town = my_makeAwesomeIcon('shopping-cart',"lightred"),
            tent = my_makeAwesomeIcon('tent', 'lightblue')
        )

        ## create map with the trails
        ## HERE: next add panes to make sure order is correct when adding from control panel
        # add different tile options
        leaflet() %>%
            addProviderTiles(providers$Stamen.Terrain, options = providerTileOptions(opacity = 0.99), group = "Terrain") %>%
            addProviderTiles(providers$Esri.NatGeoWorldMap, options = providerTileOptions(opacity = 0.99), group = "NatGeo") %>%
            addProviderTiles(providers$Esri.WorldImagery, options = providerTileOptions(opacity = 0.99), group = "Satellite") %>%
            addProviderTiles(providers$HikeBike.HikeBike, options = providerTileOptions(opacity = 0.99), group = "HikeBike") %>%
            addProviderTiles(providers$CartoDB.DarkMatter, options= providerTileOptions(opacity = 0.99), group = "Dark Map") %>%
            addProviderTiles(providers$CartoDB.Positron, options = providerTileOptions(opacity = 0.99), group = "Light Map") %>%
            setView(-106.4452306, 40.6330673, zoom = 6) %>%
            enableTileCaching() %>%
            #addPolylines(data = at_track, color = track_colors[1], opacity = 1, popup = "Appalachian Trail") %>%
            #addPolylines(data = pct_track, color = track_colors[2], opacity = 1, popup = "Pacific Crest Trail") %>%
            addPolylines(data = cdt_track, color = "black", opacity = 0.5, popup = "CDNST", 
                         group = "CDNST Track", options = list(zIndex = 2)) %>%
            addAwesomeMarkers(data = image_gps, lng = image_gps$GPSLongitude, lat = image_gps$GPSLatitude,
                              layerId = image_gps$GPSDateTime,
                              icon = iconSet["image"],
                              popup = popups,
                              clusterOptions = markerClusterOptions(maxClusterRadius = 50),
                              group = "Images", popupOptions = popupOptions(maxWidth = "auto")) %>%
            addAwesomeMarkers(data = cdt_resupply, lng = cdt_resupply$lng_town, lat = cdt_resupply$lat_town,
                              icon = iconSet["town"], 
                              popup = popupTable(cdt_resupply, zcol = c("town_name", "state", "resupply", "gear_box",
                                                                        "food_box", "transportation", "laundry", "shower", 
                                                                        "shoes", "overnight", "inside")),
                              clusterOptions = markerClusterOptions(),
                              group = "Towns") %>%
            addAwesomeMarkers(data = cdt_days, lng = cdt_days$lng, lat = cdt_days$lat, layerId = cdt_days$time_day,
                              icon = iconSet["tent"],
                              popup = cdt_days$tentsite, 
                              clusterOptions = markerClusterOptions(),
                              group = "End of Day") %>%
            addCircles(data = cdt_points, lat = cdt_points$lat, lng = cdt_points$lng, 
                       color = cdt_points$color, opacity = 1, 
                       popup = popupTable(cdt_points, zcol = c("time_local", "elev_ft", "velocity_mph",
                                                               "recorded_miles")),
                       group = "My Track") %>%
            addFullscreenControl() %>%
            addLayersControl(overlayGroups =  c('My Track', 'CDNST Track', 'Images', 'Towns', 'End of Day'),
                             baseGroups = c("Terrain", "NatGeo", "Satellite", "HikeBike", "Dark Map", "Light Map"),
                             options = layersControlOptions(collapsed=F))
    })
    
    observe({
        if(!is.null(input$select_image)) {
            # close currently selected popup
            session$sendCustomMessage("close_popup", "go")
            # get the old location
            direction <- gsub("^.*-", "", input$select_image)
            first_id <- as.numeric(gsub("-.*", "", input$select_image))
            next_id <- ifelse(direction == "left", first_id - 1, first_id + 1)
            # get new popup
            marker <- image_gps %>%
                filter(id == next_id)
            # add a new popup
            isolate({
                leafletProxy("trails_map", session) %>%
                    clearPopups() %>%
                    setView(lat = marker$GPSLatitude, lng = marker$GPSLongitude, zoom = input$trails_map_zoom) %>%
                    addPopups(lat = marker$GPSLatitude, lng = marker$GPSLongitude,
                              popup = popup_html(marker$s3_path, id = marker$id),
                              options = popupOptions(maxWidth = "auto"))
            })
        }
        
    })
}

