
# This Script reads CSV files with new / updated site and horizon data and appends the data to the current site and horizon files
# Note that the script has been designed to work with files that have the same column structure 
# New data files can have more rows than the current files
# Babak Kasraei and Chuck Bulmer
###########################################################
##################### Imported libraries##########################
packages4thisscript <- c("anytime", "dplyr", "sp", "rgdal", "ggplot2", "stringr")
lapply(packages4thisscript, library, character.only = TRUE)

setwd("X:/BC_DSM/_Projects/Sabiston_Eagle_Hill")
dir("_data")
dir("_data/_updates")

##  --- SITE UPDATER --- ####### (use the site update template.csv to prepare new data for loading to the site file)  
#######################################################
s_current <- read.csv("_data/EHF_site_latest.csv", stringsAsFactors = FALSE)
s_newdata <- read.csv("_data/_updates/EHF_site_update_template.csv", stringsAsFactors = FALSE) #prepared off line
#######################################################

# add the new / updated attribute data to existng site database
for (i in 1:nrow(s_newdata)){
  for (j in 1:length(names(s_newdata))){
    ifelse(!is.na(s_newdata[i,j]), s_current[i,j] <- s_newdata[i,j],next)
  }
}

#sort the updated file
s_current <- s_current[order(s_current$PID),] 

#archive the old site file and save the new site file
file.rename("_data/EHF_site.csv", paste("_data/EHF_site_", Sys.Date(), ".csv", sep = "")) #archive
write.csv(s_current, "_data/EHF_site.csv", row.names = FALSE) # save

#archive the site update file (ie the edited update template), save new update template file
file.rename("_data/_updates/EHF_site_update_template.csv", paste("_data//_updates/EHF_site_update_template_", Sys.Date(), ".csv", sep = ""))
s_current_na <- s_current
s_current_na[,5:ncol(s_current_na)] <- NA
write.csv(s_current_na, "_data/_updates/EHF_site_update_template.csv", row.names = FALSE)


##  --- ADD NEW SITES TO HORIZON FILE --- #############
#######################################################
h_current <- read.csv("_data/EHF_horizons_latest.csv", stringsAsFactors = FALSE)
new_sites <- s_current[!(s_current$PID %in% unique(h_current$PID)),]

h_temp = h_current[FALSE,]

for (i in 1:length(new_sites$PID)){
  h_temp[i,] <- c(NA, new_sites$PID[i], "H1", 0, 100, new_sites$SaDate[i], NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
}

h_current_w_new_sites <- rbind(h_current, h_temp)
h_current_w_new_sites <- h_current_w_new_sites[order(h_current_w_new_sites$PID, h_current_w_new_sites$HID),] 

#archive the old horizons file and save the new horizons file
file.rename("_data/EHF_horizons.csv", paste("_data/EHF_horizons_", Sys.Date(), ".csv", sep = "")) #archive
write.csv(h_current_w_new_sites, "_data/EHF_horizons.csv", row.names = FALSE) # save

#archive the old update template file and save the new update template file
file.rename("_data/_updates/horizons_update_template.csv", paste("_data//_updates/horizons_update_template_", Sys.Date(), ".csv", sep = ""))
h_current_na <- h_current
h_current_na[,7:ncol(h_current_na)] <- NA

write.csv(h_current_na, "_data/_updates/horizons_update_template.csv", row.names = FALSE)


##  --- HORIZON UPDATER --- ###########################
#######################################################
h_current <- read.csv("_data/EHF_horizons.csv", stringsAsFactors = FALSE)
h_list_of_sites <- unique(h_current$PID)
s_list_of_sites <- s_current$PID
length(h_list_of_sites) - length(s_list_of_sites) #check they have the same length
h_newdata <- read.csv("_data/_updates/horizons_updates_2020_02_12.csv", stringsAsFactors = FALSE) #prepared off line 
#######################################################

# add the new / updated attribute data to existing horizons database
for (i in 1:nrow(h_newdata)){
  for (j in 1:length(names(h_newdata))){
    ifelse(!is.na(h_newdata[i,j]), h_current[i,j] <- h_newdata[i,j],next)
  }
}

#sort the horizon data file
h_current <- h_current[order(h_current$PID, h_current$HID),] 

h_list_of_sites <- unique(h_current$PID)
s_list_of_sites <- s_current$PID
length(h_list_of_sites) - length(s_list_of_sites) #check they have the same length

#archive the old horizons file and save the new horizons file
file.rename("_data/EHF_horizons_latest.csv", paste("_data/EHF_horizons_", Sys.Date(), ".csv", sep = "")) #archive
write.csv(h_current, "_data/EHF_horizons_latest.csv", row.names = FALSE) # save

#archive the old update template file and save the new update template file
file.rename("_data/_updates/horizons_update_template.csv", paste("_data//_updates/horizons_update_template_", Sys.Date(), ".csv", sep = ""))
h_current_na <- h_current
h_current_na[,7:ncol(h_current_na)] <- NA

write.csv(h_current_na, "_data/_updates/horizons_update_template.csv", row.names = FALSE)
