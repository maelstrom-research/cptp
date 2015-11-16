## @knitr connection

#url
url<-'xxxxxxxxxxxxxxxxxxxxxxxxxx'
username<-getOption('opal.username','xxxxxxxxx')  #change 
password<-getOption('opal.password','xxxxxxxx')  #change



## @knitr configuration
datasource <- getOption("opal.datasource","xxxxxxxxxxxx")
table <- getOption("opal.table","xxxxxxxxxxx") #"HOP
withStatistics <- getOption("opal.withStatistics", F)
withGraphs <- getOption("opal.withGraphs", FALSE)
withFullTable<-getOption("opal.withFullTable",T)
namespace <- NULL

## @knitr variablelist

##ADD your short (not the full table) list of variables to report here  
variables<-c()




## @knitr utils
asIconstatus <- function(info) {
   if(info == 'ok'){
      return('<span class="glyphicon glyphicon-ok-sign"></span>')
    }else if (info =='no'){
      return('<span class="glyphicon glyphicon-remove-sign"></span>')
    }else{
      return('<span class="glyphicon glyphicon-question-sign"></span>')
    }
}

  