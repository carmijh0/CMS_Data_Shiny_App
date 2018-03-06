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
      filter(provider_state %in% list(input$state))
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
        DT::datatable(data = top_25,  options=list(columnDefs = list(list(visible=FALSE, targets=c(3, 4)))),
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
  
  output$distPlot <- renderPlot({
    
    x    <- input$x1
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         main = "Histogram of 2015 DRG's")
    
  })

  #Hover table for the above scatter
  output$table1 <- renderPrint({
    brushedPoints(grouped_drg, input$plot_brush, allRows = TRUE)
  })
    
  #   DT::renderDataTable({
  #   nearPoints(filtered(), input$plot_hover) %>%
  #     select(drg, definition, Discharges, Avg.Covered.Charges, Avg.Total.Payments,
  #            Avg.Medicare.Payments)
  # 
  # })
  
  drgDF <- reactive({
    mdf <- modDf()
    if (length(input$drg) == 0){
      return(mdf)
    }
    else {
      new <- mdf %>%
        filter(drg %in% list(input$drg))
      return(new)
    }

  })
  
  observe({
    
    mdf <- modDf()
    
    updateSelectInput(session,
                      "drg",
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
                                  "Heart Failure With Shock" = "HEART FAILURE & SHOCK W/O CC/MCC")
    )
  })
  
  # observe({
  # 
  #   mdf <- modDf()
  # 
  #   updateSelectInput(session,
  #                     "drg",
  #                     choices = c("AL" = "AL",
  #                                 "AK" = "AK",
  #                                 "AZ" = "AZ",
  #                                 "AR" = "AR",
  #                                 "CA" = "CA",
  #                                 "CO" = "CO",
  #                                 "CT" = "CT",
  #                                 "DE" = "DE",
  #                                 "FL" = "FL",
  #                                 "GA" = "GA",
  #                                 "HI" = "HI",
  #                                 "ID" = "ID",
  #                                 "IL" = "IL",
  #                                 "IN" = "IN",
  #                                 "IA" = "IA",
  #                                 "KS" = "KS",
  #                                 "KY" = "KY",
  #                                 "LA" = "LA",
  #                                 "ME" = "ME",
  #                                 "MD" = "MD",
  #                                 "MA" = "MA",
  #                                 "MI" = "MI",
  #                                 "MN" = "MN",
  #                                 "MS" = "MS",
  #                                 "MO" = "MO",
  #                                 "MT" = "MT",
  #                                 "NE" = "NE",
  #                                 "NV" = "NV",
  #                                 "NH" = "NH",
  #                                 "NJ" = "NJ",
  #                                 "NM" = "NM",
  #                                 "NY" = "NY",
  #                                 "NC" = "NC",
  #                                 "ND" = "ND",
  #                                 "OH" = "OH",
  #                                 "OK" = "OK",
  #                                 "OR" = "OR",
  #                                 "PA" = "PA",
  #                                 "RI" = "RI",
  #                                 "SC" = "SC",
  #                                 "SD" = "SD",
  #                                 "TN" = "TN",
  #                                 "TX" = "TX",
  #                                 "UT" = "UT",
  #                                 "VT" = "VT",
  #                                 "VA" = "VA",
  #                                 "WA" = "WA",
  #                                 "WV" = "WV",
  #                                 "WI" = "WI",
  #                                 "WY" = "WY",
  #                                 "DC" = "DC")
  #   )
  # })

  output$bar1 <- renderPlot({
    
    ggplot(drgDF(), aes(provider_name, get(input$y2))) +
      geom_col(colour = "black") +
      theme(axis.text.x=element_text(angle=45, hjust=1)) +
      scale_y_continuous(labels = comma) +
      ylab(paste(input$y2)) +
      xlab(paste('Provider Name'))
  })

})

 
