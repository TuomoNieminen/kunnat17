shinyUI(
  fluidPage(theme = "bootstrap.css",
            br(),
            fluidRow(
              
              # selections
              # ----------
              
              # municipality and party
              column(4,
                     selectizeInput("Kunta", "Valitse kunta", 
                                    choices = kunnat, 
                                    options = list(maxItems = 1, placeholder = 'etsi kuntia'), 
                                    selected = "Helsinki"),
                     uiOutput("Puolue")),
              
              # description and plot download options
              column(4, 
                     div(align = "center", 
                         HTML("<p>Applikaatio perustuu HS vaalikoneen 
                              <a href = 'https://github.com/HS-Datadesk/avoindata/tree/master/vaalikoneet/kuntavaalit2017'>
                              avoimeen aineistoon.</a> </p>"),
                         br(),
                         
                         downloadButton("downloadLikert", label = "Lataa kuva"))),
              column(4,
                    numericInput("plot_width", "ladatun kuvan leveys (px)", value = 1000),
                    numericInput("plot_height", "ladatun kuvan pituus (px)", value = 1000)
              )),
            
            hr(),
            
            # question navigation
            div(align = "center", uiOutput("question_slider")),
            
            hr(),
            
            #  plot output
            plotOutput("likert")
  )
)