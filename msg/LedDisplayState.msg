uint8 MODE_RANDOM=0     # the display's own animation: the drift, or a PSI's wipe
uint8 MODE_TEXT=1       # a display's own text mode (the console's `leds text`)
uint8 MODE_SOLID=2      # one colour
uint8 MODE_MANUAL=3     # pixels set from the console
uint8 MODE_OFF=4        # black, and left alone
uint8 MODE_EFFECT=5     # a run holds it; reported, never set
uint32 HOLD_FOREVER=4294967295  # hold_remaining_ms under the sticky manual setting
string  name
uint8   mode
uint8   brightness      # percent
int8    hue             # -128..127 of the hue circle
string  drift           # calm, lively or custom; empty on a PSI
string  text            # its own text mode's text, or empty
string  changed_by      # who last changed the display itself, not through a run: ros, console,
                        #   ui, text_topic; empty when nothing has since boot
string  changed_by_owner  # changed_by is ros: the owner the request named
string  held_by         # console, ui, text_topic, or manual: ROS requests at priority 1..199
                        #   that touch this display are refused. Empty when not held
uint32  hold_remaining_ms  # 0 when not held; HOLD_FOREVER while held_by is manual
