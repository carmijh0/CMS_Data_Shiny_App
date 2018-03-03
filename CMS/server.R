library(shiny)
library(plotly)
library(ggplot2)
library(DT)
library(shinythemes)
library(scales)
#-----------------------------------------------------------------------------------------

# Define server logic
shinyServer(function(input, output) {
  
  filtered <- reactive ({
    grouped_drg %>% 
      filter(drg == input$plot_hover)
    
  })
  
  #Top 25 drg bar chart
  output$bar <- renderPlot({
    
     ggplot(top_25, aes(drg, get(input$y))) +
            geom_col(colour = "black") +
            theme(axis.text.x=element_text(angle=45, hjust=1)) +
            scale_y_continuous(labels = comma) +
            ylab(paste(input$y)) +
            xlab(paste('Diagnosis Related Group'))
  })
  # Regualr Search Table
  output$table <- DT::renderDataTable({
    View(top_25)
    if(input$show_data){
      DT::datatable(data = top_25, options = list(pagelength = 10),
                    rownames = FALSE)
    }
  
 #Variable exploration scatter of grouped drg df
  output$scatter <- renderPlot({

    ggplot(grouped_drg, aes(get(input$x1), get(input$y1))) +
        geom_point() +
        scale_x_continuous(labels = comma) +
        scale_y_continuous(labels = comma) +
        ylab(paste(input$y1)) +
        xlab(paste(input$x1))
  })

  #Hover table for the above scatter
  output$table1 <- DT::renderDataTable({
    nearPoints(filtered(), input$plot_hover) %>%
      select(drg, definition, Discharges, Avg.Covered.Charges, Avg.Total.Payments,
             Avg.Medicare.Payments)

    })
  
  })

})


