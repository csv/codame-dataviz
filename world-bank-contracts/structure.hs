type Beat    = Integer -- Placeholder
type Measure = (Beat, Beat, Beat, Beat)
type Stanza  = (Measure, Measure, Measure, Measure,
                Measure, Measure, Measure, Measure)
type Song    = [Stanza]

stanza :: Maybe Integer -> ()
stanza = ()
  -- First measure is aggregate
  -- Six measures, one per region, with one (random) country per region
  -- Last measure is the sum of the previous seven,
  --   maybe with some interesting close of the last measure

main <- do
  song   = [ stanza Nothing,
             stanza 2000,
             stanza 2000,
             stanza 2001,
             stanza 2001,
             stanza 2002,
             stanza 2002,
             stanza 2003,
             stanza 2003,
             stanza 2004,
             stanza 2004,
             stanza 2005,
             stanza 2005,
             stanza 2006,
             stanza 2006,
             stanza 2007,
             stanza 2007,
             stanza 2008,
             stanza 2008,
             stanza 2009,
             stanza 2009,
             stanza 2010,
             stanza 2010,
             stanza 2011,
             stanza 2011,
             stanza 2012,
             stanza 2012,
             stanza 2013,
             stanza 2013 ]
  nbeats = (length song) * 8 * 4
  bpm    = 256
  minutes= bpm / nbeats
