uint8 ZONE_CLOSED=0
uint8 ZONE_INTERMEDIATE=1
uint8 ZONE_OPEN=2

string   joint
int32    raw_target             # always present: what was last commanded
int32    raw_position           # measured; valid only if position_is_measured
float64  position               # radians
bool     position_is_measured   # false: derived from raw_target, NOT a measurement
bool     enabled                # output live NOW; false after a policy release
uint8    zone                   # ZONE_*, computed from raw_target
bool     moving
bool     stalled
bool     fault
float64  temperature_c          # per capability; NaN if absent
float64  voltage
float64  load
