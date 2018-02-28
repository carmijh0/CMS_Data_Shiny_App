library(shiny)
library(plotly)
library(ggplot2)
library(plotly)

load(file = 'data/grouped_drg.Rda')

#-----------------------------------------------------------------------------------------

server <- function(input, output) {
  
  output$dgrplot <- renderPlot({
    
    plot_ly(data = df,
            x= drg_definition,
            y = input$y,
            type = "bar") %>% 
      layout(xaxis = x, yaxis = y, title = input$variable, "by Procedure Type")
    
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)