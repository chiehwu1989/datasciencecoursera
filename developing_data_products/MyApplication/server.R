library(shiny)
library(ggplot2)
data(mtcars)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  model <- reactive({
    brushedData <- brushedPoints(mtcars, input$brush1, xvar=input$x, yvar=input$y)
    
    if(nrow(brushedData) < 2){
      return(NULL)
    }
    
    lm(eval(parse(text = input$y)) ~ eval(parse(text = input$x)), data = brushedData)
  })
  
  groupType <- reactive({
    switch(input$groupType,
           am = as.factor(mtcars$am),
           cyl = as.factor(mtcars$cyl),
           gear = as.factor(mtcars$gear),
           none = as.factor(rep(0, nrow(mtcars)))
    )
  })
    
  output$slopeOut <- renderText({
    if(is.null(model())){
      "No Model Found"
    } else {
      model()[[1]][2]
    }
  })
  
  output$intOut <- renderText({
    if(is.null(model())){
      "No Model Found"
    } else {
      model()[[1]][1]
    }
  })
   
  output$plot1 <- renderPlot({
    plot(mtcars[,input$x], mtcars[,input$y], xlab = input$x,
         ylab = input$y, main = "Variable Graph",
         pch = 16, col=groupType())
    if (length(unique(groupType())) > 1) {
      legend("topright", legend=levels(groupType()), col=1:length(unique(groupType())), pch=16)
    }
    if(!is.null(model())){
      abline(model(), col = "blue", lwd = 2)
    }
  })
})
