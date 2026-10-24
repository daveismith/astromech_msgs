# One catalogue entry, as sound_player's `list` reports it.
string   name            # unique, lower-case, the catalogue key
string[] tags            # pools it belongs to (mood labels and reactions)
uint32   duration_ms
float32  gain_db         # set alignment + outlier trim + override, peak-limited
bool     excluded        # music, speech, silence: manual play only
