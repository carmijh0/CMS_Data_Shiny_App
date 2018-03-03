library(shiny)
library(plotly)
library(ggplot2)
library(DT)
library(shinythemes)
library(scales)

load(file = 'data/top25_grouped_drg.Rda')
#-----------------------------------------------------------------------------------------

# Define server logic
shinyServer(function(input, output) {
  
  
  output$dgrplot <- renderPlot({
    
    p <- ggplot(top_25, aes(drg, get(input$y))) +
          geom_col(colour = "black") +
          theme(axis.text.x=element_text(angle=45, hjust=1)) +
          scale_y_continuous(labels = comma) +
          ylab(paste(input$y)) +
          xlab(paste('Diagnosis Related Group'))
    p
  })
  
  output$table <- DT::renderDataTable({
    # nearPoints(top_25, input$plot_hover) 
    #   select(drg, definition, provider_state, total_discharges, average_total_payments,
    #           average_medicare_payments)
    # Regualr Search Table - may use on another tab
    if(input$show_data){
      DT::datatable(data = top_25, options = list(pagelength = 10),
                    rownames = FALSE)
    }
  
  })

})


