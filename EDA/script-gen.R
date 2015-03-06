
#######################################################################
#                                                                     #
# ***********   GENERATION OF MAGMA JAVASCRIPT SCRIPTS FOR OPAL *******
#                                                                     #  
#######################################################################

source('~/teradisk/scripts/RscriptGeneral/utils//util-script-generator.R',echo = F,print.eval = T)

#add default script
message('** Adding default script in typedf** ')
typedf<-add_default_script(typedf)
message('** OK **')

#add script for text value
message('** Adding trim and upperCase for TEXT value**')
script_text<-def_script_text(typedf)
typedf<-update_script(typedf,script_text,typedf$predValType=='text')
message('** Ok trim and upperCase for text**')

####### update script for duplication
if(T %in% hasduplicate){
  #first define duplication script
  message('** Defining duplication-removal script ** ')
  script_dup<-def_script_dup(typedf)
  message('** OK **')
  
  #then update the script in the df based on the condition: in this case update only vars with dupl value
  message('** Updating duplication-removal script in typedf IF DUPLICATION IS FOUND** ')
  typedf<-update_script(typedf,script_dup,typedf$hasduplicate)
  message('** OK dup-removal-script updated in typedf**')
  
}else{
  message ('**NO DUPLICATE VALUE IN VARS** ')
}

####### update script for non-num in Num data
if(T %in% (typedf$predValType =='numeric' & typedf$hasNONnumeric & !typedf$hasduplicate)){
  message('** Defining non-num-removal script ...**')
  script_non_num<-def_script_clean_non_num(typedf)
  message('** OK **')
  
  #then update the script in the df based on the condition: in this case update only num vars with non-num errors
  message('** Updating non-num-removal script in typedf IF NON-NUM IS FOUND IN NUMERIC VAR** ')
  typedf<-update_script(typedf,script_non_num,typedf$predValType =='numeric' & typedf$hasNONnumeric & !typedf$hasduplicate)
  message('** OK non-num-removal-script updated in typedf**')
}else{
  message ('**NO NON-NUM VALUE IN NUMERIC VARS** ')
}





###############################################
#     SAVE THE TABLE IN EXCEL FILES           #
###############################################
###write df to excel files
message('** SAVING EXCEL FILES... **')
xlsx::write.xlsx(typedf,file = paste0(datasource,'.xlsx'),sheetName = 'variables',col.names = T,row.names = F,showNA = F)
message( '** OK EXCEL FILE IS SAVED ... **')

#########################################
##      SAVE THE FINAL DF 
#########################################
message('** SAVING FINAL DATAFRAME: typedf ** ')
save(typedf,file=file.path(saved_rdata_dir,paste0('DF_final-',datasource,'.RData')))              #<-SAVE
message('** OK FINAL DF SAVED **')
