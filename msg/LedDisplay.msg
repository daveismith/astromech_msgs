# One LED display, as its controller describes it.
string  name            # "tfld": the key the services take
string  display         # "TOP FLD", for a UI
string  kind            # fld, rld, front_psi, rear_psi
uint8   rows
uint8   cols
uint16  leds
bool    has_text        # false on the PSIs
bool    has_drift       # the logic displays
