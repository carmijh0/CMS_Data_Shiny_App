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
  # tabPanel("Mapping"),
  tabPanel("Provider Comparison Tool",
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId = "drg", 
                           label = "Diagnosis Related Group:",
                           choices = ('SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W MCC',
                                      'SIMPLE PNEUMONIA & PLEURISY W CC',
                                      'HEART FAILURE & SHOCK W CC',
                                      'ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC',
                                      'KIDNEY & URINARY TRACT INFECTIONS W/O MCC',
                                      'MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC',
                                      'HEART FAILURE & SHOCK W MCC',
                                      'SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC',
                                      'CELLULITIS W/O MCC',
                                      'CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC',
                                      'SIMPLE PNEUMONIA & PLEURISY W MCC',
                                      'MISC DISORDERS OF NUTRITION,METABOLISM,FLUIDS/ELECTROLYTES W/O MCC',
                                      'RENAL FAILURE W CC',
                                      'CHRONIC OBSTRUCTIVE PULMONARY DISEASE W CC',
                                      'G.I. HEMORRHAGE W CC',
                                      'PULMONARY EDEMA & RESPIRATORY FAILURE',
                                      'RENAL FAILURE W MCC',
                                      'CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W CC',
                                      'INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W CC OR TPA IN 24 HRS',
                                      'HIP & FEMUR PROCEDURES EXCEPT MAJOR JOINT W CC',
                                      'CHRONIC OBSTRUCTIVE PULMONARY DISEASE W/O CC/MCC',
                                      'KIDNEY & URINARY TRACT INFECTIONS W MCC',
                                      'CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W MCC
                                      'RED BLOOD CELL DISORDERS W/O MCC',
                                      'HEART FAILURE & SHOCK W/O CC/MCC'),
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
  )
))

