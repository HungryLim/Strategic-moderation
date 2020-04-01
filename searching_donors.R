#set working directory
setwd("")


#this is the list of corporate PAC names that I want to find out
name<-read.csv("corp_names.csv",header=TRUE)
names<-name$most.recent.contributor.name
names<-unique(names)

#this is the large file that I want to read
transactFile <- 'dime_contributors_1979_2014.csv'

readLines(transactFile, n=1)
higgs_colnames <- c("bonica.cid","contributor.type","num.records","num.distinct","most.recent.contributor.name","most.recent.contributor.address","most.recent.contributor.city","most.recent.contributor.zipcode","most.recent.contributor.state","most.recent.contributor.occupation","most.recent.contributor.employer","most.recent.transaction.id","contributor.gender","is_corp","contributor.cfscore","is.projected","first_cycle_active","last_cycle_active","amount_1980","amount_1982","amount_1984","amount_1986","amount_1988","amount_1990","amount_1992","amount_1994","amount_1996","amount_1998","amount_2000","amount_2002","amount_2004","amount_2006","amount_2008","amount_2010","amount_2012","amount_2014")
###
index <- 0
chunkSize <- 100000 #read 100000 rows in each iteration
con <- file(description=transactFile,open="r")   
dataChunk <- read.table(con, nrows=chunkSize, header=T, fill=TRUE, sep=",", col.names=higgs_colnames)
datalist = list()
#r.cfscore  <- NA

repeat {
  index <- index + 1
  print(paste('Processing rows:', index * chunkSize))
  datalist[[index]]<- dataChunk[dataChunk$most.recent.contributor.name %in% names, ]
  
  if (nrow(dataChunk) != chunkSize){
    print('Processed all files!')
    break}
  
  dataChunk <- read.table(con, nrows=chunkSize, skip=0, header=FALSE, fill = TRUE, sep=",", col.names=higgs_colnames)
  
  if (index > 165) break #307
  
}
close(con)

nrow(datalist)
big_data = do.call(rbind, datalist)
nrow(big_data)
write.csv(big_data, file = "large_data.csv")

#sum(is.na(r.cfscore))
