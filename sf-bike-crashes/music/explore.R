setwd('~/Dropbox/code/codame-dataviz/sf-bike-crashes')
library(lubridate)
library(plyr)
library(ggplot2)

d <- read.csv('data/crashses.csv', stringsAsFactors=F)

# add year month counts
d$year_month <- paste(strftime(mdy_hm(d$datetime), "%Y-%m"), "-01", sep="")
d$datetime <- parse_date_time(gsub("p.m.", "PM", gsub("a.m.", "AM", d$datetime)), "%m/%d/%Y %H:%M %p")
counts <- ddply(d, 'year_month', function(x) {data.frame(month_count=nrow(x))})
shell <- data.frame(
  day = seq(from=as.Date('2005-01-01'), to=as.Date('2009-12-31'), by='day')
  )
shell$year_month <- paste(strftime(shell$day, '%Y-%m'), "-01", sep="")
month_counts <- join(counts, shell, by='year_month', type='right')
write.csv(month_counts, 'data/month_counts.csv', row.names=F)
 
plot(x=as.Date(counts$day), y=counts$month_count, type="l")
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
d$p1[d$p1=='SOLO_ACCIDENT'] <- 'BICYCLIST'
d$p1[d$p1=='NO_FAULT'] <- 'OTHER'
d$p1[d$p1=='PEDESTRIAN'] <- 'OTHER'

# at fault per month barplot
bike.col = '#FC8D6250'
car.col = '#8da0cb50'
other.col= '#ffff9950'
par(bg='black')
svg(filename='barplot.svg', width=9, height=5)
barplot(table(d$p1, d$year_month), border=NA, col=c(bike.col, car.col, other.col))
dev.off()

# bake this to file for sonification!
tab <- table(d$p1, d$year_month)
mat <- as.matrix(t(tab))
df <- data.frame(year_month=row.names(mat), auto=mat[,1], bike=mat[,2], other=mat[,3])
at_fault <- join(df, shell, by='year_month')
write.csv(at_fault, 'data/at_fault.csv', row.names=F)

# munge road surface
d$roadsurfac[d$roadsurfac=='Slippery (muddyy, oily, etc.)'] <- 'Wet'
d$roadsurfac[d$roadsurfac==''] <- NA

d$hit_n_run <- d$hr
d$hit_n_run <- ifelse(d$hit_n_run=='YES', 1, 0)
d$hr <- NULL
d$dist_from_intersection <- d$disfm
d$disfm <- NULL

tab <- table(d$p1, d$year_month)
barplot(tab)

d <- d[order(d$year_month, d$day),]

d$week <- week(d$datetime)
d$year_week <- paste(d$year, sprintf("%02d", d$week), sep="-")

ddply(d, aes(x=year_week, y=facet(p1))) + geom_bar()
barplot(table(d$p1, d$year_week ))

head(d)
