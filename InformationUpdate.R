# 1)This Script reads CSV files with new/updated site and horizon data 
# 2)Appends the data to the current site and horizon files
## Note:
#### The script has been designed to work with files that have the same column structure 
#### New data files can have more rows than the current files
# Author: Babak Kasraei and Chuck Bulmer
# Modified by Jin Zhang on Jan 15, 2021 for BCSIS database 

###########################################################
##################### Imported libraries##########################
packages4thisscript <- c("anytime","tidyr", "dplyr", "sp", "rgdal", "ggplot2", "stringr")
lapply(packages4thisscript, library, character.only = TRUE)

setwd("/Volumes/WorkDISC")
dir("_data")
dir("_data/_updates")

##  --- SITE UPDATER --- ####### (use the site update template.csv to prepare new data for loading to the site file)  
#######################################################
s_current <- read.csv("_data/BCSIS_site_latest.csv", stringsAsFactors = FALSE)


#Filled template with the updated data
s_newdata <- read.csv("_data/_updates/BC_site_update_template.csv", 
                      stringsAsFactors = FALSE) #prepared off line


#######################################################

# Add the new / updated attribute data to existng site database
# Remove any empty rows

s_updated <- (rbind(s_current, s_newdata))
s_updated<-(s_updated %>% drop_na)

# update Row ID (RID) coloum
s_updated$SITE_ID <- 1:nrow(s_updated)


#archive the old site file and filled update template for this update 
#1)archieve site data before update
file.rename("_data/BCSIS_site.csv", paste("_data/_archieve/BCSIS_SITE", Sys.time(), ".csv", sep = ""))

#2)archieve filled out the template for this update
file.rename("_data/_updates/BCSIS_site_update_template.csv", 
            paste("_data/_archieve/BCSIS_site_update_template", 
                  Sys.time(), ".csv", sep = ""))



#save the updated site data for future processes 
#1)save updated site data
write.csv(s_updated, "_data/BCSIS_site.csv", row.names = FALSE) 
#2)#save updated site data into ~latest 
write.csv(s_updated, "_data/BCSIS_site_latest.csv", row.names = FALSE)



#set up empty template form for the future update
s_current_na <- s_current
s_current_na[,2:ncol(s_current_na)] <- NA
write.csv(s_current_na, "_data/_updates/BCSIS_site_update_template.csv", row.names = FALSE)


##  --- ADD NEW SITES TO HORIZON FILE --- #############
#######################################################
h_current <- read.csv("_data/EHF_horizons_latest.csv", stringsAsFactors = FALSE)
new_sites <- s_current[!(s_current$PID %in% unique(h_current$PID)),]

h_temp = h_current[FALSE,]

for (i in 1:length(new_sites$PID)){
  h_temp[i,] <- c(NA, new_sites$PID[i], "H1", 0, 100, 
                  new_sites$SaDate[i], NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
}

h_current_w_new_sites <- rbind(h_current, h_temp)
h_current_w_new_sites <- h_current_w_new_sites[order(h_current_w_new_sites$PID, 
                                                     h_current_w_new_sites$HID),] 

#archive the old horizons file and save the new horizons file
file.rename("_data/EHF_horizons.csv", paste("_data/EHF_horizons_", Sys.Date(), ".csv", sep = "")) #archive
write.csv(h_current_w_new_sites, "_data/EHF_horizons.csv", row.names = FALSE) # save

#archive the old update template file and save the new update template file
file.rename("_data/_updates/horizons_update_template.csv", 
            paste("_data//_updates/horizons_update_template_", 
                  Sys.Date(), ".csv", sep = ""))
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
