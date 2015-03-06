##################################################################################################################
# This script is a more general settings
# it will contain  useful helper function
##################################################################################################################
message(' LOADING ALL UTILITY FUNCTIONS ...')
#########################################
#utility functions are defined here
#########################################

#function get vars from opal
var.assign<-function(opal,datasource,table,variables=NULL){
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

################################################
####      PATTERN FUNCTIONS
###############################################

####function get vars with a specific pattern
has_pattern<-function(var,pattern){
  T %in% stringr::str_detect(var,stringr::ignore.case(pattern))
}

vars_pattern<-function(table,pattern){
  table<-as.data.frame(table)
  vars<-NULL
  for (x in colnames(table)){
    if(has_pattern(table[,x],pattern)){
      vars<-c(vars,x)
    }
  }
  return(vars)
}

#get duplicate value with this specific pattern
#is_duplicate with pattern
is_duplicate<-function(value,pattern){
  if(length(value)>1){ stop ('Require only ONE value to check if this particular value is duplicated',call. = F)}
  split<-stringr::str_split(value,pattern)[[1]]
  if(length(split) == 2){
    split1<-stringr::str_trim(split[1],'both')
    split2<-stringr::str_trim(split[2],'both')
    if(split1==split2){
      TRUE
    }else{
      FALSE
    }
  }else{
    FALSE
  }
}

has_duplicate<-function(var,pattern){
  bool<-FALSE
  for (x in var){
    if (is_duplicate(x,pattern)){
      bool<-TRUE
      break
    }
  }
  return(bool)
}

has_dupl_in_table<-function(table,pattern){
  table<-as.data.frame(table)
  bool<-NULL
  for (x in colnames(table)){
    var<-table[,x]
    if(has_pattern(var,pattern)){
      if(has_duplicate(var,pattern)){
        bool<-c(bool,TRUE)
      }else{
        bool<-c(bool,FALSE)
      }
    }else{
      bool<-c(bool,FALSE)
    }
  }
  return(bool)
}

vars_dup_value<-function(table,pattern){
  table<-as.data.frame(table)
  var_match<-vars_pattern(table,pattern)
  vars<-NULL
  
  for (x in colnames(table)){
    var<-table[,x]
    if(has_pattern(var,pattern)){
      if(has_duplicate(var,pattern)){
        vars<-c(vars,x)
      }
    }
  }
  return(vars)
}

######################################
#check if all the variable is missing value
is_allNA<-function(var){
  all(is.na(var))
}

##########################################################
#         2-      NUMERIC FUNCTIONS 
######################################################
#very utils function to test decimal vs integer
## function to test if a value is a number. ex: '2' is number
#install.packages('schoolmath')
#ex: schoolmath::is.whole(x) vs schoolmath::is.decimal
is_Number<-function(value){
  if (!is.atomic(value)){
    stop('object must be and atomic vector',call. = F)
  }else if(length(value)>1){
    stop('Require only ONE value to check if this particular value is a number',call. = F)
  }else{
    suppressWarnings(!is.na(as.numeric(value)))
  }
}

is_all_Number<-function(var){
  #check that all valid-value (non missing) are number
  if(is_allNA(var)){
    FALSE
  }else { 
    var<-na.omit(var)
    if(T %in% suppressWarnings(is.na(as.numeric(var)))){
      FALSE
    }else{
      all(suppressWarnings(!is.na(as.numeric(var))))
    }
  }
}

is_Decimal<-function(value){
  if(!is_Number(value)){
    FALSE
  }else{
    value<-as.numeric(value)
    schoolmath::is.decimal(value)
  }
}

has_Decimal<-function(var){ 
  #check that all valid-value (non missing) are Decimal
  var<-na.omit(suppressWarnings(as.numeric(var)))
  if(is_allNA(var)){
    FALSE
  }else { 
    
    T %in% schoolmath::is.decimal(var)
  }
}

is_Integer<-function(value){
  if(!is_Number(value)){
    FALSE
  }else{
    value<-as.numeric(value)
    schoolmath::is.whole(value)
  }
}

is_all_Integer<-function(var){ 
  #check that all valid-value (non missing) are Integer
  if(is_allNA(var)){
    FALSE
  }else { 
    var<-na.omit(var)
    if(T %in% suppressWarnings(is.na(as.numeric(var)))){
      FALSE
    }else{
      all(schoolmath::is.whole(as.numeric(var)))
    } 
  }
}

has_Number<-function(var){ 
  #check if var has at least one value of type number
  T %in%  suppressWarnings(!is.na(as.numeric(var)))
}

#############################################
#     TEXT FUNCTIONS
#############################################
has_non_numeric<-function(var){
  if(is_allNA(var)){
    FALSE
  }else{
    var<-na.omit(var)
    T %in% suppressWarnings(is.na(as.numeric(var)))
  }
}

####################################
#####       TYPE PREDICTION
###################################
predict_num_or_text<-function(var){
  #THIS FUNCTION ATTEMPTS TO PREDICT THE TYPE OF THE VAR...
  #USEFUL TO DETECT ERROR IN DATA
  
  if(all(is.na(var))){
    'missing'
  }else{
    BOOL<-suppressWarnings(!is.na(as.numeric(na.omit(var))))
    df<-as.data.frame(prop.table(table(BOOL))*100)
    colnames(df)<-c('BOOL','FREQ')
    if(nrow(df) == 2){ #true & false
      if(df$FREQ[1] < 50){ #false freq
        'numeric'
      }else if(df$FREQ[1] == 50){
        'undetermined'
      }else{
        'text'
      }
    }else if(as.logical(df$BOOL)){ #TRUE?
      paste0('numeric')
    }else{
      'text'
    }
  }
}

#prediction with a full table
predict_ValueType<-function(table){
  #This function attempt to predict valueType for var(not clean) in table
  apply(table,2,predict_num_or_text)
}


#function to get valueType when data is clean
get_valuetype<-function(table){
  #This function give the valueType for very clean variables
  apply(table,2,function(var){
    if(predict_num_or_text(var) == 'numeric'){
      if(has_Decimal(var)){ 
        'decimal'
      }else {
        'integer'
      }
    }else{
      'text'
    } 
  })
}

