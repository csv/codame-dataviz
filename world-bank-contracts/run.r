library(reshape2)
library(ggplot2)
library(scales)
library(plyr)

library(ddr)

if (!('a' %in% ls())) {
  a <- read.csv('major-contract-awards.csv', stringsAsFactors = FALSE)
  a$As.of.Date <- strptime(a$As.of.Date, '%m/%d/%Y 12:00:00 AM')
  a$Contract.Signing.Date <- strptime(a$Contract.Signing.Date, '%m/%d/%Y 12:00:00 AM')

  a$Country <- a$Borrower.Country
  a$Year <- a$Fiscal.Year

  a$Total.Contract.Amount..USD. <- as.numeric(sub('^\\$', '', a$Total.Contract.Amount..USD.))
}

if (!('gdp' %in% ls())) {
  .gdp.wide <- read.csv('gdp.csv')
}

if (!('population' %in% ls())) {
  population <- read.csv('population.csv')
}

eda <- function() {
  # x <- join(na.omit(gdp), a, by = c('Year', 'Country'))

  # Each verse is a country
  # a.zambia <- subset(a, Country == 'Zambia')

  p1 <- ggplot(a.zambia) + aes(x = Contract.Signing.Date, y = Total.Contract.Amount..USD.) +
    aes(color = Supplier.Country == 'Zambia') +
    facet_wrap(~Procurement.Method) +
    scale_y_log10('Contract amount (USD)', labels = dollar) +
    geom_point()

  p2 <- ggplot(a) + aes(x = Procurement.Category) + facet_wrap(~ Country) + geom_bar()

  # ddply(a, 'Country', function(df) {
  #   c(
  #     Domestic.Supplier = mean(df$Supplier.Country == df$Country),
  #     Consultant.Sernices = mean(df$Procurement.Category == 'Consultant Services')
  #   )
  # }

  p3 <- ggplot(x) + aes(x = GDP, y = Total.Contract.Amount..USD.) +
    aes(color = Procurement.Category) +
    scale_x_log10('GDP (USD)', labels = dollar) +
    scale_y_log10('Contract amount (USD)', labels = dollar) +
    facet_wrap(~ Procurement.Category) +
    geom_point(alpha = 0.3)

  # sort(table(a$Supplier), decreasing = T)[1:20]
  a$Supplier.Reduced <- a$Supplier
  a$Supplier.Reduced[grepl('UNITED NATIONS', a$Supplier.Reduced)] <- 'UNITED NATIONS'
  a$Supplier.Reduced[a$Supplier.Reduced == 'ERNST & YOUNG'] <- 'BIG 4'
  a$Supplier.Reduced[a$Supplier.Reduced == 'DELOITTE & TOUCHE'] <- 'BIG 4'
  a$Supplier.Reduced[a$Supplier.Reduced == 'KPMG'] <- 'BIG 4'
  a$Supplier.Reduced[a$Supplier.Reduced == 'PRICEWATERHOUSECOOPERS'] <- 'BIG 4'
  a$Supplier.Reduced[a$Supplier.Reduced == 'PRICE WATERHOUSE COOPERS'] <- 'BIG 4'

  # a$Supplier.Reduced[a$Supplier.Reduced] <-
  print(sort(table(a$Supplier.Reduced), decreasing = T)[1:10])
  print(sort(table(a$Supplier.Reduced[a$Supplier.Country == a$Borrower.Country]), decreasing = T)[1:10])
  print(sort(table(a$Supplier.Reduced[a$Supplier.Country != a$Borrower.Country]), decreasing = T)[1:10])
}

# Two measures, eight beats
phrase <- function(contracts, gdp, population, year, region, country) {
# this.contracts <- subset(contracts, Borrower.Country == country & Year == year)
  this.gdp <- subset(gdp, Country.Name == country & Year == year)
  this.population <- subset(population, Country.Name == country & Year == year) 

  list(
    # Scale drones to a note, and play them for both measures.
    drone1 = this.gdp[1,'Value'],
    drone2 = this.population[1,'Value']
  )
}

m <- phrase(contracts, gdp, population, 2003, 'ASIA', 'Bangladesh')
