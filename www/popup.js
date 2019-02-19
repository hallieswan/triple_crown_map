Shiny.addCustomMessageHandler("close_popup", function(e) {
    $(document.getElementById("trails_map")).data("leaflet-map").closePopup();
})