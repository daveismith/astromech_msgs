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
