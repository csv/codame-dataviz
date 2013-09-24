## Plans

Already ready

1. Stop-question-frisk webpage
2. Gifts my true love gave to me on the 12 days of Christmas
3. FMS Symphony
4. Ridership rachenitsa

To do

1. Data-driven dance (below)
2. CSV shirts, with `,`, `\r`, and `\n` (Let's make a store, too!)
3. Big light-up comma
4. More songs (below)
5. Collecting bike accident data for an SF-related dataset. Almost done geocoding. Presentation could be similar to sqf-symphony or separate. [Info on what variables we have](https://www.baycitizen.org/data/bikes/bike-accident-tracker/). 

## Data-driven dance

In the part of `fms` when the debt ceiling is about to rise and the drums drop out, have everyone in the crowd yell 
"RAISE THE ROOF" and do this move:

![raise-the-roof](http://gifrific.com/wp-content/uploads/2013/05/Michael-Scott-and-Dwight-Schrute-Raise-the-Roof.gif)

## General inspirations

### Bring things in parts at a time
In the music and video, we can bring in things parts at a time.
A cool way of doing this is to use datasets that only start at
a particular time, but we could also do this by arbitrarily cutting
things off. Or we could cut things off at meaningful places.

### Live data feed
Something in the music and video changes based on a Wiimote or
whatever. We can hand that out to the audience

## Song ideas

### Ambient
Fit a model to some sparse and small dataset. Map the model
predictions to notes.

For example, we predict average daily bicycle ridership on
New York bridges from monthly data. We use some sort of nice
smoothing function so we get clean interpolations. Kernel
density should be fine.

Then we map predictions to frequencies. In the above example,
we only have one instrument, but we can have more instruments
for different dependent variables.

### Open data portal usage analytics
http://thomaslevine.com/!/socrata-metrics-api/

## Datasets

* http://thomaslevine.com/!/socrata-metrics-api/
* Nursing homes
* American Community Survey
