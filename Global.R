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

#Reading in the Medicare outpatient provider utilization and payment data.  

dfout_2015 = read_csv('data/Medicare_Charge_Outpatient_APC28_CY2015_Provider.csv')
dfout_2014 = read_csv('data/Medicare_Provider_Charge_Outpatient_APC32_CY2014.csv')
dfout_2013 = read_csv('data/Medicare_Provider_Charge_Outpatient_APC30_CY2013_v2.csv')
dfout_2012 = read_csv('data/Medicare_Charge_Outpatient_APC30_Summary_by_APCState_CY2012.csv')
dfout_2011 = read_csv('data/Medicare_Provider_Charge_Outpatient_APC30_CY2011_v2.csv')

#Reading in the Medicare Inpatient provider utilization and payment data. 

dfin_2015 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRGALL_FY2015.csv')
dfin_2014 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRGALL_FY2014.csv')
dfin_2013 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRG100_FY2013.csv')
dfin_2012 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRG100_FY2012.csv')
dfin_2011 = read_csv('data/Medicare_Provider_Charge_Inpatient_DRG100_FY2011.csv')

#------------------------------------------------------------------------------------------

#First I need to standerdize the column headers for both in and outpatient. 

View(dfout_2015)
View(dfout_2014)
View(dfout_2013)
View(dfout_2012)
View(dfout_2011)
View(dfin_2015)
View(dfin_2014)
View(dfin_2013)
View(dfin_2012)
View(dfin_2011)

#The first step will be to lowercase all column headers.

lower_cols <- function(x) {
  colnames(x) <- tolower(colnames(x))
  x
}

dfout_2015 <- lower_cols(dfout_2015)
dfout_2014 <- lower_cols(dfout_2014)
dfout_2013 <- lower_cols(dfout_2013)
dfout_2012 <- lower_cols(dfout_2012)
dfout_2011 <- lower_cols(dfout_2011)
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

dfout_2013 <- underscore(dfout_2013)
dfout_2012 <- underscore(dfout_2012)
dfout_2011 <- underscore(dfout_2011)
dfin_2015 <- underscore(dfin_2015)
dfin_2014 <- underscore(dfin_2014)
dfin_2013 <- underscore(dfin_2013)
dfin_2012 <- underscore(dfin_2012)
dfin_2011 <- underscore(dfin_2011)

#All the string fields need to be standerdized to uppercase.  

dfout_2015 <- mutate_all(dfout_2015, funs(toupper))
dfout_2014 <- mutate_all(dfout_2014, funs(toupper))
dfout_2013 <- mutate_all(dfout_2013, funs(toupper))
dfout_2012 <- mutate_all(dfout_2012, funs(toupper))
dfout_2011 <- mutate_all(dfout_2011, funs(toupper))
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

dfout_2015 <- add_year_col(dfout_2015, 2015)
dfout_2014 <- add_year_col(dfout_2014, 2014)
dfout_2013 <- add_year_col(dfout_2013, 2013)
dfout_2012 <- add_year_col(dfout_2012, 2012)
dfout_2011 <- add_year_col(dfout_2011, 2011)
dfin_2015 <- add_year_col(dfin_2015, 2015)
dfin_2014 <- add_year_col(dfin_2014, 2014)
dfin_2013 <- add_year_col(dfin_2013, 2013)
dfin_2012 <- add_year_col(dfin_2012, 2012)
dfin_2011 <- add_year_col(dfin_2011, 2011)

#Combining all 5 years into one dataframe for each category.  Will the 2012 outpatient lack of columns be a problem? 



