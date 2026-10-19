std_msgs/Header   header    # stamp in UTC
uint8             level     # the sound level now
bool              level_set # false: the build's default, nothing has set it
LedDisplayState[] displays
LedSurfaceState[] surfaces
bool              strip_enabled  # false: the strip is switched off (`leds enable off`), or not fitted
bool              manual         # the sticky manual setting: every display held until it is cleared
