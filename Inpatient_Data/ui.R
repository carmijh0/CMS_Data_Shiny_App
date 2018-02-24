library(shiny)
library(shinythemes)

# Define UI for miles per gallon app ----
ui <- fluidPage(theme=shinytheme("cosmo"),
  
  # App title ----
  titlePanel("Top 5 National Providers"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for variable to plot against year ----
      selectInput("variable", "Variable:",
                  c("Average Covered Charges" = "average_covered_charges",
                    "Average Total Payments" = "average_total_payments",
                    "Average Medicare Payments" = "average_medicare_payments")),
      
      # Input: Checkbox for whether outliers should be included ----
      checkboxInput("outliers", "Show outliers", TRUE)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Plot of the requested variable against mpg ----
      plotOutput("providerPlot")
      
    )
  )
)