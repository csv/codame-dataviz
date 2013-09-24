#Import the library
from midiutil.MidiFile import MIDIFile
from math import ceil
from random import sample
import json
from defaults import *

def note_to_midi(n):
  if isinstance(n, basestring):
    return note_lookup[n]
  elif isinstance(n, int):
    return n

def root_to_midi(n):
  if isinstance(n, basestring):
    return root_lookup[n]
  elif isinstance(n, int):
    return n

def str_count_parse(count):
  if isinstance(count, basestring):
    items = count.split('/')
    return float(items[0]) / float(items[1])
  else:
    return count

def bpm_time(bpm=120, count=0.25):
  count = str_count_parse(count)
  onebar = float((60.0/float(bpm))*4.0)
  return onebar*float(count)

def scale_vec(vec, low, high):
  # make it big so we can ignore float probs
  vec = [int(ceil(v*1e5)) for v in vec]

  # extract min and max info
  min_vec = min(vec) + abs(min(vec))
  max_vec = max(vec) + abs(min(vec))

  # scale
  return [(int(ceil(v - min_vec)) * (high-low) / (max_vec - min_vec)) for v in vec]

def midify(
    vec, 
    out_file,
    bpm,
    key,
    scale, 
    count, 
    channel, 
    min_note, 
    max_note
  ):

  # transform keys and min/max notes
  key = root_to_midi(key)
  min_note = note_to_midi(min_note)
  max_note = note_to_midi(max_note)

  # select notes
  notes = build_scale(key, scale, min_note, max_note)

  # scale notes
  # hack to ensure 
  note_indexes = scale_vec(vec, low=0, high=(len(notes)-1))

  # determinte note length
  beat = bpm_time(bpm, count)

  # generate midi file
  midi_track = MIDIFile(1)
  midi_track.addTempo(track=0, time=0,tempo=bpm)

  t = 0
  for i in note_indexes:
    n = notes[i]
    midi_track.addNote(track=0, channel=0, pitch=n, time=t, duration=beat, volume=100)
    t += beat

  binfile = open(out_file, 'wb')
  midi_track.writeFile(binfile)
  binfile.close()

if __name__ == '__main__':
  vec = sample(range(1,10000), 32)
  midify(vec, bpm=130, count= '1/4', out_file="random.mid", scale=CHROMATIC, min_note="C2", max_note="D#3")
  vec = sample(range(1,10000), 32)
  midify(vec, bpm=130, count= 0.125, out_file="bass.mid", key = "E", scale=MAJOR, min_note="E2", max_note="G#4")
  vec = sample(range(1,10000), 32)
  midify(vec, bpm=130, count= 0.125, out_file="arp.mid", key = "E", scale=MAJOR, min_note="B5", max_note="G#7")