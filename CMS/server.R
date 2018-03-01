library(shiny)
library(plotly)
library(ggplot2)
library(DT)

load(file = 'data/grouped_drg.Rda')
load(file = 'data/top25_grouped_drg.Rda')
load(file = 'Data/drgtable_grouped_drg.Rda')
#-----------------------------------------------------------------------------------------

# Define server logic
shinyServer(function(input, output) {
   
  output$dgrplot <- renderPlot({
    
    ggplot(top_25, aes(x=drg_definition, y=input$y)) +
       geom_col()
    
    # p + scale_y_continuous(name=input$y, limits=c(0, 90000000000))
    
    # #dataset <- reactive({
    #   df[input$x, input$y]
    # })
    # 
    # p <- ggplot(dataset(), aes(x = input$x, y = input$y)) + 
    #   geom_bar(stat = "identity")
    # 
    # ggplotly(p)
    
     #plot_ly(df, x = ~input$x, y = ~input$y, type = "bar")
  })
  
  output$table <- DT::renderDataTable({
    if(input$show_data){
      DT::datatable(data = top_25 %>% select(1:7), options = list(pagelength = 10),
                    rownames = FALSE)
    }
  })
})

