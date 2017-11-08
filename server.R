# POTENTIALGEBIETE MITTELLAND
# roth@hintermannweber.ch
# 13.06.2017

server <- function(input, output, session) {
  
  # Handling of session data
  data <- reactive({
    if (input$Lebensraumtyp == "Feuchtgebiete") {
      ras <- raTotFG
      infra <- fg
      infraras <- fgras
      vern <- fgvern
    }
    if (input$Lebensraumtyp == "Trockengebiete") {
      ras <- raTotTG
      infra <- tg
      infraras <- tgras
      vern <- tgvern
    }

    # Nur minimale Distanz anzeigen
    if (input$distberechnen) {
      ras[getValues(infraras) > input$bufwidth] <- NA
    }  
    # Nur beste x% anzeigen
    if (input$bestberechnen) {
      ras[!is.na(values(ras)) & values(ras) < quantile(values(ras), prob = 1 - (input$tquant/100), na.rm = TRUE)] <- NA
    }
    list(ras = ras, infra = infra, infraras = infraras, vern = vern)
  })
  
  # Angaben für Output
  output$lebensraum <- renderText(input$Lebensraumtyp)
  output$dist <- renderText(ifelse(input$distberechnen, paste0(input$bufwidth, "m"), "Keine Einschränkung"))
  output$beste <- renderText(ifelse(input$bestberechnen, paste0(input$tquant, "% beste"), "Keine Einschränkung"))
  output$vernetz <- renderText(ifelse(input$vernberechnen | input$buffer, paste0("<", input$vernedist, " km"), "Nicht angezeigt"))
  output$textinfra <- renderText(textinfra)
  output$textbest <- renderText(textbest)
  output$textbestes <- renderText(textbestes)
  
  # Leaflet zeichnen ----
  output$mymap <- renderLeaflet({
    ref <- "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
    map <- leaflet(options = providerTileOptions(minZoom = 8, maxZoom = 15)) %>%
      setView(lng = 7.8, lat = 47.2, zoom = 8)
  })
  
  # Hintergrundkarte in Leaflet ändern
  observe({
    if(input$tiles == "Luftbild") ref <- "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
    if(input$tiles == "Karte") ref <- "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    proxy <- leafletProxy("mymap") %>% clearTiles() 
    addTiles(proxy, urlTemplate = ref)
  })
  
  # Modell in Leaflet zeichnen
  observe({
    input$tiles
    proxy <- leafletProxy("mymap") %>% clearImages()
    addRasterImage(proxy, data()$ras, opacity = input$opac, project = FALSE,
                   colors = colorNumeric(tcol, domain = range(values(data()$ras), na.rm = TRUE), alpha = TRUE, na.color = "#00000000"))
  })
  
  # Bestehende Infrastruktur und Vernetzung dieser einzeichnen
  observe({
    proxy <- leafletProxy("mymap") %>% clearShapes()
    addPolylines(proxy, data = perimeter, color = "black", weight = 3)
    if(input$bestinfra) addPolygons(proxy, data = data()$infra, stroke = FALSE, fillColor = as.character(data()$infra@data$col), fillOpacity = 1)
    if(input$buffer) {
      vernb <- spTransform(data()$vern, CRS("+init=epsg:21781"))
      vernb <- buffer(vernb, 500)
      vernb <- spTransform(vernb, CRS("+init=epsg:4326"))
      addPolygons(proxy, data = vernb, stroke = FALSE, opacity = 10, fillColor = "yellow")
    }
    if(input$vernberechnen) {
      addPolylines(proxy, data = data()$vern[SpatialLinesLengths(data()$vern, longlat = TRUE) <= input$vernedist], color = "blue")
      addPolylines(proxy, data = data()$vern[SpatialLinesLengths(data()$vern, longlat = TRUE) > input$vernedist], color = "red")
    }
  })

}





