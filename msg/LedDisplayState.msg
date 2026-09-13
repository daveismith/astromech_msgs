uint8 MODE_RANDOM=0     # the display's own animation: the drift, or a PSI's wipe
uint8 MODE_TEXT=1       # a display's own text mode (the console's `leds text`)
uint8 MODE_SOLID=2      # one colour
uint8 MODE_MANUAL=3     # pixels set from the console
uint8 MODE_OFF=4        # black, and left alone
uint8 MODE_EFFECT=5     # a run holds it; reported, never set
string  name
uint8   mode
uint8   brightness      # percent
int8    hue             # -128..127 of the hue circle
string  drift           # calm, lively or custom; empty on a PSI
string  text            # its own text mode's text, or empty
