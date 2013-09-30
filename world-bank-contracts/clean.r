library(reshape2)
library(ggplot2)
library(scales)
library(plyr)

if (!('a' %in% ls())) {
  a <- read.csv('major-contract-awards.csv', stringsAsFactors = FALSE)
  a$As.of.Date <- strptime(a$As.of.Date, '%m/%d/%Y 12:00:00 AM')
  a$Contract.Signing.Date <- strptime(a$Contract.Signing.Date, '%m/%d/%Y 12:00:00 AM')

  a$Country <- a$Borrower.Country
  a$Year <- a$Fiscal.Year

  a$Total.Contract.Amount..USD. <- as.numeric(sub('^\\$', '', a$Total.Contract.Amount..USD.))
}

if (!('gdp' %in% ls())) {
  .gdp.wide <- read.csv('gdp.tsv', sep = '\t')
  .columns <- c('Country', 'Subject.Descriptor', 'Units', 'Scale', 'Country.Series.specific.Notes', 'Estimates.Start.After')
  gdp <- melt(.gdp.wide, .columns, variable.name = 'Year', value.name = 'GDP')
  gdp$Scale <- NULL # billions
  gdp$Subject.Descriptor <- NULL # GDP
  gdp$Estimates.Start.After <- NULL
  gdp$Country.Series.specific.Notes <- NULL
  gdp$Units <- NULL # USD
  gdp$GDP <- as.numeric(gdp$GDP) * 1e9
  gdp$Year <- as.numeric(sub('^X', '', as.character(gdp$Year)))
}

# x <- join(na.omit(gdp), a, by = c('Year', 'Country'))

a.zambia <- subset(a, Country == 'Zambia')

p <- ggplot(a.zambia) + aes(x = Contract.Signing.Date, y = Total.Contract.Amount..USD.) +
  aes(color = Supplier.Country == 'Zambia') +
  facet_wrap(~Procurement.Method) +
  scale_y_log10('Contract amount (USD)', labels = dollar) +
  geom_point()
