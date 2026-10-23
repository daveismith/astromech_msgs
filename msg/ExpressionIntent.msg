# One thing the personality or an operator wants a channel to do. Published on
# /expression/intent by the personality's behaviour and idle nodes and by operator tools
# (the express CLI, a console), as events, with no fixed cadence. The channel's arbiter
# decides whether it runs. A manual intent claims its channel for the arbiter's
# manual_hold_s.
uint8 PRIORITY_IDLE=10
uint8 PRIORITY_BEHAVIOR=100
uint8 PRIORITY_MANUAL=200
uint8 PRIORITY_SAFETY=255

std_msgs/Header header
string  channel        # fld | tfld | bfld | rld | psi | magic | dome (later: sound, servo:<joint>)
string  source         # idle | behavior | manual | safety: who is asking
uint8   priority       # PRIORITY_*; the arbiter refuses a source above its ladder slot
string  action         # the channel's vocabulary: effect, clip, text, configure, stop | sequence, brightness, stop | look_at, glance, turn, rest, stop
string  params         # JSON for the action; empty for stop
uint32  duration_ms    # 0: the action's own length, or until stopped (manual only; the
                       #    personality is capped by the arbiter's max_duration_ms)
bool    interruptible  # false: a newer intent of the same priority waits until this ends
string  intent_id      # caller's id, echoed in ChannelStatus; empty: the arbiter assigns one
