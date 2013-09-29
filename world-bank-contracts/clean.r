library(reshape2)
library(plyr)

if (!('a' %in% ls())) {
  a <- read.csv('major-contract-awards.csv', stringsAsFactors = FALSE)
  a$As.of.Date <- strptime(a$As.of.Date, '%m/%d/%Y 12:00:00 AM')
  a$Contract.Signing.Date <- strptime(a$Contract.Signing.Date, '%m/%d/%Y 12:00:00 AM')

  a$Country <- a$Borrower.Country
  a$Year <- a$Fiscal.Year
}

if (!('gdp' %in% ls())) {
  .gdp.wide <- read.csv('gdp.tsv', sep = '\t')
  .columns <- c('Country', 'Subject.Descriptor', 'Units', 'Scale', 'Country.Series.specific.Notes', 'Estimates.Start.After')
  gdp <- melt(gdp.wide, .columns, variable.name = 'Year', value.name = 'GDP')
  gdp$Scale <- NULL # billions
  gdp$Subject.Descriptor <- NULL # GDP
  gdp$Estimates.Start.After <- NULL
  gdp$Country.Series.specific.Notes <- NULL
  gdp$Units <- NULL # USD
  gdp$GDP <- as.numeric(gdp$GDP) * 1e9
  gdp$Year <- as.numeric(sub('^X', '', as.character(gdp$Year)))
}
a.agg <- ddply(a, c('Year', 'Country'), function(df) {
  c(Count = nrow(df))
})

x <- join(na.omit(gdp), a.agg, by = c('Year', 'Country'))
