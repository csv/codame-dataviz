if (!('a' %in% ls())) {
  a <- read.csv('major-contract-awards.csv', stringsAsFactors = FALSE)
  a$As.of.Date <- strptime(a$As.of.Date, '%m/%d/%Y 12:00:00 AM')
  a$Contract.Signing.Date <- strptime(a$Contract.Signing.Date, '%m/%d/%Y 12:00:00 AM')
}

if (!('gdp' %in% ls())) {
  gdp <- read.csv('gdp.tsv', sep = '\t')
}
