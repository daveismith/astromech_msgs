# One channel as its arbiter sees it. Published on /expression/status by each arbiter, one
# message per channel, at status_hz (2 Hz) and immediately on every change, so a console can
# show why a channel is not answering the mood.
uint8 STATE_IDLE=0      # nothing running; the palette's own drift shows
uint8 STATE_RUNNING=1   # an intent is running
uint8 STATE_CLAIMED=2   # held by a claim or a manual intent; lower priorities dropped
uint8 STATE_FOREIGN=3   # a person holds it on the device (held_by), or a run this arbiter did not start
uint8 STATE_STALE=4     # /mood/state is stale: neutral palette, no flourishes
uint8 STATE_OFFLINE=5   # the device's services or state topic are not answering
uint8 STATE_DARK=6      # LEDs: the strip is switched off (LedStateArray.strip_enabled false)
uint8 STATE_SUPPRESSED=7 # dome: the body is moving, the personality holds off

std_msgs/Header header
string  channel
uint8   state
string  owner           # claim holder or manual source; when foreign, the device's held_by
                        #   (console, ui, text_topic, manual) or "other" for the panel
uint8   priority        # of the holder; 0 when unclaimed
float32 lease_remaining_s   # of a claim; of a device hold, hold_remaining_ms/1000 (-1: forever)
string  active_source   # of the running intent; empty when idle
string  active_action
string  active_intent_id
uint32  active_remaining_ms   # 0 when unknown or unbounded
string  mood            # the label the palette is following
uint32  dropped         # intents dropped since start because a higher priority held the channel
uint32  refused         # device refusals (held by ...) since start
