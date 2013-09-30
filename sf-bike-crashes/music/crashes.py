from midify import *
import pandas as pd
from midiutil.MidiFile import MIDIFile
from datetime import datetime, timedelta
from operator import itemgetter

crashes = json.load(open('../data/hex_running_totals.min.json'))
attr = json.load(open('../data/case-lookup-table.min.json'))

# make a data.frame
data = []
for day in crashes.values():
    for crash in day:
        row = dict(
            crash.items() + 
            attr[crash['case_id']].items()
            )
        data.append(row)

df = pd.DataFrame(data)
df.to_csv('data/crashses.csv')

# count by hex_id
hex_counts = {}
for day, data in crashes.iteritems():
    for crash in data:
        if hex_counts.has_key(crash['hex_id']):
            hex_counts[crash['hex_id']] += 1
        else:
            hex_counts[crash['hex_id']] = 1
hex_counts = sorted(hex_counts.iteritems(), key=itemgetter(1))


hex_to_key = {
    'h0.033': 'E5',
    'h0.068': 'D5',
    'h0.044': 'C5',
    'h0.072': 'A5',
    'h0.054': 'G4',
    'h0.066': 'E4',
    'h0.037': 'D4',
    'h0.076': 'C4',
    'h0.032': 'A4',
    'h0.063': 'G3',
    'h0.046': 'E3',
    'h0.040': 'D3',
    'h0.071': 'C3',
    'h0.049': 'A3',
    'h0.062': 'G2',
    'h0.058': 'E2',
    'h0.038': 'D2',
    'h0.057': 'C2',
    'h0.036': 'A2',
    'h0.023': 'G1',
    'h0.028': 'E1',
    'h0.014': 'D1',
    'h0.042': 'C1',
    'h0.026': 'E0',
    'h0.021': 'G0',
    'h0.005': 'D0',
    'h0.029': 'C0',
    'h0.015': 'A1',
    'h0.012': 'A0'
}


min_date = datetime(year=2005, month=01, day=01)
max_date =  datetime(year=2009, month=12, day=31)
date_range = [min_date + timedelta(days=d) for d in range(0 , (max_date - min_date).days + 1)]

bpm = 120
midi_track = MIDIFile(1)
midi_track.addTempo(track=0, time=0,tempo=bpm)

beat = bpm_time(bpm, count='1/4')
t = 0


for d in date_range:
    day = d.strftime('%Y-%m-%d')
    if crashes.has_key(day):
        for crash in crashes[day]:
            key = hex_to_key[crash['hex_id']]
            print key
            midi_track.addNote(
                track=0, 
                channel=0,
                pitch=key,
                duration=beat, 
                volume=100, 
                time=t
            )
    t += beat

binfile = open('midi/crash-arp.mid', 'wb')  
midi_track.writeFile(binfile)
binfile.close()

#  __  __  ___  _   _ _____ _   _   __  __ _____ _     ___  ______   __
# |  \/  |/ _ \| \ | |_   _| | | | |  \/  | ____| |   / _ \|  _ \ \ / /
# | |\/| | | | |  \| | | | | |_| | | |\/| |  _| | |  | | | | | | \ V / 
# | |  | | |_| | |\  | | | |  _  | | |  | | |___| |__| |_| | |_| || |  
# |_|  |_|\___/|_| \_| |_| |_| |_| |_|  |_|_____|_____\___/|____/ |_|  
                                                                     
months = pd.read_csv('../data/month_counts.csv')

# ceiling
vec = months.month_count
out_file="months.mid"
bpm=120
key="A"
scale=[0,3,5,7,10]
count='1/4' 
channel=1
min_note="A2"
max_note="A5"

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

bpm = 120
midi_track = MIDIFile(1)
midi_track.addTempo(track=0, time=0,tempo=bpm)

beat = bpm_time(bpm, count='1/4')
t = 0

for d in date_range:
    day = d.strftime('%Y-%m-%d')
    if crashes.has_key(day):
        for crash in crashes[day]:
            key = hex_to_key[crash['hex_id']]
            print key
            midi_track.addNote(
                track=0, 
                channel=0,
                pitch=key,
                duration=beat, 
                volume=100, 
                time=t
            )
    t += beat

binfile = open('midi/crash-months.mid', 'wb')  
midi_track.writeFile(binfile)
binfile.close()
