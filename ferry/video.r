f <- read.csv('ferry.smooth.csv')
f <- f[order(f$Year, f$Month),]

interpolate <- function(a, b) {
  seq(a, b, (b-a)/30)
}

reducer <- function(a, b) {
  c(a, interpolate(a[length(a)], b)[-1])
}

freq = function(vec) {
  440 * (3/2) ^ ((vec - mean(vec)) / sd(vec))
}

# Play these frequencies.
downtown <- freq(Reduce(reducer, f$Downtown.Passengers))
midtown  <- freq(Reduce(reducer, f$Midtown.Passengers))
