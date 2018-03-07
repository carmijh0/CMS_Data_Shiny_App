library(shiny)
library(plotly)
library(ggplot2)
library(DT)
library(shinythemes)
library(scales)
library(gridExtra)
#-----------------------------------------------------------------------------------------

# Define server logic
shinyServer(function(input, output, session) {
  
  filtered <- reactive ({
    grouped_drg %>%
      filter(drg == input$plot_hover)
    return(grouped_drg)
  })
  
  modDf <- reactive({
    mdf <- test %>%
      filter(provider_state %in% input$state)
    return(mdf)
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
    if(input$show_data){
        DT::datatable(data = top_25,  options=list(columnDefs = list(list(visible=FALSE, targets=c(3)))),
                    rownames = FALSE)
    }

  })
  
 #Variable exploration scatter of grouped drg df
  output$scatter <- renderPlot({

    ggplot(grouped_drg, aes(get(input$x1), get(input$y1))) +
        geom_point() +
        scale_x_continuous(labels = comma) +
        scale_y_continuous(labels = comma) +
        ylab(paste(input$y1)) +
        xlab(paste(input$x1))
  })
  
  #Histogram of drg's
  
  output$hist <- renderPlot({
    
    value1 <- unlist(grouped_drg$Discharges)
    value2 <- unlist(grouped_drg$Avg.Covered.Charges)
    value3 <- unlist(grouped_drg$Avg.Total.Payments)
    value4 <- unlist(grouped_drg$Avg.Medicare.Payments)
    
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # hist(x, breaks = bins, col = "#75AADB", border = "white",
    #      main = "Histogram of 2015 DRG's")
    
    if (get(input$x1) == "Discharges") {
      
      hist(value1, breaks = bins, main = "Histogram of Discharges")}
    
    if (get(input$x1) == "Avg.Covered.Charges") {
      
      hist(value2, breaks = bins, main = "Histogram of Average Covered Charges")}
    
    if (get(input$x1) == "Avg.Total.Payments") {
      
      hist(value3, breaks = bins, main = "Histogram of Total Payments")}
    
    if (get(input$x1) == "Avg.Medicare.Payments") {
      
      hist(value4, breaks = bins, main = "Histogram of Average Medicare Payments")}
  })

  #Hover table for the above scatter
  # output$table1 <- renderPrint({
  #   brushedPoints(filtered(), input$plot_brush, allRows = TRUE)
  # })
    
  output$info <- renderPrint({
    
    brushedPoints(filterd(), input$plot_brush, xvar = get(input$x1), yvar = get(input$y1))
  })
  
    # output$table1 <- DT::renderDataTable({
  #   nearPoints(filtered(), input$plot_hover) %>%
  #     select(drg, definition, Discharges, Avg.Covered.Charges, Avg.Total.Payments,
  #            Avg.Medicare.Payments)
  # 
  # })
  output$sum <- renderPrint({
    
    summary(grouped_drg[(get(input$x1))])
  })
  
  drgDF <- reactive({
    mdf <- modDf()
    if (length(input$drg) == 0){
      return(mdf)
    }
    else {
      new <- mdf %>%
        filter(drg %in% input$drg)
      return(new)
    }

  })
  
  observe({
    
    mdf <- modDf()
    
    updateSelectInput(session,
                      "drg",
                      choices = sort(unique(mdf$drg))
    )
  })
  

  output$bar1 <- renderPlot({
   # View(drgDF)
    ggplot(drgDF(), aes(provider_name, get(input$y2))) +
      geom_col(colour = "black") +
      theme(axis.text.x=element_text(angle=45, hjust=1)) +
      scale_y_continuous(labels = comma) +
      ylab(paste(input$y2)) +
      xlab(paste('Provider Name'))
  }, height = 500, width = 900)

})

 
