
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)


shinyServer(function(input, output, session) {
  
  # example 1: reactive() 
  # data <- reactive({
  #   rnorm(input$num)
  # })
  
  # example 2: eventReactive() 
  # data <- eventReactive(input$go, {
  #   rnorm(input$num)
  # })
  
  # example 3: observe() 
  # observe({
  #   rv$data <- rnorm(input$num)
  # })
  
  # example 4: reactiveValues() + observeEvent()
  rv <- reactiveValues(data=rnorm(50))
  
  observeEvent( input$normal, { 
    rv$data <- rnorm(input$num)
  })
  
  observeEvent( input$uniform, {
    rv$data <- runif(input$num)
  })
  
  # example 5: invalidateLater()
  clockdata <- reactive({
    invalidateLater(1000)
    Sys.time()
  })

  # plot and summary, should use data or rv$data
  output$hist <- renderPlot({
    hist(rv$data)
  })
  output$summary <- renderPrint({
    summary(rv$data)
  })
  output$clock <- renderPrint({
    invalidateLater(1000)
    Sys.time()
    # clockdata()   # another option is to call the reactive dataset
  })
  
  # example 6: reactiveFileReader()
  linedata <- reactiveFileReader(
    intervalMillis = 5000,
    session = session,
    filePath = "data.csv",
    readFunc = read.csv
  )
  output$line <- renderPlot({
    plot(linedata(), type = "l")
  })

  # example 7: interactive viz
  diamonds2 <- reactive({
    read.csv("diamonds2.csv")
    #diamonds2 <- diamonds[sample(1:nrow(diamonds), 5000), ]
  })
  
  output$plot1 <- renderPlot({
    ggplot(diamonds2(), aes(x = diamonds2()[[input$xVar]], y = diamonds2()[[input$yVar]])) +
      xlab(input$xVar) +
      ylab(input$yVar) +
      geom_count() +
      theme_bw() 
  })
  
  # viz using qplot
#   output$plot1 <- renderPlot({
#     qplot(diamonds2[[input$xVar]], diamonds2[[input$yVar]], 
#           xlab = input$xVar, ylab = input$yVar, data = diamonds2)
#   })
  
  output$clickVals <- renderText({
    paste0("x=", input$click$x, "\ny=", input$click$y)
  })
  
  output$dblclickVals <- renderText({
    paste0("x=", input$dblclick$x, "\ny=", input$dblclick$y)
  })
  
  output$hoverVals <- renderText({
    paste0("x=", input$hover$x, "\ny=", input$hover$y)
  })
  
  output$brushVals <- renderText({
    paste0("xmin=", input$brush$xmin, "\nymin=", input$brush$ymin, "\nxmax=", input$brush$xmax,"\nymax=", input$brush$ymax)
  })
  
  output$plot2 <- renderPlot({
    ggplot(diamonds2(), aes(carat, price)) +
      geom_point() +
      theme_bw() + 
      geom_point(color = "red",
                 data = brushedPoints(diamonds2(), input$brush, xvar = input$xVar, yvar = input$yVar))
  })
  
  output$info <- renderPrint({
    brushedPoints(diamonds2(), input$brush, xvar = input$xVar, yvar = input$yVar)
  })
    
  
})
