# astromech_msgs

ROS 2 interfaces for an astromech droid's servo controllers. One record describes any
servo (`ServoDescriptor`), one message carries its live state (`ServoState`), and three
services per controller node let a panel anywhere on the droid list, configure and
raw-move one without knowing which controller owns it:

| interface | kind | name (relative to the node) |
| --- | --- | --- |
| `srv/ListServos` | service | `~/servo/list` |
| `msg/ServoStateArray` | topic | `~/servo/states` |
| `srv/ConfigureServo` | service | `~/servo/configure` |
| `srv/MoveServoRaw` | service | `~/servo/move_raw` |

A servo controller is any node offering `~/servo/list`:

```sh
ros2 service list -t | grep ListServos
```

Normal joint motion needs none of this: it is `sensor_msgs/JointState` in radians on the
controller's command topic. These interfaces are the configuration and maintenance side.

The normative specification lives beside the first implementation, in
[r2_domeplayer](https://github.com/daveismith/r2_domeplayer)
(`components/servo/docs/servo_model_spec.md`). Versioned with the astromech URDF
extension namespace (`https://astromech.co/urdf/1.0`).

Build on a ROS 2 host with `colcon build --packages-select astromech_msgs`; on a
micro-ROS target it is an extra package in the colcon workspace.

The dome drive's hardware interface, [ros2_roamadome](https://github.com/daveismith/ros2_roamadome),
publishes `msg/DomeTelemetry` on `~/telemetry`: one stamped message per firmware position
report, with the unwrapped angle and a regression velocity estimate.

`srv/DomeBenchDrive` is the bench-mode raw rotate service (`~/bench/drive`) on the same
hardware interface: a `:DPR` percentage, -100..100, kept alive by repeated calls (a heartbeat);
it is only offered when the interface is launched with bench mode enabled.
`srv/DomeBenchMove` (`~/bench/move`) is its companion for the position-move bench: one
absolute, home-relative `:DPA` move that the firmware runs to completion on its own, with an
optional per-move speed (`speed_percent`, sent as `:DPA<deg>,<percent>`).

## Personality

The droid's mood is kept by one affect node, and three interfaces carry it. Design:
`docs/personality-architecture.md` in the r2_dev workspace.

`msg/Stimulus` is published on `/stimuli`: one thing a perception node saw, with a `kind`
(the affect table's key), the producing node's name as `source`, an `intensity` and
`confidence` in 0..1, and optionally a `subject`, a `bearing_rad` (NaN when unknown) and a
`ttl_s`. Adapters, the stimulate CLI and consoles produce it; the affect node consumes it.
Producers describe what they saw and never decide what the droid feels: that is the affect
layer's job.

`msg/MoodState` is published on `/mood/state` by the affect node at 10 Hz, whether or not
anything changed, so silence means the node is gone. It carries the four axes (arousal,
valence, curiosity, confidence), the nearest mood label and its strength, the lock state, the
current focus (subject and bearing) and `idle_s`, the time since the last accepted external
stimulus. Behaviour and expression nodes consume it.

`srv/SetMood` is offered as `/mood/set`: force a mood, lock the current one, or clear either.
A force jumps the state to the named mood and switches the label at once; with `lock` false
the dynamics then resume from there. A lock freezes the dynamics, though focus still follows
stimuli, until `duration_s` elapses or a clearing call (empty `mood`, `lock` false) arrives.
A lock is overridden only by a lock from its own `source` or by a clear from any source, so
two consoles cannot fight and the operator can always free it. A refused request (unknown
label, or a lock held by another source) changes nothing.

## Expression (2.1.0)

Three more interfaces carry the personality's output to the lights. 2.1.0 is additive on
2.0.0: nothing existing changed. The dome device does not build these three types, so it
needs no reflash; the Pi and the container only need to be on the same 2.x as the device
for the LED and Magic Panel types.

`msg/ExpressionIntent` is published on `/expression/intent`: one thing someone wants a
channel to do. `channel` is `fld`, `tfld`, `bfld`, `rld`, `psi` or `magic` (`tfld` and `bfld`
are sub-channels of `fld`; `dome` from 2.2.0; `sound` from 2.3.0; later: `servo:<joint>`). `action` is the channel's
vocabulary (`effect`, `clip`, `text`, `configure`, `stop` for the LEDs; `sequence`,
`brightness`, `stop` for the Magic Panel; `look_at`, `glance`, `turn`, `rest`, `stop` for `dome`) and `params` is its JSON. `source` is `idle`,
`behavior`, `manual` or `safety`, with `priority` on the ladder 10 (`PRIORITY_IDLE`), 100
(`PRIORITY_BEHAVIOR`), 200 (`PRIORITY_MANUAL`) and 255 (`PRIORITY_SAFETY`); the arbiter
refuses a source above its slot. A manual intent claims its channel for the arbiter's
`manual_hold_s`, renewed by each one. `duration_ms` 0 is allowed for manual intents only;
the personality is capped. `interruptible` false makes a newer intent of the same priority
wait; `intent_id` is echoed in `ChannelStatus`.

`srv/ClaimChannel` is offered as `/expression/claim/led` by the LED arbiter (`fld`, `tfld`,
`bfld`, `rld`, `psi`) and as `/expression/claim/magic` by the Magic Panel arbiter (`magic`):
two servers on one name do not share requests under rmw_zenoh. A claim holds a
channel for one `owner` at one `priority` for `lease_s` (capped by the arbiter's
`max_lease_s`); call again to renew, or with `lease_s` 0 to release. A claim at higher
priority than the holder is accepted, equal priority from another owner is refused naming
the holder. Each arbiter answers for its own channels and refuses the other's with the
reason "not my channel". The response carries the channel's `ChannelStatus` after the call.

`msg/ChannelStatus` is published on `/expression/status`, one per channel, at `status_hz`
(2 Hz) and on every change. `state` is `STATE_IDLE`, `RUNNING`, `CLAIMED`, `FOREIGN` (a person
holds it on the device, or a run this arbiter did not start), `STALE` (no fresh mood: neutral
palette), `OFFLINE` (the device is not answering) or `DARK` (the LED strip is switched off) or, from 2.2.0, `SUPPRESSED` (`dome`: the body is moving).
`owner`, `priority` and `lease_remaining_s` describe the holder (`-1`: forever), `active_*`
the running intent, and `mood` the palette being followed. `dropped` counts intents dropped
because a higher priority held the channel and `refused` counts device refusals
(`held by ...`), both since start.

## Dome motion (2.2.0)

One more interface and one more state carry the personality's dome motion. 2.2.0 is additive
on 2.1.0: no existing field, constant or type changed; a consumer must tolerate the new
`ChannelStatus` state 7. The dome device does not build the new type, so it needs
no reflash.

`msg/DomeCommandStatus` is published on `/dome/cmd/status` by `dome_twist_converter` on every
source change and at `status_hz` otherwise. `source` is `SOURCE_IDLE`, `SOURCE_JOYSTICK`,
`SOURCE_FOXGLOVE` or `SOURCE_PERSONALITY` (string constants: `idle`, `joystick`, `foxglove`,
`personality`), `velocity_rad_s` is what went to `/dome_controller/commands` that tick, and
`capped` is true when the personality's value was clamped by speed or acceleration.

`msg/ChannelStatus` gains `STATE_SUPPRESSED` (7): on the `dome` channel, the body is moving
and the personality holds off. The `channel` comment of `msg/ExpressionIntent` now lists
`dome`.

## Sound (2.3.0)

Six interfaces carry the sound channel. 2.3.0 is additive on 2.2.0: no existing field,
constant or type changed.

`msg/SoundClip` is one catalogue entry (`name`, `tags` = the pools it belongs to,
`duration_ms`, `gain_db`, `clip_fraction` = the share of clipped samples in the source file,
`excluded` for music and other manual-only clips).
`srv/ListSounds` returns the clips with the catalogue id, the sample rate and whether
`vocalize` is available. `srv/PlaySound` plays a clip by `name` or picks one from a `pool`;
`priority` and `owner` (up to 31 bytes) are echoed in the state, and the response reports the
clip chosen and the play's length. It is never refused for "busy", only for an unknown name or
pool or a closed player. `srv/Vocalize` plays a synthesised phrase from `arousal`, `valence`,
`length_s` and a `seed` (0: random; the seed used is returned). `srv/StopSound` fades out and
stops. `msg/SoundState` is published on `/sound_player/state`: `IDLE`, `PLAYING` or `FADING`, the
clip, owner, priority and intent id, `elapsed_ms` and `remaining_ms` from the stream, `last_end`
(0 none, 1 ended, 2 duration, 3 stopped, 4 replaced, 5 failed: a decode or the output failed
after the play was accepted), the block `level` and the `backend`.

Device pattern as for the LEDs: `sound_player` serves the services and publishes the state, and
only `sound_arbiter` calls play, vocalize and stop. The level topics are `std_msgs`, so nothing
new is defined for them. `msg/ExpressionIntent` now lists `sound` (actions `play`, `vocalize`,
`stop`).

## 2.0.0: who is driving

The LED displays and the Magic Panel are driven by people on the droid itself (its console,
its touchscreen, the `/dome/text/line*` topics) as well as over ROS. From 2.0.0 every write
that runs, says text, or changes a display is tagged with where it came from, and a person's
write holds what it touched for a few seconds, during which low-priority ROS requests are
refused. (A stop names no owner, and `ConfigureMagicPanel` is unchanged: it takes no priority.) A personality node that drives
the lights can then give way exactly, from the reply it gets, rather than infer a takeover
from the state topic a second late.

Every new field is appended after the 1.x fields of its own message. That does not make 2.0.0
readable as 1.x: `LedStateArray` carries arrays of the grown messages, and the type hashes all
change, so both ends must move to 2.0.0 together.

**Set `priority` on every request.** 0 is never refused for a hold, as 1.x behaved, and 0 is
also what an unset field is: a 2.0.0 node that forgets it overrides a person.

The source words are `ros`, `console`, `ui` and `text_topic` (`showsync` is reserved). `ros`
is every ROS client, so wherever a source is reported an owner sits beside it: the string the
request named. A node that names itself in every request can tell its own runs and changes from
another node's, and from a person's. (It is what `SetMood` calls `source`: there `source` is
the requester's name, here it is the channel the write came in on.)

| interface | new field | meaning |
| --- | --- | --- |
| `RunLedEffect`, `SayLedText`, `ConfigureLedDisplay` (request) | `string owner` | who is asking, up to 31 bytes; kept with a run and echoed on `~/leds/states` |
| the same, and `StopLedEffect` (request) | `uint8 priority` | 1..199 is refused while a display the request touches is held; 0 (every 1.x client) and 200 and above (`PRIORITY_OVERRIDE`) never are |
| `LedSurfaceState` | `string source`, `string owner` | who started the current run; empty when idle |
| `LedSurfaceState` | `string last_source`, `string last_owner` | who started the previous run, beside `last_end` |
| `LedDisplayState` | `string changed_by` | who last changed the display itself (mode, fill, pixel, text, brightness...), not through a run |
| `LedDisplayState` | `string changed_by_owner` | the owner that change named, when it came from ROS |
| `LedDisplayState` | `string held_by`, `uint32 hold_remaining_ms` | `console`, `ui`, `text_topic` or `manual` while the display is held; `HOLD_FOREVER` under `manual` |
| `LedStateArray` | `bool strip_enabled` | false while the strip is switched off from the console, or not fitted |
| `LedStateArray` | `bool manual` | the controller's sticky manual setting: everything held until a person clears it |
| `StartMagicSequence` (request) | `string owner`, `uint8 priority` | as for the LEDs |
| `StopMagicSequence` (request) | `uint8 priority` | as for the LEDs |
| `MagicPanelState` | `string started_by`, `string owner` | `ros`, `console`, `ui` for a run this controller started, `other` for one it did not |
| `MagicPanelState` | `bool manual`, `string held_by`, `uint32 hold_remaining_ms` | as for an LED display; `HOLD_FOREVER` under `manual` |

A refused request changes nothing, and its new reasons are `held by console`, `held by ui`,
`held by text topic`, `held: manual`, and `owner too long` (32 bytes or more), word for word. The rules, and the order the
controller checks them in, are in r2_domeplayer's `components/ws2812b/docs/led_ros_spec.md`
and `components/magic_panel/docs/magic_panel_ros_spec.md`.
