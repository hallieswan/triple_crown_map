fillPage(
    tags$head(
        tags$style(
            type = "text/css",
            "#trails_map {
                height: calc(100vh) !important;
                padding: 0;
                margin: 0;
            }"
        ),
        tags$link(rel = "stylesheet", type = "text/css", href = "popup.css"),
        tags$script(src = "popup.js")
    ),
    leafletOutput("trails_map")
)
