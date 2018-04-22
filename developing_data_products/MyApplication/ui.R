library(shiny)

axisOptions <- c("mpg"="mpg",
                 "disp"="disp",
                 "drat"="drat",
                 "wt"="wt",
                 "qsec"="qsec")
shinyUI(fluidPage(
  
  titlePanel("Visualize Models with Car's Variables"),
  
  plotOutput("plot1", brush = brushOpts(id = "brush1")),
  
  hr(),
  
  fluidRow(
    column(3,
      h4("Linear Regression Coefficient"),
      h5("Slope"),
      textOutput("slopeOut"),
      h5("Intercept"),
      textOutput("intOut"),
      br(),
      p("Draw a rectangle on the plot to select points for generating the models")
    ),
    column(3,
           h4("Group Type"),
           radioButtons(
             "groupType",
             NULL,
             c("none" = "none",
               "am" = "am",
               "cyl" = "cyl",
               "gear" = "gear"
             ),
             selected = "none"
           ),
           p("Break down data points by a categorical variable")
    ),
    column(3,
           selectInput(
             "x", 
             strong("X Axis"),
             axisOptions,
             selected = "wt"),
           selectInput(
             "y", 
             strong("Y Axis"),
             axisOptions,
             selected = "mpg"),
           p("Select x and y Axis")
    )
  )
))
