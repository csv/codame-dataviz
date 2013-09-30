"""
Music Scales

Source: http://en.wikipedia.org/wiki/List_of_musical_scales_and_modes

"""

ACOUSTIC_SCALE = [0, 2, 4, 6, 7, 9, 10]
ADONAI_MALAKH = [0, 2, 4, 5, 7, 8, 10]
AEOLIAN_MODE = [0, 2, 3, 5, 7, 8, 10]
ALGERIAN_SCALE = [0, 2, 3, 6, 7, 8, 11]
ALTERED_SCALE = [0, 1, 3, 4, 6, 8, 10]
AUGMENTED_SCALE = [0, 3, 4, 7, 8, 11]
BEBOP_DOMINANT = [0, 2, 4, 5, 7, 9, 10, 11]
BLUES_SCALE = [0, 3, 5, 6, 7, 10]
DORIAN_MODE = [0, 2, 3, 5, 7, 9, 10]
DOUBLE_HARMONIC_SCALE = [0, 1, 4, 5, 7, 8, 11]
ENIGMATIC_SCALE = [0, 1, 4, 6, 8, 10, 11]
FLAMENCO_MODE = [0, 1, 4, 5, 7, 8, 11]
GYPSY_SCALE = [0, 2, 3, 6, 7, 8, 10]
HALF_DIMINISHED_SCALE = [0, 2, 3, 5, 6, 8, 10]
HARMONIC_MAJOR_SCALE = [0, 2, 4, 5, 7, 8, 11]
HARMONIC_MINOR_SCALE = [0, 2, 3, 5, 7, 8, 11]
HIRAJOSHI_SCALE = [0, 4, 6, 7, 11]
HUNGARIAN_GYPSY_SCALE = [0, 2, 3, 6, 7, 8, 11]
INSEN_SCALE = [0, 1, 5, 7, 10]
IONIAN_MODE = [0, 2, 4, 5, 7, 9, 11]
IWATO_SCALE = [0, 1, 5, 6, 11]
LOCRIAN_MODE = [0, 1, 3, 5, 6, 8, 10]
LYDIAN_AUGMENTED_SCALE = [0, 2, 4, 6, 8, 9, 11]
LYDIAN_MODE = [0, 2, 4, 6, 7, 9, 11]
MAJOR_LOCRIAN = [0, 2, 4, 5, 6, 8, 10]
MELODIC_MINOR_SCALE = [0, 2, 3, 5, 7, 9, 11]
MIXOLYDIAN_MODE = [0, 2, 4, 5, 7, 9, 10]
NEAPOLITAN_MAJOR_SCALE = [0, 1, 3, 5, 7, 9, 11]
NEAPOLITAN_MINOR_SCALE = [0, 1, 3, 5, 7, 8, 11]
PERSIAN_SCALE = [0, 1, 4, 5, 6, 8, 11]
PHRYGIAN_MODE = [0, 1, 3, 5, 7, 8, 10]
PROMETHEUS_SCALE = [0, 2, 4, 6, 9, 10]
TRITONE_SCALE = [0, 1, 4, 6, 7, 10]
UKRAINIAN_DORIAN_SCALE = [0, 2, 3, 6, 7, 9, 10]
WHOLE_TONE_SCALE = [0, 2, 4, 6, 8, 10]
MAJOR = [0, 2, 4, 5, 7, 9, 11]
MINOR = [0, 2, 3, 5, 7, 8, 10]
CHROMATIC = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]


def build_scale(key, scale, min_note=0, max_note=128):
    s = [s + key for s in scale]
    return [x + (12 * j)
        for j in range(12)
        for x in s
        if x + (12 * j) >= min_note and x + (12 * j) <= max_note]

"""
from: http://www.pianochord.com/list-of-C-chords
"""
chord_lookup = {
  "maj": [0,4,7],
  "maj_no_fifth": [0,4],
  "power": [0,7],
  "sus": [0,5,7],
  "sus2": [0,2,7],
  "maj_six": [0,4,7,9],
  "maj_six_no_fifth": [0,4,9],
  "maj_six_nine": [0,4,9, 14],
  "min": [0,3,7],
  "min_no_fifth": [0,3],
  "min_six": [0,3,7,9],
  "min_six_no_fifth": [0,3,9],
  "min_six_nine": [0,3,9, 14],
  "dim": [0,3,6],
  "aug": [0,4,8],
  "maj7": [0,4,7,11],
  "maj7_no_fifth": [0,4,11]
}

note_lookup = {  
  "C-1": 0,
  "C#-1": 1,
  "Db-1": 1,
  "D-1": 2,
  "D#-1": 3,
  "Eb-1": 3,
  "E-1": 4,
  "F-1": 5,
  "F#-1": 6,
  "Gb-1": 6,
  "G-1": 7,
  "G#-1": 8,
  "Ab-1": 8,
  "A-1": 9,
  "A#-1": 10,
  "Bb-1": 10,
  "B-1": 11,
  "C0": 12,
  "C#0": 13,
  "Db0": 13,
  "D0": 14,
  "D#0": 15,
  "Eb0": 15,
  "E0": 16,
  "F0": 17,
  "F#0": 18,
  "Gb0": 18,
  "G0": 19,
  "G#0": 20,
  "Ab0": 20,
  "A0": 21,
  "A#0": 22,
  "Bb0": 22,
  "B0": 23,
  "C1": 24,
  "C#1": 25,
  "Db1": 25,
  "D1": 26,
  "D#1": 27,
  "Eb1": 27,
  "E1": 28,
  "F1": 29,
  "F#1": 30,
  "Gb1": 30,
  "G1": 31,
  "G#1": 32,
  "Ab1": 32,
  "A1": 33,
  "A#1": 34,
  "Bb1": 34,
  "B1": 35,
  "C2": 36,
  "C#2": 37,
  "Db2": 37,
  "D2": 38,
  "D#2": 39,
  "Eb2": 39,
  "E2": 40,
  "F2": 41,
  "F#2": 42,
  "Gb2": 42,
  "G2": 43,
  "G#2": 44,
  "Ab2": 44,
  "A2": 45,
  "A#2": 46,
  "Bb2": 46,
  "B2": 47,
  "C3": 48,
  "C#3": 49,
  "Db3": 49,
  "D3": 50,
  "D#3": 51,
  "Eb3": 51,
  "E3": 52,
  "F3": 53,
  "F#3": 54,
  "Gb3": 54,
  "G3": 55,
  "G#3": 56,
  "Ab3": 56,
  "A3": 57,
  "A#3": 58,
  "Bb3": 58,
  "B3": 59,
  "C4": 60,
  "C#4": 61,
  "Db4": 61,
  "D4": 62,
  "D#4": 63,
  "Eb4": 63,
  "E4": 64,
  "F4": 65,
  "F#4": 66,
  "Gb4": 66,
  "G4": 67,
  "G#4": 68,
  "Ab4": 68,
  "A4": 69,
  "A#4": 70,
  "Bb4": 70,
  "B4": 71,
  "C5": 72,
  "C#5": 73,
  "Db5": 73,
  "D5": 74,
  "D#5": 75,
  "Eb5": 75,
  "E5": 76,
  "F5": 77,
  "F#5": 78,
  "Gb5": 78,
  "G5": 79,
  "G#5": 80,
  "Ab5": 80,
  "A5": 81,
  "A#5": 82,
  "Bb5": 82,
  "B5": 83,
  "C6": 84,
  "C#6": 85,
  "Db6": 85,
  "D6": 86,
  "D#6": 87,
  "Eb6": 87,
  "E6": 88,
  "F6": 89,
  "F#6": 90,
  "Gb6": 90,
  "G6": 91,
  "G#6": 92,
  "Ab6": 92,
  "A6": 93,
  "A#6": 94,
  "Bb6": 94,
  "B6": 95,
  "C7": 96,
  "C#7": 97,
  "Db7": 97,
  "D7": 98,
  "D#7": 99,
  "Eb7": 99,
  "E7": 100,
  "F7": 101,
  "F#7": 102,
  "Gb7": 102,
  "G7": 103,
  "G#7": 104,
  "Ab7": 104,
  "A7": 105,
  "A#7": 106,
  "Bb7": 106,
  "B7": 107,
  "C8": 108,
  "C#8": 109,
  "Db8": 109,
  "D8": 110,
  "D#8": 111,
  "Eb8": 111,
  "E8": 112,
  "F8": 113,
  "F#8": 114,
  "Gb8": 114,
  "G8": 115,
  "G#8": 116,
  "Ab8": 116,
  "A8": 117,
  "A#8": 118,
  "Bb8": 118,
  "B8": 119,
  "C9": 120,
  "C#9": 121,
  "Db9": 121,
  "D9": 122,
  "D#9": 123,
  "Eb9": 123,
  "E9": 124,
  "F9": 125,
  "F#9": 126,
  "Gb9": 126,
  "G9": 127
}

root_lookup = {  
  "C": 0,
  "C#": 1,
  "Db": 1,
  "D": 2,
  "D#": 3,
  "Eb": 3,
  "E": 4,
  "F": 5,
  "F#": 6,
  "Gb": 6,
  "G": 7,
  "G#": 8,
  "Ab": 8,
  "A": 9,
  "A#": 10,
  "Bb": 10,
  "B": 11
}