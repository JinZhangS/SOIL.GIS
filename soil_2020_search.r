
##Feb 23, 2021, using My sql, R, my sql bench to build soil_2020 database 
##The RMariaDB package is used, and will try with the set another markdown to use RMySql


library(RMariaDB)
#The connection method below uses a password stored in a variable. 
#To use this set localuserpassowrd = "The password of jza18" Which is the search results user 

##soil_Db <- dbConnect(RMariaDB::MariaDB(), 
                       ##user='jza18',
                       ##password=localuserpassword,
                       ##dbname='soil_2020',
                      ## host='localhost')
##dbListTables(soil_Db)
##dbDisconnect(soil_Db)
##_________________________________________________________________________________##
##The connection below used the information stored in the 
##soil_2020.cnf (settings)file
##R needs a full path to find the setting file. 
soil_Db.settingsfile<-"/Volumes/WorkDISC/soil_2020.cnf"
soil_Db.db<-"soil_2020"
soil_Db<-dbConnect(RMariaDB::MariaDB(),
                   default.file=soil_Db.settingsfile,
                   group=soil_Db.db)

###list the table. This confirms we connected to the database. 
dbListTables(soil_Db)

###Disconnect to clean up the connection to the database. 
dbDisconnect(soil_Db)
