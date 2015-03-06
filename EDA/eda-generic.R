#######################################
#
#  ATLANTIC EXPLORATORY ANALYSIS
######################################

#########################
# ANALYTICS EXPLORATION
#########################
source('~/teradisk/scripts/RscriptGeneral/utils//util-eda.R',echo = F,print.eval = T)

##########
# EDA
##########
library('dplyr')

message('** define pattern **')
pattern1<-'\\s*/\\s*'
pattern2<-'\\s*\\|\\s*'
pattern3<-"^Enter\\b"
save(pattern1,pattern2,pattern3,file=file.path(saved_rdata_dir,'PATTERN.RData'))
message('** OK SAVE **')

##variables elligible for first check according to pattern
#var_pat<-vars_pattern(RAW,pattern2)
#vars_dup<-vars_dup_value(RAW,pattern2)
#var_pat_Enter<-vars_pattern(RAW,pattern3)
#save(var_pat,vars_dup,var_pat_Enter,file = 'VARS.RData') #<-SAVE

##############################
# COMPUTE CHECKS
#############################
#check is all NA
message('** checking if var is all NA... **')
isallNA<-apply(RAW,2,is_allNA)
save(isallNA,file = file.path(saved_rdata_dir,paste0('ISALLNA-',datasource,'.RData')))  #<-SAVE
message('** OK SAVE **')

#check Is numeric 
message('** checking if var is Numeric... **')
isnumber<-apply(RAW,2,is_all_Number)
save(isnumber,file = file.path(saved_rdata_dir,paste0('ISNUMBER-',datasource,'.RData')))  #<-SAVE
message('** OK SAVE **')

#check has number
message('** checking if var has number... **')
hasnumber<-apply(RAW,2,has_Number)
save(hasnumber,file = file.path(saved_rdata_dir,paste0('HASNUMBER-',datasource,'.RData'))) #<-SAVE
message('** OK SAVE **')

#check has non_numeric
message(' **checking if var has non numeric... **')
hasNONnumeric<-apply(RAW,2,has_non_numeric)
save(hasNONnumeric,file = file.path(saved_rdata_dir,paste0('HAsNONnUMERIC-',datasource,'.RData'))) #<-SAVE
message('** OK SAVE **')

#predict valueType
message('** Predicting ValueType for var(not clean).... **')
predValType<-predict_ValueType(RAW)
save(predValType,file = file.path(saved_rdata_dir,paste0('PREDTYPE-',datasource,'.RData')))  #<-SAVE
message('** OK SAVE **')

#assign valueType
message('** assigning valueType for clean var .... **')
valueType<-get_valuetype(RAW)
save(valueType,file = file.path(saved_rdata_dir,paste0('TYPE-',datasource,'.RData')))  #<-SAVE
message('** OK SAVE **')

#check duplicate
message('** checking duplicate in var... **')
hasduplicate<-has_dupl_in_table(RAW,pattern2)
save(hasduplicate,file = file.path(saved_rdata_dir,paste0('HASDUP-',datasource,'.RData')))  #<-SAVE
message('** OK SAVE **')

#check ENTER pattern
message('** checking <ENTER..> Pattern in var... **')
has_ENTERpattern<-apply(RAW,2,has_pattern,pattern3)
save(has_ENTERpattern,file = file.path(saved_rdata_dir,paste0('HASENTER-',datasource,'.RData')))  #<-SAVE
message('** OK SAVE **')

##################################
#   STATS OF  DIFFERENT CHECKS
##################################
message('** Computing stats for all checks... **')
#stats of isnumber
stat_is_number<-table(isnumber)
#stats of hasnumber
stat_has_number<-table(hasnumber)
#stats of has NON numeric
stat_hasNONnumeric<-table(hasNONnumeric)
#stats of valueType
stat_valueType<-table(valueType)
#stats of duplicate
stat_hasduplicate<-table(hasduplicate)
#stat of ENTER..pattern
stat_ENTERpattern<-table(has_ENTERpattern)
#stat is all na
stat_isallNA<-table(isallNA)

save(stat_is_number,stat_valueType,stat_has_number,
     stat_hasduplicate,stat_ENTERpattern,stat_isallNA,
     file = file.path(saved_rdata_dir,paste0('STATS-',datasource,'.RData')))            ##<-SAVE
message('** OK STATS -- SAVE **')

##Create dataframe with attributes and properties
message('** Defining dataframe with checks... **')
typedf<-data.frame(name = names(isnumber),isallNA,predValType,valueType,isnumber,hasnumber,
                   hasNONnumeric,hasduplicate,has_ENTERpattern,row.names = NULL)

save(typedf,file = file.path(saved_rdata_dir,paste0('DF_default-',datasource,'.RData')))              #<-SAVE
message('** OK SAVE **')

