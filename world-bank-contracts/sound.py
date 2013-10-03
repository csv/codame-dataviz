import json
import math
from midiutil.MidiFile import MIDIFile

region_keys = [
  u'intro',
  u'AFRICA',
  u'EAST ASIA AND PACIFIC',
  u'EUROPE AND CENTRAL ASIA',
  u'LATIN AMERICA AND CARIBBEAN',
  u'MIDDLE EAST AND NORTH AFRICA',
  u'SOUTH ASIA',
  u'out',
]
region_keys_dict = dict([(v,k) for k, v in enumerate(region_keys)])

def fraction_to_midi(fraction):
    '''
    Args:
        fraction: A number between zero and one
    Returns:
        An integer for midi
    '''
    # Bad implementation for now for scaffolding
    return max(5, 20 + int(10 * math.log(1000 * fraction)))

def add_phrase(beat, midi, time, phrase, melody_track):
    total_melody = sum([v for k,v in phrase.items() if k in set('01234567')])
    for instrument,value in phrase.items():
        if instrument.startswith('drone'):
            if value not in {'NA', 'NaN'}:
                midi.addNote(
                    track=0 + int(instrument[-1]),
                    channel=0,
                    pitch=fraction_to_midi(value),
                    duration=8,
                    volume=30,
                    time=time
                )
        elif instrument in set('01234567'): # Melody
            midi.addNote(
                track=2 + melody_track,
                channel=0,
                pitch=30 + int(12 * value/total_melody),
                duration=1,
                volume=int(25 * math.sqrt(total_melody)),
                time=time + int(instrument) * beat
            )
    return midi, (time + 8 * beat)

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

song = json.load(open('song.json'))

bpm = 240
midi = MIDIFile(10)
for i in range(10):
    midi.addTempo(track=i, time=0,tempo=bpm)

beat = bpm_time(bpm, count='1/4')
t = 0

for stanza_key in ['intro'] + map(str, range(2000, 2014)) + ['out']:
    for region_key in region_keys:
        midi, t = add_phrase(beat, midi, t, song[stanza_key][region_key],
            melody_track = region_keys_dict[region_key])

binfile = open('bank.mid', 'wb')
midi.writeFile(binfile)
binfile.close()
