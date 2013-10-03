from midiutil.MidiFile import MIDIFile

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

def add_phrase(midi_track, time, phrase):
    return midi_track, time
