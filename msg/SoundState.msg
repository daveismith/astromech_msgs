# What sound_player is doing. Published on /sound/state at state_hz and on every change.
uint8 IDLE=0
uint8 PLAYING=1
uint8 FADING=2

std_msgs/Header header
uint8   state           # IDLE | PLAYING | FADING
string  name            # clip name or "voice:<seed>"
string  owner
uint8   priority
string  intent_id
uint32  elapsed_ms      # from the stream's frame count
uint32  remaining_ms
uint8   last_end        # how the last play ended: 0 none, 1 ended, 2 duration, 3 stopped, 4 replaced
float32 level           # RMS 0..1 of the last block
string  backend         # sounddevice | wav | null
