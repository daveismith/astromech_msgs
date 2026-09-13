string  name
bool    running
string  effect          # the effect or clip, "text", or cycle:<child>; empty when idle
uint32  elapsed_ms
uint32  duration_ms     # 0: no limit
string  last_effect     # the previous run's, or empty
string  last_end        # none, ended, duration, stopped, replaced, released
