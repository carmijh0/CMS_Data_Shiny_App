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
                            choices = c("Total Discharges" = "Total Discharges",
                              "Average Covered Charges" = "Average Covered Charges",
                              "Average Total Payments" = "Average Total Payments",
                              "Average Medicare Payments" = "Average Medicare Payments"),
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
              plotOutput("bar"),
              DT::dataTableOutput(outputId = 'table')
    )
  )
),
  tabPanel("Explore",
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId = "y1", 
                           label = "Y-axis:",
                           choices = c("Total Discharges" = "Discharges",
                                       "Average Covered Charges" = "Avg.Covered.Charges",
                                       "Average Total Payments" = "Avg.Total.Payments",
                                       "Average Medicare Payments" = "Avg.Medicare.Payments"),
                           multiple = FALSE),
               selectInput(inputId = "x1", 
                           label = "X-axis:",
                           choices = c("Total Discharges" = "Discharges",
                                       "Average Covered Charges" = "Avg.Covered.Charges",
                                       "Average Total Payments" = "Avg.Total.Payments",
                                       "Average Medicare Payments" = "Avg.Medicare.Payments"),
                           multiple = FALSE),
               checkboxInput(inputId = "show_data1",
                             label = "Show data table",
                             value = TRUE)
             ),
             #Plots on first tab
             mainPanel(
               plotOutput("scatter", hover="plot_hover"),
               dataTableOutput(outputId = 'table1')
             )
           )
  ),
  tabPanel("Mapping"),
  tabPanel("Provider Comparison Tool")
))

