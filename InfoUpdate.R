
---
title: "Updateing soil database of BC"
ouput: 
## by Jin Zhang for soil database of BC
---

# 1)This Script reads CSV files with new/updated site and horizon data 
# 2)Appends the data to the current site, horizon, and soil file
# 3)Archive the current site.csv, horizon.csv, soil.csv, site_update_template.csv and horizon_update_template.csv
# 4)Write updated SITE.csv, HZN.csv, SOIL.csv 
# 5)Prepare new clean templates: SITE_updates_template.csv and HZN_updates_template.csv for next update
  
## Note:
#### The script has been designed to work with files that have the same column structure 
#### New data files can have more rows than the current files, but must have the same number of columns 
#### criedit to Babak Kasraei and Chuck Bulmer 
# Last edited: Jan 30, 2021

#__________________Imported libraries & Set dirctory_____________________#

library(anytime)
library(tidyverse)
library(dplyr)
library(sp)
library(rgdal)
library(ggplot2)
library(stringr)
setwd("/Volumes/WorkDISC/Update_SOIL")
dir("_data")
dir("_data/_updates")
dir("_data/_archive")
dir("_script")


#______________________ 1. Import tables into R_____________________________#
#site_update_template.csv
#horizon_update_template.csv
#site.csv
#horizon.csv
#soil.csv

s_current <- read.csv("_data/SITE.csv", stringsAsFactors = FALSE)
s_newdata <- read.csv("_data/_updates/SITE_updates_template.csv", 
                      stringsAsFactors = FALSE) #prepared off line
h_current <- read.csv("_data/HZN.csv", stringsAsFactors = FALSE)
h_newdata <- read.csv("_data/_updates/HZN_updates_template.csv", 
                      stringsAsFactors = FALSE) #prepared off line 
soil_current <- read.csv("_data/SOIL.csv", stringsAsFactors = FALSE)

#________________________2-1. Update site.csv table____________________________# 
# combine site_update_template with site.csv
# checking for duplicate 
# Checking for row of empty enteries 
nrow(s_current)
s_updated <- union(s_current, s_newdata)
s_updated<-(s_updated %>% filter_all(any_vars(!is.na(.))))
nrow(s_updated)


#___________________________2-2. Update horizon.csv____________________________#
# combine horizon_updated_template with HZN.csv 
# exporte hzn.csv
# checking for rows of empty enteries
nrow(h_current)
h_updated <- union(h_current, h_newdata)
h_updated<-(h_updated %>% filter_all(any_vars(!is.na(.))))
nrow(h_updated)


#__________________2-3. Updated soil table___________________________________# 
# join site_updates with horizon_updates 
nrow(soil_current)
soil_new <- s_newdata %>% inner_join(h_newdata, by = "SITE_ID")
soil_updated <- union(soil_current, soil_new)
nrow(soil_updated)


#__________________ 3. Archive all the data tables__________________________#
# site table before this update with a time stamp
# hzn table before this update with a time stamp
# harmized soil table before this update with a time stamp 

file.rename("_data/SITE.csv", paste("_data/_archive/SITE_", 
                                    Sys.time(), ".csv", sep = ""))
file.rename("_data/HZN.csv", paste("_data/_archive/HZN_", 
                                   Sys.time(), ".csv", sep = ""))
file.rename("_data/SOIL.csv", paste("_data/_archive/SOIL_", 
                                    Sys.time(), ".csv", sep = ""))

# filled site update template with a time stamp for this update 
# filled hzn update template with a time stamp for this update

file.rename("_data/_updates/SITE_updates_template.csv", 
            paste("_data/_archive/SITE_update_template", 
                  Sys.time(), ".csv", sep = ""))

file.rename("_data/_updates/HZN_updates_template.csv", 
           paste("_data/_archive/HZN_update_template_", 
                 Sys.time(), ".csv", sep = ""))

#___________________________4. Exporte most updated data____________________________#
# Exporte updated site.csv
# Exporte updated hzn.csv
# Exporte updated soil.csv 

write.csv(s_updated, "_data/SITE.csv", row.names = FALSE)
write.csv(h_updated, "_data/HZN.csv", row.names = FALSE)
write.csv(soil_updated, "_data/SOIL.csv", row.names = FALSE)




#__________________________5. Prepare a empty templates for next update______________#
#SITE_updates_template.csv
#HZN_updates_template.csv

s_newdata_na <- s_newdata
s_newdata_na[,1:ncol(s_newdata_na)] <- NA
write.csv(s_newdata_na, 
          "_data/_updates/SITE_update_template.csv", 
          row.names = FALSE)
h_newdata_na <- h_newdata
h_newdata_na[,1:ncol(h_newdata_na)] <- NA
write.csv(h_newdata_na, 
          "_data/_updates/HZN_update_template.csv", 
          row.names = FALSE)


print("The END")
#________________________The END________________________________________________#
              
















