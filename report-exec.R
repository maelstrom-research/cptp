#!/usr/bin/Rscript

library(opal)

input <- commandArgs(TRUE)[1]
output <- commandArgs(TRUE)[2]

options(opal.url="https://cpt.maelstrom-research.org:444",
        opal.username="smbatchou",
        opal.password="******", #add before running the script
        opal.datasource="Atlantic_PATH",
        opal.table="Atlantic_PILOT_FINAL_copy",
        opal.withStatistics=TRUE,
        opal.withGraphs=FALSE,
        opal.withFullTable=FALSE,
        opal.style='spacelab')

#options(opal.url="https://cpt.maelstrom-research.org:444",
 #       opal.username="xxx",
#        opal.password="xxx",
#        opal.datasource="OHS",
#        opal.table="CPTP_pilot_OHS",
 #       opal.withStatistics=TRUE,
 #       opal.withGraphs=FALSE)

opal.report(input, output, boot_style=getOption('opal.style'),progress=FALSE)
