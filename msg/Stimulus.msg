# One thing a perception node saw, described without any opinion about what the droid
# should feel: that is the affect layer's job, keyed by `kind` in its affect.yaml.
# Published on /stimuli by any producer (adapters, the stimulate CLI, a console).
std_msgs/Header header   # stamp: when it was observed, in the producer's clock
string   kind            # the affect table key: button_sequence, being_driven, bump, ...
string   source          # the producing node's name
float32  intensity       # 0..1, normalised by the producer; scales the impulse
float32  confidence      # 0..1; below the affect node's min_confidence it is ignored
string   subject         # who or what, when known: "dave", "unknown_person", "LRR"
float32  bearing_rad     # body-relative direction, +ve left; NaN when unknown
float32  ttl_s           # how long this stays relevant to reactions and focus; 0: default
string   extra           # JSON for producer-specific detail; empty when none
