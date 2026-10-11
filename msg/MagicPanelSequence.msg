# One entry of a Magic Panel's sequence catalogue, as the device describes it. The id is the
# identifier everywhere: what StartMagicSequence takes, what the panel's own rotary switch and
# any legacy controller mean. The name is for display only, and empty without CAP_NAMES.
uint8 FLAG_LOOPS=1          # runs until stopped; length_ms is LENGTH_INDEFINITE
uint8 FLAG_RANDOM=2         # content depends on the panel's PRNG
uint8 FLAG_ENDS_LIT=4       # the panel is left lit at the end
uint8 FLAG_HOLD=8           # a static image held for the whole length
uint8 FLAG_VARIES=16        # the length differs from run to run: treat it as typical

uint32 LENGTH_INDEFINITE=4294967295

uint8   id                  # the catalogue id: what start takes
string  name                # up to 16 chars as the device returned it; empty without CAP_NAMES
uint8   flags               # bitwise OR of FLAG_*, passed through: a later firmware may add one
uint32  length_ms           # one iteration, as the firmware measured it
