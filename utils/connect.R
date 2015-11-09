##################################################################################################################
# This script is a more general settings
# it will contain credentials to connect to opal and useful helper function
##################################################################################################################

#opal connection
#opts <- list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3) #change often
#url<-######url of the server

#connect to server
source(paste0('~/login/.',server,'-login.R'))

#test connection
message('Testing connection ....')

dstest <- try(opal.datasources(o),silent = T)
test<- !inherits(dstest, what = "try-error") & !inherits(o, what = "try-error")

if (test) {
  cat(paste0('Connection to server: ',o$name,' is OK'))
}else {
  message(paste0('Connection to server: ',o$name,' failed.\nPlease try again!'))
}

#clean intemediate object(s) in work space
rm(dstest,test)

