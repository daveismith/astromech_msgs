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
