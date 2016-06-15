
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
diamonds2 <- read.csv("diamonds2.csv")

shinyUI(fluidPage(

  h1("I'm so shiny..."),
  
  h3("viz histogram with summary output"),
  # histogram bin slider
  sliderInput("num","Choose a number",1,100,50),
  
  # one button
  # actionButton("go","Update"),
  
  # two buttons
  actionButton("normal","Normal Data"),
  actionButton("uniform","Uniform Data"),
  
  # the histogram plot and summary
  plotOutput("hist"),
  verbatimTextOutput("summary"),
  
  # real time clock 
  h3("real time clock"),
  verbatimTextOutput("clock"),
  
  # line graph refresh every data update
  h3("line graph auto refresh every data update"),
  plotOutput("line"),
  
  # interactive viz
  h3("viz points on the bottom will show as red when data is selected"),
  selectInput("yVar", "Select Y", 
              choices = names(diamonds2), selected = "cut"),  
  selectInput("xVar", "Select X", 
              choices = names(diamonds2), selected = "price"),
  fluidRow(
    column(3, 
           h4("Click"),
           verbatimTextOutput("clickVals")
    ),
    column(3, 
           h4("Double Click"),
           verbatimTextOutput("dblclickVals")
    ),
    column(3, 
           h4("Hover"),
           verbatimTextOutput("hoverVals")
    ),
    column(3, 
           h4("Brush"),
           verbatimTextOutput("brushVals")
    )
  ),  
  plotOutput("plot1",
             click = "click",
             dblclick = "dblclick",
             hover = "hover",
             brush = "brush"),
  
  # viz points will show as red when plot1 is highlighted
  plotOutput("plot2"),
  
  # show all rows
  verbatimTextOutput("info")

  
  
))
