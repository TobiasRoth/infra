# POTENTIALGEBIETE MITTELLAND
# roth@hintermannweber.ch

header <- dashboardHeader(
  title = "Potenzialflächenerk. Ökol. Infrastruktur Mittelland (v1.0)", 
  tags$li(a(href = '1449 Benutzungsanleitung Hinweistool v1.pdf', icon("file-pdf-o"), title = "Hilfe"), class = "dropdown"),
  tags$li(a(href = 'mailto:schlup@hintermannweber.ch?Subject=Oekologische%20Infrastruktur%20Mittelland', icon("envelope"), title = "Mail schreiben"), class = "dropdown"),
  tags$li(a(href = 'https://github.com/TobiasRoth/infra', icon("github"), title = "Source-Code"), class = "dropdown"),
  tags$li(a("Auftraggeber: Naturschutzfachst. AG, BE, ZH", title = "Die Auftraggeber sind die Naturschutzfachstellen der Kantone Aargau, Bern und Zürich."), class = "dropdown"),
  tags$li(a(href = 'http://www.hintermannweber.ch', "Konzept: Hintermann & Weber AG", title = "Konzept"), class = "dropdown"),
  # tags$li(a(href = 'http://www.hintermannweber.ch', 
  #           img(src = 'logo.png',title = "Company Home", height = "30px"),
  #           style = "padding-top:10px; padding-bottom:10px;"),
  #         class = "dropdown"),
  titleWidth = 560
)

sidebar <- dashboardSidebar(
  br(),
  tags$b("Lebensraumtyp auswählen:"),
  selectInput(inputId = "Lebensraumtyp", label = NA,
              choices = c("Trockengebiete", "Feuchtgebiete"),
              selectize = FALSE, width = "100%", selected = "Trockengebiete"),
  tags$hr(),
  tags$b("Auswahl Analysetools:"),
  br(),br(),
  sidebarMenu(
    id = "setting",
    menuItem("Maximale Distanz", tabName = "ergaenzen", icon = icon("sign-in")),
    menuItem("Bestes Potential", tabName = "beste", icon = icon("star")),
    menuItem("Bestehendes vernetzen", tabName = "vernetzen", icon = icon("random"))
  ),
  tags$hr(),
  tags$b("Darstellungsoptionen:"),
  checkboxInput(inputId = "bestinfra",
                label = "Bestehende Infrastruktur mit nationaler (rot) und kantonaler (grün) Bedeutung.", value = FALSE),
  sliderInput(inputId = "opac",
              label = "Deckkraft der Farben:",
              min = 0,  max = 1,  value = 0.6),
  selectInput(inputId = "tiles", label = "Hintergrund auswählen:",
              choices = c("Luftbild", "Karte"),
              selectize = FALSE, width = "100%", selected = "Luftbild")
)

body <- dashboardBody(
  # Erste Zeile mit Karte (Höhe wird durch height des Leaflets bestimmt)
  fluidRow( 
    box(width = 9, solidHeader = FALSE, title = NULL, 
        leafletOutput("mymap", height = 500)),
    box(title = "Potentialkarte", background = "light-blue",
        uiOutput("lebensraum"), width = 3),
    infoBox(icon = icon("sign-in"), color = colanzeige, fill = TRUE, width = 3,
            title =  "Maximale Distanz", subtitle = uiOutput("dist")),
    infoBox(icon = icon("star"), color = colanzeige, fill = TRUE, width = 3,
            title =  "Bestes Potential", subtitle = uiOutput("beste")),
    infoBox(icon = icon("random"), color = colanzeige, fill = TRUE, width = 3,
            title =  "Vernetzung", subtitle = uiOutput("vernetz"))
  ),
  # Zweite Zeile
  tabItems(
    # Bestehende Infrastruktur ergänzen
    tabItem(tabName = "ergaenzen",
            fluidRow(
              box(width = 6, background = coltool,
                  tags$b("Potentialflächen nahe der bestehenden Infrastruktur auswählen:"),
                  uiOutput("textbestes", container = tags$h5)
              ),
              box(background = coltool, width = 3, 
                  sliderInput(inputId = "bufwidth", label = "Distanz (in m)", min = 0,  max = 5000,  value = 2000)),
              box(background = coltool, width = 3, 
                  checkboxInput("distberechnen", "Maximale Distanz berücksichtigen", FALSE))
            )
    ),
    # Bestehende Infrastruktur vernetzen
    tabItem(tabName = "vernetzen",
            fluidRow(
              box(width = 6, background = coltool,
                  tags$b("Potentialflächen so auswählen, dass die bestehende Infrastruktur besser vernetzt wird:"),
                  uiOutput("textinfra", container = tags$h5)
              ),
              box(background = coltool, width = 3, 
                  sliderInput(inputId = "vernedist", label = "Höchstdistanz für ein Verbindungs-stück (km)", min = 0,  max = 25,  value = 10)),
              box(background = coltool, width = 3, 
                  checkboxInput("vernberechnen", "Vernetzung als Linie anzeigen", FALSE),
                  checkboxInput("buffer", "Puffer um Vernetzungslinie", FALSE))
            )
    ),
    # Beste Gebiete auswählen
    tabItem(tabName = "beste",
            fluidRow(
              box(width = 6, background = coltool,
                  tags$b("Flächen mit dem grössten Potential auswählen:"),
                  uiOutput("textbest", container = tags$h5)
              ),
              box(background = coltool, width = 3, 
                  sliderInput(inputId = "tquant", label = "Beste xx% anzeigen", min = 0,  max = 100,  value = 80)),
              box(background = coltool, width = 3, 
                  checkboxInput("bestberechnen", "Nur beste Flächen darstellen", FALSE))
            )
    )
  )
)

ui <- function(){
  dashboardPage(
    header,
    sidebar,
    body,
    "ÖIM",
    "blue"
  )
  
}


