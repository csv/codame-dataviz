library(plyr)
library(aplpack)
library(reshape2)
library(rjson)
library(sqldf)
library(plyr)
setwd('~/Dropbox/code/codame-dataviz/fms-symphony/video')

table2.raw <- read.csv('../data/table2-std.csv')

# Fix types
table2.raw$date <- as.Date(table2.raw$date)
table2.raw$type <- factor(table2.raw$type)
table2.raw$item <- factor(table2.raw$item)
table2.raw$today <- as.numeric(table2.raw$today)

source('data.r')
fed.rate <- read.csv('../data/fed_rate.csv', stringsAsFactors = F)
fed.rate$date <- strptime(fed.rate$date, format = '%m/%d/%y')

# Write some data for the website, skipping the top 40 for rolling
links <- sqldf('select date, url from [table2.raw] group by date')[-(1:40),]
links$dayOfWeek <- strftime(links$date, format = '%A')
links$date <- strftime(links$date, format = '%A, %B %d, %Y')
links$url <- sub('dir=w', 'dir=a', links$url)
json.data <- toJSON(links)
json.file <- file("data_files.js")
writeLines(paste('var dataFiles =', json.data), json.file)
close(json.file)
print('Wrote data_files.js')

# Remove totals, and select a few columns
table2 <- table2.raw[!table2.raw$is_total,c('date', 'type', 'item', 'today')]

# Select only the items that are present on all days.
n.days <- length(unique(table2$date))
table2.pca <- ddply(table2, c('type', 'item'), function(df) {
    if (nrow(df) == n.days) {
        df
    }
})

# Run PCA
items <- dcast(table2.pca, date ~ type + item, value.var = 'today')[-1]
pca <- princomp(items, cor = T)
pca.stuff <- function() {
    summary(pca)
    plot(pca$sdev ~ I(1:length(pca$sdev)))
}
factored <- t(scale(items, center = pca$center, scale = pca$scale) %*% pca$loadings)

# Make faces
f.all <- faces(t(factored)[,1:15], plot = F, print.info = F)

# Plot a Chernoff face for a day at an x, y
face <- function(day.or.days, x, y, ...) {
    # day.or.days is a row index

    f <- f.all
    f$xy <- f$faces <- NULL

    f$xy <- matrix(f.all$xy[,day.or.days])
    dimnames(f$xy) <- dimnames(f.all$xy)
    f$faces <-f.all$faces[day.or.days]

    plot.faces(f, face.type = 1, x.pos = x, y.pos = y, ...)
}

# Other plot stuff
table2.tmp <- ddply(table2.pca, 'date', function(df) { c(error = sd(df$today)) })
table2.toplot <- join(join(table2.tmp, fms.day[c('date', 'balance')]), fed.rate)

# Remove NAs
table2.toplot[c(358, 833, 1022, 1393, 1398),] <- table2.toplot[c(358, 833, 1022, 1393, 1398) - 1,]

# Skip the top 40 for rolling.
table2.toplot <- table2.toplot[-(1:40),]

# read in brian's data and join to thomas'
fms.brian <- read.csv('../data/fms_brian.csv', stringsAsFactors=FALSE)
fms.brian$rate <- NULL
fms.brian$date <- strptime(fms.brian$date, "%m/%d/%y")
table2.toplot <- join(fms.brian, table2.toplot, by='date', type='right')


# Video frame
bal.of.week <- c(
  Sunday = '#1a1be3',
  Monday = '#7db737',
  Tuesday = '#af4a4d',
  Wednesday = '#4ea297',
  Thursday = '#7e00ff',
  Friday = '#ff32fe',
  Saturday = '#5627a6'
)
rate.of.week <- c(
  Sunday = '#1be31a',
  Monday = '#b7377d',
  Tuesday = '#4a4daf',
  Wednesday = '#a2974e',
  Thursday = '#00ff7e',
  Friday = '#32feff',
  Saturday = '#27a656'
)
debt.of.week <- c(
  Sunday = '#E41A1C',
  Monday = '#377EB8',
  Tuesday = '#4DAF4A',
  Wednesday = '#984EA3',
  Thursday = '#FF7F00',
  Friday = '#FFFF33',
  Saturday = '#A65628'
)

start.of.debt = 154
start.of.rate = 543
frame <- function(i) {
  
    # select colors
    day.of.week.a <- strftime(table2.toplot[i,'date'], format = '%A')
    bal.col <- bal.of.week[day.of.week.a][[1]]
    rate.col <- rate.of.week[day.of.week.a][[1]]
    debt.col <- debt.of.week[day.of.week.a][[1]]
    
    # graphical parameters
    par(
        bg = 'grey20',
        family = 'Helvetica Neue',
        mai = c(1,0.7,1, 1.7),
        mgp = c(0, 1, 0)
    )
    
    # plot shell
    plot(
        table2.toplot[1:i,'balance'] ~ table2.toplot[1:i,'date'],
        type = 'n',
        xlim = range(table2.toplot$date),
        ylim = range(table2.toplot$balance),
        xlab = '', #Date
        ylab = '', main = '', #'FMS Soundsystem',
        axes = F, col = bal.col, col.lab = bal.col # so we notice errors
    )
    
    # x axis
    abline(h = 0, col = bal.col)

    # Balance
    polygon(
        c(table2.toplot[1:i,'date'], table2.toplot[i:1,'date']),
        c(table2.toplot[1:i,'balance'], table2.toplot[i:1,'balance']) + c(table2.toplot[1:i,'error'], - table2.toplot[i:1,'error']),
        col = bal.col, border=bal.col
    )

    # Balance number
    text(
        x = min(table2.toplot$date),
        y = mean(range(table2.toplot$balance)) * c(1.1, 1),
        labels = c(
            'Balance',
            sub('\\$-', '$', paste('$', as.character(round(table2.toplot[i,'balance'] / 1000)), ' billion', sep = ''))
        ),
        pos = 4, font = 2:1, col = bal.col, cex = 1.5
    )
    if (i >= start.of.rate) {
    # Interest rate number
      text(
        x = max(table2.toplot$date),
        y = 2.5e5 * c(1.15, 1),
        labels = c(
          'Interest rate',
          paste(as.character(table2.toplot[i,'rate']), '%', sep = '')
        ),
        pos = 2, font = 2:1, col = rate.col, cex = 1.5
      )
    }
    
    if (i >= start.of.debt) {
      # Debt Ceiling
      text(
        x = max(table2.toplot$date),
        y = 3.5e5 * c(1.1, 1),
        labels = c(
          'Debt Ceiling',
          paste('$', as.character(table2.toplot[i,'ceiling'] / 1000000), ' trillion', sep = '')
        ),
        pos = 2, font = 2:1, col = debt.col, cex = 1.5
      )
      
      # Distance to Ceiling
      text(
        x = max(table2.toplot$date),
        y = 4.5e5 * c(1.08, 1),
        labels = c(
          'Distance to Ceiling',
          paste('$', as.character(round(table2.toplot[i,'dist_to_ceiling'] / 1000, digits=2)), ' billion', sep = '')
        ),
        pos = 2, font = 2:1, col = debt.col, cex = 1.5
      )
    }
    
   # date
   title(
      sub = strftime(table2.toplot[i,'date'], format = '%B %d, %Y'),
      col.sub = 'grey50', cex.sub = 2
   )
    
    # balance axis
    ticks <- seq(-2e5, 6e5, 1e5)
    axis(2, 
         at = ticks, labels = paste0("$", round(ticks / 1000), "B"), 
         col = bal.col, col.ticks = bal.col, 
         col.axis=bal.col, col.lab=bal.col)
    
    # chernoff face
    face(i,
        x = mean(table2.toplot$date),
        y = table2.toplot[i,'balance'],
        height = abs(diff(range(table2.toplot$balance))) / 5,
        width = abs(diff(range(table2.toplot$date))) / 10,
        labels = '',
        cex=0.01
    )
    
    if (i >= start.of.rate) {
    # interest rate
      par(new = T)
      plot(
        table2.toplot[start.of.rate:i,'rate'] ~ table2.toplot[start.of.rate:i,'date'],
        axes = F, xlab = '', ylab = '', type = 'l', lty = 2, lwd = 2, col = rate.col,
        xlim = range(table2.toplot$date), ylim = c(-2, max(table2.toplot$rate))
      )
      axis(4, 
           at = 0:5, labels = paste(0:5, '%', sep = ''), 
           lty = 2, col = rate.col, col.ticks = rate.col, 
           col.axis = rate.col, col.lab = rate.col)
    }
    
    if (i >= start.of.debt) {
    # debt ceiling and distance to debt ceiling
      par(new=T)
      plot(
        table2.toplot[start.of.debt:i, 'subject_to_limit'] ~ table2.toplot[start.of.debt:i, 'date'],
        axes = F, xlab = '', ylab = '', type = 'l', lty = 3, lwd = 2, col = debt.col,
        xlim = range(table2.toplot$date), ylim = c(-5950000, max(table2.toplot$subject_to_limit))
      )
      lines(table2.toplot[start.of.debt:i, 'ceiling'] ~ table2.toplot[start.of.debt:i, 'date'], col = debt.col, lwd=2)
      axis(4, 
           line = 2.5, at = seq(0, 1.5e7, by=0.5e7), 
           labels = paste0("$", c(0, paste0(seq(5, 15, by=5), "T"))),
           col = debt.col, col.axis = debt.col, col.ticks = debt.col,
           col.lab = debt.col, lty=3)
    }
}

main.plots <- function() {
    for (i in 1:nrow(table2.toplot)) {
         fp = sprintf('slideshow/%04d.png', i)
         cat(sprintf("writng %s to file\n", fp))
         png(fp, width = 1920, height = 1080) 
         frame(i)
         dev.off()
    }
}
main.plots()