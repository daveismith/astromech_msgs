string  name
bool    running
string  effect          # the effect or clip, "text", or cycle:<child>; empty when idle
uint32  elapsed_ms
uint32  duration_ms     # 0: no limit
string  last_effect     # the previous run's, or empty
string  last_end        # none, ended, duration, stopped, replaced, released
string  source          # who started the current run: ros, console, ui, text_topic; empty when idle
string  owner           # source is ros: the owner the request named
string  last_source     # who started the previous run, beside last_end
string  last_owner      # and its owner
