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

  # Remove contracts without regions
  contracts <- subset(contracts, Region != 'Not assigned' & Region != 'OTHER')
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
phrase <- function(contracts, gdp, population, year = NULL, region = NULL, country = NULL, play.melody = TRUE) {
  if (!is.null(year)) {
    contracts <- subset(contracts, Year == year)
    gdp <- subset(gdp, Year == year)
    population <- subset(population, Year == year)
  }


  if (!is.null(country) & is.null(region)){
    region <- subset(contracts, Borrower.Country == country)[1,'Region']
  } else if (is.null(country) & !is.null(region)){
    country <- sample(subset(contracts, Region == region)$Borrower.Country, 1)
  }

  if (is.null(country) & is.null(region)) {
    # All the countries that year
    this.gdp <- sum(gdp$GDP)
    this.population <- sum(population$Population)
    drones <- list(
      drone1 = this.gdp,
      drone2 = this.population
    )

    melody <- dlply(contracts, 'Region', function(df) {
      table(df$Year.Eighth)
    })


  } else {
    # One country in the region
    this.gdp <- subset(gdp, Country == country)[1,'GDP']
    this.population <- subset(population, Country == country)[1,'Population']

    this.contracts <- subset(contracts, Borrower.Country == country)

    is.domestic <- this.contracts$Borrower.Country == this.contracts$Supplier.Country
    domestic.contracts <- table(this.contracts[is.domestic,'Year.Eighth'])
    foreign.contracts <- table(this.contracts[!is.domestic,'Year.Eighth'])

    drones <- list(
      drone1 = this.gdp,
      drone2 = this.population
    )

    melody <- list(
      melody1 = domestic.contracts,
      melody2 = foreign.contracts
    )
  }

  # Scale each drone to an eight-beat-long note.
  if (play.melody) {
    c(drones, melody)
  } else {
    drones
  }
}

# Song: 16 Stanzas
song <- list(
  # Stanza: 8 Phrases
  intro = list(
    # Phrase: 2 measures (8 beats)
    intro      = phrase(contracts, gdp, population, play.melody = FALSE),
    africa     = phrase(contracts, gdp, population, region = 'AFRICA', play.melody = FALSE),
    south.asia = phrase(contracts, gdp, population, region = 'SOUTH ASIA', play.melody = FALSE),
    out        = phrase(contracts, gdp, population, play.melody = TRUE)
  ),
  y2003 = list(
    intro      = phrase(contracts, gdp, population, 2003, play.melody = FALSE),
    africa     = phrase(contracts, gdp, population, 2003, region = 'AFRICA', country = 'Sierra Leone', play.melody = TRUE),
    south.asia = phrase(contracts, gdp, population, 2003, region = 'SOUTH ASIA', country = 'Bangladesh'),
    out        = phrase(contracts, gdp, population, 2003, play.melody = TRUE)
  ),
  y2004 = list(
    intro      = phrase(contracts, gdp, population, 2004, play.melody = FALSE),
    africa     = phrase(contracts, gdp, population, 2004, region = 'AFRICA', play.melody = TRUE),
    south.asia = phrase(contracts, gdp, population, 2004, region = 'SOUTH ASIA', play.melody = TRUE),
    out        = phrase(contracts, gdp, population, 2004, play.melody = TRUE)
  ),
  out = list(
    intro      = phrase(contracts, gdp, population, play.melody = TRUE),
    africa     = phrase(contracts, gdp, population, region = 'AFRICA', play.melody = TRUE),
    south.asia = phrase(contracts, gdp, population, region = 'SOUTH ASIA', play.melody = TRUE),
    out        = phrase(contracts, gdp, population, play.melody = TRUE)
  )
)
