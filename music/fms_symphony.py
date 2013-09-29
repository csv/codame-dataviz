from midify import *
import pandas as pd
from midiutil.MidiFile import MIDIFile

df = pd.read_csv('data/fms.csv')

# rate
midify(
    df.rate, 
    out_file="midi/fms-rate.mid",
    bpm=160,
    key="C",
    scale=MAJOR, 
    count='1/4', 
    channel=1, 
    min_note="C1", 
    max_note="B7"
  )

# ceiling
midify(
    df.dist_to_ceiling, 
    out_file="midi/fms-ceiling.mid",
    bpm=160,
    key="C",
    scale=MAJOR, 
    count='1/4', 
    channel=1, 
    min_note="C1", 
    max_note="B7"
  )

# chords
bpm = 160
midi_track = MIDIFile(1)
midi_track.addTempo(track=0, time=0,tempo=bpm)

beat = bpm_time(bpm, count='1/4')
t = 0
for z in df.z_change:

    # add chords based on z-change
    if z < 0:
        if z <= -0.5:
            midi_track.addChord(
                track=0, 
                channel=0, 
                root="A5", 
                chord="min", 
                duration=beat, 
                volume=120, 
                time=t
            )
        else:
            midi_track.addChord(
                track=0, 
                channel=0, 
                root="A4", 
                chord="min", 
                duration=beat, 
                volume=120, 
                time=t
            )
    else:
        if z >= 0.5:
            midi_track.addChord(
                track=0, 
                channel=0, 
                root="C5", 
                chord="maj", 
                duration=beat, 
                volume=120, 
                time=t
            )
        else:
            midi_track.addChord(
                track=0, 
                channel=0, 
                root="C4", 
                chord="maj", 
                duration=beat, 
                volume=120, 
                time=t
            )

    # increase time
    t += beat

binfile = open('midi/fms-chords.mid', 'wb')  
midi_track.writeFile(binfile)
binfile.close()