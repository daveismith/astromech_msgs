# One finished sequence on the dome's buttons: a fact about the input, nothing about what it
# did. Published once per sequence on /dome/buttons/sequence, and never repeated.
uint8 SOURCE_CONTROLLER=0   # read off the button controller
uint8 SOURCE_INJECTED=1     # injected on the dome's console, for testing

std_msgs/Header header      # stamp: when the dome dispatched it, UTC
uint16 value                # the captured value: each LEFT tap shifts in a 1, each RIGHT a 0
string taps                 # the shortest tap string for it: "LRR" for 4
uint16 id                   # the controller's sequence id, or the injection count; never 0
uint8  source               # SOURCE_*; (id, source) names one sequence
