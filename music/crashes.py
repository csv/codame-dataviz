from midify import *
import pandas as pd
from midiutil.MidiFile import MIDIFile
from datetime import datetime, timedelta
from operator import itemgetter

crashes = json.load(open('data/hex_running_totals.min.json'))
attr = json.load(open('data/case-lookup-table.min.json'))


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
    day = d.strftime('%Y-%m-%d'
    if crashes.has_key(day):
        for crash in crashes[day]:
            note = hex_to_note(crash['hex_id'])
            print note
            midi_track.addNote(
                track=0, 
                channel=0,
                pitch=note,
                duration=beat, 
                volume=100, 
                time=t
            )

            t += beat
    else:
        t += beat

binfile = open('crashes.mid', 'wb')  
midi_track.writeFile(binfile)
binfile.close()


# df = pd.read_csv('data/bike_data_hexed.csv')
# df.simpledate = df.simpledate.apply(lambda x: datetime.strptime(str(x), "%Y%m%d"))

# hex_to_note = {
#     'h1': "C3",
#     'h10' : "B4",
#     'h11': "C5",
#     'h2': "E3",
#     'h3': "G3",
#     'h4': "A3",
#     'h44': "G5",
#     'h5': "B4",
#     'h6' : "C4",
#     'h7' : "E4",
#     'h8' : "G4",
#     'h9' : "A4"
#  }

# bpm = 120
# midi_track = MIDIFile(1)
# midi_track.addTempo(track=0, time=0,tempo=bpm)

# beat = bpm_time(bpm, count='1/2')
# t = 0

# for d in date_range:
#     this_df = sf[sf.simpledate==d]
#     if len(this_df)!=0:
#         for i in this_df.index:
#             if this_df.fatal[i]==1:
#                 volume = 120
#             else:
#                 volume = 60
#             try:
#                 note = hex_to_note[this_df.hex_id.values[0]]
#             except:
#                 t += beat
#             else:
#                 midi_track.addNote(
#                     track=0, 
#                     channel=0,
#                     pitch=note_to_midi(note),
#                     duration=beat, 
#                     volume=volume, 
#                     time=t
#                 )

#                 t += beat
#     else:

#         t += beat

# binfile = open('crashes.mid', 'wb')  
# midi_track.writeFile(binfile)
# binfile.close()