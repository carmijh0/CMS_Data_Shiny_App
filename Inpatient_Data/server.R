library(shiny)
library(plotly)
library(ggplot2)
library(plotly)

x <- list(
  title = "DRG (type of procedure)"
)

server <- function(input, output) {
  
  formulaText <- reactive({
    paste(input$variable, "by Procedure Type")
  })
 
  output$caption <- renderText({
    formulaText()
  })
  
  # Create plotly output 
  output$drgbar <- renderPlotly({
    plot_ly(data = df,
            x= df$drg_definition,
            y = input$y,
            type = "bar") %>% 
      layout(xaxis = x, yaxis = y, title = "by Procedure Type")
  })
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
