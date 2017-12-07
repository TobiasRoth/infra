# POTENTIALGEBIETE MITTELLAND
# roth@hintermannweber.ch
# 21.05.2017

#------------------------------------------------------------------------------
# Libraries ----
#------------------------------------------------------------------------------
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
load("Modelle/raTotFG.RData")
load("Modelle/raTotTG.RData")

# Daten Bestehende Infrastruktur laden
load("BestehendeInfrastruktur/fgras.RData")
fgras <- projectRasterForLeaflet(fgras)
load("BestehendeInfrastruktur/fgvern.RData")
load("BestehendeInfrastruktur/fg.RData")

load("BestehendeInfrastruktur/tgras.RData")
tgras <- projectRasterForLeaflet(tgras)
load("BestehendeInfrastruktur/tg.RData")
load("BestehendeInfrastruktur/tgvern.RData")

load("Hintergrunddaten/perimeter.RData")

#------------------------------------------------------------------------------
# Textbausteine ----
#------------------------------------------------------------------------------
textbestes <- "Neue Flächen in der Nähe von Kerngebieten der bestehenden ÖI haben die besten Chancen schnell 
und von möglichst vielen Arten besiedelt zu werden. Zusätzlich erhöhen solche Flächen die Qualität der bestehenden 
Kerngebiete, da sie deren Fläche vergrössern und einen Puffer zur angrenzenden intensiv genutzten Landschaft bilden. 
Mit dem Regler lässt sich einstellen, bis zu welcher Distanz zur bestehenden Infrastruktur Potentialgebiete 
angezeigt werden sollen."

textbest <- "Die Flächen mit dem grössten Potential sollen unabhängig 
von ihrer Lage zur bestehenden Infrastruktur ausgewählt werden. Die einzelnen Zellen werden nach ihrem Potential 
geordnet und nur die x% besten Flächen werden dargestellt. Wieviel x ist, kann mit dem Regler eingestellt werden."

textinfra <- "Zur funktionellen Vernetzung der bestehenden Kerngebiete sollen sie im Sinne eines Biotopverbundes miteinander verbunden sein. Dazu 
wird die bestehende Infrastruktur mit der geringstmöglichen Distanz miteinander verbunden (Least-Cost-Distanz). Sind 
die Verbindungsstücke länger als die Höchstdistanz (mit dem Regler einstellen), dann wird das Verbindungsstück rot 
eingezeichnet. Für diese Verbindung besteht Bedarf für Vernetzungsmassnahmen."

