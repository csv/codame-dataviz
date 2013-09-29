setwd('~/Dropbox/code/codame-dataviz/music')
library(lubridate)
library(plyr)
library(ggplot2)
d <- read.csv('data/crashses.csv', stringsAsFactors=F)

# add year month counts
d$year_month <- paste(strftime(mdy_hm(d$datetime), "%Y-%m"), "-01", sep="")
counts <- ddply(d, 'year_month', function(x) {data.frame(month_count=nrow(x))})
shell <- data.frame(
  day = seq(from=as.Date('2005-01-01'), to=as.Date('2009-12-31'), by='day')
  )
shell$year_month <- paste(strftime(shell$day, '%Y-%m'), "-01", sep="")
month_counts <- join(counts, shell, by='year_month', type='right')
write.csv(month_counts, 'data/month_counts.csv', row.names=F)
 
plot(x=as.Date(counts$year_month), y=counts$month_count, type="l")
d <- join(counts, d, by="year_month", type="right")

# munge lighting conditions
d$lightingco[d$lightingco=='Dark - no street lights'] <- 'Dark'
d$lightingco[d$lightingco=='Dark - street lights'] <- 'Dark'
d$lightingco[d$lightingco=='Dark - street lights not functioning'] <- 'Dark'
d$lightingco[d$lightingco=='Dusk - dawn'] <- 'Dusk/Dawn'
d$lightingco[d$lightingco==''] <- NA

# munge at-fault
d$p1[d$p1=='PARKED_AUTO'] <- 'AUTO'
d$p2[d$p2=='PARKED_AUTO'] <- 'AUTO'

# munge road surface
d$roadsurfac[d$roadsurfac=='Slippery (muddyy, oily, etc.)'] <- 'Wet'
d$roadsurfac[d$roadsurfac==''] <- NA

d$hit_n_run <- d$hr
d$hit_n_run <- ifelse(d$hit_n_run=='YES', 1, 0)
d$hr <- NULL
d$dist_from_intersection <- d$disfm
d$disfm <- NULL


