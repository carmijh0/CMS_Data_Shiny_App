# Define UI for application that draws a histogram
shinyUI(navbarPage("Exploring Inpatient Utilization Data",
                   theme = shinytheme("flatly"), 
                   fluid = TRUE,
  
  # Application title
  tabPanel("Top 25 DRG's",
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Total Discharges" = "td_sum",
                              "Average Covered Charges" = "cc_sum",
                              "Average Total Payments" = "tp_sum",
                              "Average Medicare Payments" = "mp_sum"),
                  multiple = FALSE),
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Diagnosis Related Group" = "drg")),
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE),
      img(src='drg.png', width = "100%")
    ),
    #Plots on first tab
      mainPanel(
        plotOutput("dgrplot", hover="plot_hover"),
        dataTableOutput(outputId = 'table')
    )
  )
),
  tabPanel("Mapping"),
  tabPanel("Comparison")
))

