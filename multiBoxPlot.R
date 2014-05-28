rm(list=ls())

username<-'*********'  #add your own username
password<-'*********'  #add your own password

###### CONNECT TO OPAL
library(opal)

url<-'https://cptp.oicr.on.ca:8443'
o<-opal.login(username, password, url , opts=list(ssl.verifyhost=0,ssl.verifypeer=0,sslversion=3))

#message("**** datasources:")
opal.datasources(o)

###SET WORKING and data DIRECTORY
#workingDir<-'/home/smbatchou/Bureau/CPTP/R'    #**
#setwd(workingDir)

#variables <- opal.variables(o, datasource=datasource, table=table)
#SDC_SIB_NB, 

var.assign<-function(opal,datasource,table,variables){
  datafile<-paste0(datasource, ".", table)
  if(length(variables)==1){
    variable<-paste0(datafile,':',variables)
    opal.assign(opal,'D', variable,missings=T)
  }else{
    opal.assign(opal,'D', datafile,variables,missings=T)
  }
  var.value<-opal.execute(opal,'D')
  return (var.value)
}

multibox<-function(variable,...){
  args<-list(...)
  names<-setdiff(as.character(match.call(expand.dots=T)),as.character(match.call(expand.dots=F)))
  num<-length(names)
  par(mfrow=c(1,num))
  for (i in seq(num)){
    name<-ifelse(is.integer(type.convert(substr(names[i],4,4))),substr(names[i],1,4),substr(names[i],1,3))
    names[i]<-paste0(variable,'_',name)
    boxplot(args[[i]],main=names[i],main.cex=0.85)  
  }
  dist<-sapply(args,summary,simplify=T)
  dist<-as.data.frame(dist)
  names(dist)<-names
  dist
}




#get the sdc1 variable
vars1<-'SDC_SIB_NB'

TTP_sib<-var.assign(o,'TTP','TTP_SDC1',vars1)
OHS1_sib<-var.assign(o,'OHS','OHS1_SDC1',vars1)
OHS2_sib<-var.assign(o,'OHS','OHS2_SDC1',vars1)
CAG_sib<-var.assign(o,'CaG','CaG_SDC1',vars1)

#get the sdc2 variables
vars2<-c('SDC_INCOME_IND_NB','SDC_HOUSEHOLD_ADULTS_NB','SDC_HOUSEHOLD_CHILDREN_NB')

TTP_sdc2<-var.assign(o,'TTP','TTP_SDC2',vars2)
TTP_inc<-TTP_sdc2$SDC_INCOME_IND_NB
TTP_adult<-TTP_sdc2$SDC_HOUSEHOLD_ADULTS_NB
TTP_child<-TTP_sdc2$SDC_HOUSEHOLD_CHILDREN_NB

OHS1_sdc2<-var.assign(o,'OHS','OHS1_SDC2',vars2)
OHS1_inc<-OHS1_sdc2$SDC_INCOME_IND_NB
OHS1_adult<-OHS1_sdc2$SDC_HOUSEHOLD_ADULTS_NB
OHS1_child<-OHS1_sdc2$SDC_HOUSEHOLD_CHILDREN_NB

OHS2_sdc2<-var.assign(o,'OHS','OHS2_SDC2',vars2)
OHS2_inc<-OHS2_sdc2$SDC_INCOME_IND_NB
OHS2_adult<-OHS2_sdc2$SDC_HOUSEHOLD_ADULTS_NB
OHS2_child<-OHS2_sdc2$SDC_HOUSEHOLD_CHILDREN_NB

CAG_sdc2<-var.assign(o,'CaG','CaG_SDC2',vars2)
CAG_inc<-CAG_sdc2$SDC_INCOME_IND_NB
CAG_adult<-CAG_sdc2$SDC_HOUSEHOLD_ADULTS_NB
CAG_child<-CAG_sdc2$SDC_HOUSEHOLD_CHILDREN_NB


#box plot the variable
multibox('SDC_SIB_NB',OHS1_sib,CAG_sib,TTP_sib,OHS2_sib)
multibox('INCOME',TTP_inc,CAG_inc,OHS1_inc,OHS2_inc)
multibox('HOUSEHOLD_ADULTS',TTP_adult,CAG_adult,OHS1_adult,OHS2_adult)
multibox('HOUSEHOLD_CHIDREN',TTP_child,CAG_child,OHS1_child,OHS2_child)

#logout from opal
opal.logout(opals=o)

