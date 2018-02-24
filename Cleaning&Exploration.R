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

df_in = bind_rows(dfin_2014, dfin_2015, dfin_2013, dfin_2012, dfin_2011)
#df_out = bind_rows(dfout_2011, dfout_2012, dfout_2013, dfout_2014, dfout_2015)

#Because there's so much data in each of these, I've decided to move forward with just the inpatient dataframe.

length(unique(df_in$year))
length(unique(df_in$drg_definition))

drg_count_total <- df_in %>% 
  group_by(drg_definition) %>% 
  tally() %>% 
  arrange(desc(n))

View(drg_count_total)

df_in <- df_in %>% 


#df_in %>%
  # mutate(payments_to_charges = as.numeric(average_total_payments) / as.numeric(average_covered_charges)) %>%
  # group_by(provider_name) %>%
  # summarize(m = mean(payments_to_charges)) %>%
  # arrange(-m) %>%
  # head(20) %>% 
  # ggplot(aes(x=reorder(provider_name, -m), y = m)) + 
  #   geom_bar(stat = 'identity', fill = 'dodgerblue4', color = 'white') + 
  #   labs(x = 'Provider Name', y = '% Covered Charges', title = 'Total Medicare payments - % of Covered Charges') + 
  #   scale_y_continuous(labels = scales::percent) + 
  #   theme(axis.text.x = element_text(angle = 75, hjust = 1) )
