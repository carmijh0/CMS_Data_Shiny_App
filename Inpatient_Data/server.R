library(shiny)
library(plotly)
library(ggplot2)

#Since this
# doesn't rely on any user inputs, we can do this once at startup
# and then use the value throughout the lifetime of the app

# Define server logic to plot various variables ----
server <- function(input, output) {
  
  # Compute the formula text ----
  # This is in a reactive expression since it is shared by the
  # output$caption and output$plot
  formulaText <- reactive({
    paste("Provider ~ ", input$variable)
  })
  
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable ----
  # and only exclude outliers if requested
  output$providerPlot <- renderPlot({
    ggplot(temp, aes(x=year, y=input$variable, fill = top_5_provider$provider_name)) +
      geom_col(position = "stack")
      ylab(paste("Measuring", input$variable))
  })
  
}