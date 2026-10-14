# Raw dome position telemetry, one message per "DOME POSITION:" report line
# from the Roam-A-Dome controller. Published by the ros2_roamadome hardware
# interface on ~/telemetry when its publish_telemetry parameter is true.

std_msgs/Header header        # stamp is host receive time of the report line
uint16 position_deg           # home-relative integer from firmware, 0..359
float64 position_rad          # wrapped to [0, 2*pi)
float64 unwrapped_rad         # continuous since activation
float64 velocity_rad_s        # NaN until the regression window is populated
int8 commanded_percent        # last :DPR value sent in any mode; 0 when none
uint8 command_mode            # see constants below
uint32 sequence               # increments per report line; wraps

uint8 COMMAND_MODE_IDLE=0
uint8 COMMAND_MODE_POSITION=1
uint8 COMMAND_MODE_VELOCITY=2
uint8 COMMAND_MODE_BENCH=3
