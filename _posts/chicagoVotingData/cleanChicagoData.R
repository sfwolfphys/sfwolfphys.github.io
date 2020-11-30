#########################################################
##
## cleanChicagoData.R
##
## Cleans the 2020 Chicago voting data.
#########################################################

library(tidyverse)
library(readxl)

# read the whole thing into a single file
wholeworksheet  <- read_excel('chicagoResults.xlsx')

# find the blank rows
blankrows  <- data_frame(
    blanks = which(is.na(wholeworksheet[1]))
) %>% 
    mutate(
        dif = blanks - lag(blanks)
        , rownum = row_number()
        
        # maybe someone can suggest a better way to handle using dplyr::lag() 
        , startrow = ifelse(rownum == 1, 1, NA)
        , startrow = coalesce(ifelse(dif == 1, lag(startrow, default =1), lag(blanks + 1)), 1)
    )

# get the end rows of each table
endrows  <- blankrows %>% 
    group_by(startrow) %>% 
    summarize(
        endrow = min(blanks)
    )

# combine start and end rows into a single table
tableindex <- blankrows %>% 
    left_join(endrows, by = 'startrow') %>% 
    distinct(startrow, endrow)

# the last blank row is probably just before the last table in the sheet
if(nrow(wholeworksheet) > max(blankrows$blanks)) {
    
    lasttable  <- data_frame(startrow = max(blankrows$blanks) + 1, 
                             endrow = nrow(wholeworksheet))
    tableindex  <- tableindex %>% 
        bind_rows(lasttable)
}

# split your tables up into a list of tables 
alistoftables  <- map(1:nrow(tableindex), 
                      ~ wholeworksheet[tableindex$startrow[.x]:tableindex$endrow[.x] , ]  )

wardVoteTalliesRaw = alistoftables[- c(1:4)]
thisWard = wardVoteTalliesRaw[[1]]
thisWard[2, ]
thisWard[1,1]

cleanWardTibble = function(thisWard){
    ward = thisWard[1,1]
    rawCountData = thisWard[3:(nrow(thisWard)-2), ]
    cleanWard = data.frame(ward,rawCountData)
    names(cleanWard) = c('ward','precinct','totVotes','BidenVotes','BidenPct',
                         'TrumpVotes','TrumpPct','HawkinsVotes','HawkinsPct',
                         'LaRivaVotes','LaRivaPct','CarrollVotes','CarrollPct',
                         'JorgensenVotes','JorgensenPct')
    countCols = c(3,4,6,8,10,12,14)
    cleanWard[ ,countCols] = sapply(cleanWard[ ,countCols],FUN=as.numeric)
    return(cleanWard)
}

wardVoteTallies = lapply(wardVoteTalliesRaw,cleanWardTibble)
voteTally = NULL
for(i in 1:length(wardVoteTallies)){
    voteTally = rbind(voteTally,wardVoteTallies[[i]])
}

save(voteTally,file='chicagoVoteTally.RData')