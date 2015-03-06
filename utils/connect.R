##################################################################################################################
# This script is a more general settings
# it will contain credentials to connect to opal and useful helper function
##################################################################################################################

#opal connection
opts <- list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3) #change often
url<-######url of the server
  
#connect to server
source(paste0('/home/smbatchou/teradisk/scripts/RscriptGeneral/utils/.opal-',server,'-connect.R'))

#test connection
message('Testing connection ....')
test<-!all(is.null(opal.datasources(o)))
if (test) message(paste0('Connection to OPAL is OK'))