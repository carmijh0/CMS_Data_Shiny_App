# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exploring Inpatient Utilization Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Total Discharges" = "total_discharges",
                              "Average Covered Charges" = "average_covered_charges",
                              "Average Total Payments" = "average_total_payments",
                              "Average Medicare Payments" = "average_medicare_payments",
                              multiple = FALSE)),
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Diagnosis Related Group" = "drg_definition")),
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE),
      img(src='drg.png', width = "100%")
    ),
    #Plots on first tab
    mainPanel(
      plotOutput("dgrplot"),
      DT::dataTableOutput(outputId = 'table')
    )
  )
))
