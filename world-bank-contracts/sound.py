import math
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
    for instrument in phrase:
        if instrument.startswith('drone'):
            midi_track.addNote(
                track=0,
                channel=0,
                pitch=key,
                duration=beat,
                volume=100,
                time=time
            )
        elif instrument in set('01234567'):
            midi_track.addNote(
                track=0,
                channel=0,
                pitch=key,
                duration=beat,
                volume=100,
                time=time
            )
    return midi_track, (time + beat)
