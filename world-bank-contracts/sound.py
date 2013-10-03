import math
from midiutil.MidiFile import MIDIFile

def fraction_to_midi(fraction):
    '''
    Args:
        fraction: A number between zero and one
    Returns:
        An integer for midi
    '''

    # Bad implementation for now for scaffolding
    return round(10 * math.log(1000 * fraction))

def add_phrase(beat, midi_track, time, phrase):
    total_melody = sum([v for k,v in phrase.items() if k in set('01234567')])
    for instrument,value in phrase.items():
        if instrument.startswith('drone'):
            midi_track.addNote(
                track=0,
                channel=0,
                pitch=fraction_to_midi(value),
                duration=8,
                volume=30,
                time=time
            )
        elif instrument in set('01234567'): # Melody
            midi_track.addNote(
                track=0,
                channel=0,
                pitch=30 + round(12 * value/total_melody),
                duration=1,
                volume=round(25 * math.sqrt(total_melody)),
                time=time
            )
    return midi_track, (time + beat)

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

bpm = 120
midi_track = MIDIFile(1)
midi_track.addTempo(track=0, time=0,tempo=bpm)

beat = bpm_time(bpm, count='1/4')
t = 0

binfile = open('bank.mid', 'wb')
midi_track.writeFile(binfile)
binfile.close()
