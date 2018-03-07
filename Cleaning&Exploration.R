library("tidyverse")
library("readxl")
library("dplyr")
library("magrittr")
library("ggplot2")
library("GGally")
library("broom")
library("plyr")
library("ggmap")
library("maps")
library("mapdata")
library("rgeos")
library("maptools")
library("sp")
library("raster")
library("rgdal")
library("sf")
library("stringr")
library("qdap")
library("plotly")
library("devtools")
library("plotly")
library("reshape")

#Reading in the Medicare Inpatient provider utilization and payment data. 

dfin_2015 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRGALL_FY2015.csv')
dfin_2014 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRGALL_FY2014.csv')
dfin_2013 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRG100_FY2013.csv')
dfin_2012 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRG100_FY2012.csv')
dfin_2011 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRG100_FY2011.csv')

#------------------------------------------------------------------------------------------

#First I need to standerdize the column headers for both in and outpatient.

dfin_list <- list(dfin_2015, dfin_2014, dfin_2013, dfin_2012, dfin_2011)

#Lowercase all column headers.

lower_cols <- function(x) {
  colnames(x) <- tolower(colnames(x))
  x
}

#dfout_list <- lapply(names(dfout_list), tolower)

dfin_2015 <- lower_cols(dfin_2015)
dfin_2014 <- lower_cols(dfin_2014)
dfin_2013 <- lower_cols(dfin_2013)
dfin_2012 <- lower_cols(dfin_2012)
dfin_2011 <- lower_cols(dfin_2011)

#Need to add an underscore between words of the 2011-13 dataset column headers.  

underscore <- function(x) {
  colnames(x) <- gsub(" ", "_", colnames(x))
  x
}

dfin_2015 <- underscore(dfin_2015)
dfin_2014 <- underscore(dfin_2014)
dfin_2013 <- underscore(dfin_2013)
dfin_2012 <- underscore(dfin_2012)
dfin_2011 <- underscore(dfin_2011)

#All the string fields need to be standerdized to uppercase.  

dfin_2015 <- mutate_all(dfin_2015, funs(toupper))
dfin_2014 <- mutate_all(dfin_2014, funs(toupper))
dfin_2013 <- mutate_all(dfin_2013, funs(toupper))
dfin_2012 <- mutate_all(dfin_2012, funs(toupper))
dfin_2011 <- mutate_all(dfin_2011, funs(toupper))

#Creating a year column for each dataset. 

add_year_col <- function(x, year) {
  x$year <- as.integer(year) 
  return(x)
}

dfin_2015 <- add_year_col(dfin_2015, 2015)
dfin_2014 <- add_year_col(dfin_2014, 2014)
dfin_2013 <- add_year_col(dfin_2013, 2013)
dfin_2012 <- add_year_col(dfin_2012, 2012)
dfin_2011 <- add_year_col(dfin_2011, 2011)

#Editing column names to match up within all 5 dataframes of each category. 

col_name_in <- function(x) {
  names(x) <- c('drg_definition', 'provider_id', 'provider_name', 'provider_street_address',
                'provider_city', 'provider_state', 'provider_zip_code', 
                'hospital_referral_region','total_discharges', 'average_covered_charges', 
                'average_total_payments','average_medicare_payments', 'year')
  return(x)
}

#Combining all 5 years into one dataframe for each category.  Will the 2012 outpatient lack of columns be a problem? 

#df_in = bind_rows(dfin_2014, dfin_2015, dfin_2013, dfin_2012, dfin_2011)
#df_out = bind_rows(dfout_2011, dfout_2012, dfout_2013, dfout_2014, dfout_2015)

#Because there's so much data in each of these, I've decided to move forward with just the inpatient dataframe.
#Exploration and Visualization

length(unique(df_in$year))
length(unique(df_in$drg_definition))
length(unique(top_25$hospital_referral_region_.hrr._description))

drg_count_total <- df_in %>% group_by(drg_definition) %>% tally() %>% arrange(desc(n)) %>% View()
provider_count_total <- df_in %>% group_by(provider_name) %>% tally() %>% arrange(desc(n))

View(drg_count_total)
View(provider_count_total)

# df_in$drg_definition <- as.complex(df_in$drg_definition)
# 
# target <- c('194 - SIMPLE PNEUMONIA & PLEURISY W CC', '292 - HEART FAILURE & SHOCK W CC',
#             '871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W MCC', '690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC',
#             '392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC')
# 
# top_5_drg <- df_in[df_in$drg_definition %in% c('194 - SIMPLE PNEUMONIA & PLEURISY W CC', '292 - HEART FAILURE & SHOCK W CC',
#                                                  '871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W MCC', '690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC',
#                                                  '392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC'), ] 
# 
# df_in$provider_name <- as.character(df_in$provider_name)
# 
# target <- c('GOOD SAMARITAN HOSPITAL', 'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH HOSPITAL',
#             'MERCY MEDICAL CENTER', 'MERCY HOSPITAL')
# 
# top_5_provider <- filter(df_in, provider_name %in% target)
# 
# top_5_provider$year <- as.numeric(top_5_provider$year)
# top_5_provider$total_discharges <- as.numeric(top_5_provider$total_discharges)
# top_5_provider$average_covered_charges <- as.numeric(top_5_provider$average_covered_charges)
# 
# ggplot(top_5_provider, aes(x=year, y=average_covered_charges, fill=provider_name)) +
#          geom_bar(stat = 'identity')
# ggplot(top_5_provider, aes(x=year, y=average_total_payments, fill=provider_name)) +
#   geom_bar(stat = 'identity')
# 
# top_5_provider$provider_name <- as.factor(top_5_provider$provider_name)
# 
# temp <- top_5_provider
# temp$provider_name <- as.factor(temp$provider_name)

dfin_2015$total_discharges <- as.integer(dfin_2015$total_discharges)
dfin_2015$average_total_payments <- as.integer(dfin_2015$average_total_payments)
dfin_2015$average_covered_charges <- as.integer(dfin_2015$average_covered_charges)
dfin_2015$average_medicare_payments <- as.integer(dfin_2015$average_medicare_payments)

grouped_drg <- df %>% group_by(drg_definition) %>% tally() %>% arrange(desc(n))
top_drg <- grouped_drg[1:25,]

save(top_drg, file = 'Data/drgtable_grouped_drg.Rda')

save(dfin_2015, file = 'Data/dfin_2015.Rda')

#Total discharges by DRG

df <- dfin_2015 %>%
  group_by(drg_definition) %>% 
  mutate(td_sum = sum(as.numeric(total_discharges)),
         tp_sum = sum(as.numeric(average_total_payments)),
         cc_sum = sum(as.numeric(average_covered_charges)),
         mp_sum = sum(as.numeric(average_medicare_payments)))

df$td_sum <- as.integer(df$td_sum)
df$tp_sum <- as.integer(df$tp_sum)
df$cc_sum <- as.integer(df$cc_sum)
df$mp_sum <- as.integer(df$mp_sum)

names(df)[names(df) == 'td_sum'] <- 'Discharges'
names(df)[names(df) == 'tp_sum'] <- 'Avg Covered Charges'
names(df)[names(df) == 'cc_sum'] <- 'Avg Total Payments'
names(df)[names(df) == 'mp_sum'] <- 'Avg Medicare Payments'

df <- separate(data = df, col = drg_definition, into = c("drg", "definition"), sep = " - ")
grouped_drg <- data.frame(df)

save(grouped_drg, file = 'Data/grouped_drg.Rda')

target <- c('871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W MCC',
            '194 - SIMPLE PNEUMONIA & PLEURISY W CC',
            '292 - HEART FAILURE & SHOCK W CC',
            '392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC',
            '690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC',
            '470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC',
            '291 - HEART FAILURE & SHOCK W MCC',
            '872 - SEPTICEMIA OR SEVERE SEPSIS W/O MV >96 HOURS W/O MCC',
            '603 - CELLULITIS W/O MCC',
            '190 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC',
            '193 - SIMPLE PNEUMONIA & PLEURISY W MCC',
            '641 - MISC DISORDERS OF NUTRITION,METABOLISM,FLUIDS/ELECTROLYTES W/O MCC',
            '683 - RENAL FAILURE W CC',
            '191 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W CC',
            '378 - G.I. HEMORRHAGE W CC',
            '189 - PULMONARY EDEMA & RESPIRATORY FAILURE',
            '682 - RENAL FAILURE W MCC',
            '309 - CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W CC',
            '065 - INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W CC OR TPA IN 24 HRS',
            '481 - HIP & FEMUR PROCEDURES EXCEPT MAJOR JOINT W CC',
            '192 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W/O CC/MCC',
            '689 - KIDNEY & URINARY TRACT INFECTIONS W MCC',
            '308 - CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W MCC',
            '812 - RED BLOOD CELL DISORDERS W/O MCC',
            '293 - HEART FAILURE & SHOCK W/O CC/MCC')

top_25 <- filter(df, drg_definition %in% target)

top_25 <- data.frame(top_25)

names(top_25)[names(top_25) == 'td_sum'] <- 'Total Discharges'
names(top_25)[names(top_25) == 'tp_sum'] <- 'Average Covered Charges'
names(top_25)[names(top_25) == 'cc_sum'] <- 'Average Total Payments'
names(top_25)[names(top_25) == 'mp_sum'] <- 'Average Medicare Payments'

save(top_25, file = 'Data/top25_grouped_drg.Rda')

p <- ggplot(top_25, aes(x=drg, y=)) +
  geom_col(colour = "black") +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_y_continuous(labels = comma)
p
ggplotly(p)

ggplot(df, aes(td_sum, cc_sum)) +
  geom_point() +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma)

# df <- data.frame(df)
# df <- df[order(df$tp_sum, decreasing = TRUE),] # sort by #procedures
# 
# View(df)
# 
# save(df, file = 'Data/grouped_drg.Rda')

# x <- list(
#   title = "DRG (type of procedure)"
# )
# y <- list(
#   title = "Average Total Payments"
# )
# 
# plot_ly(x= df$drg_definition,
#         y = df$tp_sum,
#         type = "bar") %>%
#   layout(xaxis = x, yaxis = y,title = "Total Payments by Procedure Type")

p <- ggplot(top_25, aes(x=drg_definition, y=td_sum)) +
  geom_col(colour = "black") +
  theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_y_continuous()
p

#Mapping exploration - Have to upgrade RAM! 

state_map <- map_data('state')
state.abb <- append(state.abb, c("DC"))
state.name <- append(state.name, c("District of Columbia"))
top_25$region <- map_chr(top_25$provider_state, function(x) { tolower(state.name[grep(x, state.abb)]) })

df_map <- inner_join(top_25, state_map, by = "region")

states <- ggplot(data = state_map, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray")

states

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

testing <- states + 
  geom_polygon(data = df_map, aes(fill = m), color = "white") +
  geom_polygon(color = "black", fill = NA) +
  theme_bw() +
  ditch_the_axes

testing

df_map <- df_map %>% 
   group_by(region) %>%
   mutate(m = mean(as.integer(average_covered_charges)))
#   ggplot(aes(x = long, y = lat, group = group, fill = m)) + 
#   geom_polygon() + 
#   geom_path(color = 'white') + 
#   scale_fill_continuous(low = "lightblue", 
#                         high = "dodgerblue4",
#                         name = '$') + 
#   theme_map() + 
#   coord_map('albers', lat0=30, lat1=40) + 
#   ggtitle("Mean Covered Charges for all Procedures") + 
#   theme(plot.title = element_text(hjust = 0.5))

# 
# gg <- ggplot()
# gg <- gg + geom_map(data=state_map, map=state_map,
#                     aes(long, lat, map_id=id),
#                     color="#b2b2b2", size=0.05, fill="white")
# gg <- gg + geom_map(data=df, map=usa_map,
#                     aes(fill=n, map_id=fips),
#                     color="#b2b2b2", size=0.05)
# gg <- gg + scale_fill_viridis(name="Count", trans="log10")
# gg <- gg + coord_proj(us_aeqd_proj)
# gg <- gg + theme_map()
# gg <- gg + theme(legend.position=c(0.85, 0.2))
# gg
#Provider Comparison - I want the user to be able to select a state and DRG
#to compare average total covered charges for that procedure at all the hopsitals.  

# df_2 <- dfin_2015 %>% 
#   group_by(provider_state) %>%
#   mutate(state_td_sum = sum(total_discharges),
#          state_tp_sum = sum(average_total_payments),
#          state_cc_sum = sum(average_covered_charges),
#          state_mp_sum = sum(average_medicare_payments))
# 
# df_2 <- data.frame(df_2)
# df_2 <- df_2[order(df_2$state_cc_sum),] # sort by #procedures
# 
# dfin_2015 %>% group_by(provider_state, provider_name) %>% tally() %>% arrange(desc(n))
# length(unique(df$drg_definition))


#Provdier Comparison Tool

TN_prov <- top_25 %>%
  filter(provider_state == 'TN') %>% 
  group_by(provider_name) %>% 
  tally() %>% 
  arrange(desc(n))
View(TN_prov)

df1 <- df[1:13]

TN <- df1 %>% 
  filter(provider_state == 'TN') %>% 
  group_by(provider_name) %>% 
  mutate(td = sum(as.numeric(total_discharges)),
         tp = sum(as.numeric(average_total_payments)),
         cc = sum(as.numeric(average_covered_charges)),
         mp = sum(as.numeric(average_medicare_payments)))

save(TN, file = 'Data/TN.Rda')

test <- df1 %>% 
  group_by(provider_state, provider_name, drg) %>% 
  mutate(td = sum(as.numeric(total_discharges)),
         tp = sum(as.numeric(average_total_payments)),
         cc = sum(as.numeric(average_covered_charges)),
         mp = sum(as.numeric(average_medicare_payments)))

save(test, file = 'Data/test.Rda')

# modDf <- reactive({
#   mdf <- combo %>%
#     filter(item_artist %in% list(input$artist))
#   return(mdf)
# })
# 
# modDf2 <- reactive({
#   mdf <- combo %>%
#     filter(item_artist %in% list(input$artist2))
#   return(mdf)
# })
# # -------------------------------------------------------------
# 
# # CREATING FILTER BY SONG DATABASE USING ARTIST
# songDf <- reactive({
#   mdf <- modDf()
#   if (length(input$song) == 0){
#     return(mdf)
#   }
#   else {
#     new <- mdf %>%
#       filter(item_title %in% input$song)
#     return(new)
#   }
# })
# 
# songDf2 <- reactive({
#   mdf <- modDf2()
#   if (length(input$song2) == 0){
#     return(mdf)
#   }
#   else {
#     new <- mdf %>%
#       filter(item_title %in% input$song2)
#     return(new)
#   }
# })
# # ------------------------------------------------------------
# 
# # FILTERING UI SONG CHOICES BY ARTIST
# observe({
#   
#   mdf <- modDf()
#   
#   updateSelectInput(session,
#                     "song",
#                     choices = sort(unique(mdf$item_title))
#   )
# })
# 
# observe({
#   
#   mdf2 <- modDf2()
#   
#   updateSelectInput(session,
#                     "song2",
#                     choices = sort(unique(mdf2$item_title))
#   )
# })