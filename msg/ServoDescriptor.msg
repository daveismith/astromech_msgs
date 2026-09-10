# One servo, as its controller describes it. Two coordinate systems and the mapping
# between them: joint space (radians, the public interface) and actuator space (raw
# units, the configuration interface). See the servo model specification.

uint8 ACTUATOR_PWM=0
uint8 ACTUATOR_DYNAMIXEL=1

uint8 UNITS_MICROSECONDS=0
uint8 UNITS_TICKS=1
uint8 UNITS_MILLIDEGREES=2

uint8 DRIVE_HOLD=0
uint8 DRIVE_RELEASE=1

string   joint              # URDF joint name, no _joint suffix; the droid-wide key
string   display            # human label, <= 23 chars

uint8    actuator_type
uint8    raw_units

bool     has_position_feedback
bool     has_temperature
bool     has_voltage
bool     has_load
bool     can_release        # false: drive policy is fixed at HOLD, RELEASE is refused

int32    raw_min            # physical limits; never exceeded
int32    raw_max
int32    raw_closed         # configured endpoint at joint_lower
int32    raw_open           # configured endpoint at joint_upper
int32    raw_step           # smallest increment a UI should offer
bool     calibrated         # false: raw_closed/raw_open are defaults, not measurements

uint8    drive_closed       # DRIVE_*: output state once settled in the CLOSED zone
uint8    drive_open
uint8    drive_mid
uint16   settle_ms          # driven for at least this long after any command
float64  zone_epsilon       # endpoint zone half-width, fraction of travel

float64  joint_lower        # radians, from URDF <limit>
float64  joint_upper
float64  velocity_limit     # 0 = unspecified
float64  effort_limit
