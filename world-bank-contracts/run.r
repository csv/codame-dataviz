library(reshape2)
library(ggplot2)
library(scales)
library(plyr)

# library(ddr)
# ddr_init(player="/usr/bin/env mplayer'")

if (!('a' %in% ls())) {
  a <- read.csv('major-contract-awards.csv', stringsAsFactors = FALSE)
  contracts$As.of.Date <- strptime(contracts$As.of.Date, '%m/%d/%Y 12:00:00 AM')
  contracts$Contract.Signing.Date <- strptime(contracts$Contract.Signing.Date, '%m/%d/%Y 12:00:00 AM')

  contracts$Country <- contracts$Borrower.Country
  contracts$Year <- contracts$Fiscal.Year

  contracts$Total.Contract.Amount..USD. <- as.numeric(sub('^\\$', '', contracts$Total.Contract.Amount..USD.))
  contracts$Year.Week <- as.numeric(strftime(contracts$Contract.Signing.Date, format = '%W'))
  contracts$Year.Eighth <- floor(contracts$Year.Week * 8 / 53)
  contracts$Year.Eighth[contracts$Year.Eighth == 8] <- 7
  contracts$Year.Eighth <- factor(contracts$Year.Eighth, levels = 0:7)
}

if (!('gdp' %in% ls())) {
  gdp <- read.csv('gdp.csv')
  names(gdp) <- c('Country','Country.Code','Year','GDP')
}

if (!('population' %in% ls())) {
  population <- read.csv('population.csv')
  names(population) <- c('Country','Country.Code','Year','Population')
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

  # sort(table(contracts$Supplier), decreasing = T)[1:20]
  contracts$Supplier.Reduced <- contracts$Supplier
  contracts$Supplier.Reduced[grepl('UNITED NATIONS', contracts$Supplier.Reduced)] <- 'UNITED NATIONS'
  contracts$Supplier.Reduced[contracts$Supplier.Reduced == 'ERNST & YOUNG'] <- 'BIG 4'
  contracts$Supplier.Reduced[contracts$Supplier.Reduced == 'DELOITTE & TOUCHE'] <- 'BIG 4'
  contracts$Supplier.Reduced[contracts$Supplier.Reduced == 'KPMG'] <- 'BIG 4'
  contracts$Supplier.Reduced[contracts$Supplier.Reduced == 'PRICEWATERHOUSECOOPERS'] <- 'BIG 4'
  contracts$Supplier.Reduced[contracts$Supplier.Reduced == 'PRICE WATERHOUSE COOPERS'] <- 'BIG 4'

  # contracts$Supplier.Reduced[contracts$Supplier.Reduced] <-
  print(sort(table(contracts$Supplier.Reduced), decreasing = T)[1:10])
  print(sort(table(contracts$Supplier.Reduced[contracts$Supplier.Country == contracts$Borrower.Country]), decreasing = T)[1:10])
  print(sort(table(contracts$Supplier.Reduced[contracts$Supplier.Country != contracts$Borrower.Country]), decreasing = T)[1:10])
}

# Two measures, eight beats
phrase <- function(contracts, gdp, population, year, region = NULL, country = NULL) {

  
  region.records <- data.frame(
    Country = unique(contracts$Borrower.Country[contracts$Region == region]),
    Year = year)
  region.stats <- join(join(region.records, gdp), population)
  this.region.gdp <- sum(region.stats$GDP, na.rm = TRUE)
  this.region.population <- sum(region.stats$Population, na.rm = TRUE)

  region.drones <- list(
    # Scale each drone to an eight-beat-long note.
    drone1 = this.region.gdp,
    drone2 = this.region.population
  )

  if (is.null(country) & !is.null(region)) {
    # No country, just the region
    drones <- region.drones
    melody <- list()

  } else if (is.null(country) & is.null(region)) {
    # All the countries in the region
    drones <- region.drones
    melody <- list() # XXX change this evenutally

    this.contracts <- subset(contracts, Region == region & Year == year)

  } else {
    # One country in the region
    this.gdp <- subset(gdp, Country == country & Year == year)[1,'GDP']
    this.population <- subset(population, Country == country & Year == year)[1,'Population']

    this.contracts <- subset(contracts, Borrower.Country == country & Year == year)

    is.domestic <- this.contracts$Borrower.Country == this.contracts$Supplier.Country
    domestic.contracts <- table(this.contracts[is.domestic,'Year.Eighth'])
    foreign.contracts <- table(this.contracts[!is.domestic,'Year.Eighth'])

  # country.drones <- list(
  #   drone3 = this.gdp,
  #   drone4 = this.population
  # )
  # drones <- c(region.drones, country.drones)
    drones <- list(
      drone1 = this.gdp,
      drone2 = this.population
    )

    melody <- list(
      melody1 = domestic.contracts,
      melody2 = foreign.contracts
    )
  }

  c(drones, melody)
}

m1.1 <- phrase(contracts, gdp, population, 2003, 'AFRICA', '')
m1.2 <- phrase(contracts, gdp, population, 2003, 'AFRICA', 'Sierra Leone')
m1.3 <- phrase(contracts, gdp, population, 2003, 'AFRICA', '*')
m2.1 <- phrase(contracts, gdp, population, 2009, 'SOUTH ASIA', '')
m2.2 <- phrase(contracts, gdp, population, 2009, 'SOUTH ASIA', 'Bangladesh')
m2.3 <- phrase(contracts, gdp, population, 2009, 'SOUTH ASIA', '*')
