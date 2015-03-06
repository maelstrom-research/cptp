###########################################################################################
# This script is a more general settings
# it will contain  useful function to generate magma javascript script for use in opal
###########################################################################################
message('**LOADING SCRIPT-GENERATOR FUNCTIONS** ')

######################################################
#magma-js script generator functions are defined here
#####################################################
#rm(list=ls());gc()
#regex<-/\s*\|\s*/

##function to add default script: $('name')
add_default_script<-function(df){
  #add the default script in the table (df)
  df$script<-paste0("$('",df$name,"');")
  return (df)
}

#function to update a script based on condition ex: script to remove duplicate
update_script<-function(table,script_to_add,condition){ 
  ##add a script based on the condition and return a dataframe with script added where it applies
  ##the script to update need to be define first ex: see def_script_dup for duplication case
  table$script[which(condition)]<-script_to_add[which(condition)]
  return (table)
}

def_script_dup<-function(df){
  ##return a script object that will be used to remove duplication
  var_names<-df$name
  script<-paste0("var val = $('",var_names,"').type('text').upperCase().trim().value();
  var sep = regex_dup;
  if(sep.test(val)){
    var dupl  = val.split(sep);
    dupl.length === 2 && dupl[0].trim() === dupl[1].trim()? dupl[0].trim() : val;  
  }else{
    val;
  }")
  return(script)
}

def_script_text<-function(df){
  script<-paste0("$('",df$name,"').trim().upperCase();")
  return(script)
}

def_script_clean_non_num<-function(df){
  ##return a script object that will be used to remove non_num
  var_names<-df$name
  script<-paste0("var val = $('",var_names,"').type('text').upperCase().trim().value();
    !is_numeric(val.value()) ? null : val;
  
    function is_numeric(data){
      return parseFloat(data) == data;  
    }"
  )
}


