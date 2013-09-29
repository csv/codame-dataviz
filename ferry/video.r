f <- read.csv('ferry.smooth.csv')

interpolate <- function(a, b) {
  seq(a, b, (b-a)/30)
}

reducer <- function(a, b) {
  c(a, interpolate(a[length(a)], b)[-1])
}

downtown <- Reduce(reducer, f$Downtown.Passangers)
midtown  <- Reduce(reducer, f$Midtown.Passengers)
