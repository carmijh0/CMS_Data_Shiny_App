# Define UI for application
ui <- pageWithSidebar(
  
    #Title
    headerPanel("DRG Exploration"),
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis for drg barplot
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("total_discharges", "average_covered_charges", "average_total_payments", "average_medicare_payments"),
                  selected = "total_discharges")
    ),
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "drgbar")
    )
  )
