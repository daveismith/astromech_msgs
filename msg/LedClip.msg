# A clip the controller can play: a recorded animation for one target grid.
string  name
string  target          # fld, rld, psi
uint32  frames
uint32  length_ms       # one pass
bool    loops           # false: a run of it ends by itself
bool    tintable        # indexed: its tint entries, if it has any, take the run's colour
string  source          # "built-in" or "/data/clips"
