# POTENTIALGEBIETE MITTELLAND
# roth@hintermannweber.ch
# 21.05.2017

#------------------------------------------------------------------------------
# Libraries ----
#------------------------------------------------------------------------------
# packages <- c("shiny", "leaflet", "shinydashboard", "raster", "RColorBrewer", "spdep", "vegan")
# if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
#   install.packages(setdiff(packages, rownames(installed.packages())))  
# }
library(shiny)
library(leaflet)
library(shinydashboard)
library(rgdal)
library(raster)
library(RColorBrewer)
library(spdep)
library(vegan)
library(rgeos)

#------------------------------------------------------------------------------
# Einstellung Farben und Schriftgrössen ----
#------------------------------------------------------------------------------
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()
tcol <- c("white", rev(brewer.pal(8, "RdYlBu")))

# Farben Hintergrund der Boxes
coltool <- "green"
colanzeige <- "light-blue"

#------------------------------------------------------------------------------
# Daten laden und vorbereiten ----
#------------------------------------------------------------------------------
# Daten Modelle laden
load("Modelle/raTotTG.RData")
load("Modelle/raTotFG.RData")

# Daten Bestehende Infrastruktur laden
load("BestehendeInfrastruktur/fgras.RData")
load("BestehendeInfrastruktur/tgras.RData")
load("BestehendeInfrastruktur/fg.RData")
load("BestehendeInfrastruktur/tg.RData")
load("BestehendeInfrastruktur/fgvern.RData")
load("BestehendeInfrastruktur/tgvern.RData")
load("Hintergrunddaten/perimeter.RData")

#------------------------------------------------------------------------------
# Textbausteine ----
#------------------------------------------------------------------------------
textbestes <- "Neu erstellte Flächen in der nähe der bestehenden Infrastruktur haben die 
beste Chancen schnell und von möglichst vielen Arten besiedelt zu werden. Solche Flächen
helfen auch der bestehenden Infrastruktur, da sie einen gewissen Puffer zur bestehenden Infrastruktur
bilden. Mit dem Regler lässt sich einstellen, bis zu welcher Distanz zur bestehenden Infrastruktur
Potentialgebiete angezeigt werden sollen."

textbest <- "Die Flächen mit dem grössten potential sollen unabhängig von ihrer Lage zur bestehenden 
Infrastruktur ausgewählt werden. Die einzelnen Zellen werden nach ihrem potential geordnet und nur die x% besten 
Flächen werden dargestellt. Wieviel x ist, kann mit dem Regler eingestellt werden."

textinfra <- "Ziel ist es, dass die gesamte Infrastruktur miteinander vernetzt ist.
Dazu wird die bestehende Infrastruktur mit der geringstmöglichen Distanz miteinander verbunden
(minimal spanning tree). Sind die Verbindungsstücke länger als die Höchstdistanz (mit dem Regler einstellen), dann
wird das Verbindungsstück rot eingezeichnet. Für diese Verbindung wären zusätzliche
Trittsteine wünschenswert."

#------------------------------------------------------------------------------
# Vernetzung berechnen ----
#------------------------------------------------------------------------------
# map <- leaflet("mymap")
# ref <- "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
# map <- addTiles(map, urlTemplate = ref)
# vernb <- spTransform(vern, CRS("+init=epsg:21781"))
# vern1 <- buffer(vernb, 500)
# vern1 <- spTransform(vern1, CRS("+init=epsg:4326"))
# map <- addPolygons(map, data = vern1, stroke = FALSE, opacity = 10, fillColor = "yellow")
# map <- addPolylines(map, data = vern[SpatialLinesLengths(vern, longlat = TRUE) <= 10], color = "blue")
# map <- addPolylines(map, data = vern[SpatialLinesLengths(vern, longlat = TRUE) > 10], color = "red")
# map
# 
# SpatialLinesLengths(vern, longlat = TRUE)
# SpatialLinesLengths(spTransform(vern, CRS("+init=epsg:21781")), longlat = TRUE)
