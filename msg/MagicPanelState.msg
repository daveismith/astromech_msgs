# A Magic Panel as its controller last read it: the status block, the link, the settings
# and the counters. Published at a fixed rate, which is the controller's poll rate, whether
# the panel is there or not -- an absent or unsupported panel is when a subscriber most needs
# telling why.
uint8 SOURCE_NONE=0
uint8 SOURCE_I2C=1            # a register START: this controller, or another on the same bus
uint8 SOURCE_LEGACY=2         # an old one-byte controller
uint8 SOURCE_GPIO=3           # the panel's own rotary switch or jumpers
uint8 SOURCE_GPIO_RESUME=4    # a GPIO mode restarted after an I2C sequence ended

uint8 STATE_IDLE=0
uint8 STATE_RUNNING=1
uint8 STATE_COMPLETE=2
uint8 STATE_STOPPED=3

uint8 SEQ_NONE=255            # nothing has run since the panel reset
uint8 SUB_SEQ_OFF=254         # a random show is in its dark interval
uint32 NEVER=4294967295

std_msgs/Header header        # stamp: when this was PUBLISHED, UTC. NOT when it was read

uint8   link                  # MagicPanelDescriptor/LINK_*
uint8   unsupported           # MagicPanelDescriptor/UNSUP_*
uint8   fw_major              # repeated from the descriptor so a subscriber that never
uint8   fw_minor              #   calls `list` can still explain a dark panel
uint8   fw_patch
uint8   proto_major
uint8   proto_minor

bool    have_status           # false: link is not PRESENT, or nothing has been read yet
uint32  read_age_ms           # age of the reading below; NEVER if there has been none
bool    last_read_failed      # the most recent poll did not come back

uint8   sequence_id           # SEQ_NONE until something has run; otherwise the last run's id
uint8   source
uint8   state
uint8   sub_seq               # during a random show: the pattern playing, or SUB_SEQ_OFF
bool    in_pause              # sub_seq == SUB_SEQ_OFF: running and correctly showing nothing
uint8   iteration             # completed iterations; SATURATES at 255
uint8   repeat                # the run's repeat; 0 = forever
uint32  elapsed_ms            # frozen once the run ends
bool    remaining_known       # false for a loop, a random show, and anything not running
uint32  remaining_ms
bool    ours                  # this controller started the current or last run: the panel still
                              #   carries the run_counter its own confirmed START produced
bool    end_known             # ours is true, so `end` is what this controller asked for
uint8   end                   # StartMagicSequence/END_*; meaningless unless end_known
uint8   run_counter           # +1 on every start from any source; WRAPS at 256
uint8   rotary_code           # the panel's switch, reported even when its inputs are disabled

uint8   last_error            # the panel's LAST_ERROR code; never cleared by reading
string  last_error_name       # "NONE", "BAD_VALUE", "UNKNOWN_REG", ...
uint8   error_count           # +1 per rejected write; WRAPS at 256. Compare, do not read

MagicPanelSettings  live
MagicPanelSettings  saved     # what the EEPROM holds, as far as the controller can know
bool                have_saved

uint32  polls                 # the controller's counters, since its boot
uint32  read_errors
uint32  interrogations        # moves on every re-read of the panel: re-call ListMagicPanel
uint32  rejections
uint32  takeovers             # runs seen that this controller did not start

uint32  refusal_seq           # 0: nothing has been refused yet
bool    refusal_confirmed     # false: a START whose RUN_COUNTER never moved
string  refusal_reason        # the panel's own error name; empty when not confirmed
string  refusal_op            # what was sent: "BRIGHTNESS 16"
uint32  refusal_age_ms
