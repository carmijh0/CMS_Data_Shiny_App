# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("DRG Exploration"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Total Discharges" = "total_discharges",
                              "Average Covered Charges" = "average_covered_charges",
                              "Average Total Payments" = "average_total_payments",
                              "Average Medicare Payments" = "average_medicare_payments")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(plotOutput(outputId = "dgrplot", width = 8)
      
    )
  )
)

)

