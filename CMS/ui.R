# Define UI for application that draws a histogram
shinyUI(navbarPage("Exploration of 2015 Provider Inpatient Utilization and Payment Data",
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
              # verbatimTextOutput("table")
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
                             value = TRUE),
               sliderInput(inputId = "bins",
                           label = "Number of bins:",
                           min = 1,
                           max = 50,
                           value = 30),
               img(src='1.png', width = "100%"),
               img(src='2.png', width = "100%")
               
            ),
             #Plots on first tab
             mainPanel(
               tabsetPanel(
                 tabPanel("Scatter",
                          fluidRow(
                          plotOutput("scatter", hover="plot_brush"),
                          # dataTableOutput(outputId = 'table1')
                          verbatimTextOutput("info")
                          )),
                 tabPanel("Histogram",
                          plotOutput("hist")),
                 tabPanel("Summary",
                          verbatimTextOutput("sum"))
        )
      )
    )
  ),
  tabPanel("Mapping"),
  tabPanel("Provider Comparison Tool",
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId = "state", 
                           label = "State:",
                           choices = c("AL" = "AL",
                                       "AK" = "AK",
                                       "AZ" = "AZ",
                                       "AR" = "AR",
                                       "CA" = "CA",
                                       "CO" = "CO",
                                       "CT" = "CT",
                                       "DE" = "DE",
                                       "FL" = "FL",
                                       "GA" = "GA",
                                       "HI" = "HI",
                                       "ID" = "ID",
                                       "IL" = "IL",
                                       "IN" = "IN",
                                       "IA" = "IA",
                                       "KS" = "KS",
                                       "KY" = "KY",
                                       "LA" = "LA",
                                       "ME" = "ME",
                                       "MD" = "MD",
                                       "MA" = "MA",
                                       "MI" = "MI",
                                       "MN" = "MN",
                                       "MS" = "MS",
                                       "MO" = "MO",
                                       "MT" = "MT",
                                       "NE" = "NE",
                                       "NV" = "NV",
                                       "NH" = "NH",
                                       "NJ" = "NJ",
                                       "NM" = "NM",
                                       "NY" = "NY",
                                       "NC" = "NC",
                                       "ND" = "ND",
                                       "OH" = "OH",
                                       "OK" = "OK",
                                       "OR" = "OR",
                                       "PA" = "PA",
                                       "RI" = "RI",
                                       "SC" = "SC",
                                       "SD" = "SD",
                                       "TN" = "TN",
                                       "TX" = "TX",
                                       "UT" = "UT",
                                       "VT" = "VT",
                                       "VA" = "VA",
                                       "WA" = "WA",
                                       "WV" = "WV",
                                       "WI" = "WI",
                                       "WY" = "WY",
                                       "DC" = "DC"),
                           multiple = FALSE),
               selectInput(inputId = "drg",
                           label = "Diagnosis Related Group",
                           choices = c("Sepsis (W MCC)" = "SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W MCC",
                                       "Pneumonia (W CC)" = "SIMPLE PNEUMONIA & PLEURISY W CC",
                                       "Heart Failure (W CC)" = "HEART FAILURE & SHOCK W CC",
                                       "Digest Disorders" = "ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC",
                                       "Kidney/Urinary Infection (W/O MCC)" = "KIDNEY & URINARY TRACT INFECTIONS W/O MCC",
                                       "Major Joint Replacment" = "MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC",
                                       "Heart Failure (W MCC)" = "HEART FAILURE & SHOCK W MCC",
                                       "Sepsis (W/O MCC)" = "SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC",
                                       "Cellulitis" = "CELLULITIS W/O MCC",
                                       "COP" = "CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC",
                                       "Pneumonia (W MCC)" = "SIMPLE PNEUMONIA & PLEURISY W MCC",
                                       "Malnutrition" = "MISC DISORDERS OF NUTRITION,METABOLISM,FLUIDS/ELECTROLYTES W/O MCC",
                                       "Renal Failure (W CC)" = "RENAL FAILURE W CC",
                                       "COP (W CC) " = "CHRONIC OBSTRUCTIVE PULMONARY DISEASE W CC",
                                       "G.I. Hemmorrhage" = "G.I. HEMORRHAGE W CC",
                                       "Respiratory Failure" = "PULMONARY EDEMA & RESPIRATORY FAILURE",
                                       "Renal Failure (W MCC)" = "RENAL FAILURE W MCC",
                                       "Cardiac Arrhythima (W CC)" = "CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W CC",
                                       "Intracranial Hemorrhage" = "INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W CC OR TPA IN 24 HRS",
                                       "Hip/Femur Procedures" = "HIP & FEMUR PROCEDURES EXCEPT MAJOR JOINT W CC",
                                       "COP (W/O CC)" = "CHRONIC OBSTRUCTIVE PULMONARY DISEASE W/O CC/MCC",
                                       "Kidney/Urinary Infection (W MCC)" ="KIDNEY & URINARY TRACT INFECTIONS W MCC",
                                       "Cardiac Arrhythima (W MCC)" = "CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W MCC",
                                       "Blood Disorders" = "RED BLOOD CELL DISORDERS W/O MCC",
                                       "Heart Failure With Shock" = "HEART FAILURE & SHOCK W/O CC/MCC"),
                           multiple = FALSE),
               selectInput(inputId = "y2", 
                           label = "Y-axis:",
                           choices = c("Total Discharges" = "td",
                                       "Average Covered Charges" = "tp",
                                       "Average Total Payments" = "cc",
                                       "Average Medicare Payments" = "mp"),
                           multiple = FALSE),
               img(src='drg_cats.png', width = "100%")
               
             ),
             #Plots on first tab
             mainPanel(
               plotOutput("bar1")
             )
           )
        )
      )
    )

