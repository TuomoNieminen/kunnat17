shinyServer(function(input, output) {
  
  data <- reactiveValues(df = hs, items = NULL, puolueet = NULL, groups = NULL)
  
  # filter out other than selected municipality
  observe({
    if(!is.null(input$Kunta)) {
      df <- dplyr::filter(hs, Kunta %in% input$Kunta)
      no_answers <- sapply(df, all_na)
      df <- dplyr::select(df, -which(no_answers))
      data$df <- df
      data$puolueet <- sort(unique(df$Puolue))
      data$items <- df[, -(1:5)]
    }
  })
  
  # define groups by selected parties
  observe({
    if("Kaikki" %in% input$Puolue | is.null(input$Puolue)) {
      data$groups <- NULL
    } else{
      groups <- data$df$Puolue
      groups[!groups %in% input$Puolue] <- "Muut"
      data$groups <- groups
    }
  })
  
  # dynamic party selection widget. 
  # shows only parties that have candidates in the selected municipality
  output$Puolue <- renderUI({ 
    selectizeInput("Puolue", "Valitse yksi tai useampi puolue vertailtavaksi (tai 'Kaikki')", 
                   choices = c("Kaikki", data$puolueet), 
                   options = list(maxItems = 10, placeholder = "etsi puolueita"), 
                   selected = "Kaikki")
  })
  
  # selected parties and the number of candidates in them
  valitut_puolueet <- reactive({
    if(is.null(data$groups)) {
      groups <- c("Kaikki" = nrow(data$items))
    } else{
      groups <- table(data$groups)
    }
    paste0(names(groups), " (n=",groups,")", collapse = ", ")
  })
  
  
  # selected question column indices
  show_items <- reactive({
    start <- input$question_slider
    stop <- min(start + 4, ncol(data$items))
    start:stop
  })
  
  # question navigation
  output$question_slider <- renderUI({
    max <- ncol(data$items) - ncol(data$items) %% 5
    sliderInput("question_slider", "Käytä slideria kysymysten navigointiin", 
                min = 1, max = max, ticks = T,
                value = 1, step = 5)
  })
  
  # input selection summary for plot title
  selections <- reactive({
    q <-  paste(range(show_items()), collapse = "-")
    paste0("HS vaalikone (kys. ",q,"). ", input$Kunta, ": ", valitut_puolueet())
  })
  
  # plotting function
  plot_likert <- function(items, groups) { 
    # use likert package to visualize
    ld <- likert::likert(items, grouping = groups)
    p <- plot(ld, legend.position = "top")
    p <- p + ggplot2::theme(text = ggplot2::element_text(size = 18))
    p + ggplot2::ggtitle(selections())
  }
  
  # plot the (subsetted) question item distributions  
  # wrap around observer to make output plot height dynamic
  observe({
    height <- 500 + length(unique(data$groups))*100
    
    output$likert <- renderPlot({
      if(!is.null(data$items) && !is.null(input$question_slider) && input$Kunta!="") {
        p <- plot_likert(data$items[, show_items()], data$groups)
        p
      }
    }, height = height)
    
  })
  
  # plot download
  output$downloadLikert <- downloadHandler(
    filename = function() {
      paste("kunnat17-", Sys.Date(), ".png", sep="")
    },
    content = function(file) {
      png(file = file, width = input$plot_width, height = input$plot_height)
      p <- plot_likert(data$items[, show_items()], data$groups)
      print(p)
      dev.off()
    }
  )
})