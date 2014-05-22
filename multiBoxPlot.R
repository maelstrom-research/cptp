#rm(list=ls())
#adminpass<-'c9!43V3r'
username<-'*********'  #add your own username
password<-'*********'  #add your own password

###### CONNECT TO OPAL
library(opal)

url<-'https://cptp.oicr.on.ca:8443'
o<-opal.login(username, password, url , opts=list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3))

#message("**** datasources:")
#opal.datasources(o)

###SET WORKING and data DIRECTORY
#workingDir<-'/home/smbatchou/Bureau/CPTP/R'    #**
#setwd(workingDir)

#variables <- opal.variables(o, datasource=datasource, table=table)
#SDC_SIB_NB, 

var.assign<-function(opal,datasource,table,variable){
  datafile<-paste0(datasource, ".", table)
  opal.assign(opal,'D', datafile,missings=T)
  var.value<-opal.execute(opal,paste0('D$',variable))
  return (var.value)
}

multibox<-function(name,...){
  args<-list(...)
  names<-setdiff(as.character(match.call(expand.dots=T)),as.character(match.call(expand.dots=F)))
  num<-length(names)
  par(mfrow=c(1,num))
  for (i in seq(num)){
    boxplot(args[[i]],main=paste0(name,'_',names[i]))
  }
}

#get the variable
TTP<-var.assign(o,'TTP','TTP_SDC1','SDC_SIB_NB')
OHS<-var.assign(o,'OHS','OHS1_SDC1','SDC_SIB_NB'
CAG<-var.assign(o,'CaG','CaG_SDC1','SDC_SIB_NB')

#box plot the variable
multibox('SDC_SIB_NB',OHS,CAG,TTP)

#logout from opal
opal.logout(opals=o)
