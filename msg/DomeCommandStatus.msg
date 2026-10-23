# Who is driving the dome through dome_twist_converter, and what it sent. Published on
# /dome/cmd/status by the converter on every source change and at status_hz otherwise, so a
# console can show why the dome is not following the personality.
string SOURCE_IDLE=idle                 # no source is fresh; the converter sends zero
string SOURCE_JOYSTICK=joystick         # a person on the controller
string SOURCE_FOXGLOVE=foxglove         # a person on the Foxglove teleop panel
string SOURCE_PERSONALITY=personality   # the dome arbiter, via /dome/cmd/personality

std_msgs/Header header   # stamp: when the converter published this tick
string  source          # SOURCE_*: the source whose command went out this tick
float64 velocity_rad_s  # rad/s, positive in the dome joint's positive direction: what went to
                        #   /dome_controller/commands this tick
bool    capped          # the personality value was clamped by speed or acceleration;
                        #   always false for the other sources
