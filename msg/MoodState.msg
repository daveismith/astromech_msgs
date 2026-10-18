# The affect node's state, published on /mood/state at its tick rate (10 Hz) whether or
# not anything changed, so subscribers can treat silence as the node being gone.
std_msgs/Header header
float32 arousal          # -1 sleepy .. +1 frantic
float32 valence          # -1 unhappy .. +1 happy
float32 curiosity        # 0 .. 1, attention pointed outward
float32 confidence       # 0 timid .. 1 bold
string  mood             # the label of the nearest prototype, with hysteresis
float32 mood_strength    # 0..1, how close the state is to that prototype
bool    locked           # dynamics frozen by SetMood; stimuli still update focus
string  lock_source      # the SetMood.source that holds the lock; empty when not locked
builtin_interfaces/Time lock_until   # zero: until cleared
string  focus_subject    # subject of the latest unexpired stimulus that named one
float32 focus_bearing_rad            # its bearing; NaN when none
float32 idle_s           # seconds since the last accepted external stimulus
